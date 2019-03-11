%Variables prueba
%array de prueba de "lectura serial"
aux=[130 129 150 127 158 95 169 140 230 130 129 150 127 158 95 169 140 230 130 129 150 127 158 95 169 140 230 130 129 150 127 158 95 169 140 230 130 129 150 127 158 95 169 140 230 130 129 150 127 158 95 169 140 230 130 129 150 127 158 95 169 140 230 130 129 150 127 158 95 169 140 230 130 129 150 127 158 95 169 140 230 130 129 150 127 158 95 169 140 230 130 129 150 127 158 95 169 140 230 130 129 150 127 158 95 169 140 230 130 129 150 127 158 95 169 140 230 130 129 150 127 158 95 169 140 230 130 129 150 127 158 95 169 140 230 130 129 150 127 158 95 169 140 230 130 129 150 127 158 95 169 140 230 130 129 150 127 158 95 169 140 230 130 129 150 127 158 95 169 140 230 130 129 150 127 158 95 169 140 230 130 129 150 127 158 95 169 140 230 130 129 150 127 158 95 169 140 230 130 129 150 127 158 95 169 140 230 130 129 150 127 158 95 169 140 230];
i=1;
Amplitud_ch1=1;
Amplitud_ch2=2;
dac=3/(2^12);
global ini;
ini=0;
global fini;
fini=400;
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
buffersize=200;
botondestem=1;

%nuevo ciclo de adq & plot


    while aux(i)>127
        i=i+1;
    end    
bin=dec2bin(aux);    
    while i<buffersize
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
        
        switch botondestem
        case 1
                        %grafico de canales
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
                        %grafico de canales
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
    %poner aca
    %flush al buffer
    %poner aca
    