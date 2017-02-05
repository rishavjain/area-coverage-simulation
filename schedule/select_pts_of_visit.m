function [ agents ] = select_pts_of_visit( scheduleTree, agents, iAgent )

%%% initializing variables
partition = agents(iAgent).partition;
numPts = size(partition,1) - 1;

%%% getting neihgbors not yet assigned
remNeighbors = setdiff(find(scheduleTree(iAgent,:)==1), [agents(iAgent).meeting.neighbors]);

%%% check if all the neighbors are already assigned
if isempty(remNeighbors)
    return
end

%%% check if the node has been
if isempty(agents(iAgent).meeting(1).pt)
    startIndex = start_index(agents, partition, remNeighbors);
    
    agents(iAgent).meeting(1).pt = partition(startIndex,:);    
    agents(iAgent).meeting(1).neighbors = matching_neighbors(agents, agents(iAgent).meeting(1).pt, remNeighbors);
    
    for i=agents(iAgent).meeting(1).neighbors
        agents(i).meeting(1).pt = agents(iAgent).meeting(1).pt;
        agents(i).meeting(1).neighbors = iAgent;
    end
else
    startPt = agents(iAgent).meeting(1).pt;
    [~, startIndex] =  ismember(startPt, partition(1:end-1, :), 'rows');
end

remNeighbors = setdiff(remNeighbors, agents(iAgent).meeting(1).neighbors);
remPts = setdiff([rem(startIndex,numPts)+1:numPts 1:rem(startIndex,numPts)], startIndex);

i = 1;
iVisit = 1;

agents(iAgent).travelTimes = zeros(1,10);

while ~isempty(remNeighbors)
    j = mod(i, length(remPts))+1;
    
    n1 = matching_neighbors(agents, partition(remPts(i),:), remNeighbors);
    n2 = matching_neighbors(agents, partition(remPts(j),:), remNeighbors);
    
    flag = 0;
    
    if ~isempty(n1) && (isempty(intersect(n1,n2)) || length(n1)>=length(n2))
        flag = 1;
        n = n1;
    elseif ~isempty(n2)
        flag = 1;
        i = j;
        n = n2;
    else
        i=j;
    end
    
    if flag == 1
        agents(iAgent).travelTimes(iVisit) = pdist([agents(iAgent).meeting(iVisit).pt; 
            partition(remPts(i),:)], 'euclidean');
        
        iVisit = iVisit+1;
        
        agents(iAgent).meeting(iVisit).pt = partition(remPts(i),:);
        agents(iAgent).meeting(iVisit).neighbors = n;
        
        for j=agents(iAgent).meeting(iVisit).neighbors
            agents(j).meeting(1).pt = agents(iAgent).meeting(iVisit).pt;
            agents(j).meeting(1).neighbors = iAgent;
        end
        
        remPts = remPts(remPts ~= remPts(i));
        i = mod(i, length(remPts))+1;
    end
    
    remNeighbors = setdiff(remNeighbors, agents(iAgent).meeting(iVisit).neighbors);
end

agents(iAgent).travelTimes(iVisit) = pdist([agents(iAgent).meeting(iVisit).pt; 
    agents(iAgent).meeting(1).pt], 'euclidean');

agents(iAgent).travelTimes = agents(iAgent).travelTimes(1:iVisit)/agents(iAgent).speed;
agents(iAgent).totalTravelTime = sum(agents(iAgent).travelTimes);

end


function [ index ] = start_index( agents, partition, neighbors )
%%% start with the pt with maximum neighbors
    maxNeighbors = 0;
    index = 0;
    
    for i=1:size(partition,1)-1
        num = 0;
        for j=neighbors
            currPartition = agents(j).partition;
            
            if ismember(partition(i,:), currPartition, 'rows')
                num = num+1;
            end
        end
        
        if num>maxNeighbors
            maxNeighbors = num;
            index = i;
        end
    end
end

function matchedNeighbors = matching_neighbors(agents, pt, neighbors)

    matchedNeighbors = [];

    for i=neighbors
        if(ismember(pt, agents(i).partition, 'rows'))
            matchedNeighbors = [matchedNeighbors, i]; %#ok<AGROW>
        end
    end
end