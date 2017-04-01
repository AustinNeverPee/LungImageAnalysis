function varargout = ProcessingDetails(varargin)
% PROCESSINGDETAILS MATLAB code for ProcessingDetails.fig
%      PROCESSINGDETAILS, by itself, creates a new PROCESSINGDETAILS or raises the existing
%      singleton*.
%
%      H = PROCESSINGDETAILS returns the handle to a new PROCESSINGDETAILS or the handle to
%      the existing singleton*.
%
%      PROCESSINGDETAILS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROCESSINGDETAILS.M with the given input arguments.
%
%      PROCESSINGDETAILS('Property','Value',...) creates a new PROCESSINGDETAILS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ProcessingDetails_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ProcessingDetails_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ProcessingDetails

% Last Modified by GUIDE v2.5 27-Nov-2016 22:42:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ProcessingDetails_OpeningFcn, ...
                   'gui_OutputFcn',  @ProcessingDetails_OutputFcn, ...
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


% --- Executes just before ProcessingDetails is made visible.
function ProcessingDetails_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ProcessingDetails (see VARARGIN)

% Choose default command line output for ProcessingDetails
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ProcessingDetails wait for user response (see UIRESUME)
% uiwait(handles.figure1);

img_details = varargin{1}{1};
axes(handles.axes1);
imshow(img_details{1});
axes(handles.axes2);
imshow(img_details{2});
axes(handles.axes3);
imshow(img_details{3});
axes(handles.axes4);
imshow(img_details{4});
axes(handles.axes5);
imshow(img_details{5});
axes(handles.axes6);
imshow(img_details{6});
axes(handles.axes7);
imshow(img_details{7});
axes(handles.axes8);
imshow(img_details{8});


% --- Outputs from this function are returned to the command line.
function varargout = ProcessingDetails_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
