% Return cells of individual channels when given a cell of aggregate data.
% Called by DoC_DBSCAN_RipleyK_GUI/DBSCAN_All, hopefully nowhere else.

function [AllDataCh1, AllDataCh2]=Extract_Ch1_Ch2(AllData)

% Old version, provided by Thibault:
% for a=1:size(AllData,2)
%     
%     Ch12Temp1=AllData(:,a);
%     Ch12Temp1=Ch12Temp1(~cellfun('isempty',Ch12Temp1));
%     
%     for b=1:size(Ch12Temp1,1)
%     Ch12Temp2=Ch12Temp1{b};
%     Ch1=Ch12Temp2(Ch12Temp2(:,12)==1,:);
%     Ch2=Ch12Temp2(Ch12Temp2(:,12)==2,:);
%     
%     AllDataCh1{b,a}=Ch1;
%     AllDataCh2{b,a}=Ch2;
%     Ch12Temp2=[];
%     end  

AllDataCh1 = cell(size(AllData, 1), 1);
AllDataCh2 = cell(size(AllData, 1), 1);

    for k = 1:size(AllData, 1)

        AllDataCh1{k, 1} = AllData{k, 1}(AllData{k, 1}(:,12) == 1, :);
        AllDataCh2{k, 1} = AllData{k, 1}(AllData{k, 1}(:,12) == 2, :);

    end

end

