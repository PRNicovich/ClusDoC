function ExportDBSCANDataToExcelFiles(cellROIPair, Result, outputFolder, chan)

    function y = isstructmissing(x)
        if isstruct(x) || isempty(x)
            y = false;
        else
            y = ismissing(x);
        end
    end

    % Formerly Final_Result_DBSCAN_GUIV2
    % Extracts and exports Results table into Excel format
    
    A = Result(:);
    
    %cellROIPair(cellfun('isempty', A), :) = []; % filter out empty ones --
    %appears that this isn't needed? cellROIPair is already smaller than A
    %at this point...
    
    notemptyA = ~cellfun('isempty', A); % empty array cells are not ROIs, they were unused placeholders in the matrix
    notmissingA = ~cellfun(@(x) isstructmissing(x), A); % missing cells are ROIs that had no interactions, and do no appear in the cellROIPair table; can't use ismissing directly because it fails with structs
    not_empty_or_missingA = notemptyA & notmissingA;
    
    Percent_in_Cluster_column(not_empty_or_missingA) = cell2mat(cellfun(@(x) x.Percent_in_Cluster, A(not_empty_or_missingA), 'UniformOutput', false));
    Number_column(not_empty_or_missingA) = cell2mat(cellfun(@(x) x.Number, A(not_empty_or_missingA), 'UniformOutput', false));
    Area_column(not_empty_or_missingA) = cell2mat(cellfun(@(x) x.Area, A(not_empty_or_missingA), 'UniformOutput', false));
    Density_column(not_empty_or_missingA) = cell2mat(cellfun(@(x) x.Density, A(not_empty_or_missingA), 'UniformOutput', false));
    RelativeDensity_column(not_empty_or_missingA) = cell2mat(cellfun(@(x) x.RelativeDensity, A(not_empty_or_missingA), 'UniformOutput', false));
    TotalNumber(not_empty_or_missingA) = cell2mat(cellfun(@(x) x.TotalNumber, A(not_empty_or_missingA), 'UniformOutput', false));
    Circularity_column(not_empty_or_missingA) = cell2mat(cellfun(@(x) x.Mean_Circularity, A(not_empty_or_missingA),'UniformOutput', false));
    Number_Cluster_column(not_empty_or_missingA) = cell2mat(cellfun(@(x) x.Number_Cluster, A(not_empty_or_missingA), 'UniformOutput', false));

    %export data into Excel

    HeaderArray=[{'Cell'},{'ROI'},{'x bottom corner'},{'y bottom corner'},{'Size of ROI (nm)'},{'Comments'},{'Percentage of molecules in clusters'},...
        {'Average number of molecules per cluster'}, {'Average cluster area (nm^2)'}, {'Abslute density in clusters (molecules / um^2)'}, ...
        {'Relative density in clusters'}, {'Total number of molecules in ROI'}, ...
        {'Circularity'}, {'Number of clusters in ROI'}, {'Density of clusters (clusters / um^2)'}];

    Matrix_Result = [Percent_in_Cluster_column(notemptyA)'*100 , Number_column(notemptyA)' , Area_column(notemptyA)' , Density_column(notemptyA)'*1e6 ,...
        RelativeDensity_column(notemptyA)', TotalNumber(notemptyA)', Circularity_column(notemptyA)', Number_Cluster_column(notemptyA)', Number_Cluster_column(notemptyA)'./(1e-6*cellROIPair(:,5))];
    
    try 
        
        disp('Export')
        disp(chan);

        xlswrite(fullfile(outputFolder, 'DBSCAN Results.xls'), cellROIPair, sprintf('Chan%d', chan), 'A2');
        xlswrite(fullfile(outputFolder, 'DBSCAN Results.xls'), HeaderArray, sprintf('Chan%d', chan), 'A1');
        xlswrite(fullfile(outputFolder, 'DBSCAN Results.xls'), Matrix_Result, sprintf('Chan%d', chan), 'G2');
        
    catch 
        % Catch error for xlswrite that exists on some machines
        % Format as text file and export to tab-delimited text file
     
        fprintf(1, 'Error in xlswrite.  Reverting to tab-delimited text file output.\n');
        
        assignin('base', 'cellROIPair', cellROIPair);
        assignin('base', 'HeaderArray', HeaderArray);
        assignin('base', 'Matrix_Result', Matrix_Result);
        
        matOut = [cellROIPair, nan(size(cellROIPair, 1), 1), Matrix_Result];
        fID = fopen(fullfile(outputFolder, sprintf('DBSCAN Results Chan%d.txt', chan)), 'w+');
        fprintf(fID, strcat(repmat('%s\t', 1, length(HeaderArray)-1), '%s\r\n'), HeaderArray{:});
        
        fmtString = strcat(repmat('%f\t', 1, length(HeaderArray)-1), '%f\r\n');
        
        for k = 1:size(matOut, 1)
            fprintf(fID, fmtString, matOut(k,:));
        end
        fclose(fID);
        
    end

end