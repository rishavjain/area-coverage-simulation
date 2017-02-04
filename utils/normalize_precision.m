function [A] = normalize_precision(A, precision)

if ~exist('precision', 'var')
    precision = 10;
end

A = round(A*precision^precision)/precision^precision;

end