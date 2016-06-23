function [Data_DegColoc, SizeROI] = Fun_DofC_GUIV2(Data, Lr_rad, roiHere)


    %%%%%%% Threshold measure at the randomness
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf(1, 'Segment clustered points from background... \n');

    SizeROI = max(roiHere(3:4));

    dataOut = zeros(size(Data, 1), 7);
    dataOut(:,4) = Data(:,12);

    % All the value (data, idx, Dis, Density) are calculated for the
    % total number of particle regardless which channel they belong to
    [dataOut(:,1:3), ~, ~, dataOut(:,5)] = Lr_fun(Data(:,5), Data(:,6), Data(:,5), Data(:,6), Lr_rad, SizeROI); % data=[X Y Lr Kfuncans], Density=global;

    % Value calculated for a specific channel
    % unused
    [~, ~, ~, dataOut(dataOut(:,4) == 1, 7) ] = Lr_fun(Data(Data(:,12) == 1,5), Data(Data(:,12) == 1,6), ...
        Data(Data(:,12) == 1,5), Data(Data(:,12) == 1,6), Lr_rad, SizeROI); 
    [~, ~, ~, dataOut(dataOut(:,4) == 2, 7) ] = Lr_fun(Data(Data(:,12) == 2,5), Data(Data(:,12) == 2,6), ...
        Data(Data(:,12) == 2,5), Data(Data(:,12) == 2,6), Lr_rad, SizeROI);

     % Centered on Channel 1       


     %%%%% Hardcoded parameter! %%%%%
     %%%%% Hardcoded parameter! %%%%%
    Rmax = 500;                        % Max search radius of ...?
    Step = 10;                        % Step size of...?
    %%%%% Hardcoded parameter! %%%%%
    %%%%% Hardcoded parameter! %%%%%

    % Split data up to reduce overhead passed to workers
    x1 = dataOut(dataOut(:,4) == 1, 1);
    y1 = dataOut(dataOut(:,4) == 1, 2); 

    x2 = dataOut(dataOut(:,4) == 2, 1);
    y2 = dataOut(dataOut(:,4) == 2, 2); 


    %[idx1,Dis]=rangesearch([x1 y1],[x1 y1],Rmax);
    %D1max=(cellfun(@length,idx1)-1)/(Rmax^2);
    D1max = sum(dataOut(:,4) == 1)/SizeROI^2;

    %[idx2,Dis]=rangesearch([x2 y2],[x1 y1],Rmax);
    %D2max=(cellfun(@length,idx2))/(Rmax^2);
    D2maxCh1Ch2 = sum(dataOut(:,4) == 2)/SizeROI^2; % why is this defined one

    D2maxCh2Ch1 = (cellfun(@length, rangesearch([x1 y1], [x2 y2], Rmax)))/(Rmax^2); % check for Ch2 points that are Rmax within Ch1

    %i=0;
    N11 = zeros(sum(dataOut(:,4) == 1), ceil(Rmax/Step));
    N12 = zeros(sum(dataOut(:,4) == 2), ceil(Rmax/Step));
    N22 = zeros(length(x2), ceil(Rmax/Step));
    N21 = zeros(length(x2), ceil(Rmax/Step));
    
    tic
    
    fprintf(1, 'Calculating DofC scores...\n');
    % DoC calculation for Chan1 -> Chan1, Chan1 -> Chan2
    parfor i = 1:ceil(Rmax/Step)

        r = Step*i;                           

        num_points = kdtree2rnearest(x1, y1, x1, y1, r)-1;
        N11(:, i) = num_points ./ (D1max*r^2);

        num_points = kdtree2rnearest(x2, y2, x1, y1, r);
        N12(:, i) = num_points ./ (D2maxCh1Ch2*r^2);

        num_points = kdtree2rnearest(x2, y2, x2, y2, r)-1;
        N22(:, i) = num_points ./ (D1max*r^2);

        num_points = kdtree2rnearest(x1, y1, x2, y2, r);
        N21(:, i) = num_points' ./ (D2maxCh2Ch1*r^2);

    end

    fprintf(1, 'Correlating coefficients...\n');

    SA1 = zeros(length(x1, 1), 1);
    SA2 = zeros(length(x1, 1), 1);

    parfor i=1:length(x1)

        SA1(i,1) = corr(N11(i,:)', N12(i,:)', 'type', 'spearman');
        SA2(i,1) = corr(N22(i,:)', N21(i,:)','type','spearman');

    end

%     SA1a = SA1;
    SA1(isnan(SA1)) = 0;

%     SA2a = SA2;
    SA2(isnan(SA2)) = 0;

    [~, NND1] = knnsearch([x2 y2], [x1 y1]);
    dataOut(dataOut(:,4) == 1, 6) = SA1.*exp(-NND1/Rmax);

    [~, NND2] = knnsearch([x1 y1], [x2 y2]);
    dataOut(dataOut(:,4) == 2, 6) = SA2.*exp(-NND2/Rmax);

%     DofCcoef.SA1a = SA1a; 
%     DofCcoef.SA1 = SA1;
%     DofCcoef.CA1 = CA1;
% 
%     DofCcoef.SA2a = SA2a;
%     DofCcoef.SA2 = SA2;
%     DofCcoef.CA2 = CA2;

    toc

    dataOut = array2table(dataOut,'VariableNames',{'X' 'Y' 'Lr' 'Ch' 'Density' 'DofC' 'D1_D2'});

    Data_DegColoc = dataOut;% dataOut=[X Y Lr Kf Ch Density ColocalCoef]
        
end

