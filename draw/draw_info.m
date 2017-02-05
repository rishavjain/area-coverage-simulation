function draw_info( params, time, action )

persistent hTime hLegend

figure(params.fig1.num);
subplot(params.fig1.subplot(1), params.fig1.subplot(2), params.fig1.env);

if strcmp(action, 'initial')
    cla;
    hold on;
    axis equal;
    axis off;

    title('Environment Map', 'FontSize', 16);
    
    timeStr = sprintf('TIME: %.3f', time);    
    dTStr = sprintf('  dT: %.3f', params.sim.timestep);
    
    hTime = text(-0.5*params.env.size, -0.5*params.env.size - 5, {timeStr, dTStr}, ...
        'HorizontalAlignment', 'Left', 'FontSize', 12, 'BackgroundColor', [.7 .9 .7], 'Margin', 7);    
    
    dummyPolygon = 0.1*params.env.boundary;
    
    rpatch = patch(dummyPolygon(:,1), dummyPolygon(:,2), 'r', 'FaceAlpha', 1);
    bpatch = patch(dummyPolygon(:,1), dummyPolygon(:,2), 'b', 'FaceAlpha', 1);
    crpatch = patch(dummyPolygon(:,1), dummyPolygon(:,2),'y', 'FaceAlpha', 1, 'EdgeColor', 'none');
    kdot = plot(0, 0, '.k');
    wpatch = patch(dummyPolygon(:,1), dummyPolygon(:,2), 'w', 'FaceAlpha', 1);
    
    hLegend = legend([kdot crpatch wpatch rpatch bpatch], 'Agent', ...
        'Communication Range', 'Agent meeting the schedule', ...
        'Agent knows about dead agent', 'Agent''s new partition');
    
    set(hLegend, 'Position', [0.843 0.0249 .154 .212], 'Color', [.94 .94 .94], ...
        'EdgeColor', 'w');    
end

end