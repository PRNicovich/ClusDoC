function [datathr,ClusterSmooth,SumofContour,fig1,fig2,fig3] = FunDBSCAN_GUIV2( Data,p,q,r1,r2,Epsilon,Cutoff,display1,display2 )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
%   Data = Zen format
% Routine for DBSCAN apply on the Zen data
% 
        
% Calculate Lr for cumulated channels ch1
% 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
% DBSCAN, plot of the contour, cluster centre identification
 % Parameters 1
%figure1=[];
fig1=[];
fig2=[];
fig3=[];
x=Data(:,5:6);
if 1==display1
    fig1=figure();
ax1=axes('parent',fig1);

 hold on;
 plot( ax1,x(:,1), x(:,2),'Marker','.','MarkerSize',4,'LineStyle','none','color','blue');
 
 axis equal
 axis tight
end

%% Threshold for the DBSCAN_Nb_Neighbor on density
xsize=ceil (max(x(:,1))-min(x(:,1)));
ysize=ceil (max(x(:,2))-min(x(:,2)));
SizeROI=max(xsize,ysize);
AvDensity=length(x)/(xsize*ysize);
Nrandom=AvDensity*pi*r1^2;

% if Nrandom<3
%     Nrandom=3;
% end

%% L(r) thresholding

if 1==1
    %% Calculate Lr for cumulated channels ch1 
        %  Threshold the Lr at Lr_Threshold

        Lr_Threshold=((SizeROI)^2*Nrandom/(length(x)-1)/pi).^0.5;
        [data, idx, Dis, Density ] = Lr_fun(x(:,1),x(:,2),x(:,1),x(:,2),r1,SizeROI); % data=[X2 Y2 Lr Kfuncans];
        % 
        data(:,5)=Data(:,12); % channel index
        data(:,6)=Density;
        idxthr=find(data(:,3)>Lr_Threshold); % Index corresponding to the Threshold the data with Lr
        datathr=data(idxthr,:);
        
%       Include the points count in the search radius r for a point of
%       interst

        if 1==1    
        idxthr_friends=idx(idxthr);
        idxthr_friends2=cell2mat(idxthr_friends');
        Index_thr=unique(idxthr_friends2);
        datathr=data(Index_thr,:);
        end
        
        xt(:,1)=datathr(:,1); xt(:,2)=datathr(:,2); % data threshold both channel
x=xt;
Density=datathr(:,6);
% if display1==1
% plot(ax1, x(:,1), x(:,2),'Marker','.','MarkerSize',4,'LineStyle','none','color','blue');
% end

end


%%
Data4dbscan=x(:,1:2);
DBSCAN_Radius=r2;%20;
DBSCAN_Nb_Neighbor=Epsilon;%3;%ceil(Nrandom);
threads = 2;

% FAST DBSCAN CALL

class=t_dbscan(Data4dbscan(:,1), Data4dbscan(:, 2), DBSCAN_Nb_Neighbor, DBSCAN_Radius, threads);
Data4dbscan(:,3)=class;

SumofBigContour=[];
SumofSmallContour=[];
ClusterSmooth=cell(max(class),1);

for i=1:max(class)
    xin=Data4dbscan(Data4dbscan(:,3)==i,:); % Positions contained in the cluster i
    
    if display1==1
    plot( ax1,xin(:,1), xin(:,2),'Marker','.','MarkerSize',4,'LineStyle','none','color','green');
    end   
    
    [ClusImage,  Area, Circularity, Nb, contour, edges, Cutoff_point]=Smoothing_fun4cluster_V2C_1_3(xin(:,1:2),0,0); % 0.1*max intensity 
    
    
    ClusterSmooth{i,1}.Points=xin(:,1:2);
    ClusterSmooth{i,1}.Image=ClusImage;
    ClusterSmooth{i,1}.Area=Area;
    ClusterSmooth{i,1}.Nb=Nb;
    ClusterSmooth{i,1}.edges=edges;
    ClusterSmooth{i,1}.Cutoff_point=Cutoff_point;
    ClusterSmooth{i,1}.Contour=contour;
    ClusterSmooth{i,1}.Circularity=Circularity;
    ClusterSmooth{i,1}.Density=Density(Data4dbscan(:,3)==i);
    ClusterSmooth{i}.Density_Nb_A=Nb/Area;
    ClusterSmooth{i,1}.RelativeDensity=Density(Data4dbscan(:,3)==i)/AvDensity;
    ClusterSmooth{i,1}.Mean_Density=mean(Density(Data4dbscan(:,3)==i));
    ClusterSmooth{i,1}.TotalAreaDensity=AvDensity;    
    
    if Nb>=Cutoff
        SumofBigContour=[SumofBigContour; contour; nan nan ];
    else
        SumofSmallContour=[SumofSmallContour; contour; nan nan ];  
    end
    SumofContour={SumofBigContour, SumofSmallContour};
    
    % Plot the contour
    
    if display1==1
        
    if length(Nb)>Cutoff
        plot(ax1,contour(:,1),contour(:,2),'red');
        set(gca, 'box','on','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[])
    else
        plot(ax1,contour(:,1),contour(:,2),'red');
    end
    
    end
       
end
     ClusterSmooth=ClusterSmooth(~cellfun('isempty',ClusterSmooth));
     
     Name=strcat('Cell',num2str(p),'_Region',num2str(q));
     set(gca, 'box','on','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[])
     set(gcf,'Color',[1 1 1])
     tt = getframe(fig1);
     imwrite(tt.cdata, strcat('Image from DBSCAN\',Name, 'Region_with_Cluster.tif'))
     close gcf
     
%      s=cellfun('size', Cluster,1); % sort cluster by size
%      [dummy index]=sort(s);
%      Cluster=Cluster(index);
%%

if display2==1
    
                Density=datathr(:,6);
                fig2=figure;
                hold on
                %ax2=axes('parent',fig2);
                scatter(x(:,1),x(:,2),2,Density);
                if ~isempty(SumofBigContour)
                    plot(SumofBigContour(:,1),SumofBigContour(:,2),'r');
                end
                if ~isempty(SumofSmallContour)
                    plot(SumofSmallContour(:,1),SumofSmallContour(:,2),'k');
                end
                colorbar
                axis equal
                axis tight
                set(gca, 'box','on','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[])
                set(gcf,'Color',[1 1 1])
                tt = getframe(fig2);
                imwrite(tt.cdata, strcat('Image Cluster Density Map\',Name, '_Density_map.tif'))
                close gcf
                %print(gcf,'-dtiff',strcat('Image Cluster Density Map\',Name2, '_Norm_Density_map'));
                %saveas(gcf,strcat('Image Cluster Density Map\',Name2, '_Density_map'), 'tif');
                %close fig2 
                
                Norm_Density=Density./max(Density);
                fig3=figure;
                hold on
                %ax3=axes('parent',fig3);
                scatter(x(:,1),x(:,2),2,Norm_Density);
                
                if ~isempty(SumofBigContour)
                    plot(SumofBigContour(:,1),SumofBigContour(:,2),'r');
                end
                if ~isempty(SumofSmallContour)
                    plot(SumofSmallContour(:,1),SumofSmallContour(:,2),'k');
                end
                
                colorbar
                axis equal
                axis tight
                set(gca, 'box','on','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[])
                set(gcf,'Color',[1 1 1])
                tt = getframe(fig3);
                imwrite(tt.cdata, strcat('Image Cluster Density Map\',Name, '_Norm_Density_map.tif'))
                close gcf
                %print(gcf,'-dtiff',strcat('Image Cluster Density Map\',Name2, '_Norm_Density_map'));
                %saveas(gcf,strcat('Image Cluster Density Map\',Name2, '_Norm_Density_map'), 'tif');
                %close fig3
end


end




