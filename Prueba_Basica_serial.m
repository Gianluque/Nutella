%seriallist                 %muestra la lista de puertos seriales que hay
%instrfindall               %Encuentra los puertos seriales que hay

puerto=serial('COM8','BaudRate',9600,'Terminator','LF')   %Crea el objeto de matlab que lee y usa el puerto
fopen(puerto);              %abre el puerto

s=100;
x=[-5:5];
s=1;
y=[0 0 0 0 0 0 0 0 0 0 0];
while s
    y=circshift(y,-1);
    y(11)=fgets(puerto);             %lee un valor del puerto
    plot(x,y);
    grid on;
    yticklabels({})%sin valores en los ejes
    xticklabels({})
    s=s-1;
end




fclose(puerto);             %cierra el puerto para poder usarlo otra vez con otra cosa
delete(puerto);             %elimina la variable para que no quede ocupando nada
%clear                       %Limpia los datos que quedan almacenadas en el workspace
