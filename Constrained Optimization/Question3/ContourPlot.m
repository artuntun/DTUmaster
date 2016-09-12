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

x66 = 1:0.005:2;
y66 = 0*x66;

y77 = 0:0.005:1.5;
x77 = 1+0*y77;

x88 = 1:0.005:1.4;
y88 = 0.5*x88+1;
hold on
    c1 = plot(x11,yc1,'LineWidth',2)
    c2 = plot(x22,yc2,'LineWidth',2)
    c3 = plot(x3,yc3,'LineWidth',2)
    c4 = plot(x44,y44,'LineWidth',2)   
    c5 = plot(x55,yc5,'LineWidth',2)
    
    i0 = plot(2,0,'r*','LineWidth',2)
    plot(x66,y66,'r','LineWidth',2)
    i1 = plot(1,0,'r*','LineWidth',2)
    plot(x77,y77,'r','LineWidth',2)
    i2 = plot(1,1.5,'r*','LineWidth',2)
    plot(x88,y88,'r','LineWidth',2)
    i3 = plot(1.4,1.7,'r*','LineWidth',2)
    
    legend([c1,c2,c3,c4,c5],'c1','c2','c3','c4','c5')
%     legend([i0,i1,i2,i3],'x0','x1','x2','x3')
    
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
