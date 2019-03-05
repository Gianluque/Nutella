function varargout = Osciloscopio_1(varargin)
% OSCILOSCOPIO_1 MATLAB code for Osciloscopio_1.fig
%      OSCILOSCOPIO_1, by itself, creates a new OSCILOSCOPIO_1 or raises the existing
%      singleton*.
%
%      H = OSCILOSCOPIO_1 returns the handle to a new OSCILOSCOPIO_1 or the handle to
%      the existing singleton*.
%
%      OSCILOSCOPIO_1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OSCILOSCOPIO_1.M with the given input arguments.
%
%      OSCILOSCOPIO_1('Property','Value',...) creates a new OSCILOSCOPIO_1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Osciloscopio_1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Osciloscopio_1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Osciloscopio_1

% Last Modified by GUIDE v2.5 04-Mar-2019 16:39:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Osciloscopio_1_OpeningFcn, ...
                   'gui_OutputFcn',  @Osciloscopio_1_OutputFcn, ...
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


% --- Executes just before Osciloscopio_1 is made visible.
function Osciloscopio_1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Osciloscopio_1 (see VARARGIN)

% Choose default command line output for Osciloscopio_1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% configuracion de puerto
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
s=1;

% UIWAIT makes Osciloscopio_1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Osciloscopio_1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function Pantalla_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pantalla (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate Pantalla


% --- Executes on button press in closePort.
function closePort_Callback(hObject, eventdata, handles)
% hObject    handle to closePort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global puerto
global s;
s=0;
pause(1);
%fclose(puerto);             %cierra el puerto para poder usarlo otra vez con otra cosa
%delete(puerto);             %elimina la variable para que no quede ocupando nada

% --- Executes on button press in Start.
function Start_Callback(hObject, eventdata, handles)
% hObject    handle to Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla
global canales;
canales=1;
global puerto;
global Amplitud_ch1;
global Amplitud_ch2;
Amplitud_ch1=1;
Amplitud_ch2=1;
global dac;
global ini;
global fini;
global timeBase;
global time;
global ch1_plot;
global ch2_plot;
global digit_1;
global digit_2;
global a;
global b;
global c;
global d;
global s;
s=0;
pause(1);
s=1;
%ploteo canales analogicos
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
    plot(time,ch1_plot,time,ch2_plot);
    
    %sin valores en los ejes
    %yticklabels({})
    %xticklabels({})
    drawnow update
end

% --- Executes on selection change in selectorCanal.
function selectorCanal_Callback(hObject, eventdata, handles)
% hObject    handle to selectorCanal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selectorCanal contents as cell array
cla
global canales;
canales=get(selecttorCanal,'Value');
global puerto;
global Amplitud_ch1;
global Amplitud_ch2;
Amplitud_ch1=1;
Amplitud_ch2=1;
global dac;
global ini;
global fini;
global timeBase;
global time;
global ch1_plot;
global ch2_plot;
global digit_1;
global digit_2;
global a;
global b;
global c;
global d;
global s;
s=0;
pause(0.5);
%switch de canal
switch (canales)

    case 1
    

    s=1;
    %ploteo canales digitales
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
        plot(time,ch1_plot,time,ch2_plot);
    
        %sin valores en los ejes
        %yticklabels({})
        %xticklabels({})
        drawnow update
        end    
    case 2
    
    s=1;
    %ploteo canales digitales
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
        digit_1(1)=chd2*Amplitud_ch1;
        plot(time,digit_1,time,digit_2);
    
        %sin valores en los ejes
        %yticklabels({})
        %xticklabels({})
        drawnow update
    end
end

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


% --- Executes on selection change in Amplitudch1.
function Amplitudch1_Callback(hObject, eventdata, handles)
% hObject    handle to Amplitudch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Amplitudch1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Amplitudch1
cla
global canales;
global puerto;
global Amplitud_ch1;
global Amplitud_ch2;
aux=get(hObject,'Value');
switch aux
    case 1
        Amplitud_ch1=0.3;
    case 2
        Amplitud_ch1=1;
    case 3
        Amplitud_ch1=3;
end
global dac;
global ini;
global fini;
global timeBase;
global time;
global ch1_plot;
global ch2_plot;
global digit_1;
global digit_2;
global a;
global b;
global c;
global d;
global s;
s=0;
pause(0.5);
%switch de canal
switch (canales)

    case 1
    

    s=1;
    %ploteo canales digitales
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
        plot(time,ch1_plot,time,ch2_plot);
    
        %sin valores en los ejes
        %yticklabels({})
        %xticklabels({})
        drawnow update
        end    
    case 2
    
    s=1;
    %ploteo canales digitales
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
        digit_1(1)=chd2*Amplitud_ch1;
        plot(time,digit_1,time,digit_2);
    
        %sin valores en los ejes
        %yticklabels({})
        %xticklabels({})
        drawnow update
    end
end



% --- Executes during object creation, after setting all properties.
function Amplitudch1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Amplitudch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Amplitudch2.
function Amplitudch2_Callback(hObject, eventdata, handles)
% hObject    handle to Amplitudch2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Amplitudch2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Amplitudch2
cla
global canales;
global puerto;
global Amplitud_ch1;
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
global dac;
global ini;
global fini;
global timeBase;
global time;
global ch1_plot;
global ch2_plot;
global digit_1;
global digit_2;
global a;
global b;
global c;
global d;
global s;
s=0;
pause(0.5);
%switch de canal
switch (canales)

    case 1
    

    s=1;
    %ploteo canales digitales
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
        plot(time,ch1_plot,time,ch2_plot);
    
        %sin valores en los ejes
        %yticklabels({})
        %xticklabels({})
        drawnow update
        end    
    case 2
    
    s=1;
    %ploteo canales digitales
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
        digit_1(1)=chd2*Amplitud_ch1;
        plot(time,digit_1,time,digit_2);
    
        %sin valores en los ejes
        %yticklabels({})
        %xticklabels({})
        drawnow update
    end
end

% --- Executes during object creation, after setting all properties.
function Amplitudch2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Amplitudch2 (see GCBO)
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

% Hints: contents = cellstr(get(hObject,'String')) returns timeBase contents as cell array
%        contents{get(hObject,'Value')} returns selected item from timeBase
cla
global canales;
global puerto;
global Amplitud_ch1;
global Amplitud_ch2;
global dac;
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
global a;
global b;
global c;
global d;
global s;
s=0;
pause(0.5);
%switch de canal
switch (canales)

    case 1
    

    s=1;
    %ploteo canales digitales
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
        plot(time,ch1_plot,time,ch2_plot);
    
        %sin valores en los ejes
        %yticklabels({})
        %xticklabels({})
        drawnow update
        end    
    case 2
    
    s=1;
    %ploteo canales digitales
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
        digit_1(1)=chd2*Amplitud_ch1;
        plot(time,digit_1,time,digit_2);
    
        %sin valores en los ejes
        %yticklabels({})
        %xticklabels({})
        drawnow update
    end
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
