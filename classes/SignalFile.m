classdef SignalFile < File
    properties
        bg File
    end

    methods
        function obj = SignalFile(filestruct)
            obj@File(filestruct);
            
            % override cleaning params with new ones
            obj.tf = 15;
            obj.window = 20;
        end

        function subtract_background(obj)

            if ~isequal(obj.processed_data.Wavelength, obj.bg.processed_data.Wavelength)
                error("Wavelength mismatch during background subtraction.");
            end

            obj.processed_data.Intensity = obj.processed_data.Intensity - obj.bg.processed_data.Intensity;
        end
    end
end
