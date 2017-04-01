function varargout = NoduleCandidates(varargin)
% NODULECANDIDATES MATLAB code for NoduleCandidates.fig
%      NODULECANDIDATES, by itself, creates a new NODULECANDIDATES or raises the existing
%      singleton*.
%
%      H = NODULECANDIDATES returns the handle to a new NODULECANDIDATES or the handle to
%      the existing singleton*.
%
%      NODULECANDIDATES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NODULECANDIDATES.M with the given input arguments.
%
%      NODULECANDIDATES('Property','Value',...) creates a new NODULECANDIDATES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NoduleCandidates_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NoduleCandidates_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NoduleCandidates

% Last Modified by GUIDE v2.5 27-Nov-2016 21:31:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NoduleCandidates_OpeningFcn, ...
                   'gui_OutputFcn',  @NoduleCandidates_OutputFcn, ...
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


% --- Executes just before NoduleCandidates is made visible.
function NoduleCandidates_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NoduleCandidates (see VARARGIN)

% Choose default command line output for NoduleCandidates
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NoduleCandidates wait for user response (see UIRESUME)
% uiwait(handles.figure1);

img_orig = varargin{1}{1};
img_details = {};
Fs = {};
for i = 1:4
    % Lung Regions Extraction
    [lung_dilated, lung_extracted,...
        bit_plane, img_eroded,...
        img_median, img_dilated,...
        img_outlined, extraction_region, lung_floodfilled] = Extraction(img_orig{i});
    
    img_details{i} = {bit_plane, img_eroded,...
        img_median, img_dilated,...
        img_outlined, extraction_region,...
        lung_floodfilled, lung_extracted};

    % Lung Regions Segmentation
    [C, idx, K, pic_color{i}] = Segmentation(lung_dilated, lung_extracted);

    % Feature Extraction
    Fs{i} = FeatureExtraction(C, idx, K)';
end
axes(handles.axes1);
imshow(pic_color{1});
axes(handles.axes2);
imshow(pic_color{2});
axes(handles.axes3);
imshow(pic_color{3});
axes(handles.axes4);
imshow(pic_color{4});

handles.img_details = img_details;
handles.Fs = Fs;
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = NoduleCandidates_OutputFcn(hObject, eventdata, handles) 
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

varargout{1} = handles.img_details{1};
ProcessingDetails(varargout)

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


varargout{1} = handles.img_details{2};
ProcessingDetails(varargout)

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

varargout{1} = handles.img_details{3};
ProcessingDetails(varargout)

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

varargout{1} = handles.img_details{4};
ProcessingDetails(varargout)

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

varargout{1} = handles.Fs;
Features(varargout)