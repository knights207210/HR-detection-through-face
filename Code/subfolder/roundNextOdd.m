function [ out ] = roundNextOdd( in )
%ROUNDNEXTODD
out = 2.*round((in+1)./2)-1;

end