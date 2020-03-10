function varargout = trackingGUI(varargin)
% TRACKINGGUI MATLAB code for trackingGUI.fig
%      TRACKINGGUI, by itself, creates a new TRACKINGGUI or raises the existing
%      singleton*.
%
%      H = TRACKINGGUI returns the handle to a new TRACKINGGUI or the handle to
%      the existing singleton*.
%
%      TRACKINGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRACKINGGUI.M with the given input arguments.
%
%      TRACKINGGUI('Property','Value',...) creates a new TRACKINGGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before trackingGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to trackingGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above textLD1 to modify the response to help trackingGUI

% Last Modified by GUIDE v2.5 03-Feb-2020 14:32:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @trackingGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @trackingGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
else
%     init_plot_ltsa_doa
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
    
end
% End initialization code - DO NOT EDIT


% --- Executes just before trackingGUI is made visible.
function trackingGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to trackingGUI (see VARARGIN)

% Choose default command line output for trackingGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes trackingGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = trackingGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       generate/refresh plots for editing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in refresh.
function refresh_Callback(hObject, eventdata, handles)
% hObject    handle to refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
geeKids = get(0, 'Children');

if ismember(139, [geeKids.Number])
    pos = get(139, 'Position');
    fig = init_plot_angles(pos);
else
    fig = init_plot_angles;
end

% --- Executes on button press in undo.
function undo_Callback(hObject, eventdata, handles)
% hObject    handle to undo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global REMORA
temp = REMORA.brushing;
REMORA.brushing = REMORA.brushing_previous; % Store previous state of plot for undo function
REMORA.brushing_previous = temp;

plot_angles;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Drop down menu functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on selection change in options.
function options_Callback(hObject, eventdata, handles)
% hObject    handle to options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns options contents as cell array
%        contents{get(hObject,'Value')} returns selected item from options
global REMORA

contents = cellstr(get(hObject, 'String'));
str = contents{get(hObject,'Value')};
disp(str)
    
if strcmp(str, 'Load previously saved track')
    FilterSpec = '*.mat';
    BoxTitle = 'Select file';
    [FileName,PathName] = uigetfile(FilterSpec,BoxTitle);
    pfn = fullfile(PathName,FileName);
    load(pfn)
    
    % load data
    REMORA.trk = trk;
    REMORA.brushing = brushing;
    REMORA.H1 = hydLoc.H1;
    REMORA.H2 = hydLoc.H2;
    REMORA.H0 = hydLoc.H0;
    plot_angles;
    
elseif strcmp(str, 'Change detection file')
   
    boxTitle2 = 'Choose Array 1 DOA file';
    filterSpec2 = '*.mat';
    [REMORA.doa.infile1,REMORA.doa.inpath1]=uigetfile(filterSpec2,boxTitle2);
    load(fullfile(REMORA.doa.inpath1,REMORA.doa.infile1));
    REMORA.doa.Ang1 = Ang;
    REMORA.doa.TDet1 = TDet;
    REMORA.doa.LDet1 = LDet;
    REMORA.H1 = HydLoc;
    
    boxTitle2 = 'Choose Array 2 DOA file';
    filterSpec2 = '*.mat';
    [REMORA.doa.infile2,REMORA.doa.inpath2]=uigetfile(filterSpec2,boxTitle2);
    load(fullfile(REMORA.doa.inpath2,REMORA.doa.infile2));
    REMORA.doa.Ang2 = Ang;
    REMORA.doa.TDet2 = TDet;
    REMORA.doa.LDet2 = LDet;
    REMORA.H2 = HydLoc;
    
    init_plot_angles;
    
end

% --- Executes during object creation, after setting all properties.
function options_CreateFcn(hObject, eventdata, handles)
% hObject    handle to options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Whale button functionalities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in whale1.
function whale1_Callback(hObject, eventdata, handles)
% hObject    handle to whale1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
label_whale(1)

% --- Executes on button press in whale2.
function whale2_Callback(hObject, eventdata, handles)
% hObject    handle to whale2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
label_whale(2)


% --- Executes on button press in whale3.
function whale3_Callback(hObject, eventdata, handles)
% hObject    handle to whale3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
label_whale(3)


% --- Executes on button press in whale4.
function whale4_Callback(hObject, eventdata, handles)
% hObject    handle to whale4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
label_whale(4)

% --- Executes on button press in whale5.
function whale5_Callback(hObject, eventdata, handles)
% hObject    handle to whale5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
label_whale(5)

% --- Executes on button press in whale6.
function whale6_Callback(hObject, eventdata, handles)
% hObject    handle to whale6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
label_whale(6)

% --- Executes on button press in whale7.
function whale7_Callback(hObject, eventdata, handles)
% hObject    handle to whale7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
label_whale(7)

% --- Executes on button press in whale8.
function whale8_Callback(hObject, eventdata, handles)
% hObject    handle to whale8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
label_whale(8)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DELETE SELECTION / REMOVE LABEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in removeLabel.
function removeLabel_Callback(hObject, eventdata, handles)
% hObject    handle to removeLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
label_whale(0)

% --- Executes on button press in deletepoints.
function deletepoints_Callback(hObject, eventdata, handles)
% hObject    handle to deletepoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete_selection



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THRESHOLD ADJUSTMENT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on slider movement.
function LDet1_Callback(hObject, eventdata, handles)
% hObject    handle to textLD1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global REMORA
TH = get(hObject,'Value'); % proportion of points to be removed (e.g. 0.1 = 10% of points removed)

% calculate Threshold value
Lsort = sort(REMORA.brushing.all.AR1.LDet);
Lrem = length(Lsort)*TH; % number of points to be removed
Lth = Lsort(max([floor(Lrem), 1])); % 

% Prevents only the highest values from being detected (included because
% the program would crash otherwise):
if Lth == Lsort(end)
    Lunique = unique(Lsort);
    Lth = Lunique(end-1);
end

REMORA.brushing.all.AR1.label(REMORA.brushing.all.AR1.label==-2) = 0;
N = find(REMORA.brushing.all.AR1.LDet<Lth & REMORA.brushing.all.AR1.label>=0);
REMORA.brushing.all.AR1.label(N) = -2;

plot_angles;

% --- Executes during object creation, after setting all properties.
function LDet1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textLD1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function LDet2_Callback(hObject, eventdata, handles)
% hObject    handle to textLD2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global REMORA
TH = get(hObject,'Value'); % proportion of points to be removed (e.g. 0.1 = 10% of points removed)

% calculate Threshold value
Lsort = sort(REMORA.brushing.all.AR2.LDet);
Lrem = length(Lsort)*TH; % number of points to be removed
Lth = Lsort(max([floor(Lrem), 1])); % 

% Prevents only the highest values from being detected (included because
% the program would crash otherwise):
if Lth == Lsort(end)
    Lunique = unique(Lsort);
    Lth = Lunique(end-1);
end
    
REMORA.brushing.all.AR2.label(REMORA.brushing.all.AR2.label==-2) = 0;
N = find(REMORA.brushing.all.AR2.LDet<Lth & REMORA.brushing.all.AR2.label>=0);
REMORA.brushing.all.AR2.label(N) = -2;

plot_angles;

% --- Executes during object creation, after setting all properties.
function LDet2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textLD2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate 3-D Plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  --- Executes on button press in regen3D.
function regen3D_Callback(hObject, eventdata, handles)
% hObject    handle to regen3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot_track;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Export data and plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function exportpath_Callback(hObject, eventdata, handles)
% hObject    handle to exportpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of exportpath as textLD1
%        str2double(get(hObject,'String')) returns contents of exportpath as a double
global REMORA
REMORA.export.pathname = get(hObject, 'String');


% --- Executes during object creation, after setting all properties.
function exportpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exportpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function exportName_Callback(hObject, eventdata, handles)
% hObject    handle to exportName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of exportName as textLD1
%        str2double(get(hObject,'String')) returns contents of exportName as a double
% global REMORA
filename = get(hObject, 'String');

% --- Executes during object creation, after setting all properties.
function exportName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exportName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in exportTrk.
function exportTrk_Callback(hObject, eventdata, handles)
% hObject    handle to exportTrk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

f = msgbox('Saving Files ...');
global REMORA

hp = findobj('Tag', 'exportpath');
hn = findobj('Tag','exportName');

fpn = fullfile(hp.String, hn.String);

if ~exist(hp.String, 'dir')
    mkdir(hp.String)
end

% save figures:
fig = figure(139);
saveas(fig, [fpn, '_angles'], 'fig')
saveas(fig, [fpn, '_angles'], 'jpg')

fig = figure(140);
saveas(fig, [fpn, '_track3D'], 'fig')
saveas(fig, [fpn, '_track3D'], 'jpg')

fig = figure(141);
saveas(fig, [fpn, '_depthVsTime'], 'fig')
saveas(fig, [fpn, '_depthVsTime'], 'jpg')

% save data
track = REMORA.track;
brushing = REMORA.brushing;
hydLoc.H1 = REMORA.H1;
hydLoc.H2 = REMORA.H2;
hydLoc.H0 = REMORA.H0;

save(fpn, 'track', 'brushing', 'hydLoc')

close(f)
fprintf(['Files Saved!\nThank you for finding this whale!\n'])
