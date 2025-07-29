classdef SampleFile < SignalFile
    properties
        ref_used SignalFile
    end

    methods
        function obj = SampleFile(filestruct)
            obj@SignalFile(filestruct);
        end

        function obj = normalize(obj, ref)
            if ~isequal(obj.processed_data.Wavelength, ref.processed_data.Wavelength)
                error("Wavelength mismatch during normalization.");
            end
            obj.processed_data.Intensity = ...
                obj.processed_data.Intensity ./ ref.processed_data.Intensity;
            obj.ref_used = ref;
        end
    end
end
