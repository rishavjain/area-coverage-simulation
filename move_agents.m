function [ agents ] = move_agents(params, agents, time)

numAgents = params.agents.num;
dT = params.sim.timestep;
timeMargin = params.sch.timeMargin;

commHistory = {};

for i=1:numAgents
    
    if ~agents(i).isAlive
        continue;
    end
    
    if agents(i).mode == 1
        if time < agents(i).m1.setupTime
            % move towards the partition or random exploration
            [agents(i).position, agents(i).theta, agents(i).m1.inPartition] ...
                = get_next_position_m1(params, agents, i);
            
            % if agent has reached its partition, switch to mode 2
            if agents(i).m1.inPartition
                agents(i).m2.nextMeeting = 1;
                meeting = agents(i).meeting(agents(i).m2.nextMeeting);
                agents(i).m2.nextMeetingPt = meeting.pt;
                agents(i).m2.nextMeetingTime = agents(i).m1.setupTime + meeting.time;
                agents(i).m2.moveToMeeting = 0;
                
                logger(params, 2, sprintf('time: %.3f, agent %d switched to mode 2', time, i));
                
                % check if the agent can reach the meeting pt in time
                nextMeetingPt = agents(i).m2.nextMeetingPt;
                if norm(nextMeetingPt - agents(i).position) > agents(i).speed * (agents(i).m2.nextMeetingTime - time)
                    logger(params, 3, sprintf('time: %.3f, agent %d cannot reach the first meeting pt', time, i));
                    logger(params, 2, 'try increasing the initial setup time');
                    error('time: %.3f, agent %d cannot reach the first meeting pt', time, i);
                else
                    agents(i).mode = 2;
                end
            end
        else
            % agent could not switch to mode 2
            logger(params, 3, sprintf('time: %.3f, agent %d could not switch to mode 2', time, i));
            % try increasing the initial setup time
            logger(params, 2, 'try increasing the initial setup time');
            error('time: %.3f, agent %d could not switch to mode 2\ntry increasing the initial setup time', time, i);
        end
    elseif agents(i).mode == 2
        if time > agents(i).m2.nextMeetingTime
            % communicate and move to next meeting pt
            
            if norm(agents(i).m2.nextMeetingPt - agents(i).position) > agents(i).commRange
                warning('time: %.3f, agent %d failed to reach the meeting pt', time, i);
                logger(params, 3, sprintf('time: %.3f, agent %d failed to reach the meeting pt', time, i));
            end
            
            logger(params, 2, sprintf('time: %.3f, agent %d at meeting pt %d', i, agents(i).m2.nextMeetingPt));
            
            agents(i).m2.nextMeetingTime = time + agents(i).travelTimes(agents(i).m2.nextMeeting);
            agents(i).m2.nextMeeting = mod(agents(i).m2.nextMeeting, agents(i).totalMeetings) + 1;
            agents(i).m2.nextMeetingPt = agents(i).meeting(agents(i).m2.nextMeeting).pt;
            agents(i).m2.moveToMeeting = 0;
            
        elseif time > (agents(i).m2.nextMeetingTime - timeMargin)
            % if, all agents reach the meeting pt before time, set to next
            % meeting pt
            
            neighborAgents = agents(i).meeting(agents(i).m2.nextMeeting).neighbors;
            earlyMeeting = 1;
            
            for j = neighborAgents
                if norm(agents(i).position - agents(j).position) > agents(i).commRange + agents(j).commRange
                    earlyMeeting = 0;
                    break;
                end
            end
            
            if earlyMeeting
                logger(params, 2, sprintf('time: %.3f, agents %s meet', time, sprintf('%d ', [i neighborAgents])));
                
                for j = [i neighborAgents]
                    agents(j).m2.nextMeetingTime = agents(j).m2.nextMeetingTime + agents(j).travelTimes(agents(j).m2.nextMeeting);
                    agents(j).m2.nextMeeting = mod(agents(j).m2.nextMeeting, agents(j).totalMeetings) + 1;
                    agents(j).m2.nextMeetingPt = agents(j).meeting(agents(j).m2.nextMeeting).pt;
                    agents(j).m2.moveToMeeting = 0;
                end
            elseif time > agents(i).m2.nextMeetingTime
                logger(params, 2, sprintf('time: %.3f, agents %s failed to meet', time, sprintf('%d ', [i neighborAgents])));
                
                for j = [i neighborAgents]
                    if norm(agents(j).position - agents(j).m2.nextMeetingPt) > agents(j).commRange
                        warning('time: %.3f, agent %d failed to reach the meeting pt', time, j);
                        logger(params, 3, sprintf('time: %.3f, agent %d failed to reach the meeting pt', time, j));
                    end
                end
            end
        end
        
        [agents(i).position, agents(i).theta, agents(i).m2.moveToMeeting] ...
            = get_next_position_m2(params, agents, i, time);
        
    end
    
end

end



%     if robots(i).is_alive
%                 if TIME>50
%                     i;
%                 end
%
%         if TIME<robots(i).initial_setup_time
%             MODE = 1;
%         else
%             MODE = 2;
%         end
%
%         if MODE==1 % before first communication, random exploration
%         else
%             if robots(i).M2.distance<Step_Size
%                 if GRAPHIC == 1
%                     set(robots(i).H.polygon, 'FaceColor', 'w');
%                 end
%
%                 %%% communicate with dedicated neighbors
%                 [robots, commHistory] = Communicate3(i, ...
%                     1, ... % MODE = 1 for scheduled
%                     robots(i).M2.curr_index, robots, commHistory);
%
%                 if robots(i).trigger_schedule
%                     if robots(i).M3.remaining_visits == 0
%                         robots(i).initial_setup_time = robots(i).M3.time;
%
%                         robots(i).M1.start_pt = robots(i).position;
%                         robots(i).M1.end_pt = [0 0];
%
%
%
%                         %%% plug in new parameters
%                         index = find([Robots2.id]==robots(i).id);
%                         robots(i).location_id = Robots2(index).location_id;
%                         robots(i).polygon_area = Robots2(index).polygon_area;
%                         robots(i).polygon_perimeter = Robots2(index).polygon_perimeter;
%                         robots(i).polygon = Robots2(index).polygon;
%                         robots(i).centroid = Robots2(index).centroid;
%                         robots(i).neighbors = Robots2(index).neighbors;
%                         robots(i).level = Robots2(index).level;
%                         robots(i).visit = Robots2(index).visit;
%                         robots(i).travel_times = Robots2(index).travel_times;
%                         robots(i).total_travel_time = Robots2(index).total_travel_time;
%                         if isempty(robots(i).travel_times)
%                             robots(i).travel_times = robots(i).total_travel_time;
%                         end
%                         robots(i).total_visits = length(robots(i).visit);
%                         robots(i).M2.curr_index = robots(i).total_visits;
%                         robots(i).M2.next_index = rem(robots(i).M2.curr_index, robots(i).total_visits)+1;
%                         % % %                                 robots(i).M2.dest_arrow = MakeDestArrow(robots(i), FIG_NUM, PLOT_NUM);
%                         robots(i).M2.distance = 0;
%                         robots(i).nodes_died = [];
%                         robots(i).initial_setup_time = robots(i).initial_setup_time + (robots(i).visit(1).time/Speed);
%                         robots(i).M1.distance = Speed * (robots(i).initial_setup_time-TIME);
%                         robots(i).M1.end_pt = robots(i).visit(1).pt;
%                         robots(i).trigger_schedule = 0;
%                         robots(i).M3.remaining_visits = robots(i).total_visits-1;
%                         robots(i).M3.time = -1;
%                         clear index
%
%                         if GRAPHIC == 1
%                             set(robots(i).H.polygon, 'XData', robots(i).polygon(:,1));
%                             set(robots(i).H.polygon, 'YData', robots(i).polygon(:,2));
%                             set(robots(i).H.polygon, 'FaceColor', 'b');
%
%                             for j2 = 1:length(robots(i).H.arrows)
%                                 delete(robots(i).H.arrows(j2));
%                                 delete(robots(i).H.arrow_text(j2));
%                             end
%                             robots(i).H = rmfield(robots(i).H, 'arrows');
%                             robots(i).H = rmfield(robots(i).H, 'arrow_text');
%
%                             figure(1);
%                             subplot(2,3,[2 3 5 6]);
%                             for j2=1:length(robots(i).visit)
%                                 robots(i).H.arrows(j2) = DrawArrow(robots(i).visit(j2).pt, robots(i).centroid, j2);
%                                 robots(i).H.arrow_text(j2) = text(get(robots(i).H.arrows(j2), 'XData'), get(robots(i).H.arrows(j2), 'YData'), num2str(j2), 'FontSize', 7);
%                             end
%
%                             set(robots(i).H.text, 'Position', [robots(i).centroid(1), robots(i).centroid(2)]);
%                             %                                     set(robots(i).H.text, 'String', strcat(num2str(i),',',num2str(robots(i).initial_setup_time)));
%                             set(robots(i).H.text, 'String', strcat(num2str(i)));
%                         end
%
%                         clear j2;
%                         continue;
%                     else
%                         robots(i).M3.remaining_visits = robots(i).M3.remaining_visits-1;
%                     end
%                 end
%             end
%         end
%     end
