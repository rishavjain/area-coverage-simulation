function draw_tree( params, graph, nodeLocations )

figure(params.fig1.num);
subplot(params.fig1.subplot(1), params.fig1.subplot(2), params.fig1.tree);

cla;
hold on;
axis equal;
grid on;
grid minor;
box on;

axis off;

title('Schedule Tree', 'FontSize', 16);

fill(params.env.boundary(:,1), params.env.boundary(:,2), 'white');
gplot(graph, nodeLocations);

for i=1:size(nodeLocations,1)
    nodeSize = sqrt(2*length(find(graph(i,:)==1))*50);
    scatter(nodeLocations(i,1), nodeLocations(i,2), (75 + 20*nodeSize), 'filled');
    text(nodeLocations(i,1), nodeLocations(i,2), num2str(i), 'FontSize', nodeSize*0.75, 'Color', 'white', ...
        'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');                
end

end