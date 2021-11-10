function maxErr = calcMaxErr(Vwvform,Vprev)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    %maxErr = max(abs(Vwvform-Vprev), [], 'all');
    maxErr = 0;
    N = size(Vprev,2);
    for i = 1:size(Vprev,1)
        scaling = max([.01, sqrt(1/N.*(sum(Vprev(i,:).^2)))]);
        err = max(abs(Vprev(i,:)-Vwvform(i,:)))/scaling;
        if scaling == 0 || err == Inf
            test = 2 + 2;
        end
        maxErr = max([err, maxErr]);
    end
end

