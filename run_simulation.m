if length(dbstack) == 1 % script run directly
    params = config();
end

% initial agents location
if isfield(params.env, 'initLocations')
    initLocations = params.env.initLocations;
else
    initLocations = random_init_locations(params);
end

[partitions, neighbors] = equi_area_partitioning(params, initLocations);