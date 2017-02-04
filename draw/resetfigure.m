function [fig1handle] = resetfigure(params)

close all;

fig1Number = params.fig1.num;

fig1handle = figure(fig1Number);

set(fig1Number, 'Name', 'Area Coverage', 'NumberTitle', 'off');
clf;

%%% maximizing the window
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jFrame = get(fig1Number,'JavaFrame');
pause(0.0001);
set(jFrame,'Maximized',1);
warning('on','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');

set(gcf, 'color', 250*ones(1,3)/255);

end
