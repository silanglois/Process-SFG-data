clear
% % === Setup ===
% addpath(genpath('classes'));
% 
% data_dir = fullfile(pwd, 'data');
% calibration_str = "polystyrene";
% ref_str = "zqz";
% 
% % === Load and classify all files ===
% detected_files = dir(fullfile(data_dir, '*.csv'));
% 
% files = cell(1, numel(detected_files));
% 
% for i = 1:numel(detected_files)
%     fname = lower(detected_files(i).name);
%     is_sample = ~contains(fname, ref_str);
%     is_sig = ~contains(fname, "bg") || contains(fname, "bkg") || contains(fname, "background");
% 
%     if is_sig
%         if is_sample
%             f = SampleFile(detected_files(i));
%         else
%             f = SignalFile(detected_files(i));
%         end
%     else
%         f = File(detected_files(i));
%     end
% 
%     % Always extract info and raw data
%     files{i} = f.extract_info();
% end
% 
% 
% for i = 1:length(files)
%     f = files{i}; % Access the File object in the cell
%     plot(f.raw_data.Wavelength, f.raw_data.Intensity);
%     hold on;
% end
% 
% xlabel('Wavelength (nm)');
% ylabel('Intensity (cts)');
% hold off;

app = App();