function Fun_DBSCAN_DofC_GUIV2(ROIData,Data_Data_DofC)
% Routine to apply DBSCAN on the Degree of Colocalisation Result for
% Channel 1
% Ch1 hhhhhhh

        Path_name=pwd;
        load(fullfile(Path_name,'Data_for_Cluster_Analysis.mat'))
        
        if ~exist(strcat(Path_name,'DBSCAN '),'dir')
            mkdir('DBSCAN ');
        end
        
        cd('DBSCAN ')
        
        if ~exist(strcat(Path_name,'Image from DBSCAN'),'dir')
            mkdir('Image from DBSCAN');
        end
        
        
        % Parameters to change
        %Cutoff=10; % cutoff of number of molecules per cluster
        Display1=1; % Display and save Image from DBSCAN 
        Display2=0; % Display and save Image Cluster Density Map
        r=20;       % r= raduis for the Lr_fun which calculates the local density
        
for p=1:size(ROIData,2) % index for the cell
         for q=1:size(ROIData,1) % index for the region
             
             Data=ROIData{q,p};
             if ~isempty(Data)
                 
             Data_DoC=Data_DegColoc{q,p};
             Data_DoC1=Data_DoC(Data_DoC.Ch==1,:);            
             
                % FunDBSCAN4ZEN( Data,p,q,2,r,Cutoff,Display1, Display2 )
                % Input :
                % -Data = Data Zen table (12 or 13 columns). 
                % -p = index for cell
                % -q = index for Region
                % -Cutoff= cutoff for the min number of molecules per cluster 
                % -Display1=1; % Display and save Image from DBSCAN 
                % -Display2=0; % Display and save Image Cluster Density Map
                
                [ClusterSmooth2, fig1,fig2,fig3] = FunDBSCAN4ZEN_V3( Data_DoC1,p,q,r,Display1,Display2);
                
                % Output :
                % -Datathr : Data after thresholding with lr_Fun +
                % randommess Criterion
                % -ClusterSmooth : cell/structure with individual cluster
                % pareameter (Points, area, Nb of position Contour....)
                % -SumofContour : cell with big(>Cutoff) and small(<Cutoff)
                % contours. use to draw quickly all the contours at once
                % Fig1, fig2 fig3 : handle for figures plot in the
                % function.

                % Save the plot
                if 1==1
                Name=strcat('Table_',num2str(p),'Region_',num2str(q));
                %print(fig1, '-dtiff',strcat('Image from DBSCAN\',Name, 'Region_with_Cluster'));
                ax = gca;
                set(gca, 'box','on','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[])
                set(gcf,'Color',[1 1 1])
                tt = getframe(fig1);
                imwrite(tt.cdata, strcat('Image from DBSCAN\',Name, 'Region_with_Cluster.tif'))
                %saveas(fig1, strcat('Image from DBSCAN\',Name, 'Region_with_Cluster'), 'tif');
                %saveas(fig1, strcat('Image from DBSCAN\',Name, 'Region_with_Cluster'), 'fig');
                close all
                end
                
                % Statistics
  
                % Save the Result
             
                ClusterSmoothTableCh1A{q,p}=ClusterSmooth2; 
                
            end 
        end
    end
    
     save('DBSCAN for DoC Ch1','ClusterSmoothTableCh1A');
     clearvars -except ClusterSmoothTableCh1A
end

