load('I:\NC\nii\ASL_BOLD\data_stand\yeoindex17.mat');
fre=histcounts(yeoindex17);
endIndex=cumsum(fre);
startIndex=(endIndex-fre)+1;
for i=2:18
    start_pre=startIndex(i-1);
    end_pre=endIndex(i-1);
    startIndex(i)=end_pre+5+1;
    endIndex(i)=startIndex(i)+fre(i)-1;
end
clear end_pre
startIndex_new=startIndex;
endIndex_new=endIndex;
N_nodenew=endIndex(end);
load('I:\NC\nii\ASL_BOLD\data_stand\yeoindex17.mat');
fre=histcounts(yeoindex17);
endIndex=cumsum(fre);
startIndex=(endIndex-fre)+1;

r1 = 0.6;   % distance between origin and middle point of arc.
r2=0.7;

gap=0.3;
thetacir = -0.5*pi:pi/(N_nodenew-1):0.5*pi;        % degrees.
Xcir = cos(thetacir);                  % x coordinates.
Ycir = sin(thetacir);                  % y coordinates.
X1cir_right =r1*Xcir+gap;
Y1cir_right =r1*Ycir;
X2cir_right =r2*Xcir+gap;
Y2cir_right =r2*Ycir;
hold on
for i=1:18
    fill([X2cir_right(startIndex_new(i):endIndex_new(i)) fliplr(X1cir_right((startIndex_new(i):endIndex_new(i))))],...
        [Y2cir_right(startIndex_new(i):endIndex_new(i)) fliplr(Y1cir_right(startIndex_new(i):endIndex_new(i)))],yeoindex17_netcolor(i,:));
end

Xcir = -cos(thetacir);                  % x coordinates.
Ycir = sin(thetacir);  
X1cir_left =r1*Xcir-gap;
Y1cir_left =r1*Ycir;
X2cir_left =r2*Xcir-gap;
Y2cir_left =r2*Ycir;
hold on
yeoindex17_netcolor=[(othercolor('Spectral10',18))];

for i=1:18
    fill([X2cir_left(startIndex_new(i):endIndex_new(i)) fliplr(X1cir_left((startIndex_new(i):endIndex_new(i))))],...
        [Y2cir_left(startIndex_new(i):endIndex_new(i)) fliplr(Y1cir_left(startIndex_new(i):endIndex_new(i)))],yeoindex17_netcolor(i,:));
end
nodeIndex=[1:416];
for i=1:18
    
    nodeIndexnew(1,startIndex(i):endIndex(i))=startIndex(i):endIndex(i);
     nodeIndexnew(2,startIndex(i):endIndex(i))=startIndex_new(i):endIndex_new(i);
    
    
end


order=[1:18];
mask=yeoindex17;
t=[];
start = 1;
lines = 1;
for i = 1:length(order)
    add = find(mask==order(i));
    t = [t;add];
    start = start + length(add);
    lines(i+1) = start;
end

%%
data_reorder = T_fdr(t,t);
G=digraph(data_reorder);
edge=G.Edges.EndNodes;
edge_weights=G.Edges.Weight;

edge_weights(isnan(edge_weights))=0;
T_pos=edge_weights;
T_pos(edge_weights<=0)=0;
T_neg=edge_weights;
T_neg(edge_weights>=0)=0;

poscolor=(othercolor('YlOrRd9',100)); 
negcolor=(othercolor('YlGnBu9',100));


if all(T_neg==0)
       
    maxpos=max(T_pos);
    minpos=min(T_pos(T_pos~=0));
    
    if  maxpos==minpos
        idx_pos=100;
        pos_step=1;  
        resultcol=zeros(size(edge_weights,1),3);
        resultcol(edge_weights>0,:)=repmat(poscolor(round(idx_pos),:),sum(edge_weights>0),1);

    else
        resultcol=zeros(size(edge_weights,1),3);
        pos_step=((maxpos)-(minpos))/100;
        idx_pos=(maxpos-edge_weights(edge_weights>0))./pos_step;
        idx_pos(idx_pos<1)=1;
        idx_pos(idx_pos>100)=100;
        resultcol(edge_weights>0,:)=poscolor(round(idx_pos),:);
    end
elseif all(T_pos==0)
          
            minneg=min(T_neg);
            maxneg=max(T_neg(T_neg~=0));
           if  maxneg==minneg
               resultcol=zeros(size(edge_weights,1),3);
                idx_neg=1;
                neg_step=1;
                resultcol(edge_weights<0,:)=repmat(negcolor(round(idx_neg),:),sum(edge_weights<0),1);

           else
                resultcol=zeros(size(edge_weights,1),3);
                neg_step=((-minneg)-(-maxneg))/100;
                idx_neg=(-minneg-(-resultMap(resultMap<0)))./neg_step;
                idx_neg(idx_neg<1)=1;
                idx_neg(idx_neg>100)=100;
                resultcol(edge_weights<0,:)=negcolor(round(idx_neg),:);
           end
else
            maxpos=max(T_pos);
            minpos=min(T_pos(T_pos~=0));
            minneg=min(T_neg);
            maxneg=max(T_neg(T_neg~=0));
            resultcol=zeros(size(edge_weights,1),3);
            if  maxpos==minpos
                idx_pos=100;
                pos_step=1;
                resultcol(edge_weights>0,:)=repmat(poscolor(round(idx_pos),:),sum(edge_weights>0),1);

            else
                pos_step=((maxpos)-(minpos))/100;
                idx_pos=(maxpos-edge_weights(edge_weights>0))./pos_step;
                idx_pos(idx_pos<1)=1;
                idx_pos(idx_pos>100)=100;
                resultcol(edge_weights>0,:)=poscolor(round(idx_pos),:);
            end

           if  maxneg==minneg
                idx_neg=1;
                neg_step=1;
                resultcol(edge_weights<0,:)=repmat(negcolor(round(idx_neg),:),sum(edge_weights<0),1);
           else
                neg_step=((-minneg)-(-maxneg))/100;
                idx_neg=(-minneg-(-edge_weights(edge_weights<0)))./neg_step;
                idx_neg(idx_neg<1)=1;
                idx_neg(idx_neg>100)=100;
                resultcol(edge_weights<0,:)=negcolor(round(idx_neg),:);
           end
end  
%%


for i=1:size(edge,1)
    
    u = [X1cir_right(nodeIndexnew(2,edge(i,1)));Y1cir_right(nodeIndexnew(2,edge(i,1)))];
    v = [X1cir_left(nodeIndexnew(2,edge(i,2)));Y1cir_left(nodeIndexnew(2,edge(i,2)))];
    x0 = -(u(2)-v(2))/(u(1)*v(2)-u(2)*v(1));
    y0 =  (u(1)-v(1))/(u(1)*v(2)-u(2)*v(1)); 

% %     r=sqrt((x0-u(1))^2+(y0-u(2))^2);
%     r=sqrt((x0-v(1))^2+(y0-v(2))^2);
% %      r=sqrt((x0)^2+(y0)^2-1.6);
%     thetaLim(1) = atan2(u(2)-y0,u(1)-x0);
%     thetaLim(2) = atan2(v(2)-y0,v(1)-x0);
%     if u(1) >= 0 && v(1) >= 0
%         % ensure the arc is within the unit disk
%         theta = [linspace(max(thetaLim),pi,50),...
%         linspace(-pi,min(thetaLim),50)].';
%     else
%         theta = linspace(thetaLim(1),thetaLim(2)).';
%     end
%     line(...
%         r*cos(theta)+x0,...
%         r*sin(theta)+y0,'color','k')     
% 
    M = [(u(1) + v(1)) / 2, (u(2) + v(2)) / 2];
    dx = v(1) - u(1);
    dy = v(2) - u(2);
    d = 0.2 * sqrt(dx^2 + dy^2); 
    n = [-dy, dx] / sqrt(dx^2 + dy^2);

    if edge(i,1)<=208 & edge(i,2)<=208
        d = 0.2 * sqrt(dx^2 + dy^2); 
            C = M - d * n;   
            t = linspace(0, 1, 100);
            % 二次贝塞尔曲线方程
            P1 = (1 - t)'.^2 * u(1) + 2 * (1 - t)' .* t' .* C(1) + t.^2' * v(1);
            P2 = (1 - t)'.^2 * u(2) + 2 * (1 - t)' .* t' .* C(2) + t.^2' * v(2);
            hold on;
            plot(P1, P2, 'LineWidth', 2,'color',resultcol(i,:)); % 贝塞尔曲线
    

    elseif edge(i,1)>208 & edge(i,2)>208
        d = 0.2 * sqrt(dx^2 + dy^2); 
             C = M + d * n;
             t = linspace(0, 1, 100);
             % 二次贝塞尔曲线方程
             P1 = (1 - t)'.^2 * u(1) + 2 * (1 - t)' .* t' .* C(1) + t.^2' * v(1);
             P2 = (1 - t)'.^2 * u(2) + 2 * (1 - t)' .* t' .* C(2) + t.^2' * v(2);
             hold on;
             plot(P1, P2, 'b-', 'LineWidth', 2,'color',resultcol(i,:)); % 贝塞尔曲线
     
     
    elseif edge(i,1)<208 & edge(i,2)>208
        d = 0.1 * sqrt(dx^2 + dy^2); 
        C = M + d * n;
        t = linspace(0, 1, 100);
        % 二次贝塞尔曲线方程
        P1 = (1 - t)'.^2 * u(1) + 2 * (1 - t)' .* t' .* C(1) + t.^2' * v(1);
        P2 = (1 - t)'.^2 * u(2) + 2 * (1 - t)' .* t' .* C(2) + t.^2' * v(2);
        hold on;
        plot(P1, P2, 'r-', 'LineWidth', 2,'color',resultcol(i,:)); % 贝塞尔曲线
    else edge(i,1)<208 & edge(i,2)<208
        d = 0.1 * sqrt(dx^2 + dy^2); 
            C = M + d * n;
            t = linspace(0, 1, 100);
            % 二次贝塞尔曲线方程
            P1 = (1 - t)'.^2 * u(1) + 2 * (1 - t)' .* t' .* C(1) + t.^2' * v(1);
            P2 = (1 - t)'.^2 * u(2) + 2 * (1 - t)' .* t' .* C(2) + t.^2' * v(2);
            hold on;
            plot(P1, P2, 'b-', 'LineWidth', 2,'color',resultcol(i,:)); % 贝塞尔曲线
    end

end 
NodenameFontSize=10;
name={'VisC','VisP','SomMotA','SomMotB','DorsAttnA','DorsAttnB','SalVentAttnA','SalVentAttnB','LimbicA','LimbicB','ContA','ContB','ContC','DefaultA','DefaultB','DefaultC','TempPar','Subcortex'};
for i=1:18
    middleIndex=nodeIndexnew(2,startIndex(i)+floor((endIndex(i)-startIndex(i))/2));
        rot = 180*thetacir(i)/pi - 180;
   text(sqrt(1.5)*X2cir_left(middleIndex),sqrt(1.5)*Y2cir_left(middleIndex),name{i},'Fontsize',NodenameFontSize,...
                        'color',yeoindex17_netcolor(i,:),'HorizontalAlignment','left','FontWeight','bold','FontName','Times New Roman');
 
end

for i=1:18
    middleIndex=nodeIndexnew(2,startIndex(i)+floor((endIndex(i)-startIndex(i))/2));
        rot = 180*thetacir(i)/pi;
   text(sqrt(1.5)*X2cir_right(middleIndex),sqrt(1.5)*Y2cir_right(middleIndex),name{i},'Fontsize',NodenameFontSize,...
                        'color',yeoindex17_netcolor(i,:),'HorizontalAlignment','right','FontWeight','bold','FontName','Times New Roman');

end


set(gca,'color','k')
set(gcf,'color','k')
axis equal;
axis off;
function draw_colorbar(flagecb,h,T,poscolor,negcolor)
    switch flagecb
        case 1   
            
                 h.cb(1,1)=axes('Position',[0.95,0.6,0.01,0.2]);
                    A_range = [0 1];
                    maxpos=max(edge_weights);
                    minpos=min(edge_weights(edge_weights~=0));
                    
%                     poscolor=(othercolor('YlOrRd9',100));

                   if  maxpos==minpos
                         H_range = [0 maxpos];
                        colrange=linspace(0,maxpos,100);
                         x = linspace(A_range(1), A_range(2), 100); 
                        % x represents the range in alpha (abs(t-stats))
                        y = linspace(H_range(1), H_range(2), 100);
                        % y represents the range in hue (beta weight difference)
                        [X,Y] = meshgrid(x,y); % Transform into a 2D matrix

                        imagesc(x,y,Y,'Parent',h.cb(1,1));
                        colormap(h.cb(1,1),flipud(poscolor));

                        set(h.cb(1,1), 'YAxisLocation', 'right');
                        view(h.cb(1,1),[0,-90]);
                        set(h.cb(1,1), 'Xcolor', 'k', 'Ycolor', 'k','XTickLabel','','XTick',[],'YTick',[0 maxpos],'FontSize',20,'FontName','Times New Roman','FontWeight','bold');
                       
                   else
                         H_range = [minpos maxpos];
                        colrange=linspace(minpos,maxpos,100);
                           x = linspace(A_range(1), A_range(2), 100); 
                            % x represents the range in alpha (abs(t-stats))
                            y = linspace(H_range(1), H_range(2), 100);
                            % y represents the range in hue (beta weight difference)
                            [X,Y] = meshgrid(x,y); % Transform into a 2D matrix

                            imagesc(x,y,Y,'Parent',h.cb(1,1));
                            colormap(h.cb(1,1),flipud(poscolor));

                            set(h.cb(1,1), 'YAxisLocation', 'right');
                            view(h.cb(1,1),[0,-90]);
                        set(h.cb(1,1), 'Xcolor', 'k', 'Ycolor', 'k','XTickLabel','','XTick',[],'YTick',[minpos maxpos],'FontSize',20,'FontName','Times New Roman','FontWeight','bold');
                    end
            
        case 2
                   h.cb(1,1)=axes('Position',[0.95,0.6,0.01,0.2]);
                    A_range = [0 1];
                    maxneg=max(edge_weights);
                    minneg=min(edge_weights(edge_weights~=0));                
%                    negcolor=(othercolor('YlGnBu9',100));
                    if minneg==maxneg
                        H_range = [minneg 0];
                          colrange=linspace(minneg,0,100);
                            x = linspace(A_range(1), A_range(2), 100); 
                            % x represents the range in alpha (abs(t-stats))
                            y = linspace(H_range(1), H_range(2), 100);
                            % y represents the range in hue (beta weight difference)
                            [X,Y] = meshgrid(x,y); % Transform into a 2D matrix

                            imagesc(x,y,Y,'Parent',h.cb(1,1));
                            colormap(h.cb(1,1),negcolor)
                            set(h.cb(1,1), 'Xcolor', 'k', 'Ycolor', 'k','XTickLabel','','XTick',[],'YTick',[minneg 0],'FontSize',20,'FontName','Times New Roman','FontWeight','bold');
                            set(h.cb(1,1), 'YAxisLocation', 'right');
                            view(h.cb(1,1),[0,-90]);
                    else
                             H_range = [minneg maxneg];
                            colrange=linspace(minneg,maxneg,100);
                            x = linspace(A_range(1), A_range(2), 100); 
                            % x represents the range in alpha (abs(t-stats))
                            y = linspace(H_range(1), H_range(2), 100);
                            % y represents the range in hue (beta weight difference)
                            [X,Y] = meshgrid(x,y); % Transform into a 2D matrix

                            imagesc(x,y,Y,'Parent',h.cb(1,1));
                            colormap(h.cb(1,1),negcolor)
                            set(h.cb(1,1), 'Xcolor', 'k', 'Ycolor', 'k','XTickLabel','','XTick',[],'YTick',[minneg maxneg],'FontSize',20,'FontName','Times New Roman','FontWeight','bold');
                            set(h.cb(1,1), 'YAxisLocation', 'right');
                            view(h.cb(1,1),[0,-90]);
                    end
            
        case 3
            
                    h.cb(1,1)=axes('Position',[0.93,0.6,0.01,0.2]);
                    A_range = [0 1];
                    T_pos=edge_weights;
                    T_pos(edge_weights<=0)=0;
                    T_neg=edge_weights;
                    T_neg(edge_weights>=0)=0;
                    maxpos=max(T_pos);
                    minpos=min(T_pos(T_pos~=0));
                    minneg=min(T_neg);
                    maxneg=max(T_neg(T_neg~=0));
%                     poscolor=(othercolor('YlOrRd9',100));
%                    negcolor=(othercolor('YlGnBu9',100));
                   if  maxpos==minpos
                         H_range = [0 maxpos];
                        colrange=linspace(0,maxpos,100);
                         x = linspace(A_range(1), A_range(2), 100); 
                        % x represents the range in alpha (abs(t-stats))
                        y = linspace(H_range(1), H_range(2), 100);
                        % y represents the range in hue (beta weight difference)
                        [X,Y] = meshgrid(x,y); % Transform into a 2D matrix

                        imagesc(x,y,Y,'Parent',h.cb(1,1));
                        colormap(h.cb(1,1),flipud(poscolor));

                        set(h.cb(1,1), 'YAxisLocation', 'right');
                        view(h.cb(1,1),[0,-90]);
                        set(h.cb(1,1), 'Xcolor', 'w', 'Ycolor', 'w','XTickLabel','','XTick',[],'YTick',[0 maxpos],'FontSize',20,'FontName','Times New Roman','FontWeight','bold');
                       
                   else
                         H_range = [minpos maxpos];
                        colrange=linspace(minpos,maxpos,100);
                           x = linspace(A_range(1), A_range(2), 100); 
                            % x represents the range in alpha (abs(t-stats))
                            y = linspace(H_range(1), H_range(2), 100);
                            % y represents the range in hue (beta weight difference)
                            [X,Y] = meshgrid(x,y); % Transform into a 2D matrix

                            imagesc(x,y,Y,'Parent',h.cb(1,1));

                            colormap(h.cb(1,1),flipud(poscolor));
                            set(h.cb(1,1), 'YAxisLocation', 'right');
                            view(h.cb(1,1),[0,-90]);
                        set(h.cb(1,1), 'Xcolor', 'w', 'Ycolor', 'w','XTickLabel','','XTick',[],'YTick',[minpos maxpos],'FontSize',20,'FontName','Times New Roman','FontWeight','bold');
                    end
                    
              
                    h.cb(1,2)=axes('Position',[0.93,0.3,0.01,0.2]);
                    A_range = [0 1];
                    if minneg==maxneg
                        H_range = [minneg 0];
                          colrange=linspace(minneg,0,100);
                            x = linspace(A_range(1), A_range(2), 100); 
                            % x represents the range in alpha (abs(t-stats))
                            y = linspace(H_range(1), H_range(2), 100);
                            % y represents the range in hue (beta weight difference)
                            [X,Y] = meshgrid(x,y); % Transform into a 2D matrix

                            imagesc(x,y,Y,'Parent',h.cb(1,2));
                            colormap(h.cb(1,2),negcolor)
                            set(h.cb(1,2), 'Xcolor', 'w', 'Ycolor', 'w','XTickLabel','','XTick',[],'YTick',[minneg 0],'FontSize',20,'FontName','Times New Roman','FontWeight','bold');
                            set(h.cb(1,2), 'YAxisLocation', 'right');
                            view(h.cb(1,2),[0,-90]);
                    else
                             H_range = [minneg maxneg];
                            colrange=linspace(minneg,maxneg,100);
                            x = linspace(A_range(1), A_range(2), 100); 
                            % x represents the range in alpha (abs(t-stats))
                            y = linspace(H_range(1), H_range(2), 100);
                            % y represents the range in hue (beta weight difference)
                            [X,Y] = meshgrid(x,y); % Transform into a 2D matrix

                            imagesc(x,y,Y,'Parent',h.cb(1,2));
                            colormap(h.cb(1,2),negcolor)
                            set(h.cb(1,2), 'Xcolor', 'w', 'Ycolor', 'w','XTickLabel','','XTick',[],'YTick',[minneg maxneg],'FontSize',20,'FontName','Times New Roman','FontWeight','bold');
                            set(h.cb(1,2), 'YAxisLocation', 'right');
                            view(h.cb(1,2),[0,-90]);
                          
                    end
            
            
    end
end
