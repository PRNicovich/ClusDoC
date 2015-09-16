
%% Plot DC vs Area  

[Area, AverageDC]=getClusterAv_DC(ClusterSmoothTableCh1,'Area','DofC');
figure
scatter(AverageDC,Area)

%% Plot  Average DC versus Localistaion per cluster

[Nb]=getClusterParam(ClusterSmoothTableCh1,'Nb');
figure
scatter(AverageDC,Nb)

%% Plot 

[ DAbove04 ] = getAboveDCxx(ClusterSmoothTableCh1,0.4 )
figure
scatter(AverageDC,cell2mat(DAbove04))