if length(dbstack) == 1 % script run directly
    params = config();
end

% initial agents location
if isfield(params.env, 'initLocations')
    initLocations = params.env.initLocations;
else
    logger(params, 2, 'random initial positions for agents');
    initLocations = random_init_locations(params);
end

while 1 % loop until a valid schedule tree is obtained
%     [initLocations, partitions, centroids, neighbors] = equi_area_partitioning(params, initLocations);
    
    load('tmp/partition-data.mat', 'initLocations', 'partitions', 'centroids', 'neighbors');

    draw_partitions(params, partitions, centroids, 'initial', 'Final Partitions');
    drawnow;

    scheduleTree = create_schedule_tree(params, centroids, neighbors);
    
    if ~isempty(scheduleTree)
        break;
    else
        logger(params, 3, 'repeating the procedure using new random positions');
        initLocations = random_init_locations(params);        
    end    
end

[ agents ] = initialize_agents( params, partitions, centroids );
[ agents ] = create_schedule( params, agents, scheduleTree );

time = 0;
dT = params.sim.timestep;

draw_info(params, time, 'initial');
drawnow;

draw_env(params, agents, 'initial');
draw_agents(params, agents, 'initial');
drawnow;