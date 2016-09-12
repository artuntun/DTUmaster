x = -1:0.005:4;
y = -1:0.005:4;
[x1,x2] = meshgrid(x,y);
F = x1.^2 - x1.*2 + x2.^2 - x2.*5  ;

v= [0:2:10 10:2:100 100:10:200];
[c,h] = contour(x1,x2,F,50,'linewidth', 2);

colorbar

x11 = 0:0.005:2;
yc1 = 0.5*x11+1;
x22 = 2:0.005:4;
yc2 = -0.5*x22+3;
x3 = 2:0.005:4;
yc3 = 0.5*x3-1;
y44 = 0:0.005:1;
x44 = 0*y44;
x55 = 0:0.005:2;
yc5 = 0*x55;
hold on
%     plot(1,1,'*')
    plot(x11,yc1,'LineWidth',2)
    plot(x22,yc2,'LineWidth',2)
    plot(x3,yc3,'LineWidth',2)
    plot(x44,y44,'LineWidth',2)   
    plot(x55,yc5,'LineWidth',2)
    legend('f','c1','c2','c3','c4','c5')
    t=fill([2 4 4 2],[0 1 0 0],[0.7 0.7 0.7],'facealpha',0.5);
    set(t,'EdgeColor','None');
    q=fill([2 4 4 2],[4 4 1 2],[0.7 0.7 0.7],'facealpha',0.5);
    set(q,'EdgeColor','None');
    w=fill([0 2 2 0],[4 4 2 1],[0.7 0.7 0.7],'facealpha',0.5);
    set(w,'EdgeColor','None');
    e=fill([-1 0 0 -1],[4 4 0 0],[0.7 0.7 0.7],'facealpha',0.5);
    set(e,'EdgeColor','None');
    r=fill([-1 4 4 -1],[0 0 -1 -1],[0.7 0.7 0.7],'facealpha',0.5);
    set(r,'EdgeColor','None');
hold off
