function varargout = LungImageAnalysis(varargin)
% LungImageAnalysis MATLAB code for LungImageAnalysis.fig
%      LungImageAnalysis, by itself, creates a new LungImageAnalysis or raises the existing
%      singleton*.
%
%      H = LungImageAnalysis returns the handle to a new LungImageAnalysis or the handle to
%      the existing singleton*.
%
%      LungImageAnalysis('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LungImageAnalysis.M with the given input arguments.
%
%      LungImageAnalysis('Property','Value',...) creates a new LungImageAnalysis or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the LungImageAnalysis before LungImageAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LungImageAnalysis_OpeningFcn via varargin.
%
%      *See LungImageAnalysis Options on GUIDE's Tools menu.  Choose "LungImageAnalysis allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LungImageAnalysis

% Last Modified by GUIDE v2.5 27-Nov-2016 21:32:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LungImageAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @LungImageAnalysis_OutputFcn, ...
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


% --- Executes just before LungImageAnalysis is made visible.
function LungImageAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LungImageAnalysis (see VARARGIN)

% Choose default command line output for LungImageAnalysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LungImageAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LungImageAnalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% open file selection dialog boxexit
[FileName,PathName,FilterIndex] = uigetfile('*.bmp', 'Choose CT images','MultiSelect','on');
if isequal(FileName, 0)
    disp('User selected Cancel')
else
    % show original images
    img_orig{1} = imread([PathName(1:end), FileName{1}(1:end)]);
    axes(handles.axes1);
    imshow(img_orig{1});
    img_orig{2} = imread([PathName(1:end), FileName{2}(1:end)]);
    axes(handles.axes2);
    imshow(img_orig{2});
    img_orig{3} = imread([PathName(1:end), FileName{3}(1:end)]);
    axes(handles.axes3);
    imshow(img_orig{3});
    img_orig{4} = imread([PathName(1:end), FileName{4}(1:end)]);
    axes(handles.axes4);
    imshow(img_orig{4});
    
    handles.img_orig = img_orig;
    guidata(hObject, handles);
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

varargout{1} = handles.img_orig;
NoduleCandidates(varargout)
