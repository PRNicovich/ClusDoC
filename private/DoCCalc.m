function [dataOut, SizeROI] = DoCCalc(Data, Lr_rad, Rmax, Step, roiHere)


    %%%%%%% Threshold measure at the randomness
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf(1, 'Segment clustered points from background... \n');

    SizeROI = polyarea(roiHere(:,1), roiHere(:,2));

    dataOut = zeros(size(Data, 1), 8);
    dataOut(:,4) = Data(:,12);

    % All the value (data, idx, Dis, Density) are calculated for the
    % total number of particle regardless which channel they belong to
    [dataOut(:,1:3), ~, ~, dataOut(:,5)] = Lr_Subfun(Data(:,5), Data(:,6), Data(:,5), Data(:,6), Lr_rad, SizeROI); % data=[X Y Lr Kfuncans], Density=global;

    % Value calculated for a specific channel
    % unused
    [~, ~, ~, dataOut(dataOut(:,4) == 1, 7) ] = Lr_Subfun(Data(Data(:,12) == 1,5), Data(Data(:,12) == 1,6), ...
        Data(Data(:,12) == 1,5), Data(Data(:,12) == 1,6), Lr_rad, SizeROI); 
    [~, ~, ~, dataOut(dataOut(:,4) == 2, 7) ] = Lr_Subfun(Data(Data(:,12) == 2,5), Data(Data(:,12) == 2,6), ...
        Data(Data(:,12) == 2,5), Data(Data(:,12) == 2,6), Lr_rad, SizeROI);   

    % Pass along data that meet threshold criteria
    % Original threshold is so convoluted that it basically equals Lr_rad.
    % Lr_Threshold should be number of points within Lr_r for a random
    % distrubution of the same number of points in the current ROI
    Lr_Threshold = (size(Data, 1)/SizeROI)*pi*Lr_rad^2;
    
    
    %Nrandom = (size(Data, 1)/SizeROI)*pi*Lr_rad^2; % Number of particles per Lr_rad circle expected
    %Lr_Threshold = ((SizeROI)*Nrandom/(size(Data, 1) - 1)/pi).^0.5;
    dataOut(:,8) = dataOut(:,3) > Lr_Threshold; % Particle has Lr_r score above that of a random distribution
    
    x1 = dataOut((dataOut(:,4) == 1) & (dataOut(:,8) == 1), 1);
    y1 = dataOut((dataOut(:,4) == 1) & (dataOut(:,8) == 1), 2);

    x2 = dataOut((dataOut(:,4) == 2) & (dataOut(:,8) == 1), 1);
    y2 = dataOut((dataOut(:,4) == 2) & (dataOut(:,8) == 1), 2);


%     assignin('base', 'x1', x1);
%     assignin('base', 'y1', y1);
%     assignin('base', 'x2', x2);
%     assignin('base', 'y2', y2);
    
    %[idx1,Dis]=rangesearch([x1 y1],[x1 y1],Rmax);
    %D1max=(cellfun(@length,idx1)-1)/(Rmax^2);
    
    % Why is this defined differently than the Ch2Ch1 version?
    D1max = sum((dataOut(:,4) == 1) & (dataOut(:,8) == 1))/SizeROI^2;

    %[idx2,Dis]=rangesearch([x2 y2],[x1 y1],Rmax);
    %D2max=(cellfun(@length,idx2))/(Rmax^2);
    
    D2maxCh1Ch2 = sum((dataOut(:,4) == 2) & (dataOut(:,8) == 1))/SizeROI^2; % why is this defined one
    % Why is this defined differently than the Ch2Ch1 version?

    D2maxCh2Ch1 = (cellfun(@length, rangesearch([x1 y1], [x2 y2], Rmax)))/(Rmax^2); % check for Ch2 points that are Rmax within Ch1

    %i=0;
    N11 = zeros(numel(x1), ceil(Rmax/Step));
    N12 = zeros(numel(x1), ceil(Rmax/Step));
    N22 = zeros(numel(x2), ceil(Rmax/Step));
    N21 = zeros(numel(x2), ceil(Rmax/Step));
    
    tic
    
    fprintf(1, 'Calculating DoC scores...\n');
    % DoC calculation for Chan1 -> Chan1, Chan1 -> Chan2

    parfor i = 1:ceil(Rmax/Step)

        r = Step*i;                           

%         [idx, ~] = rangesearch([x1 y1], [x1 y1], r);
%         num_points = cellfun(@length, idx) - 1;
        num_points = kdtree2rnearest(x1, y1, x1, y1, r)-1; % Ch1 -> Ch1
        N11(:, i) = num_points ./ (D1max*r^2);
% 
%         [idx, ~] = rangesearch([x2 y2], [x1 y1], r);
%         num_points = cellfun(@length, idx) - 1;
        num_points = kdtree2rnearest(x2, y2, x1, y1, r); % Ch1 -> Ch2
        N12(:, i) = num_points ./ (D2maxCh1Ch2*r^2);

%         [idx, ~] = rangesearch([x2 y2], [x2 y2], r);
%         num_points = cellfun(@length, idx) - 1;
        num_points = kdtree2rnearest(x2, y2, x2, y2, r)-1; % Ch2 -> Ch2
        N22(:, i) = num_points ./ (D1max*r^2);

%         [idx, ~] = rangesearch([x1 y1], [x2 y2], r);
%         num_points = cellfun(@length, idx) - 1;
        num_points = kdtree2rnearest(x1, y1, x2, y2, r); % Ch2 -> Ch1
        N21(:, i) = num_points' ./ (D2maxCh2Ch1*r^2);

    end

    fprintf(1, 'Correlating coefficients...\n');

    SA1 = zeros(size(x1, 1), 1);
    SA2 = zeros(size(x2, 1), 1);

    for i=1:size(x1, 1)

        SA1(i,1) = corr(N11(i,:)', N12(i,:)', 'type', 'spearman');
        
        if le(i, size(x2, 1)) % Don't try to calc chan2 results if there aren't any chan2 ponits left!
            SA2(i,1) = corr(N22(i,:)', N21(i,:)','type','spearman');
        end

    end

%     SA1a = SA1;
    SA1(isnan(SA1)) = 0;

%     SA2a = SA2;
    SA2(isnan(SA2)) = 0;

    % DoC Assignment
    [~, NND1] = knnsearch([x2 y2], [x1 y1]);
    dataOut((dataOut(:,4) == 1) & (dataOut(:,8) == 1), 6) = SA1.*exp(-NND1/Rmax);

    [~, NND2] = knnsearch([x1 y1], [x2 y2]);
    dataOut((dataOut(:,4) == 2) & (dataOut(:,8) == 1), 6) = SA2.*exp(-NND2/Rmax);

%     DoCcoef.SA1a = SA1a; 
%     DoCcoef.SA1 = SA1;
%     DoCcoef.CA1 = CA1;
% 
%     DoCcoef.SA2a = SA2a;
%     DoCcoef.SA2 = SA2;
%     DoCcoef.CA2 = CA2;

    toc

    % dataOut(:,1) = X - X position
    % dataOut(:,2) = Y - Y position
    % dataOut(:,3) = Lr - Lr value at radius r
    % dataOut(:,4) = Ch - Channel
    % dataOut(:,5) = Density - relative density, number of points inside RipleyK filter radius, ALL CHANNELS
    % dataOut(:,6) = DoC - Cross-channel Degree of colocalization
    % dataOut(:,7) = D1_D2 - num points inside RipleyK filter radius, SAME CHANNEL
    
    
    dataOut = array2table(dataOut,'VariableNames',{'X' 'Y' 'Lr' 'Ch' 'Density' 'DoC' 'D1_D2' 'Lr_rAboveThresh'});

%     Data_DegColoc = dataOut;% dataOut=[X Y Lr Kf Ch Density ColocalCoef]
        
end

% Lr_rSubfun as subfunction form of Lr_rfun 
% here to avoid issues with private function calls
function [ data,idx,Dis,Density] = Lr_Subfun(X1, Y1, X2, Y2, r, SizeROI)

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


