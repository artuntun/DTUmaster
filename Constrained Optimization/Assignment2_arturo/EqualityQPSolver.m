function [x, lambda] = EqualityQPSolver(H, g, A, b)
    [m, n] = size(A);
    KKT = [H A'; A zeros(m)];
    solution = KKT\[-g; b];
    
    lambda = solution(length(solution)-length(b)+1:length(solution));
    x = solution(1:length(solution)-length(b));
end


