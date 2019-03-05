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
    a=uint8(aux(1));
    b=uint8(aux(2));
    c=uint8(aux(3));
    d=uint8(aux(4));
    
    %conversion bytes a char para recortar los datos de canal
    a1=dec2bin(a,8);
    b1=dec2bin(b,8);   
    c1=dec2bin(c,8);
    d1=dec2bin(d,8);
    
    %recorte de canales digitales
    chd_1=a1(2);
    chd_2=c1(2);
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
    ch1_plot(1)=ch1;
    ch2_plot(1)=ch2;
    s=s-1;
end
instrreset;