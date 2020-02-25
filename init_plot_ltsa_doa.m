function init_plot_ltsa_doa
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This is the callback for the ui function.  Input arguments are:
%	src - handle calling the function
%	ev - event data
% These are the basic callback input arguments, and event data can be empty
% if the callback functions without it.
% See http://www.mathworks.com/help/matlab/creating_plots/function-handle-callbacks.html
% for more information on callbacks.
%
% This callback creates a new formatted figure, reads the humpback.wav file
% included in the Triton folder, creates a spectrogram, and overlays text.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global REMORA PARAMS HANDLES PARAMS2 HANDLES2

REMORA.plot.value = 1;

% Make a new window and give it a handle in the global HANDLES struct
REMORA.ltsa_doa.fig = figure('NumberTitle', 'off',...
    'Name', 'LTSA DOA',...
    'Units', 'normalized',...
    'Visible', 'on',...
    'MenuBar', 'figure',...
    'Position', [0.335,0.05,0.65,0.875]);
%             'Position', [1.02,0.05,0.65,0.875]);

% REMORA.doa.fig = figure('NumberTitle', 'off',...
%     'Name', 'DOAs',...
%     'Units', 'normalized',...
%     'Visible', 'on',...
%     'MenuBar', 'figure',...
%     'Position', [1.02 0.05,0.65,0.875]);
%         'Position', [1.70 0.05,0.275,0.875]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get 2nd LTSA file

% save orignial globals
PARAMSsav = PARAMS;
HANDLESsav = HANDLES;

% user interface retrieve file to open through a dialog box
boxTitle1 = 'Open 2nd LTSA File';
filterSpec1 = '*.ltsa';
[PARAMS.ltsa.infile,PARAMS.ltsa.inpath]=uigetfile(filterSpec1,boxTitle1);
% if the cancel button is pushed, then no file is loaded so exit this script
if strcmp(num2str(PARAMS.ltsa.infile),'0')
    disp_msg('Cancel open LTSA file')
    return
else % give user some feedback
    disp_msg('Opened File: ')
    disp_msg([PARAMS.ltsa.inpath,PARAMS.ltsa.infile])
    cd(PARAMS.ltsa.inpath)
end
init_ltsadata
% save 2nd ltsa globals
PARAMS2 = PARAMS;
HANDLES2 = HANDLES;
% put original globals back
PARAMS = PARAMSsav;
HANDLES = HANDLESsav;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get DOA files

boxTitle2 = 'Choose 1st DOA file';
filterSpec2 = '*.mat';
[REMORA.doa.infile1,REMORA.doa.inpath1]=uigetfile(filterSpec2,boxTitle2);
load(fullfile(REMORA.doa.inpath1,REMORA.doa.infile1));
REMORA.doa.Ang1 = Ang;
REMORA.doa.TDet1 = TDet;
REMORA.doa.LDet1 = LDet;
REMORA.H1 = HydLoc;
%%%%

boxTitle2 = 'Choose 2st DOA file';
filterSpec2 = '*.mat';
[REMORA.doa.infile2,REMORA.doa.inpath2]=uigetfile(filterSpec2,boxTitle2);
load(fullfile(REMORA.doa.inpath2,REMORA.doa.infile2));
REMORA.doa.Ang2 = Ang;
REMORA.doa.TDet2 = TDet;
REMORA.doa.LDet2 = LDet;
REMORA.H2 = HydLoc;


REMORA.H0 = mean([REMORA.H1; REMORA.H2]); % set center of plot

%%%%%%%%%%%%%%%%%%%%%%%%
% make first plot
plot_ltsa_doa

% generate tracking GUI and set default position
monPos = get(0,'MonitorPositions'); % get position of monitors (in pixels)
noOfMonitors = size(monPos, 1); % get number of monitors

if monPos(1,4) <= 900 && noOfMonitors==1 % one small screen
    G = trackingGUI_small; % generate tracking GUI
    GUIpos = getpixelposition(G,true); % retreive default location of tracking GUI -- used to set size of GUI
    set(G, 'units', 'pixels', 'Position', [0, 39, GUIpos(3),GUIpos(4)], 'units', 'pixels')
elseif monPos(1,4) > 900 && noOfMonitors==1 % one adequately large screen
    G = trackingGUI; % generate tracking GUI
    GUIpos = getpixelposition(G,true); % retreive default location of tracking GUI -- used to set size of GUI
    set(G, 'units', 'pixels', 'Position', [0, 39, GUIpos(3), GUIpos(4)], 'units', 'pixels')
elseif noOfMonitors>1 % dual screen mode
    G = trackingGUI; % generate tracking GUI
    GUIpos = getpixelposition(G,true); % retreive default location of tracking GUI -- used to set size of GUI
    set(G, 'units', 'pixels', 'Position', [monPos(2,1)+5, 39, GUIpos(3), GUIpos(4)], 'units', 'pixels')
end

% for testing small GUI:
% G = trackingGUI_small; % generate tracking GUI
% GUIpos = getpixelposition(G,true); % retreive default location of tracking GUI -- used to set size of GUI
% set(G, 'units', 'pixels', 'Position', [0, 39, GUIpos(3),GUIpos(4)], 'units', 'pixels')

return



