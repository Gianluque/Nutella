% Defini el vector de 4 porque son 4 bytes los que entran pero no estoy
% seguro de si se deba hacer asi


A = [ 23 15 0 0];                 % Vector que toma la data del serial 

a = A(1);
b = A(2);

%Lo primero es poner los 2 LSB de a, en los 2 MSB de b

b = b & '00111111';                      % quedaria como 00xxxxxx
b = ( bitshift(a,6) | b);                % b ahora tiene los 8 bits de data

% Ahora queda es quitar los 2 LSB de a, ya que los tiene b y luego dejarlo
% en la forma 0000xxxx para concatenar con b

a = a & '00111111';                      % 00xxxxxx
a = bitshift(a,-2);                      % 0000xxxx

c = bitconcat(a,b);                      % 0000xxxxxxxxxxxx 

% Finalmente c es la data que se grafica y se repite lo mismo para los
% otros 2 bytes del vector


% se puede manipular directamente desde el vecto A pero lo dejare asi para que se entienda
% mejor y porque no se si sea mejor guardarlo en otro lado porque siempre
% se estara recibiendo data continuamente

