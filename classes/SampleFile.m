classdef SampleFile < SignalFile
    properties
        ref_used string
    end

    methods
        function obj = SampleFile(filestruct)
            obj@SignalFile(filestruct);
            obj.ref_used = "not yet normalized";
        end

        function obj = subtract_background(obj, bg)
            obj = obj.ensure_processed_data();
            bg = bg.ensure_processed_data();
            obj.processed_data.Intensity = ...
                obj.processed_data.Intensity - bg.processed_data.Intensity;
            obj.bg_used = bg.filename;
        end

        function obj = divide_by_reference(obj, ref)
            obj = obj.ensure_processed_data();
            ref = ref.ensure_processed_data();
            if ~isequal(obj.processed_data.Wavelength, ref.processed_data.Wavelength)
                error("Wavelength mismatch during normalization.");
            end
            obj.processed_data.Intensity = ...
                obj.processed_data.Intensity ./ ref.processed_data.Intensity;
            obj.ref_used = ref.filename;
        end
    end
end
