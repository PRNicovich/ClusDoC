function [ data,idx,Dis,Density] = Lr_fun( X1,Y1,X2,Y2,r,SizeROI )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
% SizeROI= size of the square (inmost case 4000nm)
       
        if isempty(X1)||isempty(X2)
            data=[];
            idx=[];
            Dis=[];
            Density=[];
        else
            
           if length(X1)~=length(X2) 
               k=0;
           elseif X1~=X2
               k=0;
           elseif X1==X2
               k=1;
           end
               
        [idx,Dis]=rangesearch([X1 Y1],[X2 Y2],r); % find element of [x y] in a raduis of r from element of [x y]
        Kfuncans=cellfun('length',idx)-k;     % remove the identity
        Density=cellfun('length',idx)/(pi*r^2);%/(length(X2)/SizeROI^2); % Relative Density
        
        Lr=((SizeROI)^2*Kfuncans/(length(X2)-1)/pi).^0.5;     % calculate L(r)
        %D=(2*2000)^2/(length(x)-1)*Kfuncans/(pi*r^2);
        data=[X2 Y2 Lr];
         
%         dataDis={x y idx Dis ch};
%         MaxLr=max(Lr); % value for threshold
%         datathr=data(data(:,3)>MaxLr/3,:); % Threshold the data with Lr 
%         idxthr=find(data(:,3)>MaxLr/3);
%         disthr=Dis{idxthr};
        end 
end

