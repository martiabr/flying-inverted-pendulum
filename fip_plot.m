%% FIP plot
plot_graphs = true;
t = 0:h:T;

if plot_graphs
    % TODO: plot all the stuffs, both in time and trajectories in space,
    % and possible state space? rs-space for instance?
    
    style1 = hgexport('factorystyle');
    style1.Format = 'png';
    style1.Width = 6;
    style1.Height = 2.5;
    style1.Resolution = 300;
    style1.Units = 'inch';
    style1.FixedFontSize = 12;

    % Attitude plot:
    f1 = figure(1);
    plot(t, out.attitude.data(:, :));
    grid on
    legend('\gamma', '\beta', '\alpha');
    title('Attitude');
    xlabel('t[s]');
    ylabel('\Theta[rad]');
    hgexport(f1,'att.png',style1,'Format','png');
    
    % Quadrotor position plot:
    f2 = figure(2);
    plot(t, squeeze(out.x.data(:, :, :)));
    grid on
    legend('x', 'y', 'z');
    title('Quadrotor position');
    xlabel('t[s]');
    ylabel('x[m]');
    hgexport(f2,'x.png',style1,'Format','png');
    
    % Pole position plot:
    f3 = figure(3);
    plot(t, out.rs.data(:, :));
    grid on
    legend('r', 's');
    title('Pole position');
    xlabel('t[s]');
    ylabel('rs[m]');
    hgexport(f3,'rs.png',style1,'Format','png');
end

%% FIP animation setup and configuration
animate = false;
animate_trajectories = true;
rotation = 4;  % 0: default, 1: rotation, 2: xz, 3: yz, 4: xy
write_gif = false;

L_arm = 0.25;
p_traj = [];
elevation = 20;
azimuth_start = 20;
azimuth_end = 70;

c1 = [66, 80, 207] / 256;
c2 = [201, 40, 51] / 256;
c3 = [168, 56, 201] / 256;

xmin = min(out.x.data(1, :, :) - L_arm);
xmax = max(out.x.data(1, :, :) + L_arm);
ymin = min(out.x.data(2, :, :) - L_arm);
ymax = max(out.x.data(2, :, :) + L_arm);
zmin = min(out.x.data(3, :, :));
zmax = max(out.x.data(3, :, :)) + 2 * L;

%% FIP animation
if animate
    fig = figure(5);
    set(gcf,'color','w');
    filename = 'fip.gif';
    for k = 1:K
        p = out.x.data(:, :, k);
        p_traj = [p_traj p];
        x = p(1);
        y = p(2);
        z = p(3);
        alpha = out.attitude.data(k, 1);
        beta = out.attitude.data(k, 2);
        gamma = out.attitude.data(k, 3);
                
        % Find position of rotors:
        R_z = [cos(alpha) -sin(alpha) 0; sin(alpha) cos(alpha) 0; 0 0 1];
        R_y = [cos(beta) 0 sin(beta); 0 1 0; -sin(beta) 0 cos(beta)];
        R_x = [1 0 0; 0 cos(gamma) -sin(gamma); 0 sin(gamma) cos(gamma)];
        R = R_x * R_y * R_z;
        R_inv = R';
        p1 = R_inv * [L_arm; 0; 0] + p;
        p2 = R_inv * [0; L_arm; 0] + p;
        p3 = R_inv * [-L_arm; 0; 0] + p;
        p4 = R_inv * [0; -L_arm; 0] + p;
        %p5 = R_inv * [0; 0; L_arm] + p;
        %p6 = R_inv * [0; 0; -L_arm] + p;

        % Find position of pendulum tip in inertial frame:
        % (assuming center of mass in middle of pendulum)
        r = out.rs.data(k, 1);
        s = out.rs.data(k, 2);
        r_i = x + 2 * r;
        s_i = y + 2 * s;
        zeta = sqrt(L^2 - r^2 - s^2);
        zeta_i = z + 2 * zeta;

        plot3(x, y, z, 'Marker', 'o', 'Color', c2, 'MarkerFaceColor', c2);
        grid on
        hold on
        
        % TODO: plot cross instead of 4 lines
        
        plot3(p1(1), p1(2), p1(3), 'Marker', 'o', 'Color', c2, 'MarkerSize', 10, 'LineWidth', 2);
        plot3(p2(1), p2(2), p2(3), 'Marker', 'o', 'Color', c2, 'MarkerSize', 10, 'LineWidth', 2);
        plot3(p3(1), p3(2), p3(3), 'Marker', 'o', 'Color', c2, 'MarkerSize', 10, 'LineWidth', 2);
        plot3(p4(1), p4(2), p4(3), 'Marker', 'o', 'Color', c2, 'MarkerSize', 10, 'LineWidth', 2);
        plot3([x p1(1)], [y p1(2)], [z p1(3)], 'LineStyle', '-', 'LineWidth', 3, 'Color', c2);
        plot3([x p2(1)], [y p2(2)], [z p2(3)], 'LineStyle', '-', 'LineWidth', 3, 'Color', c2);
        plot3([x p3(1)], [y p3(2)], [z p3(3)], 'LineStyle', '-', 'LineWidth', 3, 'Color', c2);
        plot3([x p4(1)], [y p4(2)], [z p4(3)], 'LineStyle', '-', 'LineWidth', 3, 'Color', c2);
        %plot3([x p5(1)], [y p5(2)], [z p5(3)], 'LineStyle', '-', 'LineWidth', 1.5, 'Color', c2);
        %plot3([x p6(1)], [y p6(2)], [z p6(3)], 'LineStyle', '-', 'LineWidth', 1.5, 'Color', c2);
        
        plot3(r_i, s_i, zeta_i, 'Marker', 'o', 'Color', c1, 'MarkerFaceColor', c1);
        plot3([x r_i], [y s_i], [z zeta_i], 'LineStyle', '-', 'LineWidth', 2, 'Color', c1);
        
        if animate_trajectories
            plot3(x0(1), x0(2), x0(3), 'Marker', 'x', 'Color', c3);
            plot3(x_r.data(1, k), x_r.data(2, k), x_r.data(3, k), 'Marker', 'x', 'Color', c3);
            traj_plot = plot3(p_traj(1, :), p_traj(2, :), p_traj(3, :), 'LineStyle', ':', 'LineWidth', 1, 'Color', c3);
            traj_plot.Color(4) = 0.75;
        end
        
        axis equal
        axis([-0.5, 2.5, -0.5, 3.5, -2, 2]);
        %axis tight
        
        switch rotation
            case 0
                view(45, elevation);
            case 1
                view(k/K * (azimuth_end - azimuth_start) + azimuth_start, elevation);
            case 2
                view(0, 0);
            case 3
                view(90, 0);
            case 4
                view(2);
        end
        
        drawnow
        hold off

        if write_gif
            % Capture the plot as an image 
            frame = getframe(fig); 
            im = frame2im(frame); 
            [imind,cm] = rgb2ind(im,256); 

            % Write to the GIF File 
            if k == 1 
                imwrite(imind,cm,filename,'gif', 'Loopcount',inf, 'DelayTime', h); 
            else 
                imwrite(imind,cm,filename,'gif','WriteMode','append', 'DelayTime', h); 
            end
        end
    end
end