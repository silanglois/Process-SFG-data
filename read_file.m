function obj = read_file(filename, directory, ref)
    fname = lower(filename);
    
    is_sample = ~contains(fname, ref);
    is_sig = ~contains(fname, "bg") || contains(fname, "bkg") || contains(fname, "background");

    if is_sig
        if is_sample
            obj = SampleFile(filename, directory);
        else
            obj = SignalFile(filename, directory);
        end
    else
        obj = File(filename, directory);
    end

    % Always extract info and raw data
    obj = obj.extract_info();
end
