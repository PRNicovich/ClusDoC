function [ AverageDC,Area,Nb,DAbove04]=Fun_Plot_AverageDC_vs_XX(ClusterSmoothTableCh1)

    %% Plot average DC vs Area  per cluster

    [Area, AverageDC]=getClusterAv_DC(ClusterSmoothTableCh1,'Area','DofC');
    figure
    scatter(AverageDC,Area)
    title('DC vs Area')
    %% Plot Average DC versus Localistaion per cluster

    [Nb]=getClusterParam(ClusterSmoothTableCh1,'Nb');
    figure
    scatter(AverageDC,Nb)
    title('Average DC versus Localistaion per cluster')
    %% Plot Average DC vs Localisation with DC above 0.4 per cluster

    [ DAbove04 ] = getAboveDCxx(ClusterSmoothTableCh1,0.4 );
    figure
    scatter(AverageDC,cell2mat(DAbove04))
    title('Average DC versus Localistaion (DC above 0.4) per cluster')
    
end