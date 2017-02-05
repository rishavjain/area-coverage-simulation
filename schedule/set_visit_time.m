function agents = set_visit_time(agents, iAgent, D)

if agents(iAgent).meeting(1).time == -1
    agents(iAgent).meeting(1).time = 0;
    
    for i=agents(iAgent).meeting(1).neighbors
            agents(i).meeting(1).time = agents(iAgent).meeting(1).time;
    end
end

numVisits = length(agents(iAgent).meeting);

agents(iAgent).travelTimes = (agents(iAgent).travelTimes / agents(iAgent).totalTravelTime) * D;
agents(iAgent).totalTravelTime = D;

for i=2:numVisits
    agents(iAgent).meeting(i).time = agents(iAgent).meeting(i-1).time(1) + agents(iAgent).travelTimes(i-1);
    
    for j=agents(iAgent).meeting(i).neighbors
        agents(j).meeting(1).time = agents(iAgent).meeting(i).time;
    end
end

end