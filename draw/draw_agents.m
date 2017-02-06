function draw_agents( params, agents, action )

persistent hAgents hCommRange hArrows CR_X CR_Y

numAgents = params.agents.num;
commRange = params.agents.commRange;

figure(params.fig1.num);
subplot(params.fig1.subplot(1), params.fig1.subplot(2), params.fig1.env);

if strcmp(action, 'initial')
    [CR_X, CR_Y] = pol2cart(linspace(0,2*pi,50), ones(1,50)*commRange);
    
    hAgents = zeros(1, numAgents);
    hCommRange = zeros(1, numAgents);
    hArrows = zeros(1, numAgents);
    
    for i = 1:numAgents
        position = agents(i).position;
        
        hCommRange(i) = patch(CR_X + position(1), CR_Y + position(2), ...
            'yellow', 'FaceAlpha', 0.5, 'EdgeColor', 'none');
        
        hAgents(i) = plot(position(1), position(2), '.k');
        
        [arrow_x, arrow_y] = pol2cart(agents(i).theta, agents(i).radius);
        hArrows(i) = plot(position(1) + [0 arrow_x], position(2) + [0 arrow_y], 'k-');
    end
elseif strcmp(action, 'update')
    for i = 1:numAgents
        position = agents(i).position;
        
        set(hCommRange(i), 'XData', CR_X + position(1), 'YData', CR_Y + position(2));
        set(hAgents(i), 'XData', position(1), 'YData', position(2));
        
        [arrow_x, arrow_y] = pol2cart(agents(i).theta, agents(i).radius);
        set(hArrows(i), 'XData', position(1) + [0 arrow_x], 'YData', position(2) + [0 arrow_y]);
    end    
end

end