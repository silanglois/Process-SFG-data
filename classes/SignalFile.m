classdef SignalFile < File
    properties
        bg_used File
    end

    methods
        function obj = SignalFile(filestruct)
            obj@File(filestruct);
        end

        function obj = subtract_background(obj, bg)

            if ~isequal(obj.processed_data.Wavelength, bg.processed_data.Wavelength)
                error("Wavelength mismatch during bg subtraction.");
            end

            obj.processed_data.Intensity = ...
                obj.processed_data.Intensity - bg.processed_data.Intensity;
            obj.bg_used = bg;
        end
    end
end
