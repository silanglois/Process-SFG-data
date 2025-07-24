classdef SampleFile < File
    methods
        function obj = SampleFile(filename, directory)
            obj@File(filename, directory);
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
                error("Wavelength mismatch during division.");
            end
            obj.processed_data.Intensity = ...
                obj.processed_data.Intensity ./ ref.processed_data.Intensity;
            obj.ref_used = ref.filename;
        end
    end
end
