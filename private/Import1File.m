% Import1File will pull the data from a Zeiss 1.txt file given in string to
% filepath fname.  Output is structure with fields .Header, .Data, and
% .Footer.
% 
% 05/14/2017 added support for Nikon SMLM file import.  Data is extracted
% and placed into format to match 13-column Zeiss data file.

function [Output] = Import1File(fname)

filepath = fname;

fid = fopen(filepath);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Format-specific import:
% First entry in data is a '1' in the first column.  This should be the
% first numeral following a whole string of characters and white space.

% Issue with new file formats: a 13th column of data (Z Slice) is included
% in some files.  Check if it is present by counting tabs in the first
% line.
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

if length(Head_text{1}) == 24 % Nikon file format
    format_spec = ['%s', repmat('%n', 1, 23)]; 
else % Zeiss file format
    Body_format = '%n';
    format_spec = repmat(Body_format, 1, numel(idx)+1);
end
[Body_text, Body_post] = textscan(fid, format_spec, 'delimiter', TABCHAR);

% Odd end-of-file bit in Zeiss files I can't seem to replicate in
% MATLAB-generated files.  Going to just search for the first string in the
% footer and start from there. 
floc = [];
while 1
    ftloc = ftell(fid); % Get byte position of line you're on
    tline = fgetl(fid); % Read string from line
    if ~ischar(tline)
       break
    end
    
    if strfind(tline, 'VoxelSizeX');
        
        floc = strfind(tline, 'VoxelSizeX'); % Pull Start position of first string in footer
        
        break
    else
        floc = [];
    end
    
end

if ~isempty(floc)

    format_spec = '%s%f%s';
    % Try-catch block to solve file import error on some (old?) files
    try
        Footer_text = textscan(fid, format_spec, 'headerLines', 1, 'delimiter', ':');
        fseek(fid, (ftloc-floc), -1); % Footer starts at start of line where string match was found.

        VoxelSizeX = Footer_text{2}(1);
        VoxelSizeY = Footer_text{2}(2);
        ResolutionX = Footer_text{2}(3);
        ResolutionY = Footer_text{2}(4);
        SizeX = Footer_text{2}(5);
        SizeY = Footer_text{2}(6);
    
    catch
        % On some machines the 'headerLines' value has to be 0 to work.  Not sure
        % why this is the case.
        fseek(fid, (ftloc), -1);
        Footer_text = textscan(fid, format_spec, 'headerLines', 0, 'delimiter', ':');
        Footer_text{1}(end) = [];
        
        VoxelSizeX = Footer_text{2}(1);
        VoxelSizeY = Footer_text{2}(2);
        ResolutionX = Footer_text{2}(3);
        ResolutionY = Footer_text{2}(4);
        SizeX = Footer_text{2}(5);
        SizeY = Footer_text{2}(6);
    end
else
    Footer_text = '';
end

    % Assign variables pulled out of each step.
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
    % 13. Z Slice

    switch length(Body_text)
        
        case {10, 11} % ThunderSTORM format.  The user should have chosen the .csv file.  There's an associated XML-ish
                % .txt file that has metadata and at least the pixel size in it. 
                % This file must be the same name as the input but with
                % -protocol.txt appended.
                
                Data = [Body_text{1}, Body_text{2}, ones(length(Body_text{1}), 1), ...
                        zeros(length(Body_text{1}), 1), Body_text{3}, Body_text{4}, ...
                        Body_text{10}, Body_text{6}, Body_text{8}, Body_text{9}, Body_text{5}, ...
                        ones(length(Body_text{1}), 1), ones(length(Body_text{1}), 1)];
                
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
                % Example data was only single-channel data.  Assuming this
                % is true for all ThunderSTORM data from here and filling
                % in dummy '1' values for all channels. 
                
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

        case 12

            Data = [Body_text{1} Body_text{2} Body_text{3} Body_text{4} Body_text{5} Body_text{6}...
                Body_text{7} Body_text{8} Body_text{9} Body_text{10} Body_text{11} Body_text{12}];

        case 13

            Data = [Body_text{1} Body_text{2} Body_text{3} Body_text{4} Body_text{5} Body_text{6}...
                Body_text{7} Body_text{8} Body_text{9} Body_text{10} Body_text{11} Body_text{12} Body_text{13}];

        case 14
            
            Data = [Body_text{1} Body_text{2} Body_text{3} Body_text{4} Body_text{5} Body_text{6}...
                Body_text{7} Body_text{8} Body_text{9} Body_text{10} Body_text{11} Body_text{12} Body_text{13} Body_text{14}]; 
            
        case 15 % Files generated by Generate3DTestData give 15 columns for some reason

            Data = [Body_text{1} Body_text{2} Body_text{3} Body_text{4} Body_text{5} Body_text{6}...
                Body_text{7} Body_text{8} Body_text{9} Body_text{10} Body_text{11} Body_text{12} Body_text{13} Body_text{14}]; 
            
        case 24 % Nikon format

            % Need to get channel ID out of a string ID in the first
            % column

            channelID = ones(length(Body_text{1}), 1);
            possibleChannels = unique(Body_text{1});
            if length(unique(Body_text{1})) > 1
                for k = 1:length(possibleChannels)
                    channelID(strcmp(Body_text{1}, possibleChannels{k}), 1) = k;
                end
            end
            
            Data = [(1:(length(Body_text{1})))', Body_text{13}, Body_text{14}, zeros(length(Body_text{1}), 1), ...
                    Body_text{23}, Body_text{24}, Body_text{19}, Body_text{20}, Body_text{11}, zeros(length(Body_text{1}), 1), ...
                    Body_text{8}, channelID, Body_text{18}];
                
            % Take a crack at the Footer info based on knowledge of Nikon
            % imaging criteria and data in file.
            % 160 nm pixel size explicitly constrained.
            % Allow power of 2 for pixel number. 
            
            Footer_text{1} = {'VoxelSizeX'; 'VoxelSizeY'; 'ResolutionX'; ...
                              'ResolutionY'; 'SizeX'; 'SizeY'};
                     % [0.16 \mum, 0.16 \mum, 0.1 \mum, 0.1 \mum, closest
                     % power of 2, closest power of 2];
                     closestPow2 = 2^max([ceil(log2(max(Data(:,5)/160))), ...
                                          ceil(log2(max(Data(:,6)/160)))]);
                                      
                                      
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
                                 
                                 Data(((Data(:,5) > prevPow2*1e2) | (Data(:,6) > prevPow2*1e2)), :) = [];
                                 closestPow2 = prevPow2;
                                 
                             case sprintf('Keep %.f x %.f', closestPow2, closestPow2)
                                 
                                 % Do nothing + keep size with closestPow2
                                 
                             otherwise
                                 
                                 % Default is do nothing + keep size with closestPow2
                                 
                         end
                         
                     end
                                  
                     
                     
                     
            Footer_text{2} = [0.16, 0.16, 0.1, 0.1, closestPow2/0.1, closestPow2/0.1];

    end


    


Output.Header = Head_text{1};
Output.Data = Data;
Output.Footer = Footer_text;