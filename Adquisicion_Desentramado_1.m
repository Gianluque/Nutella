puerto=serial('COM8','BaudRate',115200,'Terminator','LF')   %Crea el objeto de matlab que lee y usa el puerto
fopen(puerto); %abre el puerto
    %inicializa las variables de llegada
a=128;
b=0;
c=0;
d=0;
    %contador de ciclos para prueba
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
    
    %descuento al contador
    s=s-1;
end

disp(ch1)
disp(ch2)

fclose(puerto);             %cierra el puerto para poder usarlo otra vez con otra cosa
delete(puerto);             %elimina la variable para que no quede ocupando nada