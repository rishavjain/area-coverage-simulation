function [graph] = create_schedule_tree(params, centroids, neighbors)

logger(params, 2, 'creating schedule tree');

numAgents = params.agents.num;
graphNodes = 1:numAgents;
graph = neighbors;

draw_tree(params, graph, centroids);
drawnow;

%%% getting the middle node (with max. neighbors)
finalizedNodes = zeros(1, numAgents);
selectedNode = 0;
maxNeighbors = 0;
selectedNeighbors = [];
    
for i=setdiff(graphNodes, find(finalizedNodes==1))
    currNeighbors = find(graph(i,:)==1);  % positions of 1's in a row
    currNeighbors = setdiff(currNeighbors, find(finalizedNodes==1));
    numNeighbors = length(currNeighbors);

    if numNeighbors > maxNeighbors
        maxNeighbors = numNeighbors;
        selectedNode = i;
        selectedNeighbors = currNeighbors;
    end    
end

%%% removing edges between neighbors of middle node
for i=selectedNeighbors
    for j=selectedNeighbors
        graph(i,j) = 0;
    end
end

%%% add the 'middle node' and its 'neighbors with degree 1' to nodes_added
finalizedNodes(selectedNode) = 1;

for i=selectedNeighbors
    if length(find(graph(i,:)==1))==1
        finalizedNodes(i) = 1;
        selectedNeighbors = selectedNeighbors(selectedNeighbors~=i);
    end
end


%%% computing the final graph iteratively
while length(find(finalizedNodes==1)) < numAgents
    
    %%% finding the next node in the neighors list connecting to max. new nodes
    selectedNode = 0;
    maxNeighbors = 0;
    newNeighbors = [];

    for i=selectedNeighbors
        currNeighbors = find(graph(i,:)==1);  % positions of 1's in a row
        currNeighbors = setdiff(currNeighbors, find(finalizedNodes==1));
        num_neighbors = length(currNeighbors);

        if num_neighbors > maxNeighbors
            maxNeighbors = num_neighbors;
            selectedNode = i;
            newNeighbors = currNeighbors;
        end
    end
    
    %%% updating the selected_neighbors list
    selectedNeighbors = [selectedNeighbors(selectedNeighbors~=selectedNode), newNeighbors];
    
    %%% removing the edges between the neighbors
    for i=selectedNeighbors
        for j=selectedNeighbors
            graph(i,j) = 0;
        end
    end
    
    %%% adding the 'selected node' and 'neighbors with degree 1' to nodes_added
    finalizedNodes(selectedNode) = 1;
            
    for i=selectedNeighbors
        if length(find(graph(i,:)==1))==1
            finalizedNodes(i) = 1;
            selectedNeighbors = selectedNeighbors(selectedNeighbors~=i);
        end
    end
    
    draw_tree(params, graph, centroids);
    drawnow;    
end

logger(params, 2, 'schedule tree created');

%%% check validity of schedule tree (every node connects to a leaf node)
for i = 1:numAgents
    currNeighbors = find(graph(i,:)==1);
    
    if length(currNeighbors) > 1
        for j = currNeighbors
            if length(find(graph(j,:)==1)) == 1
                leafNode = 1;
                break;
            end
        end
        if leafNode == 0
            logger(params, 3, 'schedule tree INVALID - every node does not connect to a leaf node');
            graph = [];
            break;
        end
    end
end