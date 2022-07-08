clc
clear

output_precision(4);

# msg = msgbox("Lq'' + Rq' + 1/C q = V sin(wt)\nq(0)=0\ti(o)=0", "Calculadora");
# uiwait(msg);

prompt = {"R(Ohms)", "L(Henrios)", "C(Faradios)", "V(Volts)", "w(rad/s)"};
defaults = {"2.0", "1.0", "0.25", "50.0", "1.0"};
rowscols = [1,30; 1,30; 1,30; 1,30; 1,30];
in = inputdlg (prompt, "Ingrese los valores del circuito en serie",
      rowscols, defaults);

R = 0; L = 0; C = 0; V = 0; w = 0;

if (isempty (in))
   errordlg ('Evaluación cancelada', 'Atención');
   error("Evaluación cancelada por el usuario")
endif

R = str2num(in{1})
L = str2num(in{2})
C = str2num(in{3})
V = str2num(in{4})
w = str2num(in{5})


if (R == 0 || L == 0 || C == 0 || V == 0 || w == 0)
   errordlg ('Evaluación cancelada', 'Atención');
   error("No puede colocar valores iguales a 0")
endif

% Suponinedo que q_p(t) = A sen wt + B cos wt
% Como se vio en la semana 10 Circuitos en serie análogos



X = L.*w - 1./(C.*w)   % Reactancia
Z = sqrt(X.^2 + R.^2)  % Impedancia
A = -((V.*X)./(w.*Z.^2))
B = -((V.*R)./(w.*Z.^2))

T = (2.*pi)./w; % periodo
t = 0:(T./100):(2.*T);

qp = A.*sin(w.*t) + B.*cos(w.*t);
display(strcat(
        "qp = (",num2str(A),") sin(",num2str(w),"t) + (",
        num2str(B),") cos(",num2str(w),"t)"
        ));

ip = (V./Z) * ( (R./Z).*(sin(w.*t)) - (X./Z).*(cos(w.*t)));
display(strcat(
        "ip = ",num2str(V./Z),"((",num2str(R./Z),") sin(",num2str(w),"t) - (",
        num2str(X/Z),") cos(",num2str(w),"t))"
        ));

axis ([0 (2.*T) 0 (2.*T)])
plot(t, qp, t, ip);

