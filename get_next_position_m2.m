function [pos_, theta_, moveToMeeting_] = get_next_position_m2(params, agents, iAgent, time)

maxRetries = 5;
dT = params.sim.timestep;
timeMargin = params.sch.timeMargin;

nextMeetingTime = agents(iAgent).m2.nextMeetingTime;
nextMeetingPt = agents(iAgent).m2.nextMeetingPt;
centroid = agents(iAgent).centroid;
speed = agents(iAgent).speed;
angularSpeed = agents(iAgent).angularSpeed;
pos = agents(iAgent).position;
theta = agents(iAgent).theta;
moveToMeeting = agents(iAgent).m2.moveToMeeting;
partition = agents(iAgent).partition;
commRange = agents(iAgent).commRange;

if moveToMeeting == 0
    % explore random until the agent needs to move to the meeting pt
    dTheta = sign(rand) * (1.5*rand - 0.5) * angularSpeed;
    theta_ = wrapToPi(theta + dTheta);
    pos_ = pos + speed * dT * [cos(theta_) sin(theta_)];
    
    numTries = 0;
    while ~in_partition(pos_, partition) && numTries < maxRetries
        numTries = numTries + 1;
        dTheta = direction(centroid, pos) - theta;
        dTheta = sign(dTheta)*min(angularSpeed, abs(dTheta));
        theta_ = wrapToPi(theta + dTheta);
        pos_ = pos + (speed/numTries) * dT * [cos(theta_) sin(theta_)];                
    end
    
    if numTries == maxRetries
        pos_ = pos;
    end
    
    if norm(nextMeetingPt - pos_) > speed * (nextMeetingTime - time - timeMargin)
        moveToMeeting_ = 1;
    else
        moveToMeeting_ = 0;
    end
elseif moveToMeeting == 1
    % move towards the meeting pt
    dTheta = direction(nextMeetingPt, pos) - theta;
    dTheta = sign(dTheta)*min(angularSpeed, abs(dTheta));
    theta_ = wrapToPi(theta + dTheta);
    
    if ~isequalt(dTheta, 0)
        pos_ = pos;
    else
        pos_ = pos + speed*dT*[cos(theta_) sin(theta_)];
    end
    
    if norm(nextMeetingPt - pos_) < commRange
        moveToMeeting_ = 2;
    else
        moveToMeeting_ = 1;
    end
else
    % move within comm range of meeting pt
    numTries = 0;
    condition = 1;
    while condition
        numTries = numTries + 1;
        dTheta = sign(rand) * (1.5*rand - 0.5) * angularSpeed;
        theta_ = wrapToPi(theta + dTheta);
        pos_ = pos + (speed/numTries) * dT * [cos(theta_) sin(theta_)];                
        
        condition = (~in_partition(pos_, partition) || norm(nextMeetingPt - pos_) > commRange ...
            || norm(nextMeetingPt - pos_) < 0.3*commRange) && numTries < maxRetries;
    end
    
    if numTries == maxRetries
        pos_ = pos;
    end
    
    moveToMeeting_ = 2;
end

global poseLog
poseLog{iAgent} = [poseLog{iAgent}; time pos_, theta_, moveToMeeting_, nextMeetingTime, ...
    norm(nextMeetingPt - pos_), speed * (nextMeetingTime - time - timeMargin)]; 

if size(poseLog{iAgent},1)>1 && poseLog{iAgent}(end,5) == 1 && isequal(poseLog{iAgent}(end-1,2:4), poseLog{iAgent}(end,2:4))
    warning 'check';
end

end