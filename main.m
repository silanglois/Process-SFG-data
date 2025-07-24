clearvars
% === Setup ===
addpath(genpath('classes'));

data_dir = fullfile(pwd, 'data');
calibration_str = "calibration";
ref_str = "ref";

% === Load and classify all files ===
all_files = dir(fullfile(data_dir, '*.csv'));
objects = File.empty(0, 1);


for k = 1:length(all_files)
    f = all_files(k);
    obj = create_file_from_name(f.name, f.folder, calibration_str, ref_str);
    obj = obj.extract_data(',');
    obj = obj.avg_frames();  % optional
    obj = obj.convert_to_wn(800);  % or whatever your w1 is
    disp(class(obj))
    isa(obj, 'File')
    objects = [objects; obj];
end

% === Separate by class ===
samples = objects(arrayfun(@(f) isa(f, 'SampleFile'), objects));
sample_bgs = objects(arrayfun(@(f) isa(f, 'SampleBackground'), objects));
refs = objects(arrayfun(@(f) isa(f, 'ReferenceFile'), objects));
ref_bgs = objects(arrayfun(@(f) isa(f, 'ReferenceBackground'), objects));

% === Process each sample ===
for i = 1:length(samples)
    s = samples(i);

    % Match background
    bg_match = sample_bgs(arrayfun(@(b) b.region == s.region && b.polarization == s.polarization, sample_bgs));
    if ~isempty(bg_match)
        s = s.subtract_background(bg_match(1));
    end

    % Match reference
    ref_match = refs(arrayfun(@(r) r.region == s.region && r.polarization == s.polarization, refs));
    if ~isempty(ref_match)
        % Subtract reference background if exists
        ref = ref_match(1);
        ref_bg_match = ref_bgs(arrayfun(@(b) b.region == ref.region && b.polarization == ref.polarization, ref_bgs));
        if ~isempty(ref_bg_match)
            ref = ref.subtract_background(ref_bg_match(1));
        end

        s = s.divide_by_reference(ref);
    end

    % % === Save or plot processed result ===
    % output_path = fullfile(data_dir, ['processed_' s.filename]);
    % writetable(s.processed_data, output_path);
end

% === Prepare for plotting ===
sample_bg = [];
ref_obj = [];
ref_bg = [];

if ~isempty(bg_match), sample_bg = bg_match(1); end
if ~isempty(ref_match), ref_obj = ref_match(1); end
if ~isempty(ref_bg_match), ref_bg = ref_bg_match(1); end

% === Plot raw (wavelength) + processed (wavenumber) spectra ===
plot_raw_and_processed(s, sample_bg, ref_obj, ref_bg);
