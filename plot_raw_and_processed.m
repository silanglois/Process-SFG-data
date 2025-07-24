function plot_raw_and_processed(sample, sample_bg, ref, ref_bg)
    figure('Name', ['Sample: ' sample.sample ', Region: ' sample.region], ...
           'Position', [100 100 1000 600]);

    % === RAW DATA: Wavelength ===
    subplot(1, 2, 1);
    hold on;
    plot(sample.raw_data.Wavelength, sample.raw_data.Intensity, 'b-', 'DisplayName', 'Sample');
    
    if ~isempty(sample_bg)
        plot(sample_bg.raw_data.Wavelength, sample_bg.raw_data.Intensity, 'c--', 'DisplayName', 'Sample BG');
    end
    if ~isempty(ref)
        plot(ref.raw_data.Wavelength, ref.raw_data.Intensity, 'r-', 'DisplayName', 'Reference');
    end
    if ~isempty(ref_bg)
        plot(ref_bg.raw_data.Wavelength, ref_bg.raw_data.Intensity, 'm--', 'DisplayName', 'Reference BG');
    end

    title('Raw Spectra (Wavelength)');
    xlabel('Wavelength (nm)');
    ylabel('Intensity');
    legend show;
    grid on;

    % === PROCESSED DATA: Wavenumber ===
    subplot(1, 2, 2);
    hold on;

    if ~isempty(sample.processed_data)
        wn = sample.processed_data.Wavenumber;  % assume you've added this
        intensity = sample.processed_data.Intensity;
        plot(wn, intensity, 'k-', 'DisplayName', 'Processed');

        title('Processed Spectrum (Wavenumber)');
        xlabel('Wavenumber (cm^{-1})');
        ylabel('Intensity');
        legend show;
    else
        title('Processed Spectrum - Not Available');
    end

    grid on;
end
