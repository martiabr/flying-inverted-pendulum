%% FIP plot
    
%% FIP animation
xmin = min(out.x.data(1, :, :));
xmax = max(out.x.data(1, :, :));
ymin = min(out.x.data(2, :, :));
ymax = max(out.x.data(2, :, :));
zmin = min(out.x.data(3, :, :));
zmax = max(out.x.data(3, :, :)) + 2 * L;

fig = figure(1);
filename = 'fip.gif';
for k = 1:K
    x = out.x.data(1, :, k);
    y = out.x.data(2, :, k);
    z = out.x.data(3, :, k);
    plot3(x, y, z, 'o');
    
    grid on
    hold on
    
    % Find position of pendulum tip in inertial frame:
    % (assuming center of mass in middle of pendulum)
    r = out.rs.data(k, 1);
    s = out.rs.data(k, 2);
    r_i = x + 2 * r;
    s_i = y + 2 * s;
    zeta = sqrt(L^2 - r^2 - s^2);
    zeta_i = z + 2 * zeta;
    
    plot3(r_i, s_i, zeta_i, 'o');
    plot3([x r_i], [y s_i], [z zeta_i], '-');
    
    axis([xmin, xmax, ymin, ymax, zmin, zmax]);
    hold off
    drawnow
    %pause(0.001);
    
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