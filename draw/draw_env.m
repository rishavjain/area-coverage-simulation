function draw_env( params, agents, action )

persistent hPartitions hText hMeetingArrows

numAgents = params.agents.num;
figure(params.fig1.num);
subplot(params.fig1.subplot(1), params.fig1.subplot(2), params.fig1.env);

if strcmp(action, 'initial')
    hPartitions = zeros(1, numAgents);
    hText = zeros(1, numAgents);
    hMeetingArrows = cell(1, numAgents);
    
    for i = 1:numAgents
        partition = agents(i).partition;
        hPartitions(i) = fill(partition(:,1), partition(:,2), 'white');
        hText(i) = text(agents(i).centroid(1), agents(i).centroid(2), strcat(num2str(i)), ...
            'FontSize', 12, 'HorizontalAlignment', 'Center');

        numMeeting = 1;
        for meetingPt = {agents(i).meeting.pt}
            hMeetingArrows{i}(numMeeting,:) = draw_meeting_arrow(agents(i).meeting(numMeeting).pt, ...
                agents(i).centroid, numMeeting);
            numMeeting = numMeeting + 1;
        end
    end
end

end

function h = draw_meeting_arrow(pt1, pt2, num)
    theta = atan2(pt2(2)-pt1(2), pt2(1)-pt1(1));
    factor = 2;
    start_pt = [pt1(1)+factor*cos(theta) pt1(2)+factor*sin(theta)];
    end_pt = [pt1(1) pt1(2)];
    
    uv = (end_pt-start_pt);

    h(1) = quiver(start_pt(1), start_pt(2), uv(1), uv(2), 'b-');
    
    pt = [pt1(1) + 1.3 * factor * cos(theta), pt1(2) + 1.3 * factor * sin(theta)];
    h(2) = text(pt(1), pt(2), num2str(num), 'FontSize', 8, ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
end
