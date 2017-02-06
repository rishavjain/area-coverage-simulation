function [pos_, theta_, in_] = get_next_position_m1(params, agents, iAgent)

maxRetries = 5;
numAgents = params.agents.num;
dT = params.sim.timestep;

pos = agents(iAgent).position;
theta = agents(iAgent).theta;
in = agents(iAgent).m1.inPartition;
angularSpeed = agents(iAgent).angularSpeed;
centroid = agents(iAgent).centroid;

if in
    % random exploration
    dTheta = sign(rand) * (1.5*rand - 0.5) * angularSpeed;        
else
    % move towards partition
    dTheta = direction(centroid, pos) - theta;
    dTheta = sign(dTheta)*min(angularSpeed, abs(dTheta));
end

theta_ = wrapToPi(theta + dTheta);
pos_ = pos + agents(iAgent).speed*dT*[cos(theta_) sin(theta_)];

in_ = in_partition(pos_, agents(iAgent).partition);

if in && ~in_
    % agent moves outside partition, change direction only (towards centroid)
    dTheta = direction(centroid, pos) - theta;
    dTheta = sign(dTheta)*min(angularSpeed, abs(dTheta));
    theta_ = wrapToPi(theta + dTheta);
    
    pos_ = pos;
    in_ = in;
end

for i = setdiff(1:numAgents, iAgent)
    if norm(agents(i).position - pos_) <= (agents(i).radius + agents(iAgent).radius)
        % collision between i and iAgent
        numTries = 1;
        while norm(agents(i).position - pos_) <= (agents(i).radius + agents(iAgent).radius) && numTries < maxRetries
            dTheta = (2*rand - 1) * angularSpeed;
            dTheta = sign(dTheta)*min(angularSpeed, abs(dTheta));
            theta_ = wrapToPi(theta + dTheta);
            pos_ = pos + (agents(iAgent).speed/numTries)*dT*[cos(theta_) sin(theta_)];
            
            numTries = numTries + 1;
        end
        
        if numTries == maxRetries
            pos_ = pos;
        end            
        break;
    end
end

end