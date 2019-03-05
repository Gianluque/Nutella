%configuracion de puerto
puerto=serial('COM8','BaudRate',115200,'Terminator','LF')   %Crea el objeto de matlab que lee y usa el puerto
fopen(puerto); %abre el puerto
%inicializa variables para plot
k=100;
x=[1:k];
ch1_plot=zeros(1,k);
ch2_plot=zeros(1,k);
figure
plot(x,ch1_plot,x,ch2_plot);
    
%inicializa las variables de llegada
a=128;
b=0;
c=0;
d=0;
    %contador de ciclos para prueba
    aux=[128 0 0 0];
s=1; 
while s
    while aux(1)>127
        aux=fread(puerto,[1,4],'uint8'); 
    end
    s=s-1;
end
instrreset;