
% Input cell array.  
% In format {channel1FilePath, channel1ID;
%            channel2FilePath, channel2ID;....
%             };

fileInputArray = {'C:\Users\Rusty Nicovich\Documents\MATLAB\ClusDoC\Yue\568-1.csv', 1;
                  'C:\Users\Rusty Nicovich\Documents\MATLAB\ClusDoC\Yue\647-1.csv', 2};




% Assuming pixel size is identical for channel 1 and channel 2 data
chan1PixelSize = returnPixelSizeFromThunderSTORM(fileInputArray{1,1});

% Get data from files
% Loop over all in input array
% Concatenate data files as you go

Data = [];
saveName = '';
for k = 1:size(fileInputArray, 1)
    [headerHere, dataHere] = bodyTextFromThunderSTORM(fileInputArray{k, 1}, fileInputArray{k,2});
    Data = [Data; dataHere];
    
    [pathName, fileName] = fileparts(fileInputArray{k,1});
    if k == 1
        saveName = strcat(saveName, fileName);
    else
        saveName = strcat(saveName, ['+', fileName]);
    end
end


% Generate footer
Footer_text = generateFooterText(Data, chan1PixelSize);

Output.Header = Head_text{1};
Output.Data = Data;
Output.Footer = Footer_text;


% % Need to replace NaNs in ChiSquare column with '-inf'.
% Output.Data(isnan(Output.Data)) = -inf;
% Likely necessary, but work-around is commenting ClusDoC line 689

% Write output to file
writeZeissFormatFile(Output, pathName, saveName);

% Pull info out of metadata -protocol.txt file
function pixelSizenm = returnPixelSizeFromThunderSTORM(filepath)
    [folderPath, metaDataFile, ~] = fileparts(filepath);
    mdID = fopen(fullfile(folderPath, strcat(metaDataFile, '-protocol.txt')));

    if mdID ~= -1
        % proceed
        % Pull out pixel size
        md = textscan(mdID, '%s', 'delimiter', '\n');
        md = md{1};
        pixMD = ~cellfun(@isempty, strfind(md, 'pixel'));
        if sum(pixMD) ~= 1
            error('Format of protocol file incorrect');
        end

        splitMD = textscan(md{pixMD}, '%s %f,');
        pixelSizenm = splitMD{2};
        
   
    else
        error('Associated ThunderSTORM *-protocol.txt file not found. Please ensure file is correctly named an in same folder as data CSV file.');
    end
    
end

% Pull data from .csv file
function [Head_text, Data] = bodyTextFromThunderSTORM(filepath, channelID);

    fid = fopen(filepath);
    [~, ~, ext] = fileparts(filepath);
    if strcmp(ext, '.txt')
        TABCHAR = sprintf('\t');
    elseif strcmp(ext, '.csv')
        TABCHAR = sprintf(',');
    else
        error('File name extension not supported. File must be .txt or .csv');
    end

    idx = find(fgetl(fid) == TABCHAR);
    fseek(fid, 0, -1);

    % Pull headers
    format_spec = '%s';
    N_cols = numel(idx)+1; % Number of tabs in first line, plus 1

    [Head_text, Head_post] = textscan(fid, format_spec, N_cols, 'delimiter', TABCHAR);

    if (length(Head_text{1}) == 24) ||  (length(Head_text{1}) == 26) % Nikon file format
        format_spec = ['%s', repmat('%n', 1, N_cols - 1)]; 
    else % Zeiss file format
        Body_format = '%n';
        format_spec = repmat(Body_format, 1, numel(idx)+1);
    end
    [Body_text, Body_post] = textscan(fid, format_spec, 'delimiter', TABCHAR);
    
    Data = [Body_text{1}, Body_text{2}, ones(length(Body_text{1}), 1), ...
        zeros(length(Body_text{1}), 1), Body_text{3}, Body_text{4}, ...
        Body_text{10}, Body_text{6}, Body_text{8}, Body_text{9}, Body_text{5}, ...
        ones(length(Body_text{1}), 1)*channelID];
    
    
end

% Output to file in Zeiss 1.txt file format
function writeZeissFormatFile(Output, pathName, saveName)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Generate output file

    % Assemble into 1.txt file

    % Output to format of Zeiss 1.txt file.

    Header_string{1} = 'Index';
    Header_string{2} = 'First Frame';
    Header_string{3} = 'Number Frames';
    Header_string{4} = 'Frames Missing';
    Header_string{5} = 'Position X [nm]';
    Header_string{6} = 'Position Y [nm]';
    Header_string{7} = 'Precision [nm]';
    Header_string{8} = 'Number Photons';
    Header_string{9} = 'Background variance';
    Header_string{10} = 'Chi square';
    Header_string{11} = 'PSF width [nm]';
    Header_string{12} = 'Channel';

    
    Footer_string = cell(3, 1);
    Footer_string{1}{1} = 'VoxelSizeX';
    Footer_string{1}{2} = 'VoxelSizeY';
    Footer_string{1}{3} = 'ResolutionX';
    Footer_string{1}{4} = 'ResolutionY';
    Footer_string{1}{5} = 'SizeX';
    Footer_string{1}{6} = 'SizeY';

    Footer_matrix = Output.Footer{2};

    [Footer_string{3}{1}, Footer_string{3}{2}] = deal('um');
    [Footer_string{3}{3}, Footer_string{3}{4}, Footer_string{3}{5}, Footer_string{3}{6}] = deal([]);

    try
        fID = fopen(fullfile(pathName, strcat(saveName, '.txt')), 'w');

        % Header
        for k = 1:(length(Header_string))

            fprintf(fID, '%s\t', Header_string{k});

        end

        fprintf(fID, '\r\n');

        
        % Output table needs to be in order:
        % 1.  Index	
        % 2.  First Frame	
        % 3.  Number Frames	
        % 4.  Frames Missing	
        % 5.  Position X [nm]	
        % 6.  Position Y [nm]	
        % 7.  Precision [nm]	
        % 8.  Number Photons	
        % 9.  Background variance	
        % 10. Chi square	
        % 11. PSF width [nm]	
        % 12. Channel	

        % Body
        % Remake this with fprintf
        fprintf(fID, '%d\t%d\t%d\t%d\t%.1f\t%.1f\t%.1f\t%.0f\t%.2f\t%.2f\t%.1f\t%d \r\n', Output.Data');
        %dlmwrite(fullfile(Save_path, save_name), Output_matrix, 'delimiter', '\t', 'roffset', 0, 'newline', 'pc', '-append');
        fseek(fID, 0, 1);
        fprintf(fID, '\r\n');

        % Footer
        for k = 1:length(Footer_matrix)

            fprintf(fID, '%s : %f %s\r\n', Footer_string{1}{k}, Footer_matrix(k), Footer_string{3}{k});

        end
    catch me
        fclose('all');
        rethrow(me);
    end
end


% Generate footer from data and pixel size info
function Footer_text = generateFooterText(Data, pixelSizenm)

    Footer_text{1} = {'VoxelSizeX'; 'VoxelSizeY'; 'ResolutionX'; ...
                  'ResolutionY'; 'SizeX'; 'SizeY'};
    % [pixelSizenm/1e3 \mum, pixelSizenm/1e3 \mum, 0.1 \mum, 0.1 \mum, closest
    % power of 2, closest power of 2];
    closestPow2 = 2^max([ceil(log2(max(Data(:,5)/pixelSizenm))), ...
                  ceil(log2(max(Data(:,6)/pixelSizenm)))]);

    prevPow2 = 2^(log2(closestPow2)-1);
    outSmallBox = ((Data(:,5) > prevPow2*1e2) | (Data(:,6) > prevPow2*1e2));

    pctOutSmallBox = sum(outSmallBox)/numel(outSmallBox);
    if pctOutSmallBox < 0.05
    choice = questdlg(sprintf('%.f of %.f points (%.1d %%) are outside %.f x %.f pixel box.\n\nWould you like to truncate the field of view?', ....
                            sum(outSmallBox), numel(outSmallBox), pctOutSmallBox*100, prevPow2, prevPow2), ...
                    'Truncate master FOV', ...
                    sprintf('Truncate to %.f x %.f', prevPow2, prevPow2), ...
                    sprintf('Keep %.f x %.f', closestPow2, closestPow2), ...
                    sprintf('Truncate to %.f x %.f', prevPow2, prevPow2) );

        switch choice
            case sprintf('Truncate to %.f x %.f', prevPow2, prevPow2)

                Data(outSmallBox, :) = [];
                closestPow2 = prevPow2;

            case sprintf('Keep %.f x %.f', closestPow2, closestPow2)
                % Do nothing + keep size with closestPow2
            otherwise
                % Default is do nothing + keep size with closestPow2
        end
    end

Footer_text{2} = [pixelSizenm/1e3, pixelSizenm/1e3, 0.1, 0.1, ...
        closestPow2/0.1, closestPow2/0.1];
end