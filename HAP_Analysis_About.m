function varargout = HAP_Analysis_About(varargin)
% HAP_ANALYSIS_ABOUT M-file for HAP_Analysis_About.fig
%      HAP_ANALYSIS_ABOUT, by itself, creates a new HAP_ANALYSIS_ABOUT or raises the existing
%      singleton*.
%
%      H = HAP_ANALYSIS_ABOUT returns the handle to a new HAP_ANALYSIS_ABOUT or the handle to
%      the existing singleton*.
%
%      HAP_ANALYSIS_ABOUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HAP_ANALYSIS_ABOUT.M with the given input arguments.
%
%      HAP_ANALYSIS_ABOUT('Property','Value',...) creates a new HAP_ANALYSIS_ABOUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HAP_Analysis_About_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HAP_Analysis_About_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
% File is part of the HAP analysis program
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
% Edit the above text to modify the response to help HAP_Analysis_About

% Last Modified by GUIDE v2.5 10-Jul-2012 10:46:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HAP_Analysis_About_OpeningFcn, ...
                   'gui_OutputFcn',  @HAP_Analysis_About_OutputFcn, ...
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


% --- Executes just before HAP_Analysis_About is made visible.
function HAP_Analysis_About_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HAP_Analysis_About (see VARARGIN)

% Choose default command line output for HAP_Analysis_About
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HAP_Analysis_About wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HAP_Analysis_About_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% Set Screen Size
set(0,'Units','Character');
set(handles.figure1,'Units','character');
screen_height = 4;
screen_width = 3;
dposition = get(hObject,'Position');
d_height = 23.62; %dposition(screen_width);
d_width = 78.0;%dposition(screen_width);
screen_dim = get(0,'ScreenSize');
dialog_height = (screen_dim(screen_height)- d_height )*2/3;
left_edge = (screen_dim(screen_width)- d_width  )/2;
pos1 = [left_edge dialog_height d_width d_height  ];
set(hObject,'Position',pos1) ;

% --- Executes on button press in pb_close.
function pb_close_Callback(hObject, eventdata, handles)
% hObject    handle to pb_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close 'HAP_Analysis_About'
