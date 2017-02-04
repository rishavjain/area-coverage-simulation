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
    
    neighbors = zeros(numAgents);
    sum = 0;    
    newLocations = locations;
    
    for i=1:numAgents
        for j=setdiff(1:numAgents, i)
            if ~isempty(polyxpoly(partitions{i}(:,1), partitions{i}(:,2), partitions{j}(:,1), partitions{j}(:,2)))
                neighbors(i,j) = 1;
                
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

end