ibfunction [feasible] = checkFeasibility(x,A, b)
    feasible = true;
    u = A*x <= b;
    for i=1:length(u)
        if u(i) < 1
            feasible = false;
        end 
    end
end