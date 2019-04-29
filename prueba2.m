
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

%Tamano del buffer que recibe los datos del demo
buffersize=488;
flush=0;
%Codigo de graficado
a=;
while a==1
    %busqueda de inicio y adquisicion de bytes
    aux=fread(puerto,[1,buffersize],'uint8'); 
  %      flush del puerto
    flush=flush+1;
    if flush>2
    flushinput(puerto)
    flush=0;
    end
    i=1;
    while aux(i)>127
        i=i+1;
    end  
    zzzz=i*120
    bin=dec2bin(aux);    
    while i<(buffersize-8)
       chauxAlog1= strcat(bin(i,3:8),bin(i+1,3:8));
       chauxdig1= bin(i,2); 
       chauxAlog2= strcat(bin(i+2,3:8),bin(i+3,3:8)); 
       chauxdig2= bin(i+2,2);
       i=i+4;
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
        
        if 1==1
         %grafico de canales continuo
        cla;
        
        if 1==1
        plot(time,ch1_plot,'b');
        end
        hold on;
        grid on;
        axis([0 5 0 5]);
         
        
        end
      
    end
a=a-1;
    %cla 
   
end
instrreset;   