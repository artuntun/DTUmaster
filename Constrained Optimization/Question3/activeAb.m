function [currentA, currentb] = activeAb(activeSet, A, b)
    currentA = [];
    currentb = [];
    if isempty(activeSet) ==0
        for elem = activeSet
            currentA = [currentA; A(elem,:)];
            currentb = [currentb; b(elem,:)];
        end   
    end
end