function varargout = Osciloscopio_7(varargin)
% OSCILOSCOPIO_7 MATLAB code for Osciloscopio_7.fig
%      OSCILOSCOPIO_7, by itself, creates a new OSCILOSCOPIO_7 or raises the existing
%      singleton*.
%
%      H = OSCILOSCOPIO_7 returns the handle to a new OSCILOSCOPIO_7 or the handle to
%      the existing singleton*.
%
%      OSCILOSCOPIO_7('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OSCILOSCOPIO_7.M with the given input arguments.
%
%      OSCILOSCOPIO_7('Property','Value',...) creates a new OSCILOSCOPIO_7 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Osciloscopio_7_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Osciloscopio_7_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Osciloscopio_7

% Last Modified by GUIDE v2.5 05-Mar-2019 09:56:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Osciloscopio_7_OpeningFcn, ...
                   'gui_OutputFcn',  @Osciloscopio_7_OutputFcn, ...
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


% --- Executes just before Osciloscopio_7 is made visible.
function Osciloscopio_7_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Osciloscopio_7 (see VARARGIN)

% Choose default command line output for Osciloscopio_7
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global puerto;
puerto=serial('COM8','BaudRate',115200,'Terminator','LF');   %Crea el objeto de matlab que lee y usa el puerto
fopen(puerto); %abre el puerto
%Arrays para plot (se ejecuta al cambio de timeBase)
global canales;
canales=1;
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
%contador de ciclos
global s;
global z;
z=0;
s=0;
% UIWAIT makes Osciloscopio_7 wait for user response (see UIRESUME)
% uiwait(handles.Osciloscopio);


% --- Outputs from this function are returned to the command line.
function varargout = Osciloscopio_7_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Graficar.
function Graficar_Callback(hObject, eventdata, handles)
% hObject    handle to Graficar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s;
global z;
cla
global canales;
global puerto;
global Amplitud_ch1;
global Amplitud_ch2;
global dac;
global time;
global ch1_plot;
global ch2_plot;
global digit_1;
global digit_2;
global a;
global b;
global c;
global d;
%canales Analogicos
if canales==1
    s=1;
    while s
    %busqueda de inicio y adquisicion de bytes
         while a>127
            a=fread(puerto,1); 
         end
        b=fread(puerto,1);
        c=fread(puerto,1);
        d=fread(puerto,1);
  
        %cambio de doble a uint8
        a=uint8(a);
        b=uint8(b);
        c=uint8(c);
        d=uint8(d);
    
        %conversion bytes a char para recortar los datos de canal
        a1=dec2bin(a,8);
        b1=dec2bin(b,8);   
        c1=dec2bin(c,8);
        d1=dec2bin(d,8);

        %recorte de datos de canal
        a2=a1(3:8);
        b2=b1(3:8);
        c2=c1(3:8);
        d2=d1(3:8);
    
        %canales en char
        ch1_char=strcat(a2,b2);
        ch2_char=strcat(c2,d2);
    
        %canales en dec
        ch1=bin2dec(ch1_char);
        ch2=bin2dec(ch2_char);
    
        %grafico de canales
  
        ch1_plot = circshift(ch1_plot,1);
        ch2_plot = circshift(ch2_plot,1);
        ch1_plot(1)=ch1*Amplitud_ch1*dac;
        ch2_plot(1)=ch2*Amplitud_ch2*dac;
        uiwait;
        if s==0
        break
        end
        pause(0.01);
        plot(time,ch1_plot,time,ch2_plot);
        drawnow;
    end
%canales Digitales    
else
    if canales==2
        z=1;
    while z
    %busqueda de inicio y adquisicion de bytes
         while a>127
            a=fread(puerto,1); 
         end
        b=fread(puerto,1);
        c=fread(puerto,1);
        d=fread(puerto,1);
  
        %cambio de doble a uint8
        a=uint8(a);
        b=uint8(b);
        c=uint8(c);
        d=uint8(d);
    
        %conversion bytes a char para recortar los datos de canal
        a1=dec2bin(a,8);
        c1=dec2bin(c,8);
        %recorte de canales digitales
        chd_1=a1(2);
        chd_2=c1(2);
        %canales en dec
        chd1=bin2dec(chd_1);
        chd2=bin2dec(chd_2);
        %ploteo de canales digitales
        digit_1 = circshift(digit_1,1);
        digit_2 = circshift(digit_2,1);
        digit_1(1)=chd1*Amplitud_ch1;
        digit_1(1)=chd2*Amplitud_ch2;
        uiwait
        if z==0
        break
        end
        plot(time,digit_1,time,digit_2);
        pause(0.01);
        drawnow;
    end
    end
    s=0;
    z=0;
end

% --- Executes on button press in Parar.
function Parar_Callback(hObject, eventdata, handles)
% hObject    handle to Parar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla
global z;
global s;
s=0;
z=0;


% --- Executes on selection change in selectorCanal.
function selectorCanal_Callback(hObject, eventdata, handles)
% hObject    handle to selectorCanal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla
global s;
global z;
s=0;
z=0;
global canales;
canales=get(hObject,'Value');
if canales==1
    s=1;
    z=0;
elseif canales==2
    s=0;
    z=1;
end
% Hints: contents = cellstr(get(hObject,'String')) returns selectorCanal contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectorCanal


% --- Executes during object creation, after setting all properties.
function selectorCanal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectorCanal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Amplitud1.
function Amplitud1_Callback(hObject, eventdata, handles)
% hObject    handle to Amplitud1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla
global s;
global z;
z=0;
s=0;
global Amplitud_ch1;
aux=get(hObject,'Value');
switch aux
    case 1
        Amplitud_ch1=0.3;
    case 2
        Amplitud_ch1=1;
    case 3
        Amplitud_ch1=3;
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


% --- Executes on selection change in Amplitud2.
function Amplitud2_Callback(hObject, eventdata, handles)
% hObject    handle to Amplitud2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla
global s;
s=0;
global z;
z=0;
global Amplitud_ch2;
aux=get(hObject,'Value');
switch aux
    case 1
        Amplitud_ch2=0.3;
    case 2
        Amplitud_ch2=1;
    case 3
        Amplitud_ch2=3;
end
        % Hints: contents = cellstr(get(hObject,'String')) returns Amplitud2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Amplitud2


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


% --- Executes on selection change in timeBase.
function timeBase_Callback(hObject, eventdata, handles)
% hObject    handle to timeBase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla
global s;
s=0;
global z;
z=0;
global ini;
global fini;
global timeBase;
aux=get(hObject,'Value');
switch aux
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


% --- Executes on mouse press over axes background.
function Pantalla_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Pantalla (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close Osciloscopio.
function Osciloscopio_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to Osciloscopio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s;
global z;
s=0;
z=0;
% Hint: delete(hObject) closes the figure
delete(hObject);
