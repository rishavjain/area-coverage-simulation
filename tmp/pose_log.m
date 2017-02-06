% agents(5).commRange

for i = 1:15
    if isempty(find(poseLog{i}(:,5) == 2, 1))
        fprintf('%d ', i);
    end
end

% iAgent = 10;
% entry = 371;
% 
% nextMeetingPt = agents(iAgent).m2.nextMeetingPt;
% pos_ = poseLog{iAgent}(entry,2:3);
% speed = agents(iAgent).speed;
% nextMeetingTime = agents(iAgent).m2.nextMeetingTime;
% time = poseLog{iAgent}(entry,1);
% timeMargin = params.sch.timeMargin;
% 
% norm(nextMeetingPt - pos_)
% 
% speed * (nextMeetingTime - time - timeMargin)

