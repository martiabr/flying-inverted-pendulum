clc;
clear;

%% Model parameters:
g = 9.81;
L = 1;
T = 20;

%% Initial values:
x0 = [0.1; -0.2; 0.5];
xd0 = [0; 0; 0];

%% LQR gain calculation:
% x y z xd yd zd gamma beta alpha r s rd sd (13)
A_vert = [0 1; 0 0]; % z z_d (2)
B_vert = [0; 1]; % a (1)
C_vert = eye(2);
A_lat = [0 1 0 0 0;
         0 0 g 0 0;
         0 0 0 0 0;
         0 0 0 0 1;
         0 0 -g g/L 0]; % x x_d beta r rd (5)
B_lat = [0; 0; 1; 0; 0]; % w_y
C_lat = eye(5);
% Note that the two lateral controllers will be identical with opposite
% signs, so only one gain is calculated.

ss_vert = ss(A_vert, B_vert, C_vert, 0);
ss_lat = ss(A_lat, B_lat, C_lat, 0);

Q_vert = [100 0; 0 0];
R_vert = 1;

Q_lat = diag([10, 0, 0, 100, 0]);
R_lat = 1;

[K_vert, S_vert, P_vert] = lqr(ss_vert, Q_vert, R_vert);
[K_lat, S_lat, P_lat] = lqr(ss_lat, Q_lat, R_lat);





A_lat2 = [0 1 0 0 0;
         0 0 -g 0 0;
         0 0 0 0 0;
         0 0 0 0 1;
         0 0 g g/L 0]; % x x_d beta r rd (5)
B_lat2 = [0; 0; 1; 0; 0]; % w_y
C_lat2 = eye(5);
ss_lat2 = ss(A_lat2, B_lat2, C_lat2, 0);
[K_lat2, S_lat2, P_lat2] = lqr(ss_lat2, Q_lat, R_lat);
