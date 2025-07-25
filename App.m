classdef App < matlab.apps.AppBase

    % Properties
    properties (Access = private)
        UIFigure matlab.ui.Figure
        MatchTab matlab.ui.container.Tab
        Grid matlab.ui.container.GridLayout

        sampleFiles           % Cell array of SampleFile objects
        signalFiles           % Cell array of SignalFile objects
        backgroundFiles       % Cell array of BackgroundFile objects
        referenceFiles        % Cell array of ReferenceFile objects

        SignalDropdowns       % Signal dropdown handles
        BackgroundDropdowns   % Background dropdown handles
        ReferenceDropdowns    % Reference dropdown handles
    end

    methods (Access = private)

        function loadFiles(app)
            data_dir = fullfile(pwd, 'data');
            detected_files = dir(fullfile(data_dir, '*.csv'));

            ref_str = "zqz";
            app.sampleFiles = {};
            app.signalFiles = {};
            app.backgroundFiles = {};
            app.referenceFiles = {};

            for i = 1:numel(detected_files)
                fname = lower(detected_files(i).name);
                is_sample = ~contains(fname, ref_str);
                is_sig = ~contains(fname, "bg") || contains(fname, "bkg") || contains(fname, "background");

                if is_sig
                    if is_sample
                        f = SampleFile(detected_files(i));
                        app.sampleFiles{end+1} = f;
                    else
                        f = SignalFile(detected_files(i));
                        app.signalFiles{end+1} = f;
                    end
                else
                    f = File(detected_files(i));
                    app.backgroundFiles{end+1} = f;
                end
            end

            app.referenceFiles = app.signalFiles;
        end

        function createMatchingUI(app)
            delete(app.MatchTab.Children);

            n = numel(app.sampleFiles);
            app.Grid = uigridlayout(app.MatchTab, [n+1, 4]);
            app.Grid.RowHeight = repmat({'fit'}, 1, n+1);
            app.Grid.ColumnWidth = {'3x', '2x', '2x', '2x'};

            % Header row
            uilabel(app.Grid, 'Text', 'Sample File');
            uilabel(app.Grid, 'Text', 'Signal File');
            uilabel(app.Grid, 'Text', 'Background File');
            uilabel(app.Grid, 'Text', 'Reference File');

            sigNames = string(cellfun(@(f) f.filename, app.signalFiles, 'UniformOutput', false));
            bgNames = string(cellfun(@(f) f.filename, app.backgroundFiles, 'UniformOutput', false));
            refNames = string(cellfun(@(f) f.filename, app.referenceFiles, 'UniformOutput', false));

            app.SignalDropdowns = gobjects(n, 1);
            app.BackgroundDropdowns = gobjects(n, 1);
            app.ReferenceDropdowns = gobjects(n, 1);

            for i = 1:n
                sf = app.sampleFiles{i};

                uilabel(app.Grid, 'Text', sf.filename, 'Interpreter', 'none');

                app.SignalDropdowns(i) = uidropdown(app.Grid, ...
                    'Items', sigNames, 'Placeholder', 'Select Signal');

                app.BackgroundDropdowns(i) = uidropdown(app.Grid, ...
                    'Items', bgNames, 'Placeholder', 'Select Background');

                app.ReferenceDropdowns(i) = uidropdown(app.Grid, ...
                    'Items', refNames, 'Placeholder', 'Select Reference');
            end
        end

        function startupFcn(app)
            loadFiles(app);
            createMatchingUI(app);
        end
    end

    methods (Access = private)

        function createComponents(app)
            app.UIFigure = uifigure('Name', 'Sample File Matcher', 'Position', [100, 100, 800, 600]);
            tabs = uitabgroup(app.UIFigure);
            app.MatchTab = uitab(tabs, 'Title', 'File Matching');
        end
    end

    methods (Access = public)

        function app = App()
            createComponents(app);
            registerApp(app, app.UIFigure);
            startupFcn(app);
        end
    end
end
