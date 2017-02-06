function [in, on] = in_partition(pt, partition)
[in, on] = inpolygon(pt(1), pt(2), partition(:,1), partition(:,2));
end