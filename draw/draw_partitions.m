function draw_partitions( params, partitions, identifiers, action, plotTitle, additionalText)

numPartitions = params.agents.num;

figure(params.fig1.num);

if strcmp(action, 'initial')    
    subplot(params.fig1.subplot(1), params.fig1.subplot(2), params.fig1.partitions);
elseif strcmp(action, 'areaParitioning')    
    subplot(params.fig1.subplot(1), params.fig1.subplot(2), params.fig1.env);
end

cla;
hold on;
axis equal;
axis off;

axis(0.5*[-params.env.size params.env.size -params.env.size params.env.size])


title(plotTitle, 'FontSize', 16);

hPartitions = zeros(numPartitions);
hIdentifiers = zeros(numPartitions);

for iPartition = 1:numPartitions
    partition = partitions{iPartition};
    hPartitions(iPartition) = fill(partition(:,1), partition(:,2), 'white');
    
    if exist('identifiers', 'var')
        hIdentifiers(iPartition) = text(identifiers(iPartition,1), identifiers(iPartition,2), ...
            num2str(iPartition), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    end
end

if exist('additionalText', 'var')
    envSize = params.env.size*0.5;
    text(envSize, -envSize-5, additionalText, 'HorizontalAlignment', 'Right', ...
        'FontSize', 12, 'BackgroundColor', [.7 .9 .7], 'Margin', 7);
end

end