classdef SignalFile < File
    properties
        bg_used File
    end

    methods
        function obj = SignalFile(filestruct)
            obj@File(filestruct);
            obj.bg_used = "not yet background subtracted";
        end

        function obj = subtract_background(obj, bg)
            obj = obj.ensure_processed_data();
            bg = bg.ensure_processed_data();
            obj.processed_data.Intensity = ...
                obj.processed_data.Intensity - bg.processed_data.Intensity;
            obj.bg_used = bg;
        end
    end
end
