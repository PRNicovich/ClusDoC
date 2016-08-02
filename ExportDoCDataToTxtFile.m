% ExportDoCDataToTxtFile
% Header columns are:
% Index	FirstFrame	NumFrames	FramesMissing	PostX[nm]	PostY[nm]
% Precision[nm]	NPhotons	BackVar	Chi^2	PSFwidth[nm]	Channel	ZSlice
% ROINum InOutMask ClusterIDNum DoCScore LrValue CrossChanDensity
% LrAboveThreshold AllChanDensity

handles = guidata(findobj('tag', 'PALM GUI'));
% handles.CoordFile = 'D:\MATLAB\ClusDoC\Test dataset with 6 cells\coordinates.txt'; 

% Export data as 21-column txt file to fileName_Export.txt in
% handles.Path_name folder


for fN = 1:length(handles.CellData)

    fileName = strcat(handles.ImportFiles{fN}(1:(end-4)), '_Export.txt');
    fprintf(1, 'Writing to file %s\n', fileName);

    fID = fopen(fileName, 'w+');

    headerString = sprintf('Index\tFirstFrame\tNumFrames\tNFramesMissing\tPostX[nm]\tPostY[nm]\tPrecision[nm]\tNPhotons\tBkgdVar\tChi^2\tPSFWidth[nm]\tChannel\tZSlice\tROINum\tInOutMask\tDoCScore\tLrValue\tCrossChanDensity\tLrAboveThreshold\tAllChanDensity\r\n');
    fprintf(fID, '%s', headerString);

    fmtStr = strcat(repmat('%d\t', 1, 4), repmat('%.1f\t', 1, 3), '%d\t%.4f\t%.4f\t%.1f\t%d\t%d\t%s\t%d\t%d\t%.4f\t%.4f\t%.4f\t%d\t%.4f\r\n');
    ROIIDStr = dec2bin(handles.CellData{fN}(:,14));
    for k = 1:size(handles.CellData{fN}, 1);

        fprintf(fID, fmtStr, handles.CellData{fN}(k,1:13), ROIIDStr(k, :), handles.CellData{fN}(k, 15:end));

    end

    fprintf(fID, '\r\n');
    fprintf(fID, '\r\n');
    % 
    % Footer contains info on data processing parameters
    fprintf(fID, '# SourceFile: %s\r\n', handles.ImportFiles{fN});
    fprintf(fID, '# CoordinatesFile: %s\r\n', handles.CoordFile);
    fprintf(fID, '# NROIs: %d\r\n', length(handles.ROICoordinates{fN}));

    if  handles.MaskCellPair(fN, 2) > 0
        fprintf(fID, '# MaskFile: %d\r\n', fullfile(handles.Path_name, handles.MaskFiles{handles.MaskCellPair(fN, 2)}));
    else
        fprintf(fID, '# MaskFile: %s\r\n', 'NoMask');
    end

    fprintf(fID, '# DBSCANEpsilon: %.3f\r\n', handles.DBSCAN.epsilon);
    fprintf(fID, '# DBSCANminPts: %d\r\n', handles.DBSCAN.minPts);
    fprintf(fID, '# DBSCANUseLr_Thresh: %d\r\n', handles.DBSCAN.UseLr_rThresh);
    fprintf(fID, '# DBSCANLr_rThreshRad: %.2f\r\n', handles.DBSCAN.Lr_rThreshRad);
    fprintf(fID, '# DBSCANSmoothingRad: %.2f\r\n', handles.DBSCAN.SmoothingRad);
    fprintf(fID, '# DBSCANCutoff: %.2f\r\n', handles.DBSCAN.Cutoff);
    fprintf(fID, '# DBSCANthreads: %d\r\n', handles.DBSCAN.threads);
    fprintf(fID, '# DoCLr_rRad: %.2f\r\n', handles.DoC.Lr_rRad);
    fprintf(fID, '# DoCRmax: %d\r\n', handles.DoC.Rmax);
    fprintf(fID, '# DoCStep: %d\r\n', handles.DoC.Step);
    fprintf(fID, '# DoCColocalizationThreshold: %.4f\r\n', handles.DoC.ColoThres);
    fprintf(fID, '\r\n');

    fclose(fID);
    
end