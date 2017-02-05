function [ agents ] = initialize_agents( params, partitions, centroids )

numAgents = params.agents.num;
bodyRadius = params.agents.bodyRadius;
speed = params.agents.speed;
commRange = params.agents.commrange;

[position, theta] = calculate_initial_pose(numAgents, bodyRadius);

agents = struct();
for i=1:numAgents
    agents(i).id = i;
    agents(i).isAlive = 1;
    
    agents(i).partition = partitions{i};
    agents(i).centroid = centroids(i,:);
    
    agents(i).radius = bodyRadius;
    agents(i).speed = speed;
    agents(i).commRange = commRange;
    
    agents(i).position = position{i};
    agents(i).theta = theta{i};    
end


end

function [position, theta] = calculate_initial_pose(numAgents, bodyRadius)
    n = numAgents;
    Theta = (2*pi/n) * [1:n];
    r = bodyRadius;

    R = 2*r/sin(pi/n);
    
    position = cell(1,n);
    theta = cell(1,n);
    
    for i = 1:n
        position{i} = [R*cos(Theta(i)), R*sin(Theta(i))];
        theta{i} = mod(pi + Theta(i), 2*pi);
    end
end
