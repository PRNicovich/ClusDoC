% Import data and regions files for DoC_DBSCAN_RipleyK_GUI

function [Cell_Ind, ROI, ROIPos, CellData, ROIData, Outputfolder] = ROI_Extractor_GUI_V2()

    handles = guidata(findobj('Tag', 'PALM GUI'));

    ROIData=[];
    % Dialogue box for region size
    prompt = {'Enter size of ROI(nm):'};
    dlg_title = 'Input';
    num_lines = 1;
    def = {num2str(handles.ROISize)};% Default value sizeROI=4000 in nm
    answer = inputdlg(prompt, dlg_title, num_lines, def);
    handles.ROISize = str2double(answer{1});

    % Dialogue box for coordinate file import
    [coordFileName, coordPathName, Filter_index] = uigetfile({'*.txt','TXT Data Files'}, 'Choose the coordinate file (ROI position) ');
    drawnow; pause(0.05);
    
    if Filter_index == 0
        error('No file selected');
    else
    
        handles.coordFileName = fullfile(coordPathName, coordFileName);
        Coordinates=importdata(handles.coordFileName);
        RegionXY = Coordinates.data(:,2:3);
        Table_nb = Coordinates.data(:,1);

        % Import different Tables 
        Table_index = unique(Table_nb);
        handles.dataFileName = cell(numel(Table_index), 1);
        TableData = cell(numel(Table_index), 1);
        
        for i = Table_index'
            handles.dataFileName{i} = strcat(coordPathName, num2str(i), '.txt');
            Imported_Data = importdata(handles.dataFileName{i});
            TableData{i,1} = Imported_Data.data;
            %XYTable{i,1}=Imported_Data.data(:,5:6);
        end

        %% Create vector for ROI name

        [val, indx] = unique (Table_nb);
        Cell_Ind = val;
        indx = [indx; length(Table_nb)+1];
        Numb_El = diff(indx);
        RegionName=[];
       
        for i = Numb_El'
            RegionName = [RegionName ; (1:i)'];
        end
        
        Table_nb(:,2) = RegionName;

        ROI = 10*RegionXY;
        %i=size(ROI,2);
        ROI(:,2) = 25600-ROI(:,2);
        ROI(:,3:4) = ROI;
        ROI(:,1:2) = Table_nb;
        ROIPos = ROI(:,1:2);
        
    %% Create the "Extracted Region" folder   
            if ~exist(fullfile(handles.Path_name, 'Extracted_Region'), 'dir')
                mkdir(fullfile(handles.Path_name, 'Extracted_Region'));
            end

    %% 
    
    Grand_Table = cell(size(ROI, 1), 5);
    AllData = cell(max(Table_nb(:,2)), max(Table_nb(:,1)));
    
    for i = 1:size(ROI,1)
        %xroi = [ROI(i,1)-sizeROI ROI(i,1)+sizeROI ROI(i,1)+sizeROI ROI(i,1)-sizeROI ROI(i,1)-sizeROI];
        %yroi = [ROI(i,2)+sizeROI ROI(i,2)+sizeROI ROI(i,2)-sizeROI ROI(i,2)-sizeROI ROI(i,2)+sizeROI];
        xroi = [ROI(i,3) - handles.ROISize/2, ROI(i,3) - handles.ROISize/2, ...
            ROI(i,3) + handles.ROISize/2 ROI(i,3), + handles.ROISize/2, ROI(i,3) - handles.ROISize/2];
        yroi = [ROI(i,4) - handles.ROISize/2, ROI(i,4) + handles.ROISize/2, ...
            ROI(i,4) + handles.ROISize/2 ROI(i,4), - handles.ROISize/2, ROI(i,4) - handles.ROISize/2];

        ROIPos(i,3:6) = [ROI(i,3) - handles.ROISize/2, ROI(i,4) - handles.ROISize/2, ...
            handles.ROISize handles.ROISize];
        XYROI = [xroi', yroi'];

        TableOI = TableData{Table_nb(i,1),1};
        x = TableOI(:,5);
        y = TableOI(:,6);
        XYin = inpolygon(x,y,XYROI(:,1),XYROI(:,2));

         Grand_Table{i,1} = Table_nb(i,1);
         Grand_Table{i,2} = Table_nb(i,2);
         Grand_Table{i,3} = XYROI;
         Grand_Table{i,4} = TableOI;
         Grand_Table{i,5} = TableOI(XYin,:);
%          TableIndex = Table_nb(i);
%          RegionIndex = Table_nb(i);
         AllData{Table_nb(i,2),Table_nb(i,1)} = TableOI(XYin,:);
         CellData = TableData;
         ROIData = AllData;


    end
    
    handles.AllData = AllData;
    handles.CellData = TableData;
%     handles.GrandTable = GrandTable;

    save(fullfile(handles.Path_name, 'Extracted_Region', 'AllData.mat'), 'AllData');
%     save(fullfile(handles.Path_name, 'Extracted_Region', 'Grand_Table.mat'), 'Grand_Table');
    save(fullfile(handles.Path_name, 'Extracted_Region', 'Region_and_Data.mat'), 'Cell_Ind','ROI','CellData', 'ROIData','ROIPos');
    
    Outputfolder = fullfile(handles.Path_name, 'Extracted_Region');
    
    guidata(handles.handles.MainFig, handles);

    end

end
        




