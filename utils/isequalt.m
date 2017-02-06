function [ tf ] = isequalt( A, B )
% Determine value equality within tolerance

tolerance = 1e-5;

tf = abs(A-B) < tolerance;

end

