

function Final_Result_Extractor_GUIV2(ROIPos,Result,ClusterSmoothTable)


%% Extracting average values for each region into one column

    data=ROIPos(:,1:5);
% load('DBSCAN_Cluster_Result.mat')

A=Result(:);
A=A(~cellfun('isempty',A));
Percent_in_Cluster_column=cell2mat(cellfun(@(x)x.Percent_in_Cluster,A,'UniformOutput',false));
Number_column=cell2mat(cellfun(@(x) x.Number,A,'UniformOutput',false));
Area_column=cell2mat(cellfun(@(x) x.Area,A,'UniformOutput',false));
Density_column=cell2mat(cellfun(@(x) x.Density,A,'UniformOutput',false));
RelativeDensity_column=cell2mat(cellfun(@(x) x.RelativeDensity,A,'UniformOutput',false));
TotalNumber=cell2mat(cellfun(@(x) x.TotalNumber,A,'UniformOutput',false));
Circularity_column=cell2mat(cellfun(@(x) x.Mean_Circularity,A,'UniformOutput',false));
Number_Cluster_column=cell2mat(cellfun(@(x) x.Number_Cluster,A,'UniformOutput',false));

%
B=ClusterSmoothTable(:);
B=B(~cellfun('isempty',B));
Number_clusters_column=cellfun(@length, B);

%export data into Excel

 array=[{'Cell'},{'ROI'},{'x bottom corner'},{'y bottom corner'},{'Size'},{'Empty'},{'Percent_in_Cluster'},	{'Number'},	{'Area'},...
     {'Density'}, {'RelativeDensity'},{'TotalNumber'},{'Circularity'},{'NumberOfCluster'}];
 
    Matrix_Result=[Percent_in_Cluster_column , Number_column(:,1) , Area_column(:,1) , Density_column ,...
        RelativeDensity_column, TotalNumber, Circularity_column, Number_Cluster_column];
    SheetName=strcat('A');
  

    xlswrite('DBSCAN Results',data,SheetName,'A2');
    xlswrite('DBSCAN Results',array,SheetName,'A1');
    xlswrite('DBSCAN Results',Matrix_Result,SheetName,'G2');
    
    clearvars -except   AllDataCh1 AllDataCh2 Path_name1 Coordinatefile
    
    
end