function [ agents ] = create_schedule( params, agents, scheduleTree )

numAgents = params.agents.num;

%%% finding the middle node in Graph_Matrix (=> index)
maxValue = 0;
index = 0;
for i=1:numAgents
    if length(find(scheduleTree(i,:)==1)) > maxValue
        maxValue = length(find(scheduleTree(i,:)==1));
        index = i;
    end
end

%%% setting level of middle node => 1
currLevel = 1;
agents(index).level = currLevel;
remainingAgents = setdiff(1:numAgents, index);  % remove middle node from the list

%%% setting the levels for all the nodes in the graph
while ~isempty(remainingAgents)
    %%% adding the nodes to index, whose neighbour has assigned level
    selectedAgents = [];
    for i=remainingAgents
        for j=find(scheduleTree(i,:)==1)
            if agents(j).level>0
                selectedAgents = [selectedAgents, i]; %#ok<AGROW>
            end
        end
    end
    
    %%% set incremented level for all the nodes in the index
    currLevel = currLevel + 1;
    for i=selectedAgents
        agents(i).level = currLevel;
    end
    
    %%% remove the nodes in index from the list
    remainingAgents = setdiff(remainingAgents, selectedAgents);
end

%%% add robots into nodes in increasing order of level
orderedAgents = [];
for i=1:currLevel
    orderedAgents = [orderedAgents, find([agents.level] == i)]; %#ok<AGROW>
end

%%% get points for visit for each node
for agent=orderedAgents
    [ agents ] = select_pts_of_visit(scheduleTree, agents, agent);
end

for i=1:numAgents
    for j=1:length(agents(i).meeting)
        agents(i).meeting(j).time = -1;
    end
end

D = max([agents.totalTravelTime]);
alpha = 0.8;

D = D + alpha*D;

for agent=orderedAgents
    agents = set_visit_time(agents, agent, D);
end

for i=1:numAgents
    for j=1:length(agents(i).meeting)
        for k=setdiff(1:numAgents, i)            
            for l=1:length(agents(k).meeting)
                if agents(i).meeting(j).time == agents(k).meeting(l).time ...
                        && isequal(agents(i).meeting(j).pt, agents(k).meeting(l).pt)
                    agents(i).meeting(j).neighbors = ...
                        setdiff(union(agents(i).meeting(j).neighbors, agents(k).meeting(l).neighbors), i);
                end
            end            
        end
    end
end

for i=1:numAgents
    if isempty(agents(i).travelTimes)
        agents(i).travelTimes = agents(i).totalTravelTime;
    end
    agents(i).totalMeetings = length(agents(i).travelTimes);
end

end