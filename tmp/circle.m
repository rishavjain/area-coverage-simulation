if ishandle(1)
    close(1)
end

figure(1)
hold on
box on
axis([-50 50 -50 50]);

n= 15;
theta = (2*pi/n) * [1:n];
r = 5;

R = 1.2*r/sin(pi/n);

cTheta = linspace(0,2*pi,5);

for i = 1:n
    plot(R*cos(theta(i)), R*sin(theta(i)), '.');
    plot(R*cos(theta(i)) + r*cos(cTheta), R*sin(theta(i)) + r*sin(cTheta));
end


axis square
axis equal
grid on