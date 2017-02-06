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
%         [initLocations, partitions, centroids, neighbors] = equi_area_partitioning(params, initLocations);
    
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

draw_info(params, time, 'initial'), drawnow;
draw_env(params, agents, 'initial'), drawnow;
draw_agents(params, agents, 'initial'), drawnow;

global poseLog
poseLog = cell(1, params.agents.num);

for i=1:params.agents.num
    poseLog{i} = [];
end

tic;
while time<params.sim.maxtime
    
    if ~ishandle(params.fig1handle)
        break;
    end
    
%     if time > 40
%         pause
%     end
    
    if toc > dT
        tic;
        
        agents = move_agents(params, agents, time);
        
        time = time + dT;
        
        draw_info(params, time, 'update');
        draw_agents(params, agents, 'update');
        drawnow;
        %
        %         if sim_agents_to_kill()
        %             for k=sim_agents_to_kill()
        %                 if find([agents.id] == k)
        %                     agents(k).isAlive = 0;
        %                     agents(k).position = [1000,0];
        %                 end
        %             end
        %             sim_agents_to_kill([]);
        %         end
        %
        %         speedChanged = sim_speedchanged();
        %         if speedChanged
        %             for iAgent = 1:length(agents)
        %                 agents(iAgent).speed = speedChanged;
        %             end
        %         end
        %         clear speedChanged iAgent;
        %
        %         draw_env(params, envRegions, partitions, agents, 'update');
        %         draw_agents(params, agents, envRegions, mapping, 'update');
        %         create_interactive(params, agents, time, dT, 'update');
        %         drawnow;
    end
end

finish(params)