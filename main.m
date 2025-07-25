clear
% === Setup ===
addpath(genpath('classes'));

data_dir = fullfile(pwd, 'data');
calibration_str = "polystyrene";
ref_str = "zqz";

% === Load and classify all files ===
all_files = dir(fullfile(data_dir, '*.csv'));

objects = cell(1, numel(all_files));

for i = 1:numel(all_files)
    fname = lower(all_files(i).name);
    is_sample = ~contains(fname, ref_str);
    is_sig = ~contains(fname, "bg") || contains(fname, "bkg") || contains(fname, "background");

    if is_sig
        if is_sample
            obj = SampleFile(all_files(i));
        else
            obj = SignalFile(all_files(i));
        end
    else
        obj = File(all_files(i));
    end

    % Always extract info and raw data
    objects{i} = obj.extract_info();
end
