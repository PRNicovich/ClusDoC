function [ Frequency, CF, X] = Data_distribution( data )
%UNTITLED14 Summary of this function goes here
%   Detailed explanation goes here


        [h,stats] = cdfplot(data);
        X=h.XData;
        X1=X(find(~isnan(X)| ~isinf(X)));
            ii=0;
            for i=X;
                ii=ii+1;

                Value1=find(data==i);
                Value2=find(data<=i);
                Frequency(ii)=sum(Value1);
                CF(ii)=sum(Value2)/sum(data);
            end
end

