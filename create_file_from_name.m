function obj = create_file_from_name(filename, directory, calibration, ref)
    fname = lower(filename);
    
    is_ref = contains(fname, ref);
    is_calib = contains(fname, calibration);
    is_bg = contains(fname, "bg") || contains(fname, "bkg");

    if is_calib
        obj = File(filename, directory);  % or CalibrationFile if needed
    elseif is_ref && is_bg
        obj = ReferenceBackground(filename, directory);
    elseif is_ref && ~is_bg
        obj = ReferenceFile(filename, directory);
    elseif ~is_ref && is_bg
        obj = SampleBackground(filename, directory);
    else
        obj = SampleFile(filename, directory);
    end

    % Always extract info and raw data
    obj = obj.extract_info(calibration, ref);
end
