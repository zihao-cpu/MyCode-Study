function plot_matrix(data_mat,net_label,net_order,half_flag)
% This function is used to plot the nodal-level matrix.
% input:
%       data_mat:  N*N matrix;
%       net_label: N*1 label, the value range from 1 to M, 
%                  M is the number of networks;
%       net_order: M*1, the order of networks, e,g., [1,2,3.....,M];
%       half_flag: 0 [default], plot the full matrix;
%                  1 ,plot the lower triangle of the matrix.
% edited by Zihao Zheng
% plot the orignal data matrix without reorder
if ~exist('net_label','var')
    
    data_reorder = data_mat;
    data_dim = size(data_reorder);
%     data_reorder(1:data_dim(1)+1:end) = max(data_reorder(:));%对角线设置为最大值
    figure;
    imagesc(data_reorder);

% plot the reorder data matrix based on the net_order 
else
    if exist('net_order','var')
        order = net_order;
    else
        order = [1 2 3 4 6 7]; % 1 VIS 2 SMN 3 DAN 4 VAN 5 LIM 6 FPN 7 DMN
    end
    
    % reorder the data matrix
    t = [];
    start = 1;
    lines = 1;
    mask = net_label;

    for i = 1:length(order)
        add = find(mask==order(i));
        t = [t;add];
        start = start + length(add);
        lines(i+1) = start;
    end

    data_reorder = data_mat(t,t);
    data_dim = size(data_reorder);
%     data_reorder(1:data_dim(1)+1:end) = max(data_reorder(:));
    
    % plot the lower triangle of the matrix
    if exist('half_flag','var') && half_flag == 1
        figure;
        imagesc(tril(data_reorder));
        hold on;
        line_end = lines(end)-0.5;
        for j = 2:length(lines)
            line_num = lines(j)-0.5;
            line([0.5,line_num],[line_num,line_num],'Color',[0 0 0],'Linewidth',1);
            line([line_num,line_num],[line_num,line_end],'Color',[0 0 0],'Linewidth',1);
        end
        line([0.5,line_end],[0.5,line_end],'Color',[0 0 0],'Linewidth',1);
    % plot the full matrix
    else
        figure;
        imagesc(data_reorder);
        hold on;
        line_end = lines(end)-0.5;
        for j = 2:length(lines) % draw lines dividing network
            line([0.5,line_end],[lines(j)-0.5,lines(j)-0.5],'Color',[0 0 0],'Linewidth',1);
            line([lines(j)-0.5,lines(j)-0.5],[0.5,line_end],'Color',[0 0 0],'Linewidth',1);
        end
        line([0.5,line_end],[0.5,0.5],'Color',[0 0 0],'Linewidth',1);    
    end
    
end

data_vec = mat2vec(data_reorder)';
data_min = min(data_vec);
data_max = max(data_vec);
caxis([data_min,data_max])

load('cmap.mat','cmap')
colormap(cmap); 

set(gca,'xtick',[],'xticklabel',[])
set(gca,'ytick',[],'yticklabel',[])
% box off
axis square;
set(gcf, 'units', 'inches', 'position', [0, 0, 5, 5], 'PaperUnits', 'inches', 'PaperSize', [5, 5])
set(gca,'LineWidth',2);

% hold on
% coor_result=corr(pca1');
% for i=1:8
%     for j=1:8
%         if i==j
%         temp=num2str(coor_result(i,j));
%         text(i,j,temp,'color','k','HorizontalAlignment','center');
%         else
%        temp=num2str(coor_result(i,j));
%         text(i,j,temp(1:4),'color','k','HorizontalAlignment','center');
%         end
%     
%     end
% end
% 



% name='RdBu9';
% cmp = load('colorData.mat',name);
% cmp_pos=cmp.(name)(1:5,:);
% cmp_neg=cmp.(name)(5:end,:);
% 
% c = interp1(linspace(0,1,size(cmp_pos,1)),cmp_pos,linspace(0,1,m),'cubic');
% c(c<0) = 0;
% c(c>1) = 1;
% % T=data_mat;
% % T(T<=0)=0;
% % maxasig = max(T(T~=0));
% % minasig =min(abs(T(T~=0)));
% % minsig = abs(min(T(T~=0)));
% % idx_keycurv1=round(256*(maxasig-minasig)/(minsig+maxasig));
% % idx_keycurv2=round(256*(minsig-minasig)/(minsig+maxasig));
% % cmapnew = zeros(256,3);
% % cmapnew(256-idx_keycurv1+1:256,:) =othercolor('YlOrRd9',length(256-idx_keycurv1+1:256));
% % cmapnew(1:idx_keycurv2,:)=(othercolor('YlGnBu9',length(1:idx_keycurv2)));
% % cmapnew(idx_keycurv2+1:256-idx_keycurv1,:) =0.9; 
% % vcaxis([-minsig,maxasig]);


% name='RdBu9';
% cmp = load('colorData.mat',name);
% cmp_pos=cmp.(name)(1:5,:);
% cmp_neg=cmp.(name)(5:end,:);
% 
% % T=data_mat;
% maxasig = max(T(T~=0));
% minasig =min(abs(T(T~=0)));
% minsig = abs(min(T(T~=0)));
% idx_keycurv1=round(256*(maxasig-minasig)/(minsig+maxasig));
% idx_keycurv2=round(256*(minsig-minasig)/(minsig+maxasig));
% cmapnew = zeros(256,3);
% 
% c = interp1(linspace(0,1,size(cmp_pos,1)),cmp_pos,linspace(0,1,length(256-idx_keycurv1+1:256)),'cubic');
% c(c<0) = 0;
% c(c>1) = 1;
% 
% cmapnew(256-idx_keycurv1+1:256,:) =flipud(c);
% 
% c = interp1(linspace(0,1,size(cmp_neg,1)),cmp_neg,linspace(0,1,length(1:idx_keycurv2)),'cubic');
% c(c<0) = 0;
% c(c>1) = 1;
% 
% cmapnew(1:idx_keycurv2,:)=flipud(c);
% cmapnew(idx_keycurv2+1:256-idx_keycurv1,:) =0.7; 



%建议用这个版本
% name='RdBu9';
% cmp = load('colorData.mat',name);
% cmp_pos=cmp.(name)(1:5,:);
% cmp_neg=cmp.(name)(5:end,:);
% 
% maxasig = max(T(T~=0));
% minasig =min(abs(T(T~=0)));
% minsig = abs(min(T(T~=0)));
% idx_keycurv1=round(256*(maxasig-minasig)/(minsig+maxasig));
% idx_keycurv2=round(256*(minsig-minasig)/(minsig+maxasig));
% cmapnew = zeros(256,3);
% 
% c = interp1(linspace(0,1,size(cmp_pos,1)),cmp_pos,linspace(0,1,length(256-idx_keycurv1:256)),'cubic');
% c(c<0) = 0;
% c(c>1) = 1;
% 
% cmapnew(256-idx_keycurv1:256,:) =flipud(c);
% 
% c = interp1(linspace(0,1,size(cmp_neg,1)),cmp_neg,linspace(0,1,length(1:idx_keycurv2)),'cubic');
% c(c<0) = 0;
% c(c>1) = 1;
% 
% cmapnew(1:idx_keycurv2,:)=flipud(c);
% cmapnew(idx_keycurv2+1:256-idx_keycurv1-1,:) =0.7; 


% maxasig = max(T(T~=0));
% minasig =min(abs(T(T~=0)));
% minsig = abs(min(T(T~=0)));
% idx_keycurv1=round(256*(maxasig-minasig)/(minsig+maxasig));
% idx_keycurv2=round(256*(minsig-minasig)/(minsig+maxasig));
% cmapnew = zeros(256,3);
% 
% cmapnew(256-idx_keycurv1:256,:) =flipud(othercolor('Reds5',length(256-idx_keycurv1:256)));
%  cmapnew(256-idx_keycurv1:256,:)= (othercolor('Reds5',length(256-idx_keycurv1:256)));
% cmapnew(1:idx_keycurv2,:)=flipud(othercolor('Blues5',length(1:idx_keycurv2)));
% cmapnew(idx_keycurv2+1:256-idx_keycurv1-1,:) =0.7; 





% pos
% maxasig = max(T(T~=0));
% minasig =min(abs(T(T~=0)));
% idx_keycurv1=round(256*(maxasig-minasig)/(maxasig));
% % idx_keycurv2=round(256*(minsig-minasig)/(minsig+maxasig));
% cmapnew = zeros(256,3);
% cmp=flipud(othercolor('YlOrRd9',256));
% cmp=othercolor('YlOrRd9',256);
% % cmapnew(256-idx_keycurv1+1:256,:) =cmp(256-idx_keycurv1+1:256,:); 
% % cmapnew(1:256-idx_keycurv1,:) =0.75;  %这个版本是最小值无颜色
% cmapnew(256-idx_keycurv1:256,:) =othercolor('YlOrRd9',length(256-idx_keycurv1:256));
% cmapnew(1:256-idx_keycurv1-1,:) =0.75; %这个版本是最小值有颜色


% neg
% minasig = abs(max(T(T~=0)));
% maxasig =abs(min((T(T~=0))));
% idx_keycurv1=round(256*(maxasig-minasig)/(maxasig));
% % idx_keycurv2=round(256*(minsig-minasig)/(minsig+maxasig));
% cmapnew = zeros(256,3);
% % cmp=flipud(othercolor('YlGnBu9',256));
% % cmp=othercolor('YlGnBu9',256);
% % cmapnew(1:idx_keycurv1,:)=cmp(1:idx_keycurv1,:);%这个版本是最小值无颜色
% cmapnew(1:idx_keycurv1+1,:)=(othercolor('YlGnBu9',idx_keycurv1+1));%这个版本是最小值有颜色
% cmapnew(idx_keycurv1+2:256,:) =0.7; 


