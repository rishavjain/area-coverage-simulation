function [partitions, neighbors] = equi_area_partitioning(params, initLocations)

numAgents = params.agents.num;
threshold = params.part.threshold;
envSize = params.env.size;
boundary = params.env.boundary;
factor = params.part.factor;

locations = initLocations;
initialParitions = 1;

sum = threshold+1;
while sum > threshold
    partitions = get_polygons(boundary, locations);
    
    if initialParitions
        % draw initial paritions in partitions
        draw_partitions(params, partitions, locations, 'initial');
        drawnow;
        initialParitions = 0;
    end
        
    sum = 0;    
    newLocations = locations;
    
    for i=1:numAgents
        for j=setdiff(1:numAgents, i)
            if ~isempty(polyxpoly(partitions{i}(:,1), partitions{i}(:,2), partitions{j}(:,1), partitions{j}(:,2)))
                iArea = polyarea(partitions{i}(:,1), partitions{i}(:,2));
                jArea = polyarea(partitions{j}(:,1), partitions{j}(:,2));
                
                sumDiff = abs(iArea-jArea);
                sum = sum + sumDiff;
                                
                magnitude = sumDiff/factor;
                
                theta = atan2(locations(j,2)-locations(i,2), locations(j,1)-locations(i,1));
                if iArea<jArea
                    newLocations(i,:) = [newLocations(i,1)+magnitude*cos(theta) newLocations(i,2)+magnitude*sin(theta)];
                elseif iArea>jArea
                    newLocations(i,:) = [newLocations(i,1)-magnitude*cos(theta) newLocations(i,2)-magnitude*sin(theta)];
                end            
            end
        end
        
        %% If ROBOT position gets drifted outside the SPACE, move it to CENTROID
        [in, on] = inpolygon(newLocations(i,1), newLocations(i,2), boundary(:,1), boundary(:,2));
        
        if in == 0 || on == 1
            centroid = mean(partitions{i}(1:length(partitions{i}(:,1))-1,:));
            newLocations(i,:) = centroid;
        end
    end
    
    draw_partitions(params, partitions, locations, 'areaParitioning', ...
        sprintf('Threshold : %f\nSum : %f',threshold,sum));
    drawnow;

    if sum > threshold
        locations = newLocations;
    end
end

%%% Collapsing Close Points
allPts = [];
avgPerimeter = 0;

for i=1:numAgents
    allPts = [allPts; partitions{i}(1:end-1, :)];
    [~, ~ ,~ , perimeter] = polygeom(partitions{i}(1:end-1, 1), partitions{i}(1:end-1, 2));
    avgPerimeter = avgPerimeter + perimeter;
end

allPts = unique(allPts, 'rows');
avgPerimeter = avgPerimeter/numAgents;

for i=1:size(allPts,1)-1
    for j=i+1:size(allPts,1)
        if pdist([allPts(i,:); allPts(j,:)], 'euclidean') < 0.02*avgPerimeter
            if ~isempty(find(ismember(boundary, allPts(i,:), 'rows')==1,1))
                newPt = allPts(i,:);
            elseif ~isempty(find(ismember(boundary, allPts(j,:), 'rows')==1,1))
                newPt = allPts(j,:);
            elseif polyxpoly(boundary(:,1), boundary(:,2), allPts(i,1), allPts(i,2))
                newPt = allPts(i,:);
            elseif polyxpoly(boundary(:,1), boundary(:,2), allPts(j,1), allPts(j,2))
                newPt = allPts(j,:);
            else
                newPt = mean([allPts(i,:); allPts(j,:)]);
            end
            
            for k=1:numAgents
                ii1 = find(ismember(partitions{k}, allPts(i,:), 'rows')==1);
                for l=ii1'
                    partitions{k}(l,:) = newPt;
                end
                ii1 = find(ismember(partitions{k}, allPts(j,:), 'rows')==1);
                for l=ii1'
                    partitions{k}(l,:) = newPt;
                end
                partitions{k} = [unique(partitions{k}, 'rows', 'stable'); partitions{k}(1,:)];
            end
            
            allPts(i,:) = newPt;
            allPts(j,:) = newPt;
        end
    end
end


neighbors = zeros(numAgents);

for i=1:numAgents
    for j=(i+1):numAgents
        if ~isempty(polyxpoly(partitions{i}(:,1), partitions{i}(:,2), partitions{j}(:,1), partitions{j}(:,2)))
            neighbors(i,j) = 1;
        end
    end
end
neighbors = neighbors + neighbors';

draw_partitions(params, partitions, locations, 'areaParitioning', ...
        sprintf('Threshold : %f\nSum : %f',threshold,sum));
drawnow;
    
end