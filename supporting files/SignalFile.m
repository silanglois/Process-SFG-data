classdef SignalFile < File
    properties
        bg File % file object for the corresponding background

        bgSmoothFactor double = 0 % smoothing factor for the background
        bgSlope        double = 1 % slope of the offset applied to the background
        bgIntercept    double = 0 % intercept of the offset applied to the background
    end

    methods (Access = public)

        % constructor
        function obj = SignalFile(filestruct)
            obj@File(filestruct);

            % override default cleaning params with new ones
            obj.tf     = 15;
            obj.window = 20;
        end

        % subtract the background from the signal
        function subtract_background(obj)
            if ~isequal(obj.processed_data.Wavelength, obj.bg.processed_data.Wavelength)
                error("Wavelength mismatch during background subtraction.")
            end
            bgData = obj.modifyBackground;
            obj.processed_data.Intensity = obj.processed_data.Intensity - bgData.Intensity;
        end

        % applies an offset and/or smoothing to the background
        function bgData = modifyBackground(obj)
            bgData = obj.bg.processed_data;
            if 0 <= obj.bgSmoothFactor && obj.bgSmoothFactor <= 1
                bgData = smoothdata(bgData, "movmedian", ...
                    SmoothingFactor=obj.bgSmoothFactor, DataVariables="Intensity");
            else
                error("Error: Smoothing factor for the background of %s has to be between 0 and 1", obj.filename)
            end
            bgData.Intensity = bgData.Intensity * obj.bgSlope + obj.bgIntercept;
        end
    end
end
