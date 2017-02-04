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

invalidScheduleTree = 1;
while invalidScheduleTree
    [initLocations, partitions, centroids, neighbors] = equi_area_partitioning(params, initLocations);

    draw_partitions(params, partitions, centroids, 'initial', 'Final Partitions');
    drawnow;

    scheduleTree = create_schedule_tree(params, centroids, neighbors);
    
    if ~isempty(scheduleTree)
        invalidScheduleTree = 0;
    else
        logger(params, 3, 'repeating the procedure using new random positions');
        initLocations = random_init_locations(params);        
    end    
end

create_schedule(params, partitions, graph);