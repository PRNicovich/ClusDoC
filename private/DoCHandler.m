function [Data_DoC, DensityROI] = DoCHandler(ROIPos, CellData, Lr_rad, Rmax, Step, Chan1Color, Chan2Color, Outputfolder)

    % Handler function for data arrangement and plotting of DoC calculations
    % Formerly Main_Fun_DoC_GUIV2.m
    % Follows idea of:
    % Colocalization Malkusch (Histochem Cell Biol)
    % Moved here to avoid conflicts with private functions and data
    % handling.
    % Away from button callback for clarity.

    cellList = unique(ROIPos(:,1));
    ROIList = unique(ROIPos(:,2)); % If multiple cells don't share ROIs...what happens here?


    Data_DoC = cell(numel(ROIList), numel(cellList));
    DensityROI = cell(numel(ROIList), numel(cellList));

    for cellIter = 1:numel(cellList) % cell number

        for roiIter = 1:numel(ROIList) % ROI number

            k = ROIList(roiIter);
            nt = cellList(cellIter);

            roiHere = ROIPos((ROIPos(:,1) == nt) & (ROIPos(:,2) == k), 3:6);
            [ ~, cropIdx] = Cropping_Fun(CellData{nt}(:,5:6), roiHere);
            dataCropped = CellData{nt}(cropIdx,:);

            if ~isempty(dataCropped)
                dataCropped(isnan(dataCropped(:,12)),:)=[];

                % Send single ROI of data to DoC calculation function
                [ Data_DegColoc1, SizeROI1 ] = DoCCalc( dataCropped, Lr_rad, Rmax, Step, roiHere );

                CA1 = Data_DegColoc1.DoC(Data_DegColoc1.Ch == 1); % Ch1 -> Ch2
                CA2 = Data_DegColoc1.DoC(Data_DegColoc1.Ch == 2); % Ch2 -> Ch1

                handles.handles.DoCFigPerROI = figure('color', [1 1 1], 'inverthardcopy', 'off');

                handles.handles.DoCAxPerROI(1) = subplot(2,1,1);
                histHand = histogram(handles.handles.DoCAxPerROI(1), CA1, 100);
                histHand.FaceColor = Chan1Color;
                histHand.EdgeColor = rgb(52, 73, 94);
                set(handles.handles.DoCAxPerROI(1), 'XLim', [-1 1]);
                xlabel(handles.handles.DoCAxPerROI(1), 'DoC Score Ch1 -> Ch2', 'Fontsize', 20);
                ylabel(handles.handles.DoCAxPerROI(1), 'Frequency','FontSize',20);
                set(handles.handles.DoCAxPerROI(1),'FontSize',20)

                handles.handles.DoCAxPerROI(2) = subplot(2,1,2);
                histHand = histogram(handles.handles.DoCAxPerROI(2), CA2, 100);
                histHand.FaceColor = Chan2Color;
                histHand.EdgeColor = rgb(52, 73, 94);
                set(handles.handles.DoCAxPerROI(2), 'XLim', [-1 1]);
                xlabel(handles.handles.DoCAxPerROI(2), 'DoC Score Ch2 -> Ch1', 'Fontsize', 20);
                ylabel(handles.handles.DoCAxPerROI(2), 'Frequency','FontSize',20);
                set(handles.handles.DoCAxPerROI(2),'FontSize',20)

                drawnow;

                % Save the figure
                Name = sprintf('Table_%d_Region_%d_Hist', nt, k);
                print(fullfile(Outputfolder, 'Clus-DoC Results', 'DoC histograms', Name), ...
                    handles.handles.DoCFigPerROI, '-dtiff');

                close gcf
                
                Data_DoC{k,nt} = Data_DegColoc1;


                % Average density for each region
                DensityROI{k,nt} = [size([CA1;CA2],1)/SizeROI1^2, ...
                    size(CA1,1)/SizeROI1^2, ...
                    size(CA2,1)/SizeROI1^2];

            end
            %AvDensityCell(nt,:)=mean (DensityROI,1);
        end
    end

    A = Data_DoC(~cellfun('isempty', Data_DoC(:)));
    DoC1 = cell2mat(cellfun(@(x) x.DoC(x.Ch == 1), A(:), 'UniformOutput', false));
    DoC2 = cell2mat(cellfun(@(x) x.DoC(x.Ch == 2), A(:), 'UniformOutput', false));
    DoC1(DoC1==0) = [];
    DoC2(DoC2==0) = [];

    % Plot summary data
    handles.handles.DoCFig = figure('color', [1 1 1], 'inverthardcopy', 'off');

    handles.handles.DoCAx(1) = subplot(2,1,1);
    histHand = histogram(handles.handles.DoCAx(1), DoC1, 100);
    histHand.FaceColor = Chan1Color;
    histHand.EdgeColor = rgb(52, 73, 94);
    set(handles.handles.DoCAx(1), 'XLim', [-1 1]);
    xlabel(handles.handles.DoCAx(1), 'DoC Score Ch1 -> Ch2', 'Fontsize', 20);
    ylabel(handles.handles.DoCAx(1), 'Frequency','FontSize',20);
    set(handles.handles.DoCAx(1),'FontSize',20)

    handles.handles.DoCAx(2) = subplot(2,1,2);
    histHand = histogram(handles.handles.DoCAx(2), DoC2, 100);
	histHand.FaceColor = Chan2Color;
    histHand.EdgeColor = rgb(52, 73, 94);
    set(handles.handles.DoCAx(2), 'XLim', [-1 1]);
    xlabel(handles.handles.DoCAx(2), 'DoC Score Ch2 -> Ch1', 'Fontsize', 20);
    ylabel(handles.handles.DoCAx(2), 'Frequency','FontSize',20);
    set(handles.handles.DoCAx(2),'FontSize',20)

    drawnow;

    % Save the figure
    print(fullfile(Outputfolder, 'Clus-DoC Results', 'DoC Histograms', 'Pooled DoC histogram.tif'), ...
        handles.handles.DoCFig, '-dtiff');

    close gcf;
    
    save( 'Data_for_Cluster_Analysis.mat','Data_DoC','DensityROI'); %ROIData removed!


end
