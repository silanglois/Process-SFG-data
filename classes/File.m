classdef File
    % File - A class to represent and parse spectroscopy data files.
    %
    % Syntax:
    %   obj = File(filename, directory)
    %
    % Description:
    %   Parses file names, loads data, averages frames, and converts units.
    
    properties
        filename (1,1) string
        path (1,1) string

        sample string = ""
        acq_time double = NaN
        polarization string = ""
        time_str double = NaN
        region double = NaN
        % condition string = ""
        % condition2 string = ""
        % concentration string = ""

        raw_data table = table()
        processed_data table = table()
        % pts_cleaned double = zeros(0, 2)
    end

    methods
        function obj = File(filestruct)
            % Constructor
            obj.filename = filestruct.name;
            obj.path = fullfile(filestruct.folder, filestruct.name);
        end

        function obj = extract_info(obj)
            % Extracts metadata from the filename using a regex pattern.
            tokens = File.parse_filename(obj.filename);
            obj.sample        = tokens{1};
            obj.polarization  = tokens{2};
            obj.region        = str2double(tokens{3});
            obj.acq_time      = str2double(tokens{4});
            obj.time_str      = str2double(tokens{5});

            % Loads the raw data table using the specified delimiter
            obj.raw_data = readtable(obj.path);
        end

        function obj = avg_frames(obj)
            % Averages frames from the raw/processed data
            obj = obj.ensure_processed_data();

            df = obj.processed_data;
            if ~all(ismember(["Frame", "Intensity"], df.Properties.VariableNames))
                error("File:InvalidTable", "Expected 'Frame' and 'Intensity' columns.");
            end
            max_frame = max(df.Frame);
            intensity = reshape(df.Intensity, max_frame, []);
            mean_intensity = mean(intensity, 1);

            wavelength = df.Wavelength(1:length(mean_intensity));
            obj.processed_data = table(wavelength(:), mean_intensity(:), ...
                'VariableNames', {'Wavelength', 'Intensity'});
        end

        function obj = convert_to_wn(obj, w1)
            % Converts wavelength to wavenumber using probe wavelength w1 (in nm)
            obj = obj.ensure_processed_data();

            df = obj.processed_data;
            wn = 1e7 ./ df.Wavelength - 1e7 / w1;
            obj.processed_data.Wavenumber = wn;
        end

        function info(obj)
            % Prints file summary
            fprintf("File: %s\n", obj.filename);
            fprintf("Sample: %s | Region: %.1f µm | Acquisition time: %.1fs s | Pol: %s\n", ...
                obj.sample, obj.region, obj.acq_time, obj.polarization);
        end
    end

    methods (Access = private)
        function obj = ensure_processed_data(obj)
            % Ensures processed_data is initialized (copy from raw if needed)
            if isempty(obj.processed_data)
                if isempty(obj.raw_data)
                    error("File:MissingData", ...
                        "Data not found for %s when required.", obj.filename);
                end
                obj.processed_data = obj.raw_data;
            end
        end
    end

    methods (Static, Access = private)
        function tokens = parse_filename(filename)
            % Applies regex to extract parts from a standardized filename
            pattern = "^([^_]+)" + ...
                      "(?:_([0-9]*\.?[0-9]+[a-zA-Z]+))?" + ...
                      "(?:_([^_]+))?" + ...
                      "(?:_([^_]+))?" + ...
                      "_([sp]{3})" + ...
                      "_([0-9]*\.?[0-9]+)um" + ...
                      "_([0-9]*\.?[0-9]+)s" + ...
                      "_([0-2][0-9][0-5][0-9])" + ...
                      "(?:_bg)?" + ...
                      "(?:_processed)?" + ...
                      "\.csv$";
            tokens = regexp(filename, pattern, 'tokens');

            if isempty(tokens)
                error("File:BadName", "Filename '%s' does not match expected pattern.", filename);
            end
            tokens = tokens{1};
        end
    end
end
