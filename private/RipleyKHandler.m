function valOut = RipleyKHandler(ROIPos, CellData, Start, End, Step, MaxSampledPts, Chan1Color, Chan2Color, Fun_OutputFolder_name)

% Handler function for RipleyK calculations
    
    cellList = unique(ROIPos(:,1));
    ROIList = unique(ROIPos(:,2)); % If multiple cells don't share ROIs...what happens here?

    ArrayHeader = [{'r'},{'L(r)-r'}];

    i = 0;
    
    nSteps = ceil((End - Start)/Step) + 1;
    
    uniqueROIs = unique(ROIPos(:,1:2), 'rows');
    
	Max_Lr = zeros(size(uniqueROIs, 1), max(unique(CellData{1}(:,12)))); % Assuming the first cell has the same number of channels as the rest
	Max_r = zeros(size(uniqueROIs, 1), max(unique(CellData{1}(:,12))));
	Lr_r_Result = zeros(nSteps, size(uniqueROIs, 1), max(unique(CellData{1}(:,12))));

    for cellIter = 1:numel(cellList) % cell number

        for roiIter = 1:numel(ROIList) % ROI number
            
            q = ROIList(roiIter);
            p = cellList(cellIter);
            
            roiHere = ROIPos((ROIPos(:,1) == p) & (ROIPos(:,2) == q), 3:6);
            [ ~, cropIdx] = Cropping_Fun(CellData{p}(:,5:6), roiHere);
            dataCropped = CellData{p}(cropIdx,:);

            if ~isempty(dataCropped)
                i=i+1;

                ROIsize = ROIPos((ROIPos(:,1) == p) & (ROIPos(:,2) == q), 5:6);

                size_ROI = max(ROIsize(:))*[1 1];
                A = max(ROIsize(:)).^2;

                % Calculate RipleyK for this cell + ROI w/ Channel 1
                % data

                selectNums = randsample(1:size(dataCropped, 1), MaxSampledPts);
                selectVector = false(size(dataCropped, 1), 1);
                selectVector(selectNums) = true;

                for chan = unique(dataCropped(:,12))'
                    
                    if chan == 1
                        plotColor = Chan1Color;
                    elseif chan == 2
                        plotColor = Chan2Color;
                    end

                    [r, Lr_r] = RipleyKFun(dataCropped(selectVector & (dataCropped(:,12) == chan),5:6), ...
                        A, Start, End, Step, size_ROI);

                    handles.handles.RipleyKCh1Fig = figure('color', [1 1 1]);
                    handles.handles.RipleyKCh1Ax = axes('parent', handles.handles.RipleyKCh1Fig);
                    plot(handles.handles.RipleyKCh1Ax, r, Lr_r, 'color', plotColor, 'linewidth', 2);


                    % Collect results from these calculations
                    [MaxLr_r, Index] = max(Lr_r);
                    Max_Lr(i, chan) = MaxLr_r;
                    Max_r(i, chan) = r(Index);
                    Lr_r_Result(:,i, chan) = Lr_r;

                    annotation('textbox', [0.45,0.8,0.22,0.1],...
                        'String', sprintf('Max L(r) - r: %.3f at Max r : %d', MaxLr_r, Max_r(i)), ...
                        'FitBoxToText','on');
                    xlabel(handles.handles.RipleyKCh1Ax, 'r (nm)', 'fontsize', 12);
                    ylabel(handles.handles.RipleyKCh1Ax, 'L(r) - r', 'fontsize', 12);

                    print(fullfile(Fun_OutputFolder_name, 'RipleyK Plots', sprintf('Ch%d', chan), sprintf('Ripley_%dRegion_%d.tif', p, q)), ...
                        handles.handles.RipleyKCh1Fig, '-dtiff');
                    close(handles.handles.RipleyKCh1Fig);

                    Matrix_Result = [r, Lr_r];
                    SheetName = sprintf('Cell_%dRegion_%d', p, q);
                    xlswrite(fullfile(Fun_OutputFolder_name, 'RipleyK Results', sprintf('Ch%d', chan), 'RipleyK Results.xls'), ArrayHeader, SheetName, 'A1');
                    xlswrite(fullfile(Fun_OutputFolder_name, 'RipleyK Results', sprintf('Ch%d', chan), 'RipleyK Results.xls'), Matrix_Result, SheetName, 'A2');
                end
            end

        end
    end



    for chan = unique(CellData{1}(:,12))'
        
        Average_Lr_r(:,1) = r;
        Average_Lr_r(:,1) = r;
        Average_Lr_r(:, 2) = squeeze(mean(Lr_r_Result(:,:,chan), 2));
        Std_Lr_r(:,2) = std(Lr_r_Result(:,:,chan), 0, 2);
    
        if chan == 1
            plotColor = Chan1Color;
        elseif chan == 2
            plotColor = Chan2Color;
        end
        
        Max_r_Ave=[mean(Max_r(:,chan)), std(Max_r(:,chan))];
        Max_Lr_Ave=[mean(Max_Lr(:,chan)), std(Max_Lr(:,chan))];

        % Data average on all the regions and cells
        xlswrite(fullfile(Fun_OutputFolder_name, 'RipleyK Results', sprintf('Ch%d', chan), sprintf('Ch%dPooled.xls', chan)), ArrayHeader, 'Pooled data', 'A1');
        xlswrite(fullfile(Fun_OutputFolder_name, 'RipleyK Results', sprintf('Ch%d', chan), sprintf('Ch%dPooled.xls', chan)), Average_Lr_r, 'Pooled data', 'A2');

        % average for max Lr-r and r(max Lr-r)
        xlswrite(fullfile(Fun_OutputFolder_name, 'RipleyK Results', sprintf('Ch%d', chan), sprintf('Ch%dPooled.xls', chan)), [{'r(max_Lr)'},{'Max_Lr'}], 'Pooled data', 'D3');
        xlswrite(fullfile(Fun_OutputFolder_name, 'RipleyK Results', sprintf('Ch%d', chan), sprintf('Ch%dPooled.xls', chan)), [{'Mean'},{'Std'}]', 'Pooled data', 'E2');
        xlswrite(fullfile(Fun_OutputFolder_name, 'RipleyK Results', sprintf('Ch%d', chan), sprintf('Ch%dPooled.xls', chan)), [Max_r_Ave' Max_Lr_Ave'], 'Pooled data', 'E3');

        % max Lr-r and r(max Lr-r) for each region
        xlswrite(fullfile(Fun_OutputFolder_name, 'RipleyK Results', sprintf('Ch%d', chan), sprintf('Ch%dPooled.xls', chan)), [{'r(max_Lr)'},{'Max_Lr'}], 'Pooled data', 'E6');
        xlswrite(fullfile(Fun_OutputFolder_name, 'RipleyK Results', sprintf('Ch%d', chan), sprintf('Ch%dPooled.xls', chan)), [Max_r; Max_Lr]', 'Pooled data', 'E7');

        handles.handles.RipleyKMeanFig = figure('color', [1 1 1]);
        clf(handles.handles.RipleyKMeanFig);
        handles.handles.RipleyKMeanAx = axes('parent', handles.handles.RipleyKMeanFig, 'nextplot', 'add');
        plot(handles.handles.RipleyKMeanAx, r, mean(Lr_r_Result(:,:,chan), 2), 'linewidth', 2, 'color', plotColor);
        plot(handles.handles.RipleyKMeanAx, r, mean(Lr_r_Result(:,:,chan), 2) + Std_Lr_r(:,2), ...
            'linewidth', 2, 'linestyle', ':', 'color', rgb(52, 152, 219));
        plot(handles.handles.RipleyKMeanAx, r, mean(Lr_r_Result(:,:,chan), 2) - Std_Lr_r(:,2), ...
            'linewidth', 2, 'linestyle', ':', 'color', rgb(52, 152, 219));
        xlabel(handles.handles.RipleyKMeanAx, 'r (nm)', 'fontsize', 12);
        ylabel(handles.handles.RipleyKMeanAx, 'L(r) - r', 'fontsize', 12);

        annotation('textbox', [0.45,0.8,0.22,0.1],...
            'String', sprintf('Max L(r) - r: %.3f at Max r : %d', MaxLr_r, Max_r(i)), ...
            'FitBoxToText','on');

        print(fullfile(Fun_OutputFolder_name, 'RipleyK Plots', sprintf('Ch%d', chan), 'RipleyK_Average.tif'), ...
            handles.handles.RipleyKMeanFig, '-dtiff');
        close(handles.handles.RipleyKMeanFig);
        
    end

    valOut = 1;

end