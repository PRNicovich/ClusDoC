function [ D2 ] = getAboveDCxx(ClusterSmoothTableCh1,xx )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
        [ROI,Cell]=size(ClusterSmoothTableCh1);
        A=ClusterSmoothTableCh1;
        Threshold=xx;
            for cell=1:1
                for roi=1:ROI

                    if ~isempty(A{roi,cell})
                    D1=cellfun(@(x) x.Data_DoCi.DofC>=Threshold,A{roi,cell},'UniformOutput',0);
                    D2{roi,cell}=cellfun(@(y) length(find(y>0)),D1);

                    end     
                end
            end
end

