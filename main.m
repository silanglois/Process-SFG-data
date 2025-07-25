clear
% === Setup ===
addpath(genpath('classes'));

data_dir = fullfile(pwd, 'data');
calibration_str = "calibration";
ref_str = "ref";

% === Load and classify all files ===
all_files = dir(fullfile(data_dir, '*.csv'));

