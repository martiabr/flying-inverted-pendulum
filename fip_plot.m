%% FIP plot
    
%% FIP animation
figure(1);

axis([min(out.x.data(1, :, :)), max(out.x.data(1, :, :)), min(out.x.data(2, :, :)), max(out.x.data(2, :, :)), min(out.x.data(3, :, :)), max(out.x.data(3, :, :))]);
grid on
hold on
for k = 1:K
    plot3(out.x.data(1, :, k), out.x.data(2, :, k), out.x.data(3, :, k), 'o');
    drawnow
    pause(0.01);
end