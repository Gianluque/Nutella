function varargout = Osciloscopio_19(varargin)
% OSCILOSCOPIO_19 MATLAB code for Osciloscopio_19.fig
%      OSCILOSCOPIO_19, by itself, creates a new OSCILOSCOPIO_19 or raises the existing
%      singleton*.
%
%      H = OSCILOSCOPIO_19 returns the handle to a new OSCILOSCOPIO_19 or the handle to
%      the existing singleton*.
%
%      OSCILOSCOPIO_19('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OSCILOSCOPIO_19.M with the given input arguments.
%
%      OSCILOSCOPIO_19('Property','Value',...) creates a new OSCILOSCOPIO_19 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Osciloscopio_19_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Osciloscopio_19_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Osciloscopio_19

% Last Modified by GUIDE v2.5 12-Mar-2019 19:27:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Osciloscopio_19_OpeningFcn, ...
                   'gui_OutputFcn',  @Osciloscopio_19_OutputFcn, ...
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
end

% --- Executes just before Osciloscopio_19 is made visible.
function Osciloscopio_19_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Osciloscopio_19 (see VARARGIN)

% Choose default command line output for Osciloscopio_19
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global puerto;
puerto=serial('COM8','BaudRate',115200,'Terminator','LF');   %Crea el objeto de matlab que lee y usa el puerto
fopen(puerto); %abre el puerto
%Arrays para plot (se ejecuta al cambio de timeBase)
global Amplitud_ch1;
global Amplitud_ch2;
Amplitud_ch1=1;
Amplitud_ch2=1;
global dac;
dac=3/(2^12);
global ini;
ini=0;
global fini;
fini=500;
global timeBase;
timeBase=10;
global time;
time=linspace(ini,fini,timeBase);
global ch1_plot;
ch1_plot=zeros(1,length(time));
global ch2_plot;
ch2_plot=zeros(1,length(time));
global digit_1;
digit_1=zeros(1,length(time));
global digit_2;
digit_2=zeros(1,length(time));
%inicializa variables de llegada;
global a;
a=128;
global b;
b=0;
global c;
c=0;
global d;
d=0;
% UIWAIT makes Osciloscopio_19 wait for user response (see UIRESUME)
% uiwait(handles.Osciloscopio);
end

% --- Outputs from this function are returned to the command line.
function varargout = Osciloscopio_19_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in Graficar.
function Graficar_Callback(~, ~, handles)
% hObject    handle to Graficar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.On_Off,'Value',1);
global puerto;
global Amplitud_ch1;
global Amplitud_ch2;
global dac;
global time;
global ch1_plot;
global ch2_plot;
global digit_1;
global digit_2;
buffersize=84;
%canales Analogicos


while get(handles.On_Off,'Value')==1
    %busqueda de inicio y adquisicion de bytes
    aux=fread(puerto,[1,buffersize],'uint8'); 
    i=1;

    while aux(i)>127
        i=i+1;
    end    
bin=dec2bin(aux);    
    while i<(buffersize-4)
       chauxAlog1= strcat(bin(i,3:8),bin(i+1,3:8));
       chauxdig1= bin(i,2); 
       chauxAlog2= strcat(bin(i+2,3:8),bin(i+3,3:8)); 
       chauxdig2= bin(i+2,2);
       
               %shifteo y actualizacion de canales
        digit_1 = circshift(digit_1,1);
        digit_2 = circshift(digit_2,1);
        digit_1(1)=bin2dec(chauxdig1)*Amplitud_ch1;
        digit_2(1)=bin2dec(chauxdig2)*Amplitud_ch2;    
        ch1_plot = circshift(ch1_plot,1);
        ch2_plot = circshift(ch2_plot,1);        
        ch1_plot(1)=bin2dec(chauxAlog1)*Amplitud_ch1*dac;
        ch2_plot(1)=bin2dec(chauxAlog2)*Amplitud_ch2*dac;
        
        %Canales setm o plot
        
        switch get(handles.Plot_Stem,'Value')
        case 1
                        %grafico de canales continuo
        cla;
        %if get(handles.Alog_1,'Value')==1
        if 1==1
        plot(time,ch1_plot,'b');
        hold on;
        end
        %if get(handles.Alog_2,'Value')==1
        if 1==1
        plot(time,ch2_plot,'r');
        end
        if 1==1
        %if get(handles.Digi_1,'Value')==1
        plot(time,digit_1,'g');
        end
        if 1==1
        %if get(handles.Digi_2,'Value')==1
        plot(time,digit_2,'y');
        end
        drawnow;
        
        case 2
                        %grafico de canales puntuales
        cla;
        if 1==1
        %if get(handles.Alog_1,'Value')==1
        stem(time,ch1_plot,'b');
        hold on;
        end
        if 1==1
        %if get(handles.Alog_2,'Value')==1
        stemm(time,ch2_plot,'r');
        end
        if 1==1
        %if get(handles.Digi_1,'Value')==1
        stem(time,digit_1,'g');
        end
        if 1==1
        %if get(handles.Digi_2,'Value')==1
        stem(time,digit_2,'y');
        end
        drawnow;    
        end
        i=i+4;
    end
    %flush del puerto
    flushinput(puerto)
   cla 
end

end

% --- Executes on selection change in Amplitud1.
function Amplitud1_Callback(hObject, eventdata, handles)
% hObject    handle to Amplitud1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla

global Amplitud_ch1;
aux1=get(hObject,'Value');
switch aux1
    case 1
        Amplitud_ch1=0.3;
    case 2
        Amplitud_ch1=1;
    case 3
        Amplitud_ch1=3;
end
end
% Hints: contents = cellstr(get(hObject,'String')) returns Amplitud1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Amplitud1


% --- Executes during object creation, after setting all properties.
function Amplitud1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Amplitud1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in Amplitud2.
function Amplitud2_Callback(hObject, eventdata, handles)
% hObject    handle to Amplitud2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla
global Amplitud_ch2;
aux2=get(hObject,'Value');
switch aux2
    case 1
        Amplitud_ch2=0.3;
    case 2
        Amplitud_ch2=1;
    case 3
        Amplitud_ch2=3;
end
        % Hints: contents = cellstr(get(hObject,'String')) returns Amplitud2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Amplitud2
end

% --- Executes during object creation, after setting all properties.
function Amplitud2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Amplitud2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in timeBase.
function timeBase_Callback(hObject, eventdata, handles)
% hObject    handle to timeBase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla
global ini;
global fini;
global timeBase;
aux3=get(hObject,'Value');
switch aux3
    case 1
        timeBase=10;
    case 2
        timeBase=100;
    case 3
        timeBase=1000;
end
global time;
time=linspace(ini,fini,timeBase);
global ch1_plot;
ch1_plot=zeros(1,length(time));
global ch2_plot;
ch2_plot=zeros(1,length(time));
global digit_1;
digit_1=zeros(1,length(time));
global digit_2;
digit_2=zeros(1,length(time));
% Hints: contents = cellstr(get(hObject,'String')) returns timeBase contents as cell array
%        contents{get(hObject,'Value')} returns selected item from timeBase
end

% --- Executes during object creation, after setting all properties.
function timeBase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeBase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on mouse press over axes background.
function Pantalla_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Pantalla (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes when user attempts to close Osciloscopio.
function Osciloscopio_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to Osciloscopio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.On_Off,'Value',2);
instrreset;

% Hint: delete(hObject) closes the figure
delete(hObject);
end


% --- Executes on selection change in On_Off.
function On_Off_Callback(hObject, eventdata, handles)
% hObject    handle to On_Off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns On_Off contents as cell array
%        contents{get(hObject,'Value')} returns selected item from On_Off
end

% --- Executes during object creation, after setting all properties.
function On_Off_CreateFcn(hObject, eventdata, handles)
% hObject    handle to On_Off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in Digi_1.
function Digi_1_Callback(hObject, eventdata, handles)
% hObject    handle to Digi_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Digi_1
end

% --- Executes on button press in Digi_2.
function Digi_2_Callback(hObject, eventdata, handles)
% hObject    handle to Digi_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Digi_2
end

% --- Executes on button press in Alog_1.
function Alog_1_Callback(hObject, eventdata, handles)
% hObject    handle to Alog_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Alog_1
end

% --- Executes on button press in Alog_2.
function Alog_2_Callback(hObject, eventdata, handles)
% hObject    handle to Alog_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Alog_2
end


% --- Executes on selection change in plot_stem.
function plot_stem_Callback(hObject, eventdata, handles)
% hObject    handle to plot_stem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns plot_stem contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plot_stem
end

% --- Executes during object creation, after setting all properties.
function plot_stem_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot_stem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
