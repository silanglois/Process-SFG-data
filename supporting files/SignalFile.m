classdef SignalFile < File
    properties
        bg File % file object for the corresponding background
    end

    methods
        function obj = SignalFile(filestruct)
            obj@File(filestruct);

            % override default cleaning params with new ones
            obj.tf     = 15;
            obj.window = 20;
        end

        function subtract_background(obj)

            if ~isequal(obj.processed_data.Wavelength, obj.bg.processed_data.Wavelength)
                error("Wavelength mismatch during background subtraction.");
            end

            obj.processed_data.Intensity = obj.processed_data.Intensity - obj.bg.processed_data.Intensity;
        end

        % function subtract_background(obj)
        %     % % Ensure both have same wavelength axis
        %     % if ~isequal(obj.raw_data.Wavelength(1:end), obj.bg.raw_data.Wavelength(1:end))
        %     %     error("Wavelength mismatch during background subtraction.");
        %     % end
        % 
        %     % Determine number of frames
        %     max_frame_sig = max(obj.raw_data.Frame);
        %     max_frame_bg  = max(obj.bg.raw_data.Frame);
        % 
        %     % Reshape both into [points_per_frame x num_frames]
        %     try
        %         sig_intensity = reshape(obj.raw_data.CleanIntensity, [], max_frame_sig);
        %         bg_intensity  = reshape(obj.bg.raw_data.CleanIntensity,  [], max_frame_bg);
        %     catch % if not cleaned
        %         sig_intensity = reshape(obj.raw_data.Intensity, [], max_frame_sig);
        %         bg_intensity  = reshape(obj.bg.raw_data.Intensity,  [], max_frame_bg);
        %     end
        % 
        %     % Average the background frames
        %     bg_mean = mean(bg_intensity, 2);
        % 
        %     % Subtract background from each signal frame (column-wise)
        %     sig_intensity = sig_intensity - bg_mean;
        % 
        %     % Average the background-subtracted signal frames
        %     mean_intensity = mean(sig_intensity, 2);
        % 
        %     % Store processed data
        %     wavelength = obj.raw_data.Wavelength(1:length(mean_intensity));
        %     obj.processed_data = table(wavelength(:), mean_intensity(:), ...
        %         'VariableNames', {'Wavelength', 'Intensity'});
        % end
    end
end
