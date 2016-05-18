function [ Data_in, Index_In] = Cropping_Fun( Data, ROI)
% Cropping_Fun calculate the new data set after cropping
% OUtput Data_in 
    
    xroi = [ROI(1)  ROI(1) ROI(1)+ROI(3) ROI(1)+ROI(3) ROI(1)];
    yroi = [ROI(2)  ROI(2)+ROI(4) ROI(2)+ROI(4) ROI(2) ROI(2)];
    XYROI=[xroi' yroi'];
    
    x=Data(:,1);
    y=Data(:,2);
    Index_In = inpolygon(x,y,XYROI(:,1),XYROI(:,2));
    Index_In=find(Index_In~=0);
    Data_in=Data(Index_In,:);

end

