function polygons = get_polygons(boundary, pts)

numPts = size(pts, 1);

[V, C] = voronoin(pts);

polygons = cell(1, numPts);
finalized = zeros(1, numPts);

% create polygon matrices from V and C
for i = 1:numPts
    c = C{i};
    polygons(i) = {zeros(length(c)+1, 2)};
    
    for j = 1:length(c)
        polygons{i}(j,:) = V(c(j),:);
    end
    polygons{i}(j+1,:) = V(c(1),:);
    
    polygons{i} = normalize_precision(polygons{i});
    
    % check if polygon contains Inf or collides with boundary, if not
    % polygon is finalized
    if isempty(find(polygons{i}==Inf, 1)) ...
        && isempty(polyxpoly(polygons{i}(:,1), polygons{i}(:,2), boundary(:,1), boundary(:,2)))
        
        finalized(i) = 1;
    end
end

% get the neighbor matrix
neighbors = zeros(numPts);

for i=find(finalized==0)
    for j=setdiff(1:numPts, i)
        if ~isempty(polyxpoly(polygons{i}(:,1), polygons{i}(:,2), polygons{j}(:,1), polygons{j}(:,2)))
            neighbors(i,j) = 1;
        end
    end
end
% neighbors = neighbors + neighbors';

if isempty(find(finalized==1, 1))
    neighbors = tril(ones(numPts), -1) + tril(ones(numPts), -1)';
end

% finalize the remaining polygons
for i=find(finalized==0)
    currPts = [pts(i,:);
        pts(neighbors(i,:)==1, :);
        boundary_reflected_pts(pts(i,:), boundary)];
    
    [V, C] = voronoin(currPts);
    
    c = C{1};
    polygons(i) = {zeros(length(c)+1, 2)};
    
    for j = 1:length(c)
        polygons{i}(j,:) = V(c(j),:);
    end
    polygons{i}(j+1,:) = V(c(1),:);
    
    polygons{i} = normalize_precision(polygons{i});   
end

end

function reflectedPts = boundary_reflected_pts(pt, boundary)

reflectedPts = zeros(4,2);

for i=1:length(boundary(:,1))-1
    theta = atan2(boundary(i+1,2)-boundary(i,2), boundary(i+1,1)-boundary(i,1));
    m = tan(theta);
    c = boundary(i,2) - m*boundary(i,1);
    
    dist = abs(pt(2) - m*pt(1) - c)/sqrt(m*m + 1);
    
    theta = atan2(boundary(i,1)-boundary(i+1,1), boundary(i+1,2)-boundary(i,2));
    reflectedPts(i,:) = [pt(1)+2*dist*cos(theta), pt(2)+2*dist*sin(theta)];
end

end