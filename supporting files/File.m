classdef File < handle

    properties (Access = public)
        % original file info
        filename       string
        path           string

        info           struct    % extracted file info
        vis_wl         double = NaN

        % stored data (defaults to empty table)
        raw_data       table = table()
        processed_data table = table()

        % cleaning parameters
        tf             double = 8 % threshold factor
        window         double = 15
    end

    methods (Access = public)
        function obj = File(filestruct)
            % Constructor
            obj.filename = filestruct.name;
            obj.path = fullfile(filestruct.folder, filestruct.name);
            obj.extract_info; % Extract metadata and load raw data
        end

        function extract_info(obj)
            % Extracts metadata from the filename using a regex pattern.
            obj.info = File.parse_filename(obj.filename);

            % Loads the raw data table
            obj.raw_data = readtable(obj.path);
        end

        function avg_frames(obj)
            % Averages frames

            data = obj.raw_data;
            max_frame = max(data.Frame);
            try
                intensity = reshape(data.CleanIntensity, [], max_frame);
            catch
                intensity = reshape(data.Intensity, [], max_frame);
            end
            mean_intensity = mean(intensity, 2);

            wavelength = data.Wavelength(1:length(mean_intensity));
            obj.processed_data = table(wavelength(:), mean_intensity(:), ...
                'VariableNames', {'Wavelength', 'Intensity'});
        end

        function convert_to_wn(obj)
            % Converts wavelength to wavenumber using probe wavelength w1 (in nm)
            if ~isnan(obj.vis_wl)
            wn = 1e7 ./ obj.processed_data.Wavelength - 1e7 / obj.vis_wl;
            obj.processed_data.Wavenumber = wn;
            else
                error( ...
                    "Error when converting to wavenumber: Visible wavelength not assigned (File: %s)", ...
                    obj.filename ...
                    );
            end
        end

        function cleanRays(obj)
            % Clean cosmic rays by removing outliers

            int = obj.raw_data.Intensity;

            % Get logical index of outliers
            outlierMask = isoutlier(int, "movmedian", obj.window, ThresholdFactor=obj.tf);

            % Fill outliers using interpolation
            int_clean = filloutliers(int, "linear", "movmedian", obj.window, ThresholdFactor=obj.tf);

            % Save cleaned intensity
            obj.raw_data.CleanIntensity = int_clean;

            % Save outlier info
            obj.raw_data.OutlierMask = outlierMask;   % Logical mask
        end
    end

    methods (Static, Access = private)

        function info = parse_filename(filename)
            pattern = "^([^_]+)" + ...                           % 1. sample
                "(?:_([^_]+))?" + ...                      % 2. concentration (optional)
                "(?:_([^_]+))?" + ...                      % 3. condition (optional)
                "(?:_([^_]+))?" + ...                      % 4. condition2 (optional)
                "_([sp]{3})" + ...                         % 5. polarization
                "_([0-9]*\.?[0-9]+)um" + ...               % 6. region
                "_([0-9]*\.?[0-9]+)s" + ...                % 7. acqtime
                "_([0-2][0-9][0-5][0-9])" + ...            % 8. time
                "(?:_bg)?" + ...
                "(?:_processed)?" + ...
                "\.csv$";

            tokens = regexp(filename, pattern, 'tokens');

            if isempty(tokens)
                info = struct.empty;
                return;
            end

            t = tokens{1};
            n = numel(t);

            % Initialize optional fields as empty strings
            concentration = "";
            condition     = "";
            condition2    = "";

            % Use positional inference
            switch n
                case 8  % All optional fields present
                    concentration = t{2};
                    condition     = t{3};
                    condition2    = t{4};
                case 7
                    concentration = t{2};
                    condition     = t{3};
                case 6
                    concentration = t{2};
                case 5
                    % No optional fields
            end

            % store info extarcted from filename into a struct
            info = struct( ...
                'sample',        string(t{1}), ...
                'concentration', string(concentration), ...
                'condition',     string(condition), ...
                'condition2',    string(condition2), ...
                'polarization',  string(t{n - 3}), ...
                'region',        str2double(t{n - 2}), ...
                'acqtime',       str2double(t{n - 1}), ...
                'time',          string(t{n}) ...
                );
        end

    end
end
