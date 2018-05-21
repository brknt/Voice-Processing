function varargout = Statistic(varargin)
% STATISTIC MATLAB code for Statistic.fig
%      STATISTIC, by itself, creates a new STATISTIC or raises the existing
%      singleton*.
%
%      H = STATISTIC returns the handle to a new STATISTIC or the handle to
%      the existing singleton*.
%
%      STATISTIC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STATISTIC.M with the given input arguments.
%
%      STATISTIC('Property','Value',...) creates a new STATISTIC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Statistic_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Statistic_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Statistic

% Last Modified by GUIDE v2.5 25-May-2017 20:16:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Statistic_OpeningFcn, ...
                   'gui_OutputFcn',  @Statistic_OutputFcn, ...
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


% --- Executes just before Statistic is made visible.
function Statistic_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Statistic (see VARARGIN)

% Choose default command line output for Statistic
handles.output = hObject;

% Update handles structure
global x fs ms20 ms2 r Fx ;
x=ones(9600,1);

guidata(hObject, handles);

% UIWAIT makes Statistic wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Statistic_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_talk.
function btn_talk_Callback(hObject, eventdata, handles)
% hObject    handle to btn_talk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x fs ms20 ms2 r Fx;
mysound=audiorecorder(8000,8,2);
record(mysound);
pause(4);
x=getaudiodata(mysound);
audiowrite('sesim.wav',x,8000);
plot(x);
set(handles.edit1,'String','Audio file saved');
fs=8000;
ms20=fs/50;
r=xcorr(x,ms20,'coeff');
ms2=fs/500;%max speech Fx at 500Hz
ms20=fs/50;%max speech Fx at 50Hz
r=r(ms20 +1: 2*ms20 +1);
[rmax , tx]=max(r(ms2:ms20));
Fx=fs/(ms2+tx-1);

% --- Executes on button press in btn_play.
function btn_play_Callback(hObject, eventdata, handles)
% hObject    handle to btn_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x
soundsc(x,8000);

% --- Executes on button press in btn_gender.
function btn_gender_Callback(hObject, eventdata, handles)
% hObject    handle to btn_gender (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Fx
if Fx <= 175 && Fx >=80
        set(handles.edit1,'String', 'Male');
        guidata(hObject, handles);
    elseif Fx>175 && Fx<=255
        set(handles.edit1,'String', 'Female');
        guidata(hObject, handles);
    else
        set(handles.edit1,'String', 'Could not recognize. Try speaking slowly.');
       guidata(hObject, handles);
end
