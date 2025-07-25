classdef SignalFile < File
    methods
        function obj = SignalFile(filestruct)
            obj@File(filestruct);
        end

        function obj = subtract_background(obj, bg)
            obj = obj.ensure_processed_data();
            bg = bg.ensure_processed_data();
            obj.processed_data.Intensity = ...
                obj.processed_data.Intensity - bg.processed_data.Intensity;
            obj.bg_used = bg.filename;
        end
    end
end
