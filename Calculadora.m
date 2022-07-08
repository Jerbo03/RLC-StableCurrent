% Limpiar la consola y los datos almcanados
clc
clear

%Precición de 15 decimales
output_precision(15);

% Título de la aplicación
% Para circuits RLC
% Para casos iniciales q(0)=0 y i(0)=0
msg = msgbox("Lq'' + Rq' + 1/C q = V sin(wt)\nq(0)=0\ti(o)=0", "Calculadora");
uiwait(msg);

% Ventana de ingreso de datos
prompt = {"R(Ohms)", "L(Henrios)", "C(Faradios)", "V(Volts)", "w(rad/s)"};
defaults = {"2.0", "1.0", "0.25", "50.0", "1.0"};
rowscols = [1,30; 1,30; 1,30; 1,30; 1,30];
in = inputdlg (prompt, "Ingrese los valores del circuito en serie",
      rowscols, defaults);

% Código de error en caso de que se cierre la ventana
if (isempty (in))
   errordlg ('Evaluación cancelada', 'Atención');
   error("Evaluación cancelada por el usuario")
endif

% Inicialización de los datos para calcular
R = str2num(in{1}) % Valor de la resistencia en ohms
L = str2num(in{2}) % Valor de la inductancia en henrios
C = str2num(in{3}) % Valor de la capacitancia en faradios
V = str2num(in{4}) % Valor del voltaje pico de la fuente en volts
w = str2num(in{5}) % Valor de la frecuencia en rad/s

% Para evitar errores matmétics supondremos que todos los valores
% de los voltajes picos son mayores a 0
if (R == 0 || L == 0 || C == 0 || w == 0)
  errordlg ('Evaluación cancelada', 'Atención');
  error("No puede colocar valores para los componentes iguales a 0")
endif

% Suponinedo que q_p(t) = A sen wt + B cos wt
% Como se vio en la semana 10 Circuitos en serie análogos

X = L.*w - 1./(C.*w)   % Reactancia
Z = sqrt(X.^2 + R.^2)  % Impedancia
A = -((V.*X)./(w.*Z.^2)) % Coeficiente reactivo
B = -((V.*R)./(w.*Z.^2)) % Coeficiente impedante

T = (2.*pi)./w; % periodo
t = 0:(T./100):(2.*T); % Valores del tiempo para el gráfico
% De 0 a 2 veces el periodo con unos 100 valores intermedios

% Ecuación particular de la carga
qp = A.*sin(w.*t) + B.*cos(w.*t);
% Etiqueta de la función
label_qp = strcat(
        "qp = (",num2str(A),") sin(",num2str(w),"t) + (",
        num2str(B),") cos(",num2str(w),"t)"
        );
display(label_qp);

% Ecuación particular de la corriente
ip = (V./Z) * ( (R./Z).*(sin(w.*t)) - (X./Z).*(cos(w.*t)));
% Etiqueta de la función
label_ip = strcat(
        "ip = ",num2str(V./Z),"((",num2str(R./Z),") sin(",num2str(w),"t) - (",
        num2str(X/Z),") cos(",num2str(w),"t))"
        );
display(label_ip);

% Configuración de los límites
axis ([0 (2.*T) 0 (2.*T)]);

clf; % Borrar el dibujo actual
subplot (2, 1, 1);  % Posición superior
  plot (t, qp);     % Dibujo del gráfico de la carga
  grid on;          % Activación de al malla
  title (label_qp); % Título del subgráfico
subplot (2, 1, 2);  % Posición superior
  plot (t, ip);     % Dibujo del gráfico de la corriente
  grid on;          % Activación de al malla
  title (label_ip); % Título del subgráfico
