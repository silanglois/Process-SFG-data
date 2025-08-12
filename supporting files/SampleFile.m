classdef SampleFile < SignalFile
    properties
        ref SignalFile % corresponding reference signal stored as SignalFile object
    end

    methods
        function obj = SampleFile(filestruct)
            obj@SignalFile(filestruct);
        end

        function normalize(obj)
            if ~isequal(obj.processed_data.Wavelength, obj.ref.processed_data.Wavelength)
                error("Wavelength mismatch during normalization.");
            end
            obj.processed_data.Intensity = obj.processed_data.Intensity ./ obj.ref.processed_data.Intensity;
        end

        function process(obj)

            % remove the cosmic rays in all spectra involved
            obj.cleanRays;
            obj.bg.cleanRays;
            obj.ref.cleanRays;
            obj.ref.bg.cleanRays;

            % average frames in all spectra involved
            obj.avg_frames;
            obj.bg.avg_frames;
            obj.ref.avg_frames;
            obj.ref.bg.avg_frames;

            % subtract background from signals
            obj.subtract_background;
            obj.ref.subtract_background;

            obj.normalize; % normalize

            % note that the conversion to wavenumber does not occur here
        end

    end
end
