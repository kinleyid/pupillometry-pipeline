function pupl_UI

% The UI layout is stored in this file

global userInterface

userInterface = figure('Name', '',...
    'NumberTitle', 'off',...
    'UserData', struct(...
        'dataCount', 0,...
        'activeEyeDataIdx', logical([])),...
    'SizeChangedFcn', @preservelayout,...
    'CloseRequestFcn', @savewarning,...
    'MenuBar', 'none',...
    'ToolBar', 'none',...
    'Visible', 'off');

%% Active datasets
uibuttongroup('Title', 'Active datasets',...
    'Tag', 'activeEyeDataPanel',...
    'Position',[0.01 0.01 .98 0.95],...
    'FontSize', 10);

%% File menu
fileMenu = uimenu(userInterface,...
    'Tag', 'fileMenu',...
    'Label', '&File');
uimenu(fileMenu,...
    'Label', '&Load',...
    'Callback', @(h, e)...
        updateglobals(...
            'eyeData',...
            'append',...
            @() pupl_load('type', 'eye data'),...
            1));
uimenu(fileMenu,...
    'Tag', 'importEyeDataMenu',...
    'Label', '&Import');
uimenu(fileMenu,...
    'Label', '&Save',...
    'UserData', @() isnonemptyfield(getactive('eye data')),...
    'Callback', @(src, event)...
        updateglobals([], [],...
            @() pupl_save('type', 'eye data', 'data', getactive('eye data')), []));
uimenu(fileMenu,...
    'Label', '&Batch save',...
    'UserData', @() isnonemptyfield(getactive('eye data')),...
    'Callback', @(src, event)...
        updateglobals([], [],...
            @() pupl_save('type', 'eye data', 'data', getactive('eye data'), 'batch', true), []));
uimenu(fileMenu,...
    'Label', '&Remove inactive datasets',...
    'UserData', @() dataexists('eye data'),...
    'Separator', 'on',...
    'Callback', @(src, event)...
        updateglobals([], [],...
            @() deleteinactive('eye data'), []));

%% Processing menu
processingMenu = uimenu(userInterface,...
    'Label', '&Process',...
    'UserData', @() isnonemptyfield(getactive('eye data')));
uimenu(processingMenu,...
    'Label', '&Normalize data',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'diam', 'left'),...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() pupl_normalize(getactive('eye data')),...
            1));
trimmingMenu = uimenu(processingMenu,...
    'Label', '&Trim data');
uimenu(trimmingMenu,...
    'Label', 'Trim extreme &dilation values',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'diam', 'left'),...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() trimdiam(getactive('eye data')),...
            1));
uimenu(trimmingMenu,...
    'Label', 'Trim extreme &gaze values',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'gaze', 'x'),...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() trimgaze(getactive('eye data')),...
            1));
uimenu(trimmingMenu,...
    'Label', 'Trim &isolated samples',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'diam', 'left'),...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() trimshort(getactive('eye data')),...
            1));
%{
blinksMenu = uimenu(processingMenu,...
    'Label', '&Blinks');
uimenu(blinksMenu,...
    'Label', 'Identify &blinks',...
    'Enable', 'off',...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() identifyblinks(getactive('eye data')),...
            1));
uimenu(blinksMenu,...
    'Label', 'Delete &blink samples',...
    'Enable', 'off',...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() deleteblinks(getactive('eye data')),...
            1));
%}
filterMenu = uimenu(processingMenu,...
    'Label', 'Moving average &filter');
uimenu(filterMenu,...
    'Label', '&Dilation data',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'diam', 'left'),...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() eyefilter(getactive('eye data'), 'dataType', 'Dilation'),...
            1));
uimenu(filterMenu,...
    'Label', '&Gaze data',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'gaze', 'x'),...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() eyefilter(getactive('eye data'), 'dataType', 'Gaze', 'filterType', 'median'),...
            1));
saccadesMenu = uimenu(processingMenu,...
    'Label', 'Identify &saccades and fixations',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'gaze', 'x'));
uimenu(saccadesMenu,...
    'Label', '&Velocity threshold',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'gaze', 'x'),...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() velocitythresholdsaccadeID(getactive('eye data')),...
            1));
uimenu(saccadesMenu,...
    'Label', '&Dispersion threshold',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'gaze', 'x'),...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() dispersionsaccadeID(getactive('eye data')),...
            1));
uimenu(processingMenu,...
    'Label', 'Map gaze data to fixation &centroids',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'diam', 'left'),...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() maptofixationcentroid(getactive('eye data')),...
            1));
uimenu(processingMenu,...
    'Label', '&Interpolate diameter data',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'diam', 'left'),...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() interpeyedata(getactive('eye data')),...
            1));
uimenu(processingMenu,...
    'Label', '&Merge left and right diameter streams',...
    'UserData', @() isnonemptyfield(getactive('eye data')),...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() mergelr(getactive('eye data'), 'diamlr'),...
            1));
PFEmenu = uimenu(processingMenu,...
    'Label', 'Pupil foreshortening &error correction');
uimenu(PFEmenu,...
    'Label', '&Linear detrend in gaze y-axis',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'diam', 'left') &...
        isnonemptyfield(getactive('eye data'), 'gaze', 'y'),...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() PFEdetrend(getactive('eye data'), 'axis', 'y'),...
            1));
uimenu(PFEmenu,...
    'Label', '&Quadratic detrend in gaze x-axis',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'diam', 'left') &...
        isnonemptyfield(getactive('eye data'), 'gaze', 'y'),...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() PFEdetrend(getactive('eye data'), 'axis', 'x'),...
            1));
uimenu(PFEmenu,...
    'Label', 'Automatic PFE correction (beta)',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'diam', 'left') &...
        isnonemptyfield(getactive('eye data'), 'gaze', 'y'),...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() PFEcorrection(getactive('eye data')),...
            1));

%% Trials menu
trialsMenu = uimenu(userInterface,...
    'Label', '&Trials',...
    'UserData', @() isnonemptyfield(getactive('eye data')));
%% Event logs menu
eventLogsMenu = uimenu(trialsMenu,...
    'Label', '&Event logs');
uimenu(eventLogsMenu,...
    'Tag', 'importEventLogsMenu',...
    'Label', '&Import');
uimenu(eventLogsMenu,...
    'Label', '&Synchronize with eye data',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'eventlog'),...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() attachevents(getactive('eye data')),...
            1));
%% Event-related pupillometry menu
pupillometryMenu = uimenu(trialsMenu,...
    'Label', 'Event-related pupillometry',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'event'));
uimenu(pupillometryMenu,...
    'Label', '&Fragment continuous data into trials',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'diam', 'left'),...
    'Interruptible', 'off',...
    'Separator', 'on',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() pupl_epoch(getactive('eye data')),...
            1));
uimenu(pupillometryMenu,...
    'Label', '&Baseline correction',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'epoch'),...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() baselinecorrection(getactive('eye data')),...
            1));
trialRejectionMenu = uimenu(pupillometryMenu,...
    'Label', 'Trial &rejection',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'epoch'));
% Rejection sub-menu
uimenu(trialRejectionMenu,...
    'Label', 'Reject by &missing data',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'epoch'),...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() rejecttrialsbymissingppn(getactive('eye data')),...
            1));
uimenu(trialRejectionMenu,...
    'Label', 'Reject by &blink proximity',...
    'Enable', 'off',...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() rejecttrialsbyblinkproximity(getactive('eye data')),...
            1));
uimenu(trialRejectionMenu,...
    'Label', 'Reject by e&xtreme dilation',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'epoch'),...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() rejectbyextremevalues(getactive('eye data')),...
            1));
uimenu(trialRejectionMenu,...
    'Label', '&Un-reject trials',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'epoch'),...
    'Interruptible', 'off',...
    'Separator', 'on',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() unreject(getactive('eye data')),...
            1));
uimenu(pupillometryMenu,...
    'Label', '&Merge trials into sets',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'epoch'),...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() binepochs(getactive('eye data')),...
            1));
uimenu(pupillometryMenu,...
    'Label', 'Write &statistics to spreadsheet',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'bin'),...
    'Callback', @(src, event)...
        pupl_stats(getactive('eye data')));
%% Gaze tracking menu
gazeTrackingMenu = uimenu(trialsMenu,...
    'Label', '&Gaze tracking',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'event'));
defineAOImenu = uimenu(gazeTrackingMenu,...
    'Label', '&Define areas of interest',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'event'));
uimenu(defineAOImenu,...
    'Label', '&Rectangular',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'event'),...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() defineRectAOIs(getactive('eye data')),...
            1));
uimenu(defineAOImenu,...
    'Label', '&Polygonal',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'event'),...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() definePolyAOIs(getactive('eye data')),...
            1));
uimenu(defineAOImenu,...
    'Label', '&Circular',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'event'),...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() defineCircAOIs(getactive('eye data')),...
            1));
uimenu(defineAOImenu,...
    'Label', '&Elliptical',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'event'),...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() defineEllipticalAOIs(getactive('eye data')),...
            1));
uimenu(gazeTrackingMenu,...
    'Label', '&Compute stats',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'aoi'),...
    'Interruptible', 'off',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            getfield(get(userInterface, 'UserData'), 'activeEyeDataIdx'),...
            @() computeAOIstats(getactive('eye data')),...
            1));
%% Experiment menu
experimentMenu = uimenu(userInterface,...
    'Label', '&Experiment',...
    'UserData', @() isnonemptyfield(getactive('eye data')));
uimenu(experimentMenu,...
    'Label', '&Assign datasets to conditions',...
    'Callback', @(src, event)...
        updateglobals('eyeData',...
            'append',...
            @() pupl_condition(getactive('eye data')),...
            1));

%% Plotting menu
plottingMenu = uimenu(userInterface,...
    'Label', 'P&lot',...
    'UserData', @() isnonemptyfield(getactive('eye data')));
scrollMenu = uimenu(plottingMenu,...
    'Label', 'Plot &continuous');
uimenu(scrollMenu,...
    'Label', 'P&upil dilation',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'diam', 'left'),...
    'Callback', @(src, event)...
        plotcontinuous(getactive('eye data'), 'type', 'dilation'));
uimenu(scrollMenu,...
    'Label', 'Ga&ze',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'gaze', 'x'),...
    'Callback', @(src, event)...
        plotcontinuous(getactive('eye data'), 'type', 'gaze'));
uimenu(plottingMenu,...
    'Label', 'Plot &trials',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'epoch'),...
    'Callback', @(src, event)...
        plottrials(getactive('eye data')));
plotTrialSetsMenu = uimenu(plottingMenu,...
    'Label', 'Plot trial &sets',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'bin'));
uimenu(plotTrialSetsMenu,...
    'Label', '&Line plot',...
    'Callback', @(src, event)...
        plottrialaverages(getactive('eye data')));
uimenu(plotTrialSetsMenu,...
    'Label', '&Heatmap',...
    'Callback', @(src, event)...
        eyeheatmap(getactive('eye data')));
uimenu(plottingMenu,...
    'Label', 'Pupil &foreshortening error surface',...
    'UserData', @() isnonemptyfield(getactive('eye data'), 'diam', 'left'),...
    'Callback', @(h, e)...
        UI_getPFEsurfaceparams(getactive('eye data')));

update_UI;

end