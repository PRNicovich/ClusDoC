function [ClusterSmoothTable,Result]=DBSCAN_MultiData_GUIFunV2(AllData)

% Version GUI V2 (RipleyK/DBSCAN)
        
        Path_name=pwd;
        if ~exist(strcat(Path_name,'Image from DBSCAN'),'dir')
            mkdir('Image from DBSCAN');
        end
        
        if ~exist(strcat(Path_name,'Image Cluster Density Map'),'dir')
            mkdir('Image Cluster Density Map');
        end
        
        tic
        % Parameters to change
    
     [r1,r2,Epsilon,Cutoff]=DBSCAN_Parameter;
%              
%         r1=50;       % raduis for the Lr_fun which calculates the local density     
%         r2=50;       % raduis for DBSCAN search
%         Epsilon=20;  % min number of neighbor     
%         Cutoff=10;  % cutoff of number of molecules per cluster

         Display1=1; % Display and save Image from DBSCAN 
         Display2=1; % Display and save Image Cluster Density Map
        
     for p=1:size(AllData,2) % index for the cell
         for q=1:size(AllData,1) % index for the region
             Data=AllData{q,p};
             
            if ~isempty(Data)
                
                % FunDBSCAN4ZEN( Data,p,q,2,r,Cutoff,Display1, Display2 )
                % Input :
                % -Data = Data Zen table (12 or 13 columns). 
                % -p = index for cell
                % -q = index for Region
                % -Cutoff= cutoff for the min number of molecules per cluster 
                % -Display1=1; % Display and save Image from DBSCAN 
                % -Display2=0; % Display and save Image Cluster Density Map
                
                
                [datathr, ClusterSmooth,SumofContour, fig1,fig2,fig3] = FunDBSCAN_GUIV2( Data,p,q,r1,r2,Epsilon,Cutoff,Display1,Display2 );
                
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
                if 0==Display1
                Name=strcat('Table_',num2str(p),'Region_',num2str(q));
                %print(fig1, '-dtiff',strcat('Image from DBSCAN\',Name, 'Region_with_Cluster'));                .

                %saveas(fig1, strcat('Image from DBSCAN\',Name, 'Region_with_Cluster'), 'tif');
                %saveas(fig1, strcat('Image from DBSCAN\',Name, 'Region_with_Cluster'), 'fig');
                close all
                end
                
                % Statistics
                if 1==1
                    
                    Number_aboveCutoff_Smooth=cell2mat(cellfun(@(x) x.Nb(x.Nb>Cutoff),ClusterSmooth,'UniformOutput',false));
                    Number_Cluster=length(ClusterSmooth);
                    Area_aboveCutoff_Smooth=cell2mat(cellfun(@(x) x.Area(x.Nb>Cutoff),ClusterSmooth,'UniformOutput',false));
                    Circularity_aboveCutoff_Smooth=cell2mat(cellfun(@(x) x.Circularity(x.Nb>Cutoff),ClusterSmooth,'UniformOutput',false));
                    Density_aboveCutoff_Smooth=cell2mat(cellfun(@(x) x.Density(x.Nb>Cutoff),ClusterSmooth,'UniformOutput',false));
                    
                    RelativeDensity_aboveCutoff_Smooth=cell2mat(cellfun(@(x) x.RelativeDensity(x.Nb>Cutoff),ClusterSmooth,'UniformOutput',false));
                    %Mean_Density=cellfun(@(x) mean(x.Density),ClusterSmoothTable{1,1},'UniformOutput',false);
                    Mean_number(1)=mean(Number_aboveCutoff_Smooth);
                    %Mean_number(2)=std(Number_above10_Smooth);
                    Mean_Area(1)=mean(Area_aboveCutoff_Smooth);
                    Mean_Circularity(1)=mean(Circularity_aboveCutoff_Smooth);
                    %Mean_Area(2)=std(Area_above10_Smooth);
                    % Mean_Diameter=2*sqrt(Mean_AreaSmooth)/pi;
                    Mean_Density=mean(Density_aboveCutoff_Smooth);
                    Mean_RelativeDensity=mean(RelativeDensity_aboveCutoff_Smooth);

                    % Number_above10=cell2mat(cellfun(@(x) x.Nb(x.Nb>10),Cluster,'UniformOutput',false));
                    % Area_above10=cell2mat(cellfun(@(x) x.Area(x.Nb>10),Cluster,'UniformOutput',false));
                    % Mean_number(1)=mean(Number_above10);
                    % Mean_number(2)=std(Number_above10);
                    % Mean_Area(1)=mean(Area_above10);
                    % Mean_Area(2)=std(Area_above10);
                    % Mean_Diameter=2*sqrt(Mean_Area)/pi;
                    
                    TotalNumber=size(Data,1);
                end
                
                % Save the Result
             
                %ClusterTable{q,p}=Cluster;
                ClusterSmoothTable{q,p}=ClusterSmooth;
                
                Result{q,p}.TotalNumber=TotalNumber;
                Result{q,p}.Number=Mean_number;
                Result{q,p}.Area=Mean_Area;
                Result{q,p}.Mean_Circularity=Mean_Circularity;
                Result{q,p}.Number_Cluster=Number_Cluster;
                Result{q,p}.Density=Mean_Density;
                Result{q,p}.RelativeDensity=Mean_RelativeDensity;
                
                Percent_in_Cluster=sum(cell2mat(cellfun(@(x) x.Nb,ClusterSmooth,'UniformOutput',false)))/length(Data);
                Result{q,p}.Percent_in_Cluster=Percent_in_Cluster; 
                
            end 
         end 
     end
     
     save('DBSCAN_Cluster_Result.mat','ClusterSmoothTable','Result','-v7.3');
toc


