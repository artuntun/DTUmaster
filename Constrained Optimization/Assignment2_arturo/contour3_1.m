x = -5:0.005:5;
y = -5:0.005:5;
[X,Y] = meshgrid(x,y);
F = (X.^2+Y-11).^2 + (X + Y.^2 - 7).^2;

v= [0:2:10 10:2:100 100:10:200];
[c,h] = contour(X,Y,F,50,'linewidth', 2);

colorbar
yc2 = (4*x)/10;
hold on
    i0 = plot(3.5844,-1.8481,'r*','LineWidth',2);
    i1 = plot(1,0,'r*','LineWidth',2);
    i2 = plot(-3.6546,2.7377,'r*','LineWidth',2);
    c1 = plot(x,yc2,'LineWidth',2);
hold off


% x11 = 0:0.005:2;
% yc1 = -4/4*x11+1;
% 
% 
% x66 = 1:0.005:2;
% y66 = 0*x66;
% 
% y77 = 0:0.005:1.5;
% x77 = 1+0*y77;
% 
% x88 = 1:0.005:1.4;
% y88 = 0.5*x88+1;
% hold on
%     c1 = plot(x11,yc1,'LineWidth',2)
%     
%     i0 = plot(2,0,'r*','LineWidth',2)
%     plot(x66,y66,'r','LineWidth',2)
%     i1 = plot(1,0,'r*','LineWidth',2)
%     plot(x77,y77,'r','LineWidth',2)
%     i2 = plot(1,1.5,'r*','LineWidth',2)
%     plot(x88,y88,'r','LineWidth',2)
%     i3 = plot(1.4,1.7,'r*','LineWidth',2)
%     
%     legend([c1,c2,c3,c4,c5],'c1','c2','c3','c4','c5')
% %     legend([i0,i1,i2,i3],'x0','x1','x2','x3')
%     
%     t=fill([2 4 4 2],[0 1 0 0],[0.7 0.7 0.7],'facealpha',0.5);
%     set(t,'EdgeColor','None');
%     q=fill([2 4 4 2],[4 4 1 2],[0.7 0.7 0.7],'facealpha',0.5);
%     set(q,'EdgeColor','None');
%     w=fill([0 2 2 0],[4 4 2 1],[0.7 0.7 0.7],'facealpha',0.5);
%     set(w,'EdgeColor','None');
%     e=fill([-1 0 0 -1],[4 4 0 0],[0.7 0.7 0.7],'facealpha',0.5);
%     set(e,'EdgeColor','None');
%     r=fill([-1 4 4 -1],[0 0 -1 -1],[0.7 0.7 0.7],'facealpha',0.5);
%     set(r,'EdgeColor','None');
% hold off
