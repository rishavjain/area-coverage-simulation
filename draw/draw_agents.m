function draw_env( params, agents, action )

persistent hAgents hCommRange hArrows CR_X CR_Y

numAgents = params.agents.num;
commRange = params.agents.commrange;

if isempty(CR_X)
    [CR_X, CR_Y] = pol2cart(linspace(0,2*pi,50), ones(1,50)*commRange);
end

figure(params.fig1.num);
subplot(params.fig1.subplot(1), params.fig1.subplot(2), params.fig1.env);

if strcmp(action, 'initial')
    hAgents = zeros(1, numAgents);
    hCommRange = zeros(1, numAgents);
    hArrows = zeros(1, numAgents);
    
    for i = 1:numAgents
        position = agents(i).position;
        
        hCommRange(i) = patch(CR_X + position(1), CR_Y + position(2), ...
            'yellow', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
        
        hAgents(i) = plot(position(:,1), position(:,2), '.k');
        
        [arrow_x, arrow_y] = pol2cart(agents(i).theta, agents(i).radius);
        hArrows(i) = plot(position(1) + [0 arrow_x], position(2) + [0 arrow_y], 'k-');
    end
end

end