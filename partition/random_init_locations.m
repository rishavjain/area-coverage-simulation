function [initLocations] = random_init_locations(params)

envSize = params.env.size;
numAgents = params.agents.num;

% create unique coordinates for initial locations
loopCondition = 1;
while loopCondition
    initLocations = randi(round(0.95*0.5*[-envSize envSize]), numAgents, 2);
    
    loopCondition = length(unique(initLocations, 'rows')) < length(initLocations);
end

end