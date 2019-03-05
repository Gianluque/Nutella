
s=100;
x=[-5:5];
y=uint8([0 0 0 0 0 0 0 0 0 0 0]);
while s
    y=circshift(y,-1);
    y(11)=uint8(128*10*rand);             %lee un valor del puerto le puse un random para generar bytes de prueba
    plot(x,y);
    grid on;
    yticklabels({})%sin valores en los ejes
    xticklabels({})
    s=s-1;
end