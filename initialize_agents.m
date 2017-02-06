function [ agents ] = initialize_agents( params, partitions, centroids )

numAgents = params.agents.num;
bodyRadius = params.agents.bodyRadius;
speed = params.agents.speed;
angularSpeed = params.agents.angularSpeed;
commRange = params.agents.commRange;
setupTime = params.agents.setupTime;

[position, theta] = calculate_initial_pose(numAgents, bodyRadius);

agents = struct();
for i=1:numAgents
    agents(i).id = i;
    agents(i).isAlive = 1;
    
    agents(i).partition = partitions{i};
    agents(i).centroid = centroids(i,:);
    
    agents(i).radius = bodyRadius;
    agents(i).speed = speed;
    agents(i).angularSpeed = angularSpeed;
    agents(i).commRange = commRange;
    
    agents(i).position = position{i};
    agents(i).theta = theta{i};
    
    agents(i).mode = 1; % 1 -> move to partition, 2 -> normal meeting/exlporation, 3 -> dead agent detected
    agents(i).m1.setupTime = setupTime;
    agents(i).m1.inPartition = 0;
    
    agents(i).m2.nextMeeting = 0;
    agents(i).m2.nextMeetingPt = 0;
    agents(i).m2.nextMeetingTime = 0;
    agents(i).m2.moveToMeeting = 0;
    
    agents(i).level = 0;
    agents(i).meeting(1).pt = [];
    agents(i).meeting(1).neighbors = [];
    
    agents(i).totalMeetings = 0;
    agents(i).travelTimes = [];
    agents(i).totalTravelTime = 0;
end


end

function [position, theta] = calculate_initial_pose(numAgents, bodyRadius)
n = numAgents;
Theta = (2*pi/n) * [1:n]; %#ok<NBRAK>
r = bodyRadius;

R = 2*r/sin(pi/n);

position = cell(1,n);
theta = cell(1,n);

for i = 1:n
    position{i} = [R*cos(Theta(i)), R*sin(Theta(i))];
    theta{i} = wrapToPi(Theta(i));
end
end
