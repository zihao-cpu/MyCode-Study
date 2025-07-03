function Scatter_Plot_zzh(X,Y,LineColor,LineWidth,DotsColor,n)
    new=X;
    mean_grad=Y;


    orig_rgb =DotsColor; 
    alpha = 0.3;
    lighter_rgb = (1 - alpha) * orig_rgb + alpha * [1 1 1];
    
    
    scatter(new,mean_grad,[],DotsColor,'filled');
    hold on;
    x=new';
    y=mean_grad';
    a=[x;y];
    a1=a(1,:);
    [a1,pos]=sort(a1);
    a2=a(2,pos);
    [p,s]=polyfit(a1,a2,n);
    y1=polyval(p,a1);
    % 95% confidence interval 计算：
    [yfit,dy] = polyconf(p,a1,s,'predopt','curve');
    % [yfit,dy] = polyconf(p,a1,s,'alpha',0.05);
    hold on
    %置信区域绘制
    fill([a1,fliplr(a1)],[yfit-dy,fliplr(yfit+dy)],lighter_rgb,'EdgeColor','none','FaceAlpha',0.5);
    

    p= polyfit(X, Y, n);
    X_fit = linspace(min(X), max(X), 200);
    Y_fit = polyval(p, X_fit);
    plot(X_fit, Y_fit, '-','Markersize',3.5,'LineWidth',LineWidth,'Color',LineColor);
%     p=polyfit(new,mean_grad,1);
%     yfit=polyval(p,new);
%     plot(new,yfit,'-','Markersize',3.5,'LineWidth',LineWidth,'Color',LineColor);


    set(gca,'FontName','Times New Roman','FontSize',14,'FontWeight','bold')
    set(gca,'LineWidth',2);
    set(gcf,'color','w')
end
