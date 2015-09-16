function [Value1]=getClusterParam(ClusterSmoothTableCh1,field1)

%% 
%% Field extraction, for example 'Area' or 'Nb'
A=ClusterSmoothTableCh1(:);
A=A(~cellfun('isempty',A));

Value1=cell2mat(cellfun(@(x) cellfun(@(y) y.(field1),x),A,'UniformOutput',0));


end