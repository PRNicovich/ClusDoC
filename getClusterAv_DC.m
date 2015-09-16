function [Value1, Value2]=getClusterAv_DC(ClusterSmoothTableCh1,field1,field2)
%%

%% 
%% Field extraction, for example 'Area' or 'Nb'
A=ClusterSmoothTableCh1(:);
A=A(~cellfun('isempty',A));
%Value1=cellfun(@(x) x.(field),A);
Value1=cell2mat(cellfun(@(x) cellfun(@(y) y.(field1),x),A,'UniformOutput',0));

%% Second field to extract in the Data_DoCi table, Lr Density DofC D1_D2
Value2= cell2mat(cellfun(@(y) cellfun(@(x) mean(x.Data_DoCi.(field2)),y),A,'UniformOutput',0));

end
