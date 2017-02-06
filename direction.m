function [ theta ] = direction(destination, source)
theta = atan2(destination(2)-source(2), destination(1)-source(1));
end