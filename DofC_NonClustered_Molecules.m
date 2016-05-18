
%% Unclustered molecules
% Isolate the molecules out of the cluster
% Ch1 and Ch2
%
% load('DBSCAN for DoC Ch1 Ch2.mat')
% load('F:\DATA_PALM\Sophie Data\9 region 1 cell\Out1\DofC_Result\DBSCAN\DBSCAN for DoC Ch1 Ch2.mat')
% containing ClusterSmoothTableCh1 and ClusterSmoothTableCh2

% load ('AllData.mat')
% load('F:\DATA_PALM\Sophie Data\Dataset for changes\Extracted_Region\AllData.mat')

A=ClusterSmoothTableCh1;% load from DBSCAN GUI folder Ch1
B=ClusterSmoothTableCh2;% load from DBSCAN GUI folder Ch2

[ROI, Cell]=size(A);
DofC_Ch1=cell(ROI,Cell);

for nCell=1:Cell
    for nROI=1:ROI
        
        XY_All=AllData{nROI,nCell};
         if ~isempty(XY_All)
        % Ch1
        XY_All_Ch1=XY_All(XY_All(:,12)==1,:);
        XY_Ch1=A{nROI,nCell};
        %XY_Ch1_In=cell2mat(cellfun(@(x) x.Points,XY_Ch1,'UniformOutput',0));
        XY_Ch1_In=cell2mat(cellfun(@(x) [x.Data_DoCi.X x.Data_DoCi.Y],XY_Ch1,'UniformOutput',0));
        
        [XY_Ch1_Inctrl a1 Index_Ch1_In]=intersect([XY_Ch1_In(:,1) XY_Ch1_In(:,2)],[XY_All_Ch1(:,5) XY_All_Ch1(:,6)],'rows');
        XY_Ch1_InT{nROI,nCell}=XY_All_Ch1(Index_Ch1_In,:);
        
        [XY_Ch1_Out b1 Index_Ch1_Out]=setxor([XY_Ch1_In(:,1) XY_Ch1_In(:,2)],[XY_All_Ch1(:,5) XY_All_Ch1(:,6)],'rows');
        XY_Ch1_OutT{nROI,nCell}=XY_All_Ch1(Index_Ch1_Out,:);
        
        % Ch2
        XY_All_Ch2=XY_All(XY_All(:,12)==2,:);
        XY_Ch2=B{nROI,nCell};
        %XY_Ch2_In=cell2mat(cellfun(@(x) x.Points,XY_Ch2,'UniformOutput',0));
        XY_Ch2_In=cell2mat(cellfun(@(x) [x.Data_DoCi.X x.Data_DoCi.Y],XY_Ch2,'UniformOutput',0));
        
        [XY_Ch2_Inctrl  a2 Index_Ch2_In]=intersect([XY_Ch2_In(:,1) XY_Ch2_In(:,2)],[XY_All_Ch2(:,5) XY_All_Ch2(:,6)],'rows');
        XY_Ch2_InT{nROI,nCell}=XY_All_Ch2(Index_Ch2_In,:);
        
        [XY_Ch2_Out b2 Index_Ch2_Out]=setxor([XY_Ch2_In(:,1) XY_Ch2_In(:,2)],[XY_All_Ch2(:,5) XY_All_Ch2(:,6)],'rows');
        XY_Ch2_OutT{nROI,nCell}=XY_All_Ch2(Index_Ch2_Out,:);
        
        % Recombine Ch1 and Ch2 outside the cluster
        
        XY_OutT{nROI,nCell}=[XY_All_Ch1(Index_Ch1_Out,:);XY_All_Ch2(Index_Ch2_Out,:)];
        
         end
    end
end
clearvars -except AllData ClusterSmoothTableCh1 ClusterSmoothTableCh2  XY_Ch1_OutT XY_Ch2_OutT XY_OutT XY_Ch2_InT XY_Ch1_InT
AllData=XY_OutT;
mkdir('Isolated_Out_of_Cluster');
cd('Isolated_Out_of_Cluster')
mkdir('Extracted_Region_V3');
save('Extracted_Region_V3\AllData.mat','AllData')
clearvars -except AllData
%%
% Calculate DofC for Unclustered molecules (Isolated_Out_of Cluster)
Routine_DofC_V3

%%
% Non_Clustered : 
% Isolated_out_of_Cluster, you should get Data_DegColoc

A=Data_DegColoc(:);
A=A(~cellfun('isempty',A));
Data_DegColoc=A;

Data_DegColoc_NonCluster=Data_DegColoc;
DofC_NonCluster_Ch1=cellfun(@(x) x.DofC(x.Ch==1),Data_DegColoc,'UniformOutput',0);
DofC_NonCluster_Ch2=cellfun(@(x) x.DofC(x.Ch==2),Data_DegColoc,'UniformOutput',0);

%histogram

figure;hist(cell2mat(DofC_NonCluster_Ch1),100)
tt = getframe(gcf);
imwrite(tt.cdata, 'Hist_NonClustered_DC_Ch1.tif');
close gcf
figure;hist(cell2mat(DofC_NonCluster_Ch2),100)
tt = getframe(gcf);
imwrite(tt.cdata, 'Hist_NonClustered_DC_Ch2.tif');
close gcf

%Calculate average DC of non-clustered molecules per region

Ave_DofC_NonCluster_Ch1=cellfun(@mean, DofC_NonCluster_Ch1);
Ave_DofC_NonCluster_Ch2=cellfun(@mean, DofC_NonCluster_Ch2);

Ave_DofC_NonCluster=[Ave_DofC_NonCluster_Ch1 Ave_DofC_NonCluster_Ch2 ];
save('Ave_DofC_NonCluster','Ave_DofC_NonCluster')

% Calculate % non-clustered molecules with DC>=0.4 per region
fun1=@(x) length(find(x>=0.4))/length(x);

NonCluster_percent_Ch1=cellfun(fun1 , DofC_NonCluster_Ch1);
NonCluster_percent_Ch2=cellfun(fun1 , DofC_NonCluster_Ch2);
NonCluster_percent=[NonCluster_percent_Ch1 NonCluster_percent_Ch2];
save('NonCluster_percent','NonCluster_percent')

































