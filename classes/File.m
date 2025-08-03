classdef File < handle
    
    properties (Access = public)
        % original file info
        filename string
        path string
        
        % extracted file info
        info struct
        % sample string = ""
        % acq_time double = NaN
        % polarization string = ""
        % time_str double = NaN
        % region double = NaN
        % condition string = ""
        % condition2 string = ""
        % concentration string = ""
        
        % stored data
        raw_data table = table()
        processed_data table = table()
        
        % cleaning parameters
        tf double = 8 % threshold factor
        window double = 15
    end

    methods
        function obj = File(filestruct)
            % Constructor
            obj.filename = filestruct.name;
            obj.path = fullfile(filestruct.folder, filestruct.name);
            obj.extract_info; % Extract metadata and load raw data
        end

        function extract_info(obj)
            % Extracts metadata from the filename using a regex pattern.
            obj.info = File.parse_filename(obj.filename);
            % return as struct for clarity
            % obj.info = struct( ...
            %     'sample', tokens{1}, ...
            %     'concentration', tokens{2}, ...
            %     'condition', tokens{3}, ...
            %     'condition2', tokens{4}, ...
            %     'polarization', tokens{5}, ...
            %     'region', str2double(tokens{6}), ...
            %     'acqtime', str2double(tokens{7}), ...
            %     'time', tokens{8} ...
            % );

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

        function convert_to_wn(obj, w1)
            % Converts wavelength to wavenumber using probe wavelength w1 (in nm)
            wn = 1e7 ./ obj.processed_data.Wavelength - 1e7 / w1;
            obj.processed_data.Wavenumber = wn;
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
            % obj.raw_data.OutlierMask = outlierMask;             % Logical mask
            % obj.raw_data.OutlierValues = int(outlierMask);      % values
        end
    end

    methods (Static, Access = private)

        function info = parse_filename(filename)
            % Applies regex to extract parts from a standardized filename
            pattern = "^([^_]+)" + ...                           % 1. Anything up to the first underscore — Sample name
                      "(?:_([0-9]*\.?[0-9]+[a-zA-Z]+))?" + ...   % 2. Optional: number (float/int) + units (e.g., "10.0mM")
                      "(?:_([^_]+))?" + ...                      % 3. Optional: arbitrary string (e.g., condition)
                      "(?:_([^_]+))?" + ...                      % 4. Optional: another arbitrary string (e.g., replicate, set)
                      "_([sp]{3})" + ...                         % 5. Exactly 3 letters, only s or p — polarization, like "ssp", "ppp"
                      "_([0-9]*\.?[0-9]+)um" + ...               % 6. Float number with "um" — IR wavelength (e.g., "4.5um")
                      "_([0-9]*\.?[0-9]+)s" + ...                % 7. Float number with "s" — acquisition time (e.g., "2.0s")
                      "_([0-2][0-9][0-5][0-9])" + ...            % 8. 4-digit time — e.g., 1530 (24h format)
                      "(?:_bg)?" + ...                           % Optional "_bg" — indicates background
                      "(?:_processed)?" + ...                    % Optional "_processed" — indicates it's been processed
                      "\.csv$";                                  % Ends with ".csv"
            tokens = regexp(filename, pattern, 'tokens');

            if isempty(tokens)
                error("File:BadName", "Filename '%s' does not match expected pattern.", filename);
            end
            t = tokens{1};
            
            % store collected tokens in a struct
            info = struct( ...
                'sample',        File.get_token(t, 1), ...
                'concentration', File.get_token(t, 2), ...
                'condition',     File.get_token(t, 3), ...
                'condition2',    File.get_token(t, 4), ...
                'polarization',  File.get_token(t, 5), ...
                'region',        str2double(File.get_token(t, 6)), ...
                'acqtime',       str2double(File.get_token(t, 7)), ...
                'time',          File.get_token(t, 8) ...
            );
        end
        
        function val = get_token(t, i)
            if i <= numel(t)
                val = t{i};
                if ismissing(val)
                    val = "";
                elseif ischar(val)
                    val = string(val);
                end
            else
                val = "";
            end
        end
    end
end
