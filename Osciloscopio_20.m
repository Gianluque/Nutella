function varargout = Osciloscopio_20(varargin)
% Codigo de Inicializacion Aplicacion
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Osciloscopio_20_OpeningFcn, ...
                   'gui_OutputFcn',  @Osciloscopio_20_OutputFcn, ...
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

end


function Osciloscopio_20_OpeningFcn(hObject, ~, handles, varargin)
%Inicializacion de variables a usar
handles.output = hObject;

guidata(hObject, handles);
global puerto; %Crea el objeto puerto
puerto=serial('COM8','BaudRate',115200,'Terminator','LF');   %Configutaciond e los parametros del puerto
fopen(puerto); %abre el puerto

%Variables utilizadas en la Aplicacion

%Bases de Amplitud
global Amplitud_ch1;
global Amplitud_ch2;
Amplitud_ch1=3;
Amplitud_ch2=3;

%Factor de conversion Digital Analogico (porque es a 12bit de presicion)
global dac;
dac=3/(2^12);

%Numero de puntos a plotear
global ini;
ini=0;
global fini;
fini=10;

%Base de tiempo
global timeBase;
timeBase=100;
global time;
time=linspace(ini,fini,timeBase);

%Arreglos a plotear para los canales
global ch1_plot;
ch1_plot=zeros(1,length(time));
global ch2_plot;
ch2_plot=zeros(1,length(time));
global digit_1;
digit_1=zeros(1,length(time));
global digit_2;
digit_2=zeros(1,length(time));

%inicializa variables auxiliares;
global a;
a=128;
global b;
b=0;
global c;
c=0;
global d;
d=0;
end

function varargout = Osciloscopio_20_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% Pulsaciond de Graficar.
function Graficar_Callback(~, ~, handles)
set(handles.On_Off,'Value',1);

%Variables globales a usar
global puerto;
global Amplitud_ch1;
global Amplitud_ch2;
global dac;
global time;
global ch1_plot;
global ch2_plot;
global digit_1;
global digit_2;

%Tamano del buffer que recibe los datos del demo
buffersize=500;
flush=0;
%Codigo de graficado
while get(handles.On_Off,'Value')==1
    %busqueda de inicio y adquisicion de bytes
    aux=fread(puerto,[1,buffersize],'uint8'); 
        %flush del puerto
    flush=flush+1;
    if flush>2
    flushinput(puerto)
    flush=0;
    end
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
        digit_1(1)=bin2dec(chauxdig1)*Amplitud_ch1*dac;
        digit_2(1)=bin2dec(chauxdig2)*Amplitud_ch2*dac;    
        ch1_plot = circshift(ch1_plot,1);
        ch2_plot = circshift(ch2_plot,1);        
        ch1_plot(1)=bin2dec(chauxAlog1)*Amplitud_ch1*dac;
        ch2_plot(1)=bin2dec(chauxAlog2)*Amplitud_ch2*dac;
        
        %Canales setm o plot
        
        if get(handles.plot_stem,'Value')==1
         %grafico de canales continuo
        cla;
        
        if get(handles.Alog_1,'Value')==1
        plot(time,ch1_plot,'b');
        end
        hold on;
        grid on;
        axis([0 5 0 5])
        if get(handles.Alog_2,'Value')==1
        plot(time,ch2_plot,'r');
        end
        if get(handles.Digi_1,'Value')==1
        plot(time,digit_1,'g');
        end
        if get(handles.Digi_2,'Value')==1
        plot(time,digit_2,'m');
        end
        drawnow;
        i=i+4;
        elseif get(handles.plot_stem,'Value')==2
        cla;    
        if get(handles.Alog_1,'Value')==1
        plot(time,ch1_plot,'b.');
        end
        hold on;        
        
        if get(handles.Alog_2,'Value')==1
        plot(time,ch2_plot,'r.');
        end
        if get(handles.Digi_1,'Value')==1
        plot(time,digit_1,'g.');
        end
        
        if get(handles.Digi_2,'Value')==1
        plot(time,digit_2,'m.');
        end
        drawnow;    
        end
        i=i+4;
    end

    %cla 
end

end

%Cambios en la Amplitud para el canal 1
function Amplitud1_Callback(hObject, eventdata, handles)
cla

global Amplitud_ch1;
aux1=get(hObject,'Value');
switch aux1
    case 1
        Amplitud_ch1=3;
    case 2
        Amplitud_ch1=1;
    case 3
        Amplitud_ch1=0.3;
end
end


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

%Cambios para la Amplitud del canal 2
function Amplitud2_Callback(hObject, eventdata, handles)
cla
global Amplitud_ch2;
aux2=get(hObject,'Value');
switch aux2
    case 1
        Amplitud_ch2=3;
    case 2
        Amplitud_ch2=1;
    case 3
        Amplitud_ch2=0.3;
end
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

%Cambios en la BAse de tiempo
function timeBase_Callback(hObject, eventdata, handles)
cla
global ini;
global fini;
global timeBase;
aux3=get(hObject,'Value');
switch aux3
    case 1
        timeBase=100;
    case 2
        timeBase=1000;
    case 3
        timeBase=10000;
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

%Cerrado de la Aplicacion
function Osciloscopio_CloseRequestFcn(hObject, eventdata, handles)
set(handles.On_Off,'Value',2);
instrreset;
delete(hObject);
end

%Botones o selectores que no cambian nada pero cuyo estado se revisa para
%la ejecucion del programa

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
