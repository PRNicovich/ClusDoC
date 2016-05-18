function Fun_Stat_DBSCAN_DofC_GUIV2(ClusterSmoothTableCh,Ch)
%% Comparison of density 

%% Density Comparison

[row, column]=size(ClusterSmoothTableCh);

           MeanDensityDofC=cell(row, column);
           MeanAreaDofC=cell(row, column);
           MeanCircularityDofC=cell(row, column);
           
           MeanDensity2=cell(row, column);
           MeanArea2=cell(row, column);
           MeanCircularity2=cell(row, column);
           
           MeanDensity3=cell(row, column);
           MeanArea3=cell(row, column);
           MeanCircularity3=cell(row, column);
           
for i=1:column
    
    for j=1:row
        A=ClusterSmoothTableCh{j,i};

        if ~isempty(A)
            
           % Population of cluster with Nb>10  
           AA=cellfun(@(x) x(x.Nb>10), A,'UniformOUtput',0);
           A=A(~cellfun('isempty', AA));
           
           % Cluster with Nb(Dof>0.4) >10          
           Cluster_DofC=cellfun(@(x) x(x.Nb_In>10), A,'UniformOUtput',0);
           Cluster_DofC=Cluster_DofC(~cellfun('isempty', Cluster_DofC));
           
           % Area and realtive density for Nb(Dof>0.4) >10
           DensityDofC=cellfun(@(x) x.AvRelativeDensity20, Cluster_DofC);
           AreaDofC=cellfun(@(x) x.Area, Cluster_DofC);
           CircularityDofC=cellfun(@(x) x.Circularity, Cluster_DofC);
           MeanDensityDofC{j,i}=mean(DensityDofC);
           MeanAreaDofC{j,i}=mean(AreaDofC);
           MeanCircularityDofC{j,i}=mean(CircularityDofC);
           
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           
           % Cluster with Nb(Dof>0.4) <10
           Cluster_Other=cellfun(@(x) x(x.Nb_In<=10), A,'UniformOUtput',0);
           Cluster_Other=Cluster_Other(~cellfun('isempty', Cluster_Other));
                      
           Density2=cellfun(@(x) x.AvRelativeDensity20, Cluster_Other);
           Area2=cellfun(@(x) x.Area, Cluster_Other);
           Circularity2=cellfun(@(x) x.Circularity, Cluster_Other);
           MeanDensity2{j,i}=mean(Density2);
           MeanArea2{j,i}=mean(Area2);
           MeanCircularity2{j,i}=mean(Circularity2);
           
           %MeanDensity22{j,i}=mean(Density2.*WNb2);
           %MeanArea22{j,i}=mean(Area2.*WNb2);
           
           % Population of cluster with Nb<10  
           A=ClusterSmoothTableCh{j,i};
           AA=cellfun(@(x) x(x.Nb<=10), A,'UniformOUtput',0);
           A=A(~cellfun('isempty', AA));
           
           Density3=cellfun(@(x) x.AvRelativeDensity20, A);
           Area3=cellfun(@(x) x.Area, A);
           Circularity3=cellfun(@(x) x.Circularity, A);

           MeanArea3{j,i}=mean(Area3);
           MeanDensity3{j,i}=mean(Density3);
           MeanCircularity3{j,i}=mean(Circularity3);
                      
        else
           MeanDensityDofC{j,i}=[];
           MeanAreaDofC{j,i}=[];
           MeanCircularityDofC{j,i}=[];
           
           MeanDensity2{j,i}=[];
           MeanArea2{j,i}=[];
           MeanCircularity2{j,i}=[];
                
        end        
    end
    
end

Result2.DensityDofC=MeanDensityDofC;
Result2.AreaDofC=MeanAreaDofC;
Result2.CircularityDofC=MeanCircularityDofC;

Result2.Density2=MeanDensity2;
Result2.Area2=MeanArea2;
Result2.Circularity2=MeanCircularity2;

Result2.Density3=MeanDensity3;
Result2.Area3=MeanArea3;
Result2.Circularity3=MeanCircularity3;

switch Ch
    case 1
        ResultCh1=Result2;    
        save('ResultCh1','ResultCh1')
    case 2
        ResultCh2=Result2;    
        save('ResultCh2','ResultCh2')
end
    


%% Convert to excel file
    
    % Density Area Circularity for cluster with DofC>0.4
    DensityDofC = cell2mat(MeanDensityDofC(:));
    AreaDofC = cell2mat(MeanAreaDofC(:));
    CircularityDofC=cell2mat(MeanCircularityDofC(:));
    
    % Density Area Circularity for cluster with DofC<0.4
    Density2 = cell2mat(MeanDensity2(:));
    Area2 = cell2mat(MeanArea2(:));
    Circularity2=cell2mat(MeanCircularity2(:));
    
    % Density Area Circularity for cluster with Nb<10  
    Density3 = cell2mat(MeanDensity3(:));
    Area3 = cell2mat(MeanArea3(:));
    Circularity3=cell2mat(MeanCircularity3(:));
    
     Array=[{'DensityCluster>0.4'},	{'DensityCluster<0.4'},...
         {'Density_Nb<=10'},...
    {'AreaCluster>0.4'},	{'AreaCluster<0.4'}...
    {'Area_Nb<=10'},...
    {'Circularity>0.4'},	{'Circularity<0.4'},...
         {'Circularity<=10'}];
    
    Matrix_Result=[DensityDofC...
                    Density2...
                    Density3...
                    AreaDofC...
                    Area2...
                    Area3...
                    CircularityDofC...
                    Circularity2...
                    Circularity3];
    
    RegionName=strcat('Cluster Results2');
    
 switch Ch
    case 1
        xlswrite('DofC_DBSCAN_Ch1',Array,RegionName,'A1');
        xlswrite('DofC_DBSCAN_Ch1',Matrix_Result,RegionName,'A2');
    case 2
        xlswrite('DofC_DBSCAN_Ch2',Array,RegionName,'A1');
        xlswrite('DofC_DBSCAN_Ch2',Matrix_Result,RegionName,'A2');
 end


    
end
    
    

    

   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    