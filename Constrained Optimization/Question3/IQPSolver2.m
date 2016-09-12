function [x, lambda] = IQPSolver2(H, g, A, b, x0)
    
    %%Find Active Set given the intial point
    active = A*x0 -b;
    activeSet = [];
    for i=1:length(active);
        if active(i) == 0
            activeSet = [activeSet i];
        end
    end
    
    %%Currentpoint and A b matrix for active set
    currentX = x0;
    [currentA, currentb] = activeAb(activeSet,A,b); 
    
    iterations = 0;
    found = false;
   	while found == false
        iterations = iterations +1;
        [EQTx, EQTlambda] = EqualityQPSolver(H, g, currentA, currentb);

        feasiblity = A*EQTx <= b;
        if(feasiblity==1)
            if(EQTlambda>0 | EQTlambda ==[]) %%Optimal point
                currentX = EQTx;
                found = true;
            else %removing one constraint associated to a negative lambda
                for i=1:length(EQTlambda)
                    currentX = EQTx;
                    if EQTlambda(i) < 0;
                        activeSet(i) = [];
                        [currentA, currentb] = activeAb(activeSet,A,b);
                        break;
                    end
                end
            end
        else %continue minimizing direction until crashing to a constraint
            A_p=A*(EQTx-currentX);
            b_p=b-A*currentX;
            f = [-1]; 
            t = (linprog(f,A_p,b_p));
            currentX=(currentX + t*(EQTx-currentX));
            for i =1:length(feasiblity)
                if feasiblity(i)==0
                    activeSet =  [activeSet i];
                end
            end
            [currentA, currentb] = activeAb(activeSet,A,b);
        end
    end
    
    x = currentX;
    lambda = EQTlambda;
end

