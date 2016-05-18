function [SmallCluster,  BigCluster]=Big_Small_Cluster(ClusterSmoothTableCh1)

%% 
%

[ROI,Cell]=size(ClusterSmoothTableCh1);
A=ClusterSmoothTableCh1;
for cell=1:1
    for roi=1:ROI

        A2= cellfun(@(y) y(y.('Nb')<10),A{roi,cell},'UniformOutput',0);
        A2=A2(~cellfun('isempty',A2));
        SmallCluster{roi,cell}=A2;
        
        A3= cellfun(@(y) y(y.('Nb')>=10),A{roi,cell},'UniformOutput',0);
        A3=A3(~cellfun('isempty',A3));
        BigCluster{roi,cell}=A3;
             
    end
end


%%

[ROI,Cell]=size(ClusterSmoothTableCh1);
A=ClusterSmoothTableCh1;
for cell=1:1
    for roi=1:ROI

        A2= cellfun(@(y) y(y.Do'Nb')<10),A{roi,cell},'UniformOutput',0);
        A2=A2(~cellfun('isempty',A2));
        SmallCluster{roi,cell}=A2;
        
        A3= cellfun(@(y) y(y.('Nb')>=10),A{roi,cell},'UniformOutput',0);
        A3=A3(~cellfun('isempty',A3));
        BigCluster{roi,cell}=A3;
             
    end
end




















































