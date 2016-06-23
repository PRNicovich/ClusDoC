function [ data,idx,Dis,Density] = Lr_fun(X1, Y1, X2, Y2, r, SizeROI)

% SizeROI= size of the square (inmost case 4000nm)
       
        if isempty(X1) || isempty(X2)
            data = [];
            idx = [];
            Dis = [];
            Density = [];
        else
            
           if length(X1) ~= length(X2) 
               k = 0;
           elseif X1 ~= X2
               k = 0;
           elseif X1 == X2
               k = 1;
           end
               
        [idx, Dis] = rangesearch([X1, Y1], [X2, Y2], r); % find element of [x y] in a raduis of r from element of [x y]
        Kfuncans = cellfun('length', idx) - k;     % remove the identity
        Density = cellfun('length', idx) / (pi*r^2); %/(length(X2)/SizeROI^2); % Relative Density
        
        Lr = ((SizeROI)^2*Kfuncans / (length(X2) - 1)/pi).^0.5;     % calculate L(r)
        data=[X2, Y2, Lr];

        end 
end

