function maxErr = calcMaxErr(Vwvform,Vprev)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    maxErr = max(abs(Vwvform-Vprev), [], 'all');

end

