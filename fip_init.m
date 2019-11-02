clc;
clear;

%% Model parameters:
g = 9.81;
L = 0.8;  % length to center of mass of pendulum

%% Simulation parameters:
T = 4;
h = 0.02;
K = T / h;

%x_r = timeseries([1+cos(0:h:T); 1+sin(0:h:T); zeros(1, K+1)], 0:h:T);
x_r = timeseries(zeros(3, K+1), 0:h:T);

%% Initial values:
x0 = [2; 3; -2];
xd0 = [0; 0; 0];
attitude0 = [0; 0; 0.0];
r0 = 0;
s0 = 0;
rd0 = 0;
sd0 = 0;

%% LQR gain calculation:
% x y z xd yd zd gamma beta alpha r s rd sd (13)
A_z = [0 1; 0 0]; % z z_d (2)
B_z = [0; 1]; % a (1)
C_z = eye(2);
ss_z = ss(A_z, B_z, C_z, 0);

A_x = [0 1 0 0 0;
         0 0 g 0 0;
         0 0 0 0 0;
         0 0 0 0 1;
         0 0 -g g/L 0]; % x x_d beta r rd (5)
B_x = [0; 0; 1; 0; 0]; % w_y
C_x = eye(5);
ss_x = ss(A_x, B_x, C_x, 0);

A_y = [0 1 0 0 0;
         0 0 -g 0 0;
         0 0 0 0 0;
         0 0 0 0 1;
         0 0 g g/L 0]; % y y_d gamma s sd (5)
B_y = [0; 0; 1; 0; 0]; % w_x
C_y = eye(5);
ss_y = ss(A_y, B_y, C_y, 0);

Q_z = [100 0; 0 0];
R_z = 1;

Q_xy = diag([10, 0, 0, 100, 0]);
R_xy = 1;

[K_z, ~, ~] = lqr(ss_z, Q_z, R_z);
[K_x, ~, ~] = lqr(ss_x, Q_xy, R_xy);
[K_y, ~, ~] = lqr(ss_y, Q_xy, R_xy);