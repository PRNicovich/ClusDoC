function [rvalue, Lr_r] = RipleyKFun( x,A,Start,End,Step,size_ROI)
    %Ripley Summary of this function goes here
    %   This Function calculates the ripley value for the data set x.
    %   x : nx2 matrix, n points, column 1 : x, column 2 : y
    %   A area of the ROI of interest
    %   Start : first search raduis
    %   End : last search raduis
    %   Step : step of search raduis
    %     x=1024*rand(1,10000);
    %     y=1024*rand(1,10000);


    N = size(x, 1);
    xmin = min(x, [], 1);
    xcenter = x(:,1)-xmin(1);
    ycenter = x(:,2)-xmin(2);
    i_range = (End - Start) / Step;
    i_range = i_range + 1;
    
    % If there's a parallel pool open, use that
    % Otherwise start one
    poolobj = gcp;
    if ~any(~cellfun(@isempty, (strfind(poolobj.AttachedFiles(), 'compute_circle_area.m'))))
        addAttachedFiles(poolobj,{'private/compute_circle_area.m'})
    end

    %for r=Start:Step:End
    parfor i=1:i_range

        %i=i+1;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % compute next step in radius
        r = (i-1)*Step;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        relative_area = compute_circle_area(xcenter',ycenter',r,size_ROI);
        %indexborder=find(relative_area<1);

        [idx, ~] = rangesearch(x,x,r); % can this be sped up?
        % Pontentially with pdist + binary
        % operations?

        Kfuncans1 = (cellfun('length',idx)-1)./relative_area;     % remove the identity
        Kr = mean((Kfuncans1*A/N));     % calculate L(r)
        Lr_r(i,1) = ((Kr/pi).^0.5) - r;     % calculate L(r)-r
        rvalue(i,1) = r;

    end
end
