function F = three_bus_nonlinear( X )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

theta1 = X(1);
Qg1 = X(2);
V2 = X(3);
theta2 = X(4);
V3 = X(5);
theta3 = X(6);

Pl1 = 0.2;
Ql1 = 0.3;
Pg1 = 1.2;

V1 = 1;

G1 = 3.4483;
G2 = 3.4483;
B1 = -8.6207;
B2 = -8.6207;

Pl2 = 0.8;
Ql2 = 10;

F(1) = Pl1 - Pg1 + G1*V1*V1 -G1*V1*V2*cos(theta1-theta2) -B1*V1*V2*sin(theta1-theta2);
F(2) = Ql1 - Qg1 -G1*V1*V2*sin(theta1-theta2) + B1*V1*V2*cos(theta1-theta2);
F(3) = V2 - 1;
F(4) = theta2;
F(5) = Pl2  + G2*V3*V3 -G2*V3*V2*cos(theta3-theta2) -B2*V3*V2*sin(theta3-theta2);
F(6) = Ql2 -G2*V3*V2*sin(theta3-theta2) + B2*V3*V2*cos(theta3-theta2);




end

