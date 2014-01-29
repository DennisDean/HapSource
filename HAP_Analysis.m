function varargout = HAP_Analysis(varargin)
% HAP_ANALYSIS M-file for HAP_Analysis.fig
%      HAP_ANALYSIS, by itself, creates a new
%      HAP_ANALYSIS or raises the existing
%      singleton*.
%
%      H = HAP_ANALYSIS returns the handle to a new HAP_ANALYSIS or the handle to
%      the existing singleton*.
%
%      HAP_ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HAP_ANALYSIS.M with the given input arguments.
%
%      HAP_ANALYSIS('Property','Value',...) creates a new
%      HAP_ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HAP_Analysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HAP_Analysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
% HAP_ANALAYSIS Program applied HAP analysis to data
%      The program implemnets Hierarchically AdaPtive (HAP) analysis, a 
% suite of multiple complementary techniques that enable rapid analysis of
% data and require no user input.
%
% The methods are described in detail in:
%
% Dean II, D. A. (2011) Integrating Formal Language Theory with Mathematical 
% Modeling to Solve Computational Issues in Sleep and Circadian Applications 
% [dissertation]. University of Massachusetts. 239 p.
%
%
% Informatician: Dennis A. Dean, II, Ph.D 
%
% Divison of Sleep Medicine
% Brigham and Women's Hospital
% Harvard Medical School
% 221 Longwood Ave
% Boston, MA  02149
%
% Release: 0.8 Beta
%
% Copyright © [2012] The Brigham and Women's Hospital, Inc. THE BRIGHAM AND 
% WOMEN'S HOSPITAL, INC. AND ITS AGENTS RETAIN ALL RIGHTS TO THIS SOFTWARE 
% AND ARE MAKING THE SOFTWARE AVAILABLE ONLY FOR SCIENTIFIC RESEARCH 
% PURPOSES. THE SOFTWARE SHALL NOT BE USED FOR ANY OTHER PURPOSES, AND IS
% BEING MADE AVAILABLE WITHOUT WARRANTY OF ANY KIND, EXPRESSED OR IMPLIED, 
% INCLUDING BUT NOT LIMITED TO IMPLIED WARRANTIES OF MERCHANTABILITY AND 
% FITNESS FOR A PARTICULAR PURPOSE. THE BRIGHAM AND WOMEN'S HOSPITAL, INC. 
% AND ITS AGENTS SHALL NOT BE LIABLE FOR ANY CLAIMS, LIABILITIES, OR LOSSES 
% RELATING TO OR ARISING FROM ANY USE OF THIS SOFTWARE.
%
% Edit the above text to modify the response to help HAP_Analysis

% Last Modified by GUIDE v2.5 10-Jul-2012 10:15:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @HAP_Analysis_OpeningFcn, ...
    'gui_OutputFcn',  @HAP_Analysis_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before HAP_Analysis is made visible.
function HAP_Analysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HAP_Analysis (see VARARGIN)

% Choose default command line output for HAP_Analysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HAP_Analysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% create globals to share between interfaces
global gui_globals;

% Clear edit fields incase dialog box is called following a run
set(handles.e_database_fn, 'String', ' ');
set(handles.pm_subject_id, 'String', ' ');

% Define global variables and flags
handles.database_fn = '';
handles.datbase_pn = '';
handles.database_file_is_selected = 0;

% Database is loaded
handles.database_is_loaded = 0;
handles.database_fn = '';
handles.database_pn = '';
handles.hormone_database = {};

% Individual Subject Parameters
handles.subject_is_displayed = 0;
handles.fig_id = 0;

% Pulse Library
handles.subject_pulses = {};
handles.pulse_library = {};

handles.pulse_library_file_is_selected = 0;
handles.pulse_library_fn = '';
handles.pulse_library_pn = '';
handles.pulse_library_is_loaded = 0;

handles.num_pulses_by_subject = [];

% Storage for context free language
handles.cfl_results_struct = struct('partioning_cell_array_collection',...
        {},'start_path', '', 'result_folder','','file_name','',...
        'location', '');
handles.group_summary_file_is_selected = 0;
handles.group_summary_fn = '';
handles.group_summary_pn = '';
handles.partioning_cell_array_collection = {};
    
% working with figures
handles.fig_set_info = [];


% set root path
handles.application_root_directory = cd;

guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = HAP_Analysis_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% Set starting position in characters. Had problems with pixels
left_border = .8;
header = 2.0;
MCMC_Drill = 3.93;
set(0,'Units','character') ;
screen_size = get(0,'ScreenSize');
set(handles.figure1,'Units','character');
dlg_size    = get(handles.figure1, 'Position');
pos1 = [ left_border , screen_size(4)-dlg_size(4)-1*header,...
    dlg_size(3) , dlg_size(4)];
set(handles.figure1,'Units','character');
set(handles.figure1,'Position',pos1);

% Store upper left hand corner of available space
left_ = dlg_size(3)+left_border*4;
top_ = screen_size(4) - 3*header - 0.2;
upper_left_corner = [left_  top_];
handles.upper_left_corner  = upper_left_corner;
guidata(hObject, handles);

% Create display rectagle
handles.display_rectangle = [ left_,                screen_size(2),...
    (screen_size(3)-left_), screen_size(4)];

[ left_,                screen_size(2),...
    (screen_size(3)-left_), screen_size(4)];

% Save changes to global handle
guidata(hObject, handles);


% redo but in pixel
% Set starting position in characters. Had problems with pixels
left_border = 3;
header = 2.0;

set(0,'Units','pixel') ;
screen_size = get(0,'ScreenSize');
set(handles.figure1,'Units','pixel');
dlg_size    = get(handles.figure1, 'position');
set(handles.figure1,'Units','character');
pos1 = [ left_border , screen_size(4)-dlg_size(4)-1*header,...
    dlg_size(3) , dlg_size(4)];

% Store upper left hand corner of available space
left_ = dlg_size(3)+left_border*4;
top_ = screen_size(4) - 3*header - 0.2;
upper_left_corner = [left_  top_];
guidata(hObject, handles);

% Create display rectagle
handles.display_rectangle = [ left_,                screen_size(2),...
    (screen_size(3)-left_), screen_size(4)];

% Save figure information
guidata(hObject, handles);


function e_database_fn_Callback(hObject, eventdata, handles)
% hObject    handle to e_database_fn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_database_fn as text
%        str2double(get(hObject,'String')) returns contents of e_database_fn as a double


% --- Executes during object creation, after setting all properties.
function e_database_fn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_database_fn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_select_db.
function pb_select_db_Callback(hObject, eventdata, handles)
% hObject    handle to pb_select_db (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[database_fn database_pn database_file_is_selected ] = pb_select_database_file_f();

% check if user selected a file
if database_file_is_selected == 1
    % write file name to dialog box
    set(handles.e_database_fn, 'String', database_fn);
    guidata(hObject, handles);
    
    % Save file information to globals
    handles.database_fn = database_fn;
    handles.database_pn = database_pn;
    handles.database_file_is_selected = database_file_is_selected;
    guidata(hObject, handles);
end

% --- Executes on button press in pb_load_db.
function pb_load_db_Callback(hObject, eventdata, handles)
% hObject    handle to pb_load_db (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

database_file_is_selected = handles.database_file_is_selected ;

if database_file_is_selected == 1;
    database_fn = handles.database_fn ;
    database_pn = handles.database_pn ;
    [hormone_database database_is_loaded ] = ...
        load_hormone_database_from_file(database_fn, database_pn);
    if database_is_loaded == 1
        % Set Subject ID Pop Up Menu
        subject_id_str = get_subject_id_cell(hormone_database);
        set(handles.pm_subject_id, 'String', subject_id_str);
        
        % Save load information to globals
        handles.database_is_loaded = database_is_loaded;
        handles.database_fn = database_fn;
        handles.database_pn = database_pn;
        handles.hormone_database = hormone_database;
        
        % Save changes to global variaables
        guidata(hObject, handles);
    else
        msgbox('Selected file does not contain ''hormone_database'' variable. Select another file.');
    end
else
    msgbox('Select database file');
end

% --- Executes on button press in pb_close_all.
function pb_close_all_Callback(hObject, eventdata, handles)
% hObject    handle to pb_close_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Selected windows to close


hands     = get (0,'Children');   % locate fall open figure handles
hands     = sort(hands);          % sort figure handles
numfigs   = size(hands,1);        % number of open figures
indexes   = find(hands-round(hands)==0);

close(hands(indexes));

% Set flags
handles.subject_is_displayed = 0;
handles.fig_id = 0;
fig_set_info = [];

guidata(hObject, handles);


% --- Executes on button press in pb_quit.
function pb_quit_Callback(hObject, eventdata, handles)
% hObject    handle to pb_quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pb_close_all_Callback(hObject, eventdata, handles);
close 'HAP_Analysis'
% --- Executes on button press in pb_about.
function pb_about_Callback(hObject, eventdata, handles)
% hObject    handle to pb_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

HAP_Analysis_About

% --- Executes on button press in pb_save.

function pb_save_Callback(hObject, eventdata, handles)
% hObject    handle to pb_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[pulse_library_fn pulse_library_pn library_file_is_selected ]...
    = pb_pulse_library_file();
if library_file_is_selected == 1
    pulse_library = handles.pulse_library;
    save_mat_file(pulse_library, pulse_library_fn, pulse_library_pn);
end


% --- Executes on selection change in pm_subject_id.
function pm_subject_id_Callback(hObject, eventdata, handles)
% hObject    handle to pm_subject_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pm_subject_id contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_subject_id


% --- Executes during object creation, after setting all properties.
function pm_subject_id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_subject_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_display.
function pb_display_Callback(hObject, eventdata, handles)
% hObject    handle to pb_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


database_is_loaded = handles.database_is_loaded;

if database_is_loaded == 1
    % Get database
    hormone_database = handles.hormone_database;
    
    % Get subject information
    subject_id_val = get(handles.pm_subject_id,'Value');
    subject_id_str = get(handles.pm_subject_id,'String');
    subject_id_str = subject_id_str(subject_id_val);
    
    % Set upper left hand position
    hormone_database.upper_left_corner = handles.upper_left_corner;
    
    % Generate plot
    hormone_plot = ...
        create_subject_plot_structure(hormone_database,subject_id_val);
    [fig_id v] = create_hormone_subject_w_sleep_plot(hormone_plot);
    
    % Save figure id for future analysis
    handles.subject_is_displayed = 1;
    handles.fig_id = fig_id;
    handles.subject_id_val = subject_id_val;
    
    guidata(hObject, handles);
end

% --- Executes on button press in pb_mark.
function pb_mark_Callback(hObject, eventdata, handles)
% hObject    handle to pb_mark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


subject_is_displayed= handles.subject_is_displayed;
if subject_is_displayed == 1
    % Get hormone database
    hormone_database = handles.hormone_database;
    
    % Get subject information
    subj_info.subject_id_val = get(handles.pm_subject_id,'Value');
    subject_id_str = get(handles.pm_subject_id,'String');
    subj_info.subject_id_str = subject_id_str(subj_info.subject_id_val);
    
    % Get figure id
    fig_info.fig_id = handles.fig_id;
    fig_exists = does_figure_exist(fig_info.fig_id);
    if fig_exists == 0
        pb_display_Callback(hObject, eventdata, handles)
    end
    
    % Get subject data
    [t Y] = get_subject_data(hormone_database, subj_info.subject_id_val);
    data_info.t = t;
    data_info.Y = Y;
    
    % Mark Figure
    [pulse_cells num_pulses] = pb_mark(subj_info, fig_info, data_info);
    
    % Save subject pulses to library
    if num_pulses > 0
        % Define subject pulses structure
        subject_pulses.pulse_cells = pulse_cells;
        subject_pulses.num_pulses = num_pulses;
        subject_pulses.subject_id_val = subj_info.subject_id_val;
        subject_pulses.subject_id_str = subj_info.subject_id_str;
        subject_pulses.data_info = data_info;
        
        % Store pulses
        handles.subject_pulses = subject_pulses;
        
        % Upload data
        guidata(hObject, handles);
    end
else
    msgbox('Display Subject data');
end

% --- Executes on button press in pb_estimate.
function pb_estimate_Callback(hObject, eventdata, handles)
% hObject    handle to pb_estimate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_display_all.
function pb_display_all_Callback(hObject, eventdata, handles)
% hObject    handle to pb_display_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

database_is_loaded = handles.database_is_loaded;
if database_is_loaded == 1;
    % Close all figures
    pb_close_all_Callback(hObject, eventdata, handles)
    
    % Draw a figure for each subject
    hormone_database = handles.hormone_database;
    hormone_database.upper_left_corner =  handles.upper_left_corner;
    
    fig_ids = pb_display_all(hormone_database);
    
    % Save figure ids for functionality to be added later
    handles.fig_ids = fig_ids;
    guidata(hObject, handles);
else
    msgbox('Load hormone database.');
end


% --- Executes on button press in pb_tile_figs.
function pb_tile_figs_Callback(hObject, eventdata, handles)
% hObject    handle to pb_tile_figs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Use old method for display all figures that are dislayed
maxpos    = get (0,'screensize'); % determine terminal size in pixels
maxpos(4) = maxpos(4) - 25;
hands     = get (0,'Children');   % locate fall open figure handles
hands     = sort(hands) ;         % sort figure handles

numfigs   = size(hands,1);        % number of open figures
indexes   = find(hands-round(hands)==0);
hands     = hands(indexes);

if ~isempty(hands)
    % get current monitor string
    monitor_str = get(handles.pm_monitor,'String');
    monitor_val = get(handles.pm_monitor,'Value');
    monitor_val = str2num(monitor_str(monitor_val));
    
    % define tile fig paramters
    figs = hands;
    figname = [];
    monitor = monitor_val;
    layout = [floor(sqrt(length(hands))) (floor(sqrt(length(hands)))+1)];
    if monitor_val == 0 % Default monitor value
        border = [0 0 0 handles.display_rectangle(1)];
        % [top bottom right left] pixels
    else
        border = [0 0 0 0];
    end
    
    % Define figure
    fighandle = tilefig(hands,figname,monitor_val, layout, border);
    
    if fighandle == -1
        % Error message
        h = warndlg('Exceeded 48 figure limit.', 'createMode','modal');
    end
end


% --- Executes on button press in pb_next.
function pb_next_Callback(hObject, eventdata, handles)
% hObject    handle to pb_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Save current subject entry
pb_mark_parameters_save_Callback(hObject, eventdata, handles)

% Select next subject
subject_id_val = get(handles.pm_subject_id,'Value');
subject_id_str = get(handles.pm_subject_id,'String');
num_values = length(subject_id_str);
new_subject_id_val = subject_id_val+1;
if new_subject_id_val>num_values
    new_subject_id_val = 1;
end
set(handles.pm_subject_id,'Value',new_subject_id_val)
guidata(hObject, handles);


% % Mark next subject
% pb_display_Callback(hObject, eventdata, handles)
%
%
% pb_mark_Callback(hObject, eventdata, handles)

% --- Executes on button press in pb_mark_parameters_save.
function pb_mark_parameters_save_Callback(hObject, eventdata, handles)
% hObject    handle to pb_mark_parameters_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get subject pulses
subject_pulses = handles.subject_pulses;

if isstruct(subject_pulses)==1
    % Get values
    subject_id_val = subject_pulses.subject_id_val;
    subject_id_str = subject_pulses.subject_id_str{1};
    
    % Get pulse library
    pulse_library = handles.pulse_library;
    pulse_library{subject_id_val} = subject_pulses;
    handles.pulse_library = pulse_library;
    
    % Save subject pulses to library
    guidata(hObject, handles);
    
    % Save figure
    flder = '.\marked_figures\';
    fig_id = handles.fig_id;
    fig_name = strcat(flder, subject_id_str, '.mrkd.fig');
    fig_name_2 = strcat(flder, subject_id_str, '.mrkd.tiff');
    saveas(fig_id, fig_name);
    saveas(fig_id, fig_name_2);
    
    fprintf('--- Pulse data for data id = %d corresponding to subject - %s was saved to pulse library.\n'...
        ,subject_id_val, subject_id_str);
end


% --- Executes on button press in pb_mark_pulses_load.
function pb_mark_pulses_load_Callback(hObject, eventdata, handles)
% hObject    handle to pb_mark_pulses_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Database is loaded glag
database_is_loaded = handles.database_is_loaded;

if database_is_loaded == 1;
    % Select pulse library file
    [pulse_library_fn pulse_library_pn pulse_library_file_is_selected ] = pb_select_pulse_library_file();
    
    % check if user selected a file
    if pulse_library_file_is_selected == 1
        % Save file information to globals
        handles.pulse_library_fn = pulse_library_fn;
        handles.pulse_library_pn = pulse_library_pn;
        handles.database_file_is_selected = pulse_library_file_is_selected;
        guidata(hObject, handles);
        
        
        [pulse_library pulse_library_is_loaded ] = ...
            load_pulse_library_from_file(pulse_library_fn, pulse_library_pn);
        if pulse_library_is_loaded == 1
            % Save load information to globals
            handles.pulse_library_is_loaded = pulse_library_is_loaded;
            handles.pulse_library_fn = pulse_library_fn;
            handles.pulse_library_pn = pulse_library_pn;
            handles.pulse_library = pulse_library;
            
            % Save changes to global variaables
            guidata(hObject, handles);
        end
    else
        msgbox('Select pulse library file');
    end
else
    msgbox('Load pulse database file');
end


% --- Executes on button press in pb_mark_pulses_list.
function pb_mark_pulses_list_Callback(hObject, eventdata, handles)
% hObject    handle to pb_mark_pulses_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get database flags
pulse_library_is_loaded = handles.pulse_library_is_loaded;
database_is_loaded = handles.database_is_loaded;

% Load and summarize datbases
if and(pulse_library_is_loaded == 1,database_is_loaded == 1)
    % Get hormone and pulses databases
    hormone_database = handles.hormone_database;
    pulse_library = handles.pulse_library;
    
    % Echo summary to console
    summarize_pulse_library(pulse_library, hormone_database);
else
    if (database_is_loaded ==0)
        msgbox('Load hormone database');
    else
        msgbox('Load pulse library.');
    end
end


function e_display_and_fit_pulses_pulse_library_file_Callback(hObject, eventdata, handles)
% hObject    handle to e_display_and_fit_pulses_pulse_library_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_display_and_fit_pulses_pulse_library_file as text
%        str2double(get(hObject,'String')) returns contents of e_display_and_fit_pulses_pulse_library_file as a double


% --- Executes during object creation, after setting all properties.
function e_display_and_fit_pulses_pulse_library_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_display_and_fit_pulses_pulse_library_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_display_and_fit_pulses_select.
function pb_display_and_fit_pulses_select_Callback(hObject, eventdata, handles)
% hObject    handle to pb_display_and_fit_pulses_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[pulse_library_fn pulse_library_pn pulse_library_file_is_selected ] ...
    = pb_select_pulse_library_file();

% check if user selected a file
if pulse_library_file_is_selected == 1
    % write file name to dialog box
    set(handles.e_display_and_fit_pulses_pulse_library_file, 'String', pulse_library_fn);
    guidata(hObject, handles);
    
    % Save file information to globals
    handles.pulse_library_fn = pulse_library_fn;
    handles.pulse_library_pn = pulse_library_pn;
    handles.pulse_library_file_is_selected = pulse_library_file_is_selected;
    guidata(hObject, handles);
end

% --- Executes on button press in pb_display_and_fit_pulses_load_pulse_library_file.
function pb_display_and_fit_pulses_load_pulse_library_file_Callback(hObject, eventdata, handles)
% hObject    handle to pb_display_and_fit_pulses_load_pulse_library_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Test if library file has been selected
pulse_library_file_is_selected = handles.pulse_library_file_is_selected ;

% If defined load library file
if pulse_library_file_is_selected == 1;
    pulse_library_fn = handles.pulse_library_fn ;
    pulse_library_pn = handles.pulse_library_pn ;
    [pulse_library pulse_library_is_loaded ] = ...
        load_pulse_library_from_file(pulse_library_fn, pulse_library_pn);
    if pulse_library_is_loaded == 1
        % Set Subject ID and Pulse ID Pop Up Menus
        [pulse_subject_id_str num_pulses_by_subject] = ...
            get_subject_id_from_pulse_library(pulse_library);
        set(handles.pm_display_and_fit_pulses_subject_id, 'String', pulse_subject_id_str);
        num_pulses_menu_strs = return_pulse_string_menu(num_pulses_by_subject(1));
        set(handles.pm_display_and_fit_pulses_pulse_id, 'String', num_pulses_menu_strs);
        
        % Save load information to globals
        handles.pulse_library_is_loaded = pulse_library_is_loaded;
        handles.pulse_library_fn = pulse_library_fn;
        handles.pulse_libarary_pn = pulse_library_pn;
        handles.pulse_library = pulse_library;
        
        % Save subject and pulse id variables for interactive use
        handles.pulse_subject_id_str = pulse_subject_id_str;
        handles.num_pulses_by_subject = num_pulses_by_subject;
        
        % Storage of pulse parameters for pulse kept in
        gui_globals.pulse_library_params = create_pulse_lib_param_struct(num_pulses_by_subject);
        %handles.pulse_library_params = pulse_library_params;
        
        % Save changes to global variaables
        guidata(hObject, handles);
    else
        msgbox('Selected file does not contain ''pulse_library'' variable. Select another file.');
    end
else
    msgbox('Select pulse library file');
end

% --- Executes on button press in pb_display_and_fit_pulses_display_all.
function pb_display_and_fit_pulses_display_all_Callback(hObject, eventdata, handles)
% hObject    handle to pb_display_and_fit_pulses_display_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Function Constant
DEBUG = 0;

% Check if pulse library is loaded
pulse_library_is_loaded = handles.pulse_library_is_loaded;
database_is_loaded = handles.database_is_loaded;

%
if and(pulse_library_is_loaded == 1, database_is_loaded == 1)
    % Get Pulse library
    pulse_library = handles.pulse_library;
    
    % Get Hormone Database
    hormone_database = handles.hormone_database;
    
    % Get identifying information for subject and pulse
    subject_id_val = get(handles.pm_display_and_fit_pulses_subject_id, 'Value');
    subject_id_str = get(handles.pm_subject_id,'String');
    num_subjects = length(subject_id_str);
    subject_id_str = subject_id_str(subject_id_val);
    
    % Generate list of vallid pulse ids
    pulse_id_str = get(handles.pm_display_and_fit_pulses_pulse_id, 'String');
    pulse_id_values = str2num(pulse_id_str);
    
    % Set upper left hand position
    hormone_database.upper_left_corner = handles.upper_left_corner;
    
    % Get display width
    display_width_val = get(handles.pm_display_and_fit_pulses_display_width, 'Value');
    
    % Get number of pulses by subject
    num_pulses_by_subject = handles.num_pulses_by_subject;
    
    % Echo parameters to console
    if DEBUG == 0
        fprintf('pb_display_and_fit_pulses_display_indv_Callback\n');
    end
    
    % Pulse panel figure id    pulse_panel_fig_id = create_hormone_pulse_panel_plot...
    [pulse_panel_fig_ids subj_tiff_fn subj_fig_fn] = create_hormone_pulse_panel_plots...
        (hormone_database, pulse_library, num_subjects, ...
        num_pulses_by_subject, display_width_val );
    
    
    % Save updated files
    handles.pulse_panel_fig_ids = pulse_panel_fig_ids;
    handles.subj_tiff_fn = subj_tiff_fn;
    handles.subj_fig_fn = subj_fig_fn;
    guidata(hObject, handles);
else
    if database_is_loaded == 0
        msgbox('Load hormone database file');
    else
        msgbox('Load pulse library file');
    end
end


% --- Executes on selection change in pm_display_and_fit_pulses_subject_id.
function pm_display_and_fit_pulses_subject_id_Callback(hObject, eventdata, handles)
% hObject    handle to pm_display_and_fit_pulses_subject_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pm_display_and_fit_pulses_subject_id contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_display_and_fit_pulses_subject_id

% Update Pulse ID after selection of new subject ID

if handles.pulse_library_file_is_selected == 1
    % Get subject id
    subject_id = get(handles.pm_display_and_fit_pulses_subject_id, 'Value');
    
    % Create and set pulse id menu
    num_pulses_by_subject = handles.num_pulses_by_subject;
    num_pulses_menu_strs = return_pulse_string_menu(num_pulses_by_subject(subject_id));
    set(handles.pm_display_and_fit_pulses_pulse_id, 'String', num_pulses_menu_strs);
    set(handles.pm_display_and_fit_pulses_pulse_id, 'Value', 1);
end

% --- Executes during object creation, after setting all properties.
function pm_display_and_fit_pulses_subject_id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_display_and_fit_pulses_subject_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_display_and_fit_pulses_pulse_id.
function pm_display_and_fit_pulses_pulse_id_Callback(hObject, eventdata, handles)
% hObject    handle to pm_display_and_fit_pulses_pulse_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pm_display_and_fit_pulses_pulse_id contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_display_and_fit_pulses_pulse_id


% --- Executes during object creation, after setting all properties.
function pm_display_and_fit_pulses_pulse_id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_display_and_fit_pulses_pulse_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_display_and_fit_pulses_display_one.
function pb_display_and_fit_pulses_display_one_Callback(hObject, eventdata, handles)
% hObject    handle to pb_display_and_fit_pulses_display_one (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Check if pulse library is loaded
pulse_library_is_loaded = handles.pulse_library_is_loaded;
database_is_loaded = handles.database_is_loaded;

%
if and(pulse_library_is_loaded == 1, database_is_loaded == 1)
    
    % Get Pulse library
    pulse_library = handles.pulse_library;
    
    % Get Hormone Database
    hormone_database = handles.hormone_database;
    
    % Get identifying information for subject and pulse
    subject_id_val = get(handles.pm_display_and_fit_pulses_subject_id, 'Value');
    subject_id_str = get(handles.pm_subject_id,'String');
    subject_id_str = subject_id_str(subject_id_val);
    
    pulse_id_val = get(handles.pm_display_and_fit_pulses_pulse_id, 'Value');
    pulse_id_str = get(handles.pm_display_and_fit_pulses_pulse_id, 'String');
    max_num_pulses = length(pulse_id_str);
    
    % Set upper left hand position
    hormone_database.upper_left_corner = handles.upper_left_corner;
    
    % Generate plot
    pulse_plot = ...
        create_pulse_plot_structure...
        (hormone_database, pulse_library,subject_id_val,pulse_id_val);
    [pulse_fig_id v] = create_hormone_pulse_plot(pulse_plot);
    
    % Save figure id for future analysis
    last_plotted_pulse.subject_is_displayed = 1;
    last_plotted_pulse.fig_id = pulse_fig_id;
    last_plotted_pulse.subject_id_val = subject_id_val;
    
    
    handles.last_plotted_pulse = last_plotted_pulse;
    guidata(hObject, handles);
else
    if database_is_loaded == 0
        msgbox('Load hormone datbase file');
    else
        msgbox('Load pulse database file.');
    end
end



% Plot selected pulse



% --- Executes on button press in pb_display_and_fit_pulses_fit.
function pb_display_and_fit_pulses_fit_Callback(hObject, eventdata, handles)
% hObject    handle to pb_display_and_fit_pulses_fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.pulse_library_is_loaded == 1
    % get pulse library file name
    pulse_library_fn = ...
        get(handles.e_display_and_fit_pulses_pulse_library_file,'String');
    
    % Get Pulse library
    pulse_library = handles.pulse_library;
    
    % Get Hormone Database
    hormone_database = handles.hormone_database;
    
    % Get identifying information for subject and pulse
    subject_id_val = get(handles.pm_display_and_fit_pulses_subject_id, 'Value');
    subject_id_str = get(handles.pm_subject_id,'String');
    subject_id_str = subject_id_str(subject_id_val);
    
    pulse_id_val = get(handles.pm_display_and_fit_pulses_pulse_id, 'Value');
    
    % Set upper left hand position
    hormone_database.upper_left_corner = handles.upper_left_corner;
    
    % Generate plot
    pulse_plot = ...
        create_pulse_plot_structure...
        (hormone_database, pulse_library,subject_id_val,pulse_id_val);
    % Add pulse library file name
    pulse_plot.pulse_library_fn = pulse_library_fn;
    pulse_plot.subject_id_val = subject_id_val;
    
    % Set the figure box to modal, atempting to block acces until fit
    set(handles.figure1, 'WindowStyle','Modal');
    
    % Estimate model parameters
    [NEHPar isFitComplete] = estimate_hormone_param_interactive_fit(pulse_plot);
    
    if isFitComplete == 1
        % Delete run
        subject_entry = handles.pulse_library_params{subject_id_val};
        subject_entry{pulse_id_val} = NEHPar;
        handles.pulse_library_params{subject_id_val} = subject_entry;
        
        % Echo results to console
        fprintf('--- Pulse %d fit parameters for subject %s has been updated\n'...
            ,pulse_id_val, subject_id_str)
        
        % Close fit dialog
        close 'estimate_hormone_param_interactive_fit';
    end
else
    msgbox('Load pulse library.');
end


% --- Executes on button press in pb_display_and_fit_pulses_save.
function pb_display_and_fit_pulses_save_Callback(hObject, eventdata, handles)
% hObject    handle to pb_display_and_fit_pulses_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Echo results to console

% Make gui global parameters available
global gui_globals

if isfield (gui_globals, 'fit_fig_id')
    % check if figure still exist
    does_figure_exist = do_all_figures_exist(gui_globals.fit_fig_id);
    
    if does_figure_exist == 1
        % Get identifying information for subject and pulse
        subject_id_val = get(handles.pm_display_and_fit_pulses_subject_id, 'Value');
        subject_id_str = get(handles.pm_subject_id,'String');
        subject_id_str = subject_id_str{subject_id_val};
        
        pulse_id_val = get(handles.pm_display_and_fit_pulses_pulse_id, 'Value');
        
        % Get grop_string
        group_str = handles.hormone_database.subject_info(subject_id_val).group_id
        
        % Propose file name
        full_file_name = strcat(subject_id_str,'_',num2str(pulse_id_val),'_',group_str,'.tiff')
        % full_file_name = 'temp.tiff';
        file_name = full_file_name
        
        fprintf('--- Saving file %s\n',file_name);
        
        % % Save file - use print command for finer control
        % saveas(h,full_file_name);
        h = 1;
        set(h,'PaperPositionMode','auto');
        figure(h)
        % cmd = sprintf('print(''f%d'',''-r300'',''-dtiff'',full_file_name);',h)
        % eval(cmd)
        print(gcf,'-r300','-dtiff',full_file_name);
        
        % Define dummy return value
        saved = 1;
    end
end
% --- Executes on button press in pb_display_and_fit_pulses_next_pulse.
function pb_display_and_fit_pulses_next_pulse_Callback(hObject, eventdata, handles)
% hObject    handle to pb_display_and_fit_pulses_next_pulse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Plot the next pulse for the current subject

% Test if library file has been selected
pulse_library_file_is_selected = handles.pulse_library_file_is_selected ;
database_is_loaded = handles.database_is_loaded ;

% If defined load library file
if and(pulse_library_file_is_selected == 1, database_is_loaded == 1 );
    % Close all open figures
    % pb_close_all_Callback(hObject, eventdata, handles)
    
    % Get subject id information
    subject_id_value = get(handles.pm_display_and_fit_pulses_subject_id, 'Value');
    pulse_id_val = get(handles.pm_display_and_fit_pulses_pulse_id, 'Value');
    pulse_id_str = get(handles.pm_display_and_fit_pulses_pulse_id, 'String');
    max_num_pulses = length(pulse_id_str);
    
    % Set subject id to next value
    pulse_id_val = pulse_id_val + 1;
    if pulse_id_val > max_num_pulses
        pulse_id_val = 1;
    end
    set(handles.pm_display_and_fit_pulses_pulse_id, 'Value', pulse_id_val);
    
    
    % Update global and call display function
    guidata(hObject, handles);
    pb_display_and_fit_pulses_display_one_Callback(hObject, eventdata, handles)
    
else
    if database_is_loaded == 0
        msgbox('Load hormone database');
    else
        msgbox('Select pulse library file');
    end
end

% --- Executes on button press in pb_display_and_fit_pulses_save_parameter_estimate.
function pb_display_and_fit_pulses_save_parameter_estimate_Callback(hObject, eventdata, handles)
% hObject    handle to pb_display_and_fit_pulses_save_parameter_estimate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_display_and_fit_pulses_display_indv.
function pb_display_and_fit_pulses_display_indv_Callback(hObject, eventdata, handles)
% hObject    handle to pb_display_and_fit_pulses_display_indv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Function Constant
DEBUG = 0;

% Check if pulse library is loaded
pulse_library_is_loaded = handles.pulse_library_is_loaded;
database_is_loaded = handles.database_is_loaded;

%
if and(pulse_library_is_loaded == 1, database_is_loaded == 1)
    % Get Pulse library
    pulse_library = handles.pulse_library;
    
    % Get Hormone Database
    hormone_database = handles.hormone_database;
    
    % Get identifying information for subject and pulse
    subject_id_val = get(handles.pm_display_and_fit_pulses_subject_id, 'Value');
    subject_id_str = get(handles.pm_subject_id,'String');
    subject_id_str = subject_id_str(subject_id_val);
    
    % Generate list of vallid pulse ids
    pulse_id_str = get(handles.pm_display_and_fit_pulses_pulse_id, 'String');
    pulse_id_values = str2num(pulse_id_str);
    
    % Set upper left hand position
    hormone_database.upper_left_corner = handles.upper_left_corner;
    
    % Echo parameters to console
    if DEBUG == 1
        fprintf('pb_display_and_fit_pulses_display_indv_Callback\n');
    end
    % Generate cell array of hormone plot structures
    create_pulse_plot_structure_F = @(pulse_id)create_pulse_plot_structure...
        (hormone_database, pulse_library, subject_id_val, pulse_id);
    pulse_plot_struct_cell_array = ...
        arrayfun(create_pulse_plot_structure_F,pulse_id_values);
    
    % Generate plot
    % [pulse_fig_id v] = create_hormone_pulse_plot(pulse_plot);
    create_indv_plot_return_values = ...
        arrayfun(@create_hormone_pulse_plot,pulse_plot_struct_cell_array);
    
    % Save updated files
    handles.create_indv_plot_return_values = create_indv_plot_return_values;
    guidata(hObject, handles);
else
    if database_is_loaded == 0
        msgbox('Load hormone database file');
    else
        msgbox('Load pulse library file');
    end
end

% --- Executes on button press in pb_display_and_fit_pulses_grp.
function pb_display_and_fit_pulses_grp_Callback(hObject, eventdata, handles)
% hObject    handle to pb_display_and_fit_pulses_grp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Function Constant
DEBUG = 0;

% Check if pulse library is loaded
pulse_library_is_loaded = handles.pulse_library_is_loaded;
database_is_loaded = handles.database_is_loaded;

%
if and(pulse_library_is_loaded == 1, database_is_loaded == 1)
    % Get Pulse library
    pulse_library = handles.pulse_library;
    
    % Get Hormone Database
    hormone_database = handles.hormone_database;
    
    % Get identifying information for subject and pulse
    subject_id_val = get(handles.pm_display_and_fit_pulses_subject_id, 'Value');
    subject_id_str = get(handles.pm_subject_id,'String');
    subject_id_str = subject_id_str(subject_id_val);
    
    % Generate list of vallid pulse ids
    pulse_id_str = get(handles.pm_display_and_fit_pulses_pulse_id, 'String');
    pulse_id_values = str2num(pulse_id_str);
    
    % Set upper left hand position
    hormone_database.upper_left_corner = handles.upper_left_corner;
    
    % Get display width
    display_width_val = get(handles.pm_display_and_fit_pulses_display_width, 'Value');
    
    % Get number of pulses for each subject
    num_pulses_by_subject = handles.num_pulses_by_subject;
    
    % Echo parameters to console
    if DEBUG == 0
        fprintf('pb_display_and_fit_pulses_display_indv_Callback\n');
    end
    
    % Pulse panel figure id
    pulse_panel_fig_id = create_hormone_pulse_panel_plot...
        (hormone_database,    pulse_library,        subject_id_val, ...
        pulse_id_values, display_width_val);
    
    % Save updated files
    handles.pulse_panel_fig_id = pulse_panel_fig_id;
    guidata(hObject, handles);
else
    if database_is_loaded == 0
        msgbox('Load hormone database file');
    else
        msgbox('Load pulse library file');
    end
end



% --- Executes on button press in pb_display_and_fit_pulses_display_next.
function pb_display_and_fit_pulses_display_next_Callback(hObject, eventdata, handles)
% hObject    handle to pb_display_and_fit_pulses_display_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Plot all the pulses for the next subject

% Test if library file has been selected
pulse_library_file_is_selected = handles.pulse_library_file_is_selected ;
database_is_loaded = handles.database_is_loaded ;

% If defined load library file
if and(pulse_library_file_is_selected == 1, database_is_loaded == 1 );
    % Close all open figures
    pb_close_all_Callback(hObject, eventdata, handles)
    
    % Get subject id information
    subject_id_value = get(handles.pm_display_and_fit_pulses_subject_id, 'Value');
    subject_id_str = get(handles.pm_display_and_fit_pulses_subject_id, 'String');
    max_num_subjects = length(subject_id_str);
    
    % Set subject id to next value
    subject_id_value = subject_id_value + 1;
    if subject_id_value > max_num_subjects
        subject_id_value = 1;
    end
    set(handles.pm_display_and_fit_pulses_subject_id, 'Value', subject_id_value);
    
    % Reset pulse menu
    % Create and set pulse id menu
    num_pulses_by_subject = handles.num_pulses_by_subject;
    num_pulses_menu_strs = return_pulse_string_menu(num_pulses_by_subject(subject_id_value));
    set(handles.pm_display_and_fit_pulses_pulse_id, 'String', num_pulses_menu_strs);
    set(handles.pm_display_and_fit_pulses_pulse_id, 'Value', 1);
    
    
    % Update global and call display function
    guidata(hObject, handles);
    pb_display_and_fit_pulses_display_indv_Callback(hObject, eventdata, handles)
    
else
    if database_is_loaded == 0
        msgbox('Load hormone database');
    else
        msgbox('Select pulse library file');
    end
end


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_display_and_fit_pulses_display_width.
function pm_display_and_fit_pulses_display_width_Callback(hObject, eventdata, handles)
% hObject    handle to pm_display_and_fit_pulses_display_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pm_display_and_fit_pulses_display_width contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_display_and_fit_pulses_display_width


% --- Executes during object creation, after setting all properties.
function pm_display_and_fit_pulses_display_width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_display_and_fit_pulses_display_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_display_and_fit_pulses_save_all_panels.
function pb_display_and_fit_pulses_save_all_panels_Callback(hObject, eventdata, handles)
% hObject    handle to pb_display_and_fit_pulses_save_all_panels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles, 'pulse_panel_fig_ids')
    % Save updated files
    pulse_panel_fig_ids = handles.pulse_panel_fig_ids;
    subj_tiff_fn = handles.subj_tiff_fn;
    subj_fig_fn = handles.subj_fig_fn;
    
    save_subject_panels (pulse_panel_fig_ids, subj_tiff_fn, subj_fig_fn);
end


% --- Executes on button press in pb_display_and_fit_pulses_fit_next_pulse.
function pb_display_and_fit_pulses_fit_next_pulse_Callback(hObject, eventdata, handles)
% hObject    handle to pb_display_and_fit_pulses_fit_next_pulse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Check if pulse library is loaded
pulse_library_is_loaded = handles.pulse_library_is_loaded;
database_is_loaded = handles.database_is_loaded;

%
if and(pulse_library_is_loaded == 1, database_is_loaded == 1)
    
    % Get Pulse library
    pulse_library = handles.pulse_library;
    
    % Get Hormone Database
    hormone_database = handles.hormone_database;
    
    % Get identifying information for subject and pulse
    subject_id_val = get(handles.pm_display_and_fit_pulses_subject_id, 'Value');
    subject_id_str = get(handles.pm_subject_id,'String');
    subject_id_str = subject_id_str(subject_id_val);
    
    pulse_id_val = get(handles.pm_display_and_fit_pulses_pulse_id, 'Value');
    pulse_id_str = get(handles.pm_display_and_fit_pulses_pulse_id, 'String');
    max_num_pulses = length(pulse_id_str);
    
    % Set to next value
    pulse_id_val = pulse_id_val +1;
    if pulse_id_val > max_num_pulses
        pulse_id_val = 1;
    end
    set(handles.pm_display_and_fit_pulses_pulse_id, 'Value', pulse_id_val);
    
    % Store current gui state
    guidata(hObject, handles);
    
    % Fit data
    pb_display_and_fit_pulses_fit_Callback(hObject, eventdata, handles)
    
else
    if database_is_loaded == 0
        msgbox('Load hormone datbase file');
    else
        msgbox('Load pulse database file.');
    end
end



% Plot selected pulse


% --- Executes on button press in pb_mark_pulses_quality.
function pb_mark_pulses_quality_Callback(hObject, eventdata, handles)
% hObject    handle to pb_mark_pulses_quality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

database_is_loaded = handles.database_is_loaded;

if database_is_loaded == 1
    % Get database
    hormone_database = handles.hormone_database;
    
    % Get subject information
    subject_id_val = get(handles.pm_subject_id,'Value');
    subject_id_str = get(handles.pm_subject_id,'String');
    subject_id_str = subject_id_str(subject_id_val);
    
    % Set upper left hand position
    hormone_database.upper_left_corner = handles.upper_left_corner;
    
    % Generate plot
    hormone_plot = ...
        create_subject_plot_structure(hormone_database,subject_id_val);
    hormone_plot.time_adj_F = @zero_time;
    hormone_plot.plot_type = 'Quality';
    
    [fig_id v] = create_hormone_subject_w_sleep_w_quality_plot(hormone_plot);
    
    % Save figure id for future analysis
    handles.subject_is_displayed = 1;
    handles.fig_id = fig_id;
    handles.subject_id_val = subject_id_val;
    
    guidata(hObject, handles);
end


% --- Executes on button press in pb_mark_pulses_partition.
function varargout =  pb_mark_pulses_partition_Callback(hObject, eventdata, handles)
% hObject    handle to pb_mark_pulses_partition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
database_is_loaded = handles.database_is_loaded;

if database_is_loaded == 1
    % close figures to avoid memory errors
    pb_close_all_Callback(hObject, eventdata, handles)
    
    % Get database
    hormone_database = handles.hormone_database;
    
    % Get subject information
    subject_id_val = get(handles.pm_subject_id,'Value');
    subject_id_str = get(handles.pm_subject_id,'String');
    subject_id_str = subject_id_str(subject_id_val);
    
    % Set upper left hand position
    hormone_database.upper_left_corner = handles.upper_left_corner;
    
    % Generate plot
    hormone_plot = ...
        create_subject_plot_structure(hormone_database,subject_id_val);
    hormone_plot.time_adj_F = @zero_time;
    hormone_plot.plot_type = 'Segmentation';
    hormone_plot.application_root_directory = ...
        handles.application_root_directory;
    hormone_plot.segmentation_result_folder = 'Segmentation';    
    
    % % Create paritioing plots
    [subject_result_summary_struct fig_id v] = ...
        create_hormone_subject_w_sleep_w_quality_plot(hormone_plot);
    

    
    % Save figure id for future analysis
    handles.subject_is_displayed = 1;
    handles.fig_id = fig_id;
    handles.subject_id_val = subject_id_val;
    
    guidata(hObject, handles);
else
    msgbox('Load database file')
end

if nargout == 0
    varargout = {};
elseif nargout == 1
    varargout = {subject_result_summary_struct};
end

% --- Executes on button press in pb_mark_pulses_quality_all.
function pb_mark_pulses_quality_all_Callback(hObject, eventdata, handles)
% hObject    handle to pb_mark_pulses_quality_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


database_is_loaded = handles.database_is_loaded;

if database_is_loaded == 1
    % Get database
    hormone_database = handles.hormone_database;
    
    % Get subject information
    starting_subject_id_val = get(handles.pm_subject_id,'Value');
    subject_id_strs = get(handles.pm_subject_id,'String');
    num_strings = size(subject_id_strs,1);
    
    % Set upper left hand position
    hormone_database.upper_left_corner = handles.upper_left_corner;
    
    % allocate memory for figure id s
    fig_ids = zeros(num_strings,1);
    fig_set_info = struct('description', [],'fig_id',[],'v', [],...
        'subject_id',[]);
    plot_type_string = 'Quality';
    
    fig_ids = zeros(num_strings,1);
    vs = zeros(num_strings,4);
    
    % process each subject
    for s = 1:num_strings
        % Get subject id
        set(handles.pm_subject_id,'Value', s);
        subject_id_val = s;
        subject_id_str = subject_id_strs(subject_id_val);
        
        % Generate plot
        hormone_plot = ...
            create_subject_plot_structure(hormone_database,subject_id_val);
        hormone_plot.time_adj_F = @zero_time;
        hormone_plot.plot_type = 'Quality';
        
        % Generate
        [fig_id v] = create_hormone_subject_w_sleep_w_quality_plot(hormone_plot);
        
        % store plot information
        fig_ids(s) = s;
        vs(s,:) = v;
    end
    
    % Store plot group information
    fig_set_info.plot_type_string = plot_type_string;
    fig_set_info.subject_id_strs = subject_id_strs;
    fig_set_info.fig_ids = fig_ids;
    fig_set_info.vs = vs;
    
    % Return popup menu to starting value
    set(handles.pm_subject_id,'Value', starting_subject_id_val);
    
    % Legacy code before will add groups of figures later
    % Save figure id for future analysis
    handles.subject_is_displayed = 1;
    handles.fig_id = fig_id;
    handles.subject_id_val = subject_id_val;
    handles.fig_set_info = fig_set_info;
    
    guidata(hObject, handles);
end


% --- Executes on button press in pb_dialog_tile_group.
function pb_dialog_tile_group_Callback(hObject, eventdata, handles)
% hObject    handle to pb_dialog_tile_group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.fig_set_info)
    % if group is defined use group function
    display_rectangle = handles.display_rectangle;
    fig_set_info = handles.fig_set_info;
    monitor_str = get(handles.pm_monitor,'String');
    monitor_val = get(handles.pm_monitor,'Value');
    monitor_val = str2num(monitor_str(monitor_val));
    
    %
    %     % Use old method for display all figures that are dislayed
    %     maxpos    = get (0,'screensize'); % determine terminal size in pixels
    %     maxpos(4) = maxpos(4) - 25;
    %     hands     = get (0,'Children');   % locate fall open figure handles
    %     hands     = sort(hands) ;         % sort figure handles
    %
    %     numfigs   = size(hands,1);        % number of open figures
    %     indexes   = find(hands-round(hands)==0);
    %     hands     = hands(indexes);
    %
    % Call tile figures
    if isstruct(fig_set_info)
        figs = fig_set_info.fig_ids;
        figname = [];
        monitor = monitor_val;
        layout = [floor(sqrt(length(figs))) (floor(sqrt(length(figs)))+1)];
        if monitor_val == 0 % Default monitor value
            border = [0 0 0 display_rectangle(1)]; % [top bottom right left] pixels
        else
            border = [0 0 0 0];
        end
        fighandle = tilefig(figs,figname,monitor,layout,border);
    else
        msgbox('dialog_tile_group: figure group not set');
    end
else
    % Use old method for display all figures that are dislayed
    maxpos    = get (0,'screensize'); % determine terminal size in pixels
    maxpos(4) = maxpos(4) - 25;
    hands     = get (0,'Children');   % locate fall open figure handles
    hands     = sort(hands) ;         % sort figure handles
    
    numfigs   = size(hands,1);        % number of open figures
    indexes   = find(hands-round(hands)==0);
    hands     = hands(indexes);
    
    if ~isempty(hands)
        % get current monitor string
        monitor_val = 0;
        %monitor_val = str2num(monitor_str(monitor_val));
        
        fighandle = tilefig(hands,'',monitor_val);
        if fighandle == -1
            % Error message
            h = warndlg('Exceeded 48 figure limit.', 'createMode','modal');
        end
    end
end

% --- Executes on button press in pb_dialog_save_group.
function pb_dialog_save_group_Callback(hObject, eventdata, handles)
% hObject    handle to pb_dialog_save_group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% function constant
DEBUG_FLAG = 1;

% if the figure group has been set
if ~isempty(handles.fig_set_info)
    % get figure set information
    fig_set_info = handles.fig_set_info;
    
    % Get database information
    hormone_database = handles.hormone_database;
    
    % Create structure to save information
    save_fig_struct.pn = handles.folder_pn;
    save_fig_struct.fig_description = ...
        lower(strcat(fig_set_info.plot_type_string,'.',...
        hormone_database.subject_info(1).data_type,'.'...
        ));
    save_fig_struct.subject_info = hormone_database.subject_info;
    save_fig_struct.folder_name = lower(fig_set_info.plot_type_string);
    save_fig_struct.fig_ids = fig_set_info.fig_ids;
    
    if DEBUG_FLAG == 1
        save_fig_struct.pn
        save_fig_struct.fig_description
        save_fig_struct.subject_info
        save_fig_struct.folder_name
        save_fig_struct.fig_ids
    end
    
    % save figures
    figure_fns = save_figures(save_fig_struct);
    
end

% --- Executes on selection change in pm_monitor.
function pm_monitor_Callback(hObject, eventdata, handles)
% hObject    handle to pm_monitor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_monitor contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_monitor


% --- Executes during object creation, after setting all properties.
function pm_monitor_CreateFcn(hObject, ~, handles)
% hObject    handle to pm_monitor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_mark_pulses_paritition_all_2.
function pb_mark_pulses_paritition_all_2_Callback(hObject, eventdata, handles)
% hObject    handle to pb_mark_pulses_paritition_all_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% function rewritten to call the partition function directly
database_is_loaded = handles.database_is_loaded;

if database_is_loaded == 1
    
    % Define function constants
    start_path = cd;
    result_folder = 'CFL_Estimation';
    file_name = 'adler_cfl_results_by_subject.mat';
    
    % Get database
    hormone_database = handles.hormone_database;
    
    % Get subject information
    starting_subject_id_val = get(handles.pm_subject_id,'Value');
    subject_id_strs = get(handles.pm_subject_id,'String');
    num_strings = size(subject_id_strs,1);
    
    % Set upper left hand position
    hormone_database.upper_left_corner = handles.upper_left_corner;
    
    
    % Set timer
    tStart = tic;
    
    % Define cell array of results
    partioning_cell_array_collection = cell(num_strings,1);

    % process each subject
    for s = 1:num_strings
        % Set subject id
        set(handles.pm_subject_id,'Value', s);
        
        % partition value for subject
        partitioning_cell_array = ...
            pb_mark_pulses_partition_Callback(hObject, eventdata, handles);
        partioning_cell_array_collection{s} = partitioning_cell_array;
        
        % Close windows
        pb_close_all_Callback(hObject, eventdata, handles);
    end
    
    % echo 
    tElapsed = toc(tStart);
    fprintf('');
    
    % Save run information
    location = strcat(start_path,'\',result_folder,'\',file_name);
    save_cmd = sprintf('save ''%s'' partioning_cell_array_collection',location)
    eval(save_cmd);    

    % Return popup menu to starting value
    set(handles.pm_subject_id,'Value', starting_subject_id_val);

    % Save figure id for future analysis
    cfl_results_struct = struct('partioning_cell_array_collection',...
        partioning_cell_array_collection,'start_path', start_path,...
        'result_folder',result_folder,'file_name',file_name,...
        'location', location);
    handles.cfl_results_struct = cfl_results_struct;
    save 'Cortisol_CFL_Struct_2012_07_17.mat' cfl_results_struct
    guidata(hObject, handles);
end



function e_group_summary_cell_Callback(hObject, eventdata, handles)
% hObject    handle to e_group_summary_cell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_group_summary_cell as text
%        str2double(get(hObject,'String')) returns contents of e_group_summary_cell as a double


% --- Executes during object creation, after setting all properties.
function e_group_summary_cell_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_group_summary_cell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_group_summary_select_group_summary_cell_file.
function pb_group_summary_select_group_summary_cell_file_Callback(hObject, eventdata, handles)
% hObject    handle to pb_group_summary_select_group_summary_cell_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[group_summary_fn group_summary_pn group_summary_file_is_selected ] = ...
                                         pb_select_group_summary_file_f();

% check if user selected a file
if group_summary_file_is_selected == 1
    % write file name to dialog box
    set(handles.e_group_summary_cell, 'String', group_summary_fn);
    guidata(hObject, handles);
    
    % Save file information to globals
    handles.group_summary_fn = group_summary_fn;
    handles.group_summary_pn = group_summary_pn;
    handles.group_summary_file_is_selected = group_summary_file_is_selected;
    guidata(hObject, handles);
end

% --- Executes on button press in pb_group_summary_load_summary_cell.
function pb_group_summary_load_summary_cell_Callback(hObject, eventdata, handles)
% hObject    handle to pb_group_summary_load_summary_cell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

group_summary_file_is_selected = handles.group_summary_file_is_selected ;

if group_summary_file_is_selected == 1;
    group_summary_fn = handles.group_summary_fn ;
    group_summary_pn = handles.group_summary_pn ;
    [partioning_cell_array_collection, group_summary_file_is_loaded ] = ...
        load_group_summary_cell_from_file(group_summary_fn, group_summary_pn);
    if group_summary_file_is_loaded == 1        
        % Save load information to globals
        handles.group_summary_file_is_loaded = group_summary_file_is_loaded;
        handles.group_summary_fn = group_summary_fn;
        handles.group_summary_pn = group_summary_pn;
        handles.partioning_cell_array_collection = partioning_cell_array_collection;
        
        % Save changes to global variaables
        guidata(hObject, handles);
    else
        msgbox('Selected file does not contain ''partioning_cell_array_collection'' variable. Select another file.');
    end
else
    msgbox('Select group summary file');
end

% --- Executes on button press in pb_summarize.
function pb_summarize_Callback(hObject, eventdata, handles)
% hObject    handle to pb_summarize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
