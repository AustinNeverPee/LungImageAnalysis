function varargout = Features(varargin)
% FEATURES MATLAB code for Features.fig
%      FEATURES, by itself, creates a new FEATURES or raises the existing
%      singleton*.
%
%      H = FEATURES returns the handle to a new FEATURES or the handle to
%      the existing singleton*.
%
%      FEATURES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FEATURES.M with the given input arguments.
%
%      FEATURES('Property','Value',...) creates a new FEATURES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Features_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Features_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Features

% Last Modified by GUIDE v2.5 27-Nov-2016 23:37:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Features_OpeningFcn, ...
                   'gui_OutputFcn',  @Features_OutputFcn, ...
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


% --- Executes just before Features is made visible.
function Features_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Features (see VARARGIN)

% Choose default command line output for Features
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Features wait for user response (see UIRESUME)
% uiwait(handles.figure1);

handles.Fs = varargin{1}{1};
set(handles.uitable1, 'Data', handles.Fs{1})
set(handles.uitable2, 'Data', handles.Fs{2})
set(handles.uitable3, 'Data', handles.Fs{3})
set(handles.uitable4, 'Data', handles.Fs{4})
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = Features_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

features = [];
for i = 1:4
    features = [features, handles.Fs{i}];
end
features = mean(features, 2);

load net
output = net(features);

% show dialogue
s = sprintf('The probability that this patient has a lung cancer is %f.\n\n', output);
msgbox(s,'Result of Diagnosis')