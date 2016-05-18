function [Value]=getClusterParamAv(ClusterSmoothTableCh1,field)
%% 
A=ClusterSmoothTableCh1(:);
A=A(~cellfun('isempty',A));
%Value1=cellfun(@(x) x.(field),A);
Value=cellfun(@(x) cellfun(@(y) mean(y.(filed)),x),A,'UniformOutput',0);

end
