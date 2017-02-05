function [ params ] = config()

params = {};

%% agents parameters
params.agents.num = 15;
params.agents.bodyRadius = 0.5;
params.agents.speed = 10;
params.agents.commrange = 2;

%% environment parameters
params.env.size = 100;
% params.env.initLocations = [];  % initial locations for agents (optional), otherwise random locations

% params.env.initLocations = [-17,32;17,26;-6,-32];
params.env.initLocations = [29,0;38,-27;-19,42;-13,-1;-37,-12;-2,-32;-8,41;-43,-36;43,11;-24,46;-36,-26;31,14;-14,-46;-46,-22;-13,-15];
%% partitioning parameters
params.part.threshold = 0.00025 * (params.env.size*params.env.size) * params.agents.num;
params.part.threshold = 0.0025 * (params.env.size*params.env.size) * params.agents.num;
params.part.factor = (0.25 * params.env.size*params.env.size) / params.agents.num;

%% simulation parameters
params.sim.maxtime = 6000;         % maximum time for simulation
params.sim.timestep = 0.05;     % time step

params.sim.ui.areaPartitioning = 1;

%% figure parameters
params.fig1.num = 1000;
params.fig1.subplot = [2 3];
params.fig1.partitions = 1;
params.fig1.tree = 4;
params.fig1.env = [2 3 5 6];
params.fig1.envAxisPadding = 10;

%% log parameters
% params.log = {};
params.log.fileId = 1; % 1 for screen output
params.log.level = 1;

%%
%%
%% code (DO NOT MODIFY)
addpath(genpath('.'));
rmpath(genpath('.git'));

if isfield(params.env, 'initLocations')
    if ~isequal( size(params.env.initLocations), [params.agents.num 2] )
        error('incorrect size: params.env.initLocations, should be of size (numAgents, 2)');
    end
end

params.env.boundary = [-params.env.size -params.env.size;
    params.env.size -params.env.size;
    params.env.size params.env.size;
    -params.env.size params.env.size;
    -params.env.size -params.env.size]*0.5;

params.openFileIds = [];

params.fig1handle = resetfigure(params);

end
