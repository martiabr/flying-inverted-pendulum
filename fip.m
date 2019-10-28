g = 9.81;
L = 1;

% N = 13;
% M = 4;
% h = 0.01;
% T = 10;
% K = T / h;
% 
% x = zeros(N, K); % x y z x_dot y_dot z_dot gamma beta alpha r s r_dot s_dot
% u = zeros(M, K); % w_x w_y w_z a
% 
% for k = 1:K
%     
% end

f_r_dd = @(x_dd, z_dd, r, s, r_d, s_d, s_dd) ...
(-r^4 * x_dot(4) - (L^2 - x(10)^2)^2 * x_dot(4) ...
    - 2 * x(10)^2 * (x(11) * x(12) * x(13) + (-L^2 + x(11)^2) * x_dot(4)) ...
    + x(10)^3 * (x(13)^2 + 

f_s_dd = @(y_dd, z_dd, r, s, r_d, s_d, r_dd);