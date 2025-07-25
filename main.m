clear
% === Setup ===
addpath(genpath('classes'));

data_dir = fullfile(pwd, 'data');
calibration_str = "polystyrene";
ref_str = "zqz";

% === Load and classify all files ===
detected_files = dir(fullfile(data_dir, '*.csv'));

files = cell(1, numel(all_files));

for i = 1:numel(all_files)
    fname = lower(all_files(i).name);
    is_sample = ~contains(fname, ref_str);
    is_sig = ~contains(fname, "bg") || contains(fname, "bkg") || contains(fname, "background");

    if is_sig
        if is_sample
            f = SampleFile(all_files(i));
        else
            f = SignalFile(all_files(i));
        end
    else
        f = File(all_files(i));
    end

    % Always extract info and raw data
    files{i} = f.extract_info();
end
