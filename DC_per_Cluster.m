function Result=DC_per_Cluster(ClusterSmoothTableCh1)
%% Extract and calculate the DC for each cluster 
% and plot the mean and the standard deviation

[ROI,Cell]=size(ClusterSmoothTableCh1);
DofC_Cluster=[];
std_DofC_Cluster=[];
B=ClusterSmoothTableCh1(:);
B=B(~cellfun('isempty', B));
for cell=1:1
    for roi=1:ROI
        
        
        A=B{roi,cell};
        DofC_ClusterT=cellfun(@(x) mean(x.Data_DoCi.DofC), A);
        DofC_Cluster=[DofC_Cluster; DofC_ClusterT];
        
       std_DofC_ClusterT=cellfun(@(x) std(x.Data_DoCi.DofC), A);
        std_DofC_Cluster=[std_DofC_Cluster; std_DofC_ClusterT];
    end
end
Result=[DofC_Cluster std_DofC_Cluster];

figure;hist(DofC_Cluster,100);
figure;scatter(DofC_Cluster,std_DofC_Cluster);
end

