function [perf] = testPerform(A,B,C,s2,n,det)
    performance = 0;
    for i = 1:1:n
        [data] = wb1(0,A,B,C,s2);
        split = 0.8*length(data);
        data_train = data(1:split,:);
        data_test = data(split+1:end,:);
        SYSN4SID = n4sid(data_train,'best');
        [Y, fit, x] = compare(data_test,SYSN4SID);
        performance = performance + fit;
        close all
    end
    typ = {'Stochastic','Stochastic-Deterministic'};    
    title_plot = strcat(typ(det),': s2 = ',num2str(s2));  
    file_name = strcat(typ(det),num2str(s2));
    perf = performance/n;
    compare(data_test,SYSN4SID);
    title(title_plot)
    hold on
        grid
    hold off
    print(num2str(s2),'-dpng')
end

