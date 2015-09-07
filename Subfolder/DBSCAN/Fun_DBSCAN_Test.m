function [datathr,ClusterSmooth,SumofContour] = Fun_DBSCAN_Test( Data,r,Cutoff)
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
datathr=[];
x=Data(:,5:6);
figDBSCAN=figure();
ax1=axes('parent',figDBSCAN);

 hold on;
 plot( ax1,x(:,1), x(:,2),'Marker','.','MarkerSize',4,'LineStyle','none','color','blue'); 
axis image

%% Threshold for the DBSCAN_Nb_Neighbor on density
xsize=ceil (max(x(:,1))-min(x(:,1)));
ysize=ceil (max(x(:,2))-min(x(:,2)));
SizeROI=max(xsize,ysize);
AvDensity=length(x)/(xsize*ysize);
Nrandom=AvDensity*pi*r^2;

%% L(r) thresholding

if 1==0
    %% Calculate Lr for cumulated channels ch1 
        %  Threshold the Lr at Lr_Threshold

        Lr_Threshold=((SizeROI)^2*Nrandom/(length(x)-1)/pi).^0.5;
        [data, idx, Dis, Density ] = Lr_fun(x(:,1),x(:,2),x(:,1),x(:,2),r,SizeROI); % data=[X2 Y2 Lr Kfuncans];
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
else
    
end

%%
Data4dbscan=x(:,1:2);
DBSCAN_Radius=20;
DBSCAN_Nb_Neighbor=3;%ceil(Nrandom);
threads = 2;

% FAST DBSCAN CALL

class=t_dbscan(Data4dbscan(:,1), Data4dbscan(:, 2), DBSCAN_Nb_Neighbor, DBSCAN_Radius, threads);
Data4dbscan(:,3)=class;

SumofContourBig=[];
SumofContourSmall=[];
ClusterSmooth=cell(max(class),1);

for i=1:max(class)
    xin=Data4dbscan(Data4dbscan(:,3)==i,:); % Positions contained in the cluster i
    
    plot( ax1,xin(:,1), xin(:,2),'Marker','.','MarkerSize',4,'LineStyle','none','color','green');
 
    
    [ClusImage,  Area, Circularity, Nb, contour, edges, Cutoff_point]=Smoothing_fun_Vgui(xin(:,1:2),0,0); % 0.1*max intensity 
    
   
    ClusterSmooth{i,1}.Points=xin(:,1:2);
    ClusterSmooth{i,1}.Image=ClusImage;
    ClusterSmooth{i,1}.Area=Area;
    ClusterSmooth{i,1}.Nb=Nb;
    ClusterSmooth{i,1}.edges=edges;
    ClusterSmooth{i,1}.Cutoff_point=Cutoff_point;
    ClusterSmooth{i,1}.Contour=contour;
    ClusterSmooth{i,1}.Circularity=Circularity;
    ClusterSmooth{i}.Density_Nb_A=Nb/Area;
    ClusterSmooth{i,1}.TotalAreaDensity=AvDensity;  
if 1==0     
    ClusterSmooth{i,1}.Density=Density(Data4dbscan(:,3)==i);
    ClusterSmooth{i,1}.RelativeDensity=Density(Data4dbscan(:,3)==i)/AvDensity;
    ClusterSmooth{i,1}.Mean_Density=mean(Density(Data4dbscan(:,3)==i));
    ClusterSmooth{i,1}.TotalAreaDensity=AvDensity;    
end    
    if Nb>=Cutoff
        SumofContourBig=[SumofContourBig; contour; nan nan ];
    else
        SumofContourSmall=[SumofContourSmall; contour; nan nan ];  
    end
    SumofContour={SumofContourBig, SumofContourSmall};
    
    % Plot the contour
          
    if Nb>Cutoff
        plot(ax1,contour(:,1),contour(:,2),'red');
        set(gca, 'box','on','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[])
    else
        plot(ax1,contour(:,1),contour(:,2),'black');
    end
    

       
end
     ClusterSmooth=ClusterSmooth(~cellfun('isempty',ClusterSmooth));
     
     set(gca, 'box','on','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[])
     set(gcf,'Color',[1 1 1])
%      Name=strcat('Cell',num2str(p),'_Region',num2str(q));
%      tt = getframe(fig1);
%      imwrite(tt.cdata, strcat('Image from DBSCAN\',Name, 'Region_with_Cluster.tif'))
%      close gcf
     
%%

if 1==0
                Density=datathr(:,6);
                fig2=figure;
                hold on
                %ax2=axes('parent',fig2);
                scatter(x(:,1),x(:,2),2,Density);
                plot(SumofContourBig(:,1),SumofContourBig(:,2),'r');
                plot(SumofContourSmall(:,1),SumofContourSmall(:,2),'k');
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
                plot(SumofContourBig(:,1),SumofContourBig(:,2),'r');
                plot(SumofContourSmall(:,1),SumofContourSmall(:,2),'k');
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




