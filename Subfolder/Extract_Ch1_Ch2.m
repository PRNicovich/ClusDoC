function [AllDataCh1, AllDataCh2]=Extract_Ch1_Ch2(AllData)

for a=1:size(AllData,2)
    
    Ch12Temp1=AllData(:,a);
    Ch12Temp1=Ch12Temp1(~cellfun('isempty',Ch12Temp1));
    
    for b=1:size(Ch12Temp1,1)
    Ch12Temp2=Ch12Temp1{b};
    Ch1=Ch12Temp2(Ch12Temp2(:,12)==1,:);
    Ch2=Ch12Temp2(Ch12Temp2(:,12)==2,:);
    
    AllDataCh1{b,a}=Ch1;
    AllDataCh2{b,a}=Ch2;
    Ch12Temp2=[];
    end   
end

