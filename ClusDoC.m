function ClusDoC(varargin)

    figObj = findobj('Tag', 'PALM GUI');
    if ~isempty(figObj)
        figure(figObj);
    else
        DoCGUIInitialize();
    end
    
end

function DoCGUIInitialize(varargin)

    figObj = findobj('Tag', 'PALM GUI');
    if ~isempty(figObj); % If figure already exists, clear it out and reset it.
        clf(figObj);
        handles = guidata(figObj);
        fig1 = figObj;
    else
        fig1 = figure('Name','Clus-DoC', 'Tag', 'PALM GUI', 'Units', 'pixels',...
            'Position',[700 150 924 780], 'color', [1 1 1]);%'Position',[0.05 0.3 760/scrsz(3) 650/scrsz(4)] );
        set(fig1, 'CloseRequestFcn', @CloseGUIFunction);

        handles.handles.MainFig = fig1;
    end

    fig1_size_pixels = getpixelposition(fig1);

    panel_border = 680/925-0.01;
    
    handles.handles.b_panel = uipanel(fig1, 'Units', 'normalized', 'Position', [0 0.05, 1-panel_border, 0.90], ...
        'BackgroundColor', [1 1 1], 'BorderType', 'none', 'Tag', 'b_panel');

    % b_panel1 = uipanel(fig1, 'Units', 'normalized', 'Position',[0 0, 1-panel_border, 0.5] , ...
    %     'BackgroundColor', [0.5 0.5 0.5], 'BorderType', 'none', 'Tag', 'b_panel');


    handles.handles.ax_panel = uipanel(fig1, 'Units', 'normalized', 'Position', [1-panel_border 0 panel_border .90], ...
        'BackgroundColor', [1 1 1], 'BorderType', 'none', 'Tag', 'ax_panel');
    set(0,'DefaultFigureColormap',jet)
    
    handles.handles.loadPanel = uipanel(fig1, 'Units', 'normalized', 'Position', [0 .9 1 .10], ...
        'BackgroundColor', [1 1 1], 'BorderType', 'none', 'Tag', 'loadPanel');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Load panel objects
    

        % Button
        handles.handles.Load_out =     uicontrol(handles.handles.loadPanel, 'Units', 'normalized', 'Style', 'pushbutton', 'String', 'Set Input Path',...
            'Position', [0.01    0.6410    0.1500    0.3290],...
            'Callback', @Load_Data, 'Tag', 'Set Input Path');
        
        handles.handles.Load_text = uicontrol(handles.handles.loadPanel, 'Style', 'edit', 'Units', 'normalized', ...
            'Position',[0.200    0.6667    0.6000    0.2264], 'BackgroundColor', [1 1 1], ...
            'String', 'Input Folder Path', 'Callback', @Load_edit, 'Tag', 'Load_textbox');
        
        handles.handles.OutputSet =     uicontrol(handles.handles.loadPanel, 'Units', 'normalized', 'Style', 'pushbutton', 'String', 'Set Output Path',...
            'Position', [0.01    0.2410    0.1500    0.3790],...
            'Callback', @Load_pts, 'Tag', 'Set Output Path');
        
        handles.handles.OutputText = uicontrol(handles.handles.loadPanel, 'Style', 'edit', 'Units', 'normalized', ...
            'Position',[0.200    0.2667    0.6000    0.2764], 'BackgroundColor', [1 1 1], ...
            'String', 'Output Folder Path', 'Callback', @OutputEdit, 'Tag', 'Load_textbox');
        
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Button
    % Define buttons and position.  Can continute this down to add more buttons
    % in the future.  Can modify button appearance here.  Addition of multiple
    % additional buttons may require an increase in figure size or decrease in
    % button size to keep all visible.

    % Button Dimensions - now in relative units.
    butt_width = .96;
    butt_height = .08;

    space1 = 0.01;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Button Panel 2

    % Load Zen Data
    h1=butt_height;
    w1=butt_width*2/3;

    xbutton=space1;
    ybutton=1-(space1+h1);
% 
%     handles.handles.hLoad_Zen =     uicontrol(handles.handles.b_panel, 'Units', 'normalized', 'Style', 'pushbutton', ...
%         'String', 'Set Input and Output Paths',...
%         'Position', [xbutton ybutton w1 h1],'Callback', @Load_Data, 'Tag', 'Load_Data');

    % Load a data set
    %       h1=butt_height;
    %       w2=butt_width*1/3;
    %
    %       xbutton2=space1+0.005+w1;
    %       ybutton2=ybutton;

    %     handles.handles.hLoad_DataSet= uicontrol(handles.handles.b_panel2, 'Units', 'normalized','Style','pushbutton','String','<html>Load <br>Dataset<html>',...
    %  'Position',[xbutton2 ybutton2 w2 h1], 'Callback', @Load_DataSet, 'Tag', 'SelectROI','enable','on');

    % Button Load individual cell
    h1=butt_height/2;
    w1=butt_width*2/3;

    xbutton=space1;
    ybutton=ybutton-(space1+h1);

    handles.handles.hLoad_cell =     uicontrol(handles.handles.b_panel, 'Units', 'normalized', 'Style', 'pushbutton', 'String', 'Load Cell',...
        'Position', [xbutton ybutton w1 h1], 'Callback', @Load_1Cell, 'Tag', 'Load_Cell');

    % Popupmenu for selected Cell
    h2=butt_height/3;
    w2=butt_width/3;

    xbutton2=space1+0.005+w1;
    ybutton2=ybutton+h1/4;

    handles.handles.popupCell2 =     uicontrol(handles.handles.b_panel, 'Units', 'normalized', 'Style', 'popup', 'String', {'Cell'},...
        'Position', [xbutton2 ybutton2 w2 h2],'Callback', @popupCell_Callback2, 'Tag', 'SelectCell');
    align([handles.handles.hLoad_cell, handles.handles.popupCell2],'None','Center');

    % PushButton to Create ROI
    h1=butt_height/2;
    w1=butt_width*2/3;

    xbutton=space1;
    ybutton=ybutton-(space1+h1);

    handles.handles.hCreateROI = uicontrol(handles.handles.b_panel, 'Units', 'normalized','Style','pushbutton','String','Create ROI',...
        'Position',[xbutton ybutton w1 h1],'Callback', @CreateROI, 'Tag', 'CreateROI','enable','off');

    % Popupmenu for selected ROI
    h2=butt_height/3;
    w2=butt_width/3;

    xbutton2=space1+0.005+w1;
    ybutton2=ybutton+h1/4;

    handles.handles.popupROI2 = uicontrol(handles.handles.b_panel, 'Units', 'normalized', 'Style', 'popup', 'String', {'ROI'},...
        'Position', [xbutton2 ybutton2 w2 h2], 'Callback', @popupROI_Callback2, 'Tag', 'SelectROI');

    % Select ROI
    h1=butt_height/2;
    w1=butt_width*2/5-space1/2;

    xbutton=space1;
    ybutton=ybutton-(space1+h1);

    handles.handles.hSelectROI = uicontrol(handles.handles.b_panel, 'Units', 'normalized','Style','pushbutton','String','Select',...
        'Position',[xbutton ybutton w1 h1],'Callback', @SelectROI, 'Tag', 'SelectROI','enable','off');

    % Save Cells and ROIs set
    h2=butt_height/2;
    w2=butt_width*3/5-space1/2;

    xbutton=w1+2*space1;
    %       ybutton=ybutton;

    handles.handles.hSaveCellROI = uicontrol(handles.handles.b_panel, 'Units', 'normalized','Style','pushbutton','String','Save Cells & ROI',...
        'Position',[xbutton ybutton w2 h2],'Callback', @SaveCellROI, 'Tag', 'SelectROI','enable','off');

    % Button RipleyK test for Active ROI
    h1=butt_height/2;
    w1=butt_width/2-space1/2;

    xbutton=space1;
    ybutton=ybutton-(space1+h1);

    handles.handles.hRipleyActiveROI = uicontrol(handles.handles.b_panel, 'Units', 'normalized', 'Style', 'pushbutton', 'String', 'RipleyK Test',...
        'Position', [xbutton ybutton w1 h1], 'Callback', @RipleyKtest, 'Tag', 'RipleyK_test','enable','off');

    % Button DBSCAN test for Active ROI
    h1=butt_height/2;
    w2=butt_width/2-space1/2;

    xbutton=w1+2*space1;
    %     ybutton=ybutton;

    handles.handles.hDBSCANActiveROI = uicontrol(handles.handles.b_panel, 'Units', 'normalized', 'Style', 'pushbutton', 'String', 'DBSCAN Test',...
        'Position', [xbutton ybutton w2 h1],'Callback', @DBSCAN_Test, 'Tag', 'DBSCAN_test','enable','off');

    % Button RipleyK for Selected ROIs
    h1=butt_height/2;
    w1=butt_width;

    xbutton=space1;
    ybutton=ybutton-(space1+h1);

    handles.handles.hRipleyK_All = uicontrol(handles.handles.b_panel, 'Units', 'normalized', 'Style', 'pushbutton', 'String', 'RipleyK for All',...
        'Position', [xbutton ybutton w1 h1], 'Callback', @RipleyK_All, 'Tag', 'RipleyK_ROI','enable','off');

    % Button DBSCAN for Selected ROIs
    h1=butt_height/2;
    w1=butt_width;

    xbutton=space1;
    ybutton=ybutton-(space1+h1);

    handles.handles.hDBSCAN_All = uicontrol(handles.handles.b_panel, 'Units', 'normalized', 'Style', 'pushbutton', 'String', 'DBSCAN for All',...
        'Position', [xbutton ybutton w1 h1], 'Callback', @DBSCAN_All, 'Tag', 'DBSCAN_All','enable','off');

    % Button Degree of colocalisation
    h1=butt_height/2;
    w1=butt_width;

    xbutton=space1;
    ybutton=ybutton-(space1+h1);

    handles.handles.hDoC_All1 = uicontrol(handles.handles.b_panel, 'Units', 'normalized', 'Style', 'pushbutton', 'String', 'Clus-DoC for All',...
        'Position', [xbutton ybutton w1 h1], 'Callback', @DoC_All, 'Tag', 'DoC_All','enable','off');

    % Button Reset
    h1=butt_height/2;
    w1=butt_width;

    xbutton=space1;
    ybutton=ybutton-(space1+h1);
    handles.handles.hreset = uicontrol(handles.handles.b_panel, 'Units', 'normalized', 'Style', 'pushbutton', 'String', 'Reset',...
        'Position', [xbutton ybutton w1 h1], 'Callback', @Reset, 'Tag', 'Reset','enable','on');

    % End of buttons
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Axes initialization

    handles.handles.ax_h = axes('Parent', handles.handles.ax_panel, 'Position', [0.005 .01 .99 .98]);
    set(handles.handles.ax_h, 'Tag', 'PALM GUI axis');
    % initialize data to put into the axes on startup
    z=peaks(1000);
    z = z./max(abs(z(:)));
    fill_image = imshow(z, 'Parent', handles.handles.ax_h, 'ColorMap', jet, 'DisplayRange', [min(z(:)) max(z(:))]);
    set(fill_image, 'Tag', 'fill_image', 'HitTest', 'on');

    % Get rid of tick labels
    set(handles.handles.ax_h, 'xtick', [], 'ytick', [])
    axis(handles.handles.ax_h, 'image'); % Freezes axis aspect ratio to that of the initial image - disallows skewing due to figure reshaping.

    guidata(fig1, handles);
    initializeParameters();
    
end
    
function initializeParameters(varargin)

    % Set initial parameters for calculation + display parameters

    handles = guidata(findobj('Tag', 'PALM GUI'));
    
    % Initialize structure to pass values between GUI components
    handles.CellData = {};
    handles.ROIData = {};
    handles.ROIPos = [];
    handles.CurrentCellData = [];
    handles.CurrentROIData = [];

    % Default ROI settings
    handles.ROISize = 4000; % Length of ROI, in nm

    % Initialize some global settings
    handles.Chan1Color = [46, 204, 113]/255; % Flat UI Emerald
    handles.Chan2Color = [231, 76, 60]/255; % Flat UI Alizarin
    handles.UnselectedROIColor = [142, 68, 173]/255; % Flat UI Peter River
    handles.ROIColor = [155, 89, 182]/255; % Flat UI Amethyst
    
    % Default RipleyK settings
    handles.RipleyK.Start = 0;
    handles.RipleyK.End = 1000;
    handles.RipleyK.Step = 10;
    handles.RipleyK.MaxSampledPts = 1e4;
    
    % Default DBSCAN parameters
    handles.DBSCAN.epsilon = 20;
    handles.DBSCAN.minPts = 3;
    handles.DBSCAN.UseLr_rThresh = true;
    handles.DBSCAN.Lr_rThreshRad = 50;
    handles.DBSCAN.SmoothingRad = 15;
    handles.DBSCAN.Cutoff = 10;
    handles.DBSCAN.threads = 2;
    handles.DBSCAN.DoStats = true;
    
    % Default DoC parameters
    handles.DoC.Lr_rRad = 20;
    handles.DoC.Rmax = 500;
    handles.DoC.Step = 10;
    
    % Send back to main figure
    guidata(handles.handles.MainFig, handles);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback functions

% Plot SMLM data
function FunPlot(Data1)

    handles = guidata(findobj('Tag', 'PALM GUI'));

    if numel(unique(Data1(:,12))) == 1
        handles.handles.dSTORM_plot = plot(handles.handles.ax_h, Data1(:,5), Data1(:,6),'Marker','.','MarkerSize',3,'LineStyle','none',...
            'color','red', 'Tag', 'dSTORM_plot');
    else
        handles.handles.dSTORM_plot = plot(handles.handles.ax_h, Data1(Data1(:, 12) == 1, 5), Data1(Data1(:, 12) == 1, 6),...
            'Marker','.','MarkerSize',3,'LineStyle', 'none', 'color', handles.Chan1Color, 'Tag', 'dSTORM_plot');
        set(handles.handles.ax_h, 'NextPlot', 'add');
        handles.handles.dSTORM_plot = plot(handles.handles.ax_h, Data1(Data1(:, 12) == 2, 5), Data1(Data1(:, 12) == 2, 6), ...
            'Marker','.','MarkerSize',3,'LineStyle','none','color', handles.Chan2Color, 'Tag', 'dSTORM_plot');
        set(handles.handles.ax_h, 'NextPlot', 'replace');
    end

    set(handles.handles.ax_h, 'xtick', [], 'ytick', [], 'Position', [0.005 .01 .99 .955])
    axis image % Freezes axis aspect ratio to that of the initial image -



end

function handOut = plotAllROIs(handles)
    % Plot all ROIs in current window

    handles.CurrentCellROI = handles.ROIPos(handles.ROIPos(:,1) == handles.CellVal,3:6);
    handles.CurrentData = handles.ROIData{handles.ROIVal, handles.CellVal};
    for i = 1:size(handles.CurrentCellROI,1)
        rectangle('Position', handles.CurrentCellROI(i,:), 'LineWidth',2, 'EdgeColor', handles.UnselectedROIColor);
    end

    handles.CurrentROI = handles.ROIPos(handles.ROIPos(:,1) == handles.CellVal & handles.ROIPos(:,2) == handles.ROIVal, 3:6);

    % If there's already an imrect object in the axes, delete it.
    delete(findobj('tag', 'imrect', 'parent', handles.handles.ax_h));

    % Create a ROI imrect object
    handles.hROI = imrect(handles.handles.ax_h, handles.CurrentROI);
    setColor(handles.hROI, handles.ROIColor);
    title(strcat('Number Ch1, Number Ch2, Size :', mat2str(numberPerROI(handles.CurrentROI, handles.CellData{1,1}))));
    fcn1=@(x) [x(1) x(2) ceil(x(3)/1000)*1000 ceil(x(3)/1000)*1000];
    fcn2 = makeConstrainToRectFcn('imrect', get(handles.handles.ax_h,'XLim'), get(handles.handles.ax_h,'YLim'));
    fcn3=@(x) (fcn2(fcn1(x)));
    setPositionConstraintFcn(handles.hROI,fcn3)
    addNewPositionCallback(handles.hROI, @(p)title(strcat('Number Ch1, Number Ch2, Size :', mat2str(numberPerROI(p, handles.CellData{1,1})))));

    handOut = handles;

end

function Result = numberPerROI(CurrentROI, Data1)

    if numel(unique(Data1(:,12))) == 1

        [ xyCh1, ~] = Cropping_Fun(Data1(:,5:6),CurrentROI);
        NCh1 = length(xyCh1);
        Result = [NCh1 0 CurrentROI(3)];

    else
        [ xyCh1, ~] = Cropping_Fun(Data1(Data1(:,12)==1,5:6),CurrentROI);
        NCh1 = length(xyCh1);
        [ xyCh2, ~] = Cropping_Fun(Data1(Data1(:,12)==2,5:6),CurrentROI);
        NCh2 = length(xyCh2);
        Result = [NCh1 NCh2 CurrentROI(3)];
    end

end


function Load_Data(~,~,~)
    % Master load function
    % Given a folder, it'll first check if a .mat file exists
    % Given a coordinates file, it loads all data from a folder where file
    % name of data file corresponds to name given in coordinates.txt file
    % The SMLM image from the first data file is then displayed with
    % associated regions from coordinates.txt file

    handles = guidata(findobj('Tag', 'PALM GUI'));

    set(get(handles.handles.b_panel, 'children'), 'enable', 'off');


    % Set the load button to either accept a .mat file or the
    % coordinates.txt file as input.  Do load procedure as necessary given
    % input file type.

    handles.Path_name = uigetdir([],'Select the folder containing your data and region from Zen');
    if exist(fullfile(handles.Path_name, 'Extracted_Region/Region_and_Data.mat'), 'file') == 2
        RegAndData = load(fullfile(handles.Path_name, 'Extracted_Region/Region_and_Data.mat'));
        handles.Cell_Ind = RegAndData.Cell_Ind;
        handles.ROI = RegAndData.ROI;
        handles.ROIPos = RegAndData.ROIPos;
        handles.CellData = RegAndData.CellData;
        handles.ROIData = RegAndData.ROIData;
    else
        guidata(handles.handles.MainFig, handles);
        [handles.Cell_Ind, handles.ROI, handles.ROIPos, handles.CellData, handles.ROIData, handles.Outputfolder]=ROI_Extractor_GUI_V2();
    end

    % ROIData is all data in a single ROI, regardless of channel.
    
    unique(handles.ROIPos(:,1));
    handles.CellList = cellstr(num2str(unique(handles.ROIPos(:,1))));
    set(handles.handles.popupCell2,'String', handles.CellList);
    handles.CellVal = handles.handles.popupCell2.Value;

    handles.ROIList=cellstr(num2str(handles.ROIPos(handles.ROIPos(:,1) == handles.CellVal,2)));
    set(handles.handles.popupROI2, 'String', handles.ROIList);
    handles.ROIVal = handles.handles.popupROI2.Value;

    handles.Nchannels = numel(unique(handles.CellData{1,1}(:,12)));
    
    % Plot the first cell
    FunPlot(handles.CellData{1,1});

    % Plot all ROIs and make a imrect object

    handles = plotAllROIs(handles);

    % Set the button
   
    

    % Set output folder to match
    set(handles.handles.Load_text, 'String', handles.Path_name);
    
    if exist(fullfile(handles.Path_name, 'Extracted_Region'), 'dir') == 7
        set(handles.handles.OutputText, 'String', fullfile(handles.Path_name, 'Extracted_Region'));
        set(get(handles.handles.b_panel, 'children'), 'enable', 'on');
    else
        set(handles.handles.OutputText, 'String', 'Set Output Folder Before Proceeding');
    end
    

    guidata(handles.handles.MainFig, handles)
end

function OutputEdit(varargin)

    handles = guidata(findobj('Tag', 'PALM GUI'));
    set(get(handles.handles.b_panel, 'children'), 'enable', 'off');

    handles.Outputfolder = uigetdir(handles.Path_name, 'Choose or Create an output folder');
    
    set(handles.handles.OutputText, 'String', handles.OutputFolder);
    
    set(get(handles.handles.b_panel, 'children'), 'enable', 'off');

end
% function Load_DataSet(~, ~, ~)
% % Here only a .mat file is accepted as input (given a folder).  This should
% % be covered in Load_data function
%
% handles = guidata(findobj('Tag', 'PALM GUI'));
%
% Path_name = uigetdir([],'Select the folder containing your data');
%
%     if exist(fullfile('Extracted_Region/Region_and_Data.mat')
%
%         S=load('Extracted_Region/Region_and_Data.mat');
%         CellData=S.CellData;
%         ROIData=S.ROIData;
%         ROIPos=S.ROIPos;
%
%         unique(ROIPos(:,1));
%         CellList=cellstr(num2str(unique(ROIPos(:,1))));
%         set(popupCell2,'String', CellList);
%         CellVal=1;
%         ROIList=cellstr(num2str(ROIPos(ROIPos(:,1)==CellVal,2)));
%         set(popupROI2,'String', ROIList);
%         ROIVal=popupROI2.Value;
%
%         % Plot the first cell
%         Data1=CellData{1,1};
%         Ch1Ch2=(length(unique(Data1(:,12)))==1);
%         FunPlot(Data1,Ch1Ch2)
%
%         CurrentCellROI=ROIPos(ROIPos(:,1)==CellVal,3:6);
%         CurrentData=ROIData{ROIVal,CellVal};
%         for i=1:size(CurrentCellROI,1)
%             rectangle('Position',CurrentCellROI(i,:), 'LineWidth',1, 'EdgeColor','b');
%         end
%
%         CurrentROI=ROIPos(ROIPos(:,1)==CellVal & ROIPos(:,2)==ROIVal,3:6);
%
%         % Create a ROI
%         hROI = imrect(gca,CurrentROI);
%         setColor(hROI,'m')
%         title(strcat('Number Ch1, Number Ch2, Size :',mat2str(numberPerROI(CurrentROI,Data1,Ch1Ch2))))
%         fcn1=@(x) [x(1) x(2) ceil(x(3)/1000)*1000 ceil(x(3)/1000)*1000];
%         fcn2 = makeConstrainToRectFcn('imrect',get(gca,'XLim'),get(gca,'YLim'));
%         fcn3=@(x) (fcn2(fcn1(x)));
%         setPositionConstraintFcn(hROI,fcn3)
%         addNewPositionCallback(hROI,@(p)title(strcat('Number Ch1, Number Ch2, Size :',mat2str(numberPerROI(p,Data1,Ch1Ch2)))));
%
%         set(hRipleyActiveROI,'enable','on');
%         set(hDBSCANActiveROI,'enable','on');
%         set(hRipleyK_All,'enable','on');
%         set(hDBSCAN_All,'enable','on');
%         set(hDoC_All1,'enable','on');
%
%
%         Outputfolder=uigetdir(Path_name,'Choose or Create a Output folder');
%         cd(Outputfolder)
%
%         handles.Path_name=Path_name;
%         handles.hROI=hROI;
%         handles.ROIPos=ROIPos;
%         handles.CellData=CellData;
%         handles.ROIData=ROIData;
%         handles.CurrentData=CurrentData;
%         handles.Outputfolder=Outputfolder;
%
%
%         else
%             h = msgbox({'There is existing Data set' 'Load Cells'});
%     end
%
%     guidata(fig1,handles)
%
% end

function Load_1Cell(~, ~, ~)
    % Load single cell from a folder with multiple cells.
    % Coordinates.txt file need not exist
    % No ROIs created

    handles = guidata(findobj('Tag', 'PALM GUI'));

    % Get path to file name.  Look only for .txt files in each folder.
    [File_name, Path_name, Filter_index] = uigetfile({'*.txt','TXT Data Files'},'Select a table file (e.g. 1.txt)');

    if Filter_index == 0

        error('No file selected');

    else

        handles.LoadCellName = fullfile(Path_name, File_name);
        FullData = importdata(handles.LoadCellName);
        handles.CurrentCellData = FullData.data;
        % Record Load_name to handles structure attached to fig1 for future
        % retreival by other functions.

        % Plot data in this cell
        Ch1Ch2 = (numel(unique(handles.CurrentCellData(:,12))) == 1);
        FunPlot(handles.CurrentCellData, Ch1Ch2)

        % Set the popupmenu
        % ROI
        set(handles.handles.popupROI2, 'String', {'ROI'});
        set(handles.handles.popupROI2, 'Value', 1);
        % Cell
        handles.CellList = popupCell2.String;
        if strcmp(handles.CellList{1}, 'Cell')
            set(handles.handles.popupCell2,'String', {'1'});
            set(handles.handles.popupCell2,'Value', 1);
            %handles.CellData=CurrentCellData
            handles.CellData{1} = handles.CurrentCellData;
        else
            i = str2double(handles.CellList{end})+1;
            handles.CellList = [handles.CellList;num2str(i)];
            handles.CellData{i} = handles.CurrentCellData;

            %handles.CellData=CellData;
            set(handles.handles.popupCell2, 'String', handles.CellList);
            set(handles.handles.popupCell2, 'Value', i);
        end

        % set the buttons allowance
        set(handles.handles.hCreateROI, 'enable', 'on');
        set(handles.handles.hSelectROI, 'enable', 'off');
        set(handles.handles.hSaveCellROI, 'enable', 'off');
        set(handles.handles.hRipleyK_All, 'enable', 'off');
        set(handles.handles.hRipleyActiveROI, 'enable', 'off');
        set(handles.handles.hDBSCANActiveROI, 'enable', 'off');

        handles.CurrentROI=[];

        guidata(handles.handles.MainFig, handles);

    end

end

function popupCell_Callback2(~,~,~)
    % Called to update popup for which cell is currently displayed.

    handles = guidata(findobj('Tag', 'PALM GUI'));

    CellVal = popupCell2.Value;
    CellString = popupCell2.String;

    if length(CellString) > 1

        ListROI = cellstr(num2str(handles.ROIPos(handles.ROIPos(:,1) == CellVal,2)));
        set(handles.handles.popupROI2, 'String', ListROI);
        set(handles.handles.popupROI2, 'Value', 1);
        handles.ROIVal = 1;
        % Plot newly-selected cell
        FunPlot(handles.CellData{CellVal});

        % Plot all of the relevant ROIs
        handles = plotAllROIs(handles);


    end
    guidata(handles.handles.MainFig, handles);

end

function CreateROI(~, ~, ~)

    handles = guidata(findobj('Tag', 'PALM GUI'));

    % If ROI already exists, delete it
    delete(findobj('Tag', 'imrect', 'parent', handles.handles.ax_h));

    % Create a ROI at 4000 nm
    fcn1=@(x) [x(1) x(2) ceil(x(3)/1000)*1000 ceil(x(3)/1000)*1000];
    fcn2 = makeConstrainToRectFcn('imrect', get(handles.handles.ax_h,'XLim'), get(handles.handles.ax_h,'YLim'));
    fcn3=@(x) (fcn2(fcn1(x)));
    handles.hROI = imrect(handles.handles.ax_h, 'PositionConstraintFcn', fcn3);
    addNewPositionCallback(handles.hROI, @(p)title(strcat('Number, height, width :', mat2str(numberPerROI(p)))));
    setColor(handles.hROI, handles.ROIColor);

    set(handles.handles.hCreateROI,'enable','off');
    set(handles.handles.hSelectROI,'enable','on');
    set(handles.handles.hRipleyActiveROI,'enable','on');
    set(handles.handles.hDBSCANActiveROI,'enable','on');

        function Result = numberPerROI(CurrentROI)

            [ x, ~] = Cropping_Fun(handles.CellData(:,5:6),CurrentROI);
            Result=[length(x) CurrentROI(3) CurrentROI(4)];

        end

    guidata(handles.handles.MainFig, handles);

end

function SelectROI(~, ~, ~)

    handles = guidata(findobj('Tag', 'PALM GUI'));

    %         CurrentCellData=handles.CurrentCellData;
    %         CellData=handles.CellData;
    CellValue = handles.handles.popupCell2.Value;
    %ROIValue=popupROI2.Value;

    %         CurrentCellData = handles.CellData{CellValue};
    %         whos CurrentCellData
    % Crop the selection
    CurrentROI = getPosition(handles.hROI);
    %         Data1 = CurrentCellData(:,5:6);
    [~, Index_In] = Cropping_Fun(handles.CurrentCellData{CellValue}(:,5:6), CurrentROI);
    CurrentROIData = handles.CellData{CellValue}(Index_In,:);

    ROIList = handles.handles.popupROI2.String;

    %ROIList{1}
    if strcmp(ROIList{1},'ROI')
        ROIList={'1'};
        handles.ROIPos = CurrentROI;

        handles.ROIData{1,CellValue} = CurrentROIData;
        set(handles.handles.popupROI2,'Value', 1);
    else

        i=str2double(ROIList{end})+1;
        ROIList=[ROIList;num2str(i)];

        handles.ROIPos = [handles.ROIPos; CellValue i CurrentROI];
        handles.ROIData{i,CellValue} = CurrentROIData;
        set(handles.handles.popupROI2,'Value', i);
    end

    rectangle('Position',CurrentROI, 'LineWidth',1, 'EdgeColor','b');
    setColor(handles.hROI, handles.ROIColor)
    set(handles.handles.popupROI2, 'String', ROIList);
    set(hSaveCellROI,'enable','on');

    ROIVal = handles.handles.popupROI2.Value;
    handles.ROIPos = [handles.ROIPos; [CellValue ROIVal CurrentROI]];
    handles.CurrentData = handles.ROIData{ROIVal,CellValue};

    guidata(handles.handles.MainFig, handles);

end

function popupROI_Callback2(~,~,~)

    handles = guidata(findobj('Tag', 'PALM GUI'));

    ROIVal = handles.handles.popupROI2.Value;
    CellVal= handles.handles.popupCell2.Value;
    %         ROIPos = handles.ROIPos;
    %         hROI = handles.hROI;
    %         ROIData=handles.ROIData;

    %         ROIString=popupROI2.String;
    %         CellString=popupCell2.String;

    ROIPos2= handles.ROIPos(handles.ROIPos(:,1) == CellVal, :);
    CurrentROI=ROIPos2(ROIPos2(:,2)==ROIVal, 3:6);
    setPosition(handles.hROI, CurrentROI)
    setColor(handles.hROI, handles.ROIColor)
    set(handles.handles.hRipleyActiveROI, 'enable', 'on');
    set(handles.handles.hDBSCANActiveROI, 'enable', 'on');


    guidata(handles.handles.MainFig, handles);

end

% Save the cell and ROI in matlab folder
function SaveCellROI(~,~,~)

    handles = guidata(findobj('Tag', 'PALM GUI'));

    set(handles.handles.hSaveCellROI, 'enable', 'off');
    set(handles.handles.hSaveCellROI, 'Backgroundcolor', 'r');

    handles.Outputfolder = uigetdir(handles.Path_name, 'Choose or Create a Output folder');
    %         cd(Outputfolder)

    if ~exist(strcat(handles.Outputfolder,'\Extracted_Region'),'dir')
        mkdir('Extracted_Region');
    end

    save(fullfile(handles.Outputfolder, 'Extracted_Region', 'Region_and_Data.mat'), 'ROIPos', 'ROIData', 'CellData');
    save(fullfile(handles.Outputfolder, 'Extracted_Region', 'AllData.mat'), 'AllData');

    set(handles.handles.hSaveCellROI, 'enable', 'on');
    set(handles.handles.hSaveCellROI, 'Backgroundcolor', [0.94 0.94 0.94]);
    set(handles.handles.hRipleyK_All, 'enable', 'on');
    set(handles.handles.hDBSCAN_All, 'enable', 'on');
    set(handles.handles.hDoC_All1, 'enable', 'on');

    guidata(handles.handles.MainFig, handles);

end

% Pop-up window to set RipleyK parameters
function returnValue = setRipleyKParameters(handles)

    handles.handles.RipleyKSettingsFig = figure();
    set(handles.handles.RipleyKSettingsFig, 'Tag', 'ClusDoC');
    resizeFig(handles.handles.RipleyKSettingsFig, [220 180]);
    set(handles.handles.RipleyKSettingsFig, 'toolbar', 'none', 'menubar', 'none', ...
        'name', 'Ripley K Parameters');
  
	handles.handles.RipleyKSettingsTitleText(2) = uicontrol('Style', 'text', ...
        'String', '_____________________', 'parent', handles.handles.RipleyKSettingsFig,...
        'Position', [0 153 220 20], 'horizontalalignment', 'center', 'Fontsize', 10);

	handles.handles.RipleyKSettingsTitleText(1) = uicontrol('Style', 'text', ...
        'String', 'Ripley K Parameters', 'parent', handles.handles.RipleyKSettingsFig,...
        'Position', [0 158 220 20], 'horizontalalignment', 'center', 'Fontsize', 10);
    
    handles.handles.RipleyKSettingsText(1) = uicontrol('Style', 'text', ...
        'String', 'Start (nm):', 'parent', handles.handles.RipleyKSettingsFig,...
        'Position', [20 127 65 20]);
    
    handles.handles.RipleyKSettingsText(2) = uicontrol('Style', 'text', ...
        'String', 'End (nm):', 'parent', handles.handles.RipleyKSettingsFig,...
        'Position', [20 97 65 20]);
    
    handles.handles.RipleyKSettingsText(3) = uicontrol('Style', 'text', ...
        'String', 'Step (nm):', 'parent', handles.handles.RipleyKSettingsFig,...
        'Position', [20 67 65 20]);
    
    handles.handles.RipleyKSettingsText(4) = uicontrol('Style', 'text', ...
        'String', 'Max Points:', 'parent', handles.handles.RipleyKSettingsFig,...
        'Position', [20 37 65 20]);
    
    handles.handles.RipleyKSettingsEdit(1) = uicontrol('Style', 'edit', ...
        'String', num2str(handles.RipleyK.Start), 'parent', handles.handles.RipleyKSettingsFig,...
        'Position', [110 127 80 20]);
    
    handles.handles.RipleyKSettingsEdit(2) = uicontrol('Style', 'edit', ...
        'String', num2str(handles.RipleyK.End), 'parent', handles.handles.RipleyKSettingsFig,...
        'Position', [110 97 80 20]);
    
    handles.handles.RipleyKSettingsEdit(3) = uicontrol('Style', 'edit', ...
        'String', num2str(handles.RipleyK.Step), 'parent', handles.handles.RipleyKSettingsFig,...
        'Position', [110 67 80 20]);
    
    handles.handles.RipleyKSettingsEdit(4) = uicontrol('Style', 'edit', ...
        'String', num2str(handles.RipleyK.MaxSampledPts), 'parent', handles.handles.RipleyKSettingsFig,...
        'Position', [110 37 80 20]);
    
    set(handles.handles.RipleyKSettingsEdit, 'Callback', @RipleyKCheckEditBox);
    
    handles.handles.RipleyKSettingsButton = uicontrol('Style', 'pushbutton', ...
        'String', 'Continue', 'parent', handles.handles.RipleyKSettingsFig, ...
        'Position', [133 2 85 30], 'Callback', @RipleyKSetAndContinue);

    set(handles.handles.RipleyKSettingsFig, 'CloseRequestFcn', @RipleyKCloseOutWindow);
    
    uiwait;
    
    function RipleyKCloseOutWindow(varargin)
        % Cancel, don't execute further
        returnValue = 0;
        uiresume;
        delete(handles.handles.RipleyKSettingsFig);
    end

    function RipleyKCheckEditBox(hObj, varargin)
        
        input = str2double(get(hObj,'string'));
        if isnan(input) 
            
            errordlg('You must enter a numeric value','Invalid Input','modal');
%             return;
        elseif input < 0
            
            errordlg('Value must be positive','Invalid Input','modal');
%             return;
        else
            % continue
        end

    end

    function RipleyKSetAndContinue(varargin)
        
        % Collect inputs and set parameters in guidata
     	handles.RipleyK.Start = str2double(get(handles.handles.RipleyKSettingsEdit(1),'string'));
        handles.RipleyK.End = str2double(get(handles.handles.RipleyKSettingsEdit(2),'string'));
        handles.RipleyK.Step = str2double(get(handles.handles.RipleyKSettingsEdit(3),'string'));
        handles.RipleyK.MaxSampledPts = str2double(get(handles.handles.RipleyKSettingsEdit(4),'string'));
                
        returnValue = 1;
        guidata(handles.handles.MainFig, handles);
        uiresume;
        delete(handles.handles.RipleyKSettingsFig);
        
    end
    
end

% Pop-up window to set DBSCAN parameters
function returnValue = setDBSCANParameters(handles)

   handles.handles.DBSCANSettingsFig = figure();
   set(handles.handles.DBSCANSettingsFig, 'Tag', 'ClusDoC');
    resizeFig(handles.handles.DBSCANSettingsFig, [250 210]);
    set(handles.handles.DBSCANSettingsFig, 'toolbar', 'none', 'menubar', 'none', ...
        'name', 'DBSCAN Parameters');
  
	handles.handles.DBSCANSettingsTitleText(2) = uicontrol('Style', 'text', ...
        'String', '_____________________', 'parent', handles.handles.DBSCANSettingsFig,...
        'Position', [0 185 250 20], 'horizontalalignment', 'center', 'Fontsize', 10);

	handles.handles.DBSCANSettingsTitleText(1) = uicontrol('Style', 'text', ...
        'String', 'DBSCAN Parameters', 'parent', handles.handles.DBSCANSettingsFig,...
        'Position', [0 190 250 20], 'horizontalalignment', 'center', 'Fontsize', 10);
    
    %%%%%%
    
    handles.handles.DBSCANSettingsText(1) = uicontrol('Style', 'text', ...
        'String', 'Epsilon (nm):', 'parent', handles.handles.DBSCANSettingsFig,...
        'Position', [0 157 110 20], 'horizontalalignment', 'right');
    
    handles.handles.DBSCANSettingsText(2) = uicontrol('Style', 'text', ...
        'String', 'minPts:', 'parent', handles.handles.DBSCANSettingsFig,...
        'Position', [0 132 110 20], 'horizontalalignment', 'right');
    
    handles.handles.DBSCANSettingsText(3) = uicontrol('Style', 'text', ...
        'String', 'Plot Cutoff:', 'parent', handles.handles.DBSCANSettingsFig,...
        'Position', [0 107 110 20], 'horizontalalignment', 'right');
    
    handles.handles.DBSCANSettingsText(4) = uicontrol('Style', 'text', ...
        'String', 'Processing Threads:', 'parent', handles.handles.DBSCANSettingsFig,...
        'Position', [0 82 110 20], 'horizontalalignment', 'right');
    
    handles.handles.DBSCANSettingsText(5) = uicontrol('Style', 'text', ...
        'String', 'L(r) - r Radius (nm):', 'parent', handles.handles.DBSCANSettingsFig,...
        'Position', [0 57 110 20], 'horizontalalignment', 'right');
    
    handles.handles.DBSCANSettingsText(6) = uicontrol('Style', 'text', ...
        'String', 'Use', 'parent', handles.handles.DBSCANSettingsFig,...
        'Position', [190 57 30 20], 'horizontalalignment', 'right');
    
    handles.handles.DBSCANSettingsText(7) = uicontrol('Style', 'text', ...
        'String', 'Smooth Radius (nm):', 'parent', handles.handles.DBSCANSettingsFig,...
        'Position', [0 32 110 20], 'horizontalalignment', 'right');
    
	handles.handles.DBSCANSettingsText(8) = uicontrol('Style', 'text', ...
        'String', 'Calc Stats:', 'parent', handles.handles.DBSCANSettingsFig,...
        'Position', [0 6 110 20], 'horizontalalignment', 'right');
    
	%%%%%%%%%%
    
    handles.handles.DBSCANSettingsEdit(1) = uicontrol('Style', 'edit', ...
        'String', num2str(handles.DBSCAN.epsilon), 'parent', handles.handles.DBSCANSettingsFig,...
        'Position', [115 161 60 20]);
    
    handles.handles.DBSCANSettingsEdit(2) = uicontrol('Style', 'edit', ...
        'String', num2str(handles.DBSCAN.minPts), 'parent', handles.handles.DBSCANSettingsFig,...
        'Position', [115 136 60 20]);
    
    handles.handles.DBSCANSettingsEdit(3) = uicontrol('Style', 'edit', ...
        'String', num2str(handles.DBSCAN.Cutoff), 'parent', handles.handles.DBSCANSettingsFig,...
        'Position', [115 111 60 20]);
    
    handles.handles.DBSCANSettingsEdit(4) = uicontrol('Style', 'edit', ...
        'String', num2str(handles.DBSCAN.threads), 'parent', handles.handles.DBSCANSettingsFig,...
        'Position', [115 86 60 20]);
    
    handles.handles.DBSCANSettingsEdit(5) = uicontrol('Style', 'edit', ...
        'String', num2str(handles.DBSCAN.Lr_rThreshRad), 'parent', handles.handles.DBSCANSettingsFig,...
        'Position', [115 61 60 20]);
    
    handles.handles.DBSCANSettingsEdit(6) = uicontrol('Style', 'edit', ...
        'String', num2str(handles.DBSCAN.SmoothingRad), 'parent', handles.handles.DBSCANSettingsFig,...
        'Position', [115 36 60 20]);
    
    set(handles.handles.DBSCANSettingsEdit, 'Callback', @DBSCANCheckEditBox);
    
    %%%%%%
    
    handles.handles.DBSCANSetToggle = uicontrol('Style', 'checkbox', ...
        'Value', handles.DBSCAN.UseLr_rThresh, 'position', [225 60 20 20], ...
        'callback', @DBSCANUseThreshold);
    
	handles.handles.DBSCANDoStatsToggle = uicontrol('Style', 'checkbox', ...
        'Value', handles.DBSCAN.DoStats, 'position', [115 10 20 20]);
    
    
    
    handles.handles.DBSCANSettingsButton = uicontrol('Style', 'pushbutton', ...
        'String', 'Continue', 'parent', handles.handles.DBSCANSettingsFig, ...
        'Position', [165 2 85 30], 'Callback', @DBSCANSetAndContinue);

    set(handles.handles.DBSCANSettingsFig, 'CloseRequestFcn', @DBSCANCloseOutWindow);
    
    DBSCANUseThreshold();
    
    uiwait;
    
    function DBSCANCloseOutWindow(varargin)
        % Cancel, don't execute further
        returnValue = 0;
        uiresume;
        delete(handles.handles.DBSCANSettingsFig);
    end

    function DBSCANCheckEditBox(hObj, varargin)
        
        input = str2double(get(hObj,'string'));
        if isnan(input) 
            
            errordlg('You must enter a numeric value','Invalid Input','modal');
%             return;
        elseif input < 0
            
            errordlg('Value must be positive','Invalid Input','modal');
%             return;
        else
            % continue
        end

    end

    function DBSCANUseThreshold(varargin)
        
        if get(handles.handles.DBSCANSetToggle, 'value') == 1
            set(handles.handles.DBSCANSettingsEdit(5), 'enable', 'on');
        elseif get(handles.handles.DBSCANSetToggle, 'value') == 0
            set(handles.handles.DBSCANSettingsEdit(5), 'enable', 'off');
        end
        
    end

    function DBSCANSetAndContinue(varargin)
        
        % Collect inputs and set parameters in guidata
     	handles.DBSCAN.epsilon = str2double(get(handles.handles.DBSCANSettingsEdit(1),'string'));
        handles.DBSCAN.minPts = str2double(get(handles.handles.DBSCANSettingsEdit(2),'string'));
        handles.DBSCAN.cutoff = str2double(get(handles.handles.DBSCANSettingsEdit(3),'string'));
        handles.DBSCAN.threads = str2double(get(handles.handles.DBSCANSettingsEdit(4),'string'));
        handles.DBSCAN.Lr_rThreshRad = str2double(get(handles.handles.DBSCANSettingsEdit(5),'string'));
        handles.DBSCAN.SmoothingRad = str2double(get(handles.handles.DBSCANSettingsEdit(6),'string'));
        handles.DBSCAN.UseLr_rThresh = (get(handles.handles.DBSCANSetToggle, 'value')) == get(handles.handles.DBSCANSetToggle, 'Max');
                
        returnValue = 1;
        guidata(handles.handles.MainFig, handles);
        uiresume;
        delete(handles.handles.DBSCANSettingsFig);
        
    end    
end

% Pop-up window to set DoC parameters
function returnValue = setDoCParameters(handles)

   handles.handles.DoCSettingsFig = figure();
   set(handles.handles.DoCSettingsFig, 'Tag', 'ClusDoC');
    resizeFig(handles.handles.DoCSettingsFig, [200 180]);
    set(handles.handles.DoCSettingsFig, 'toolbar', 'none', 'menubar', 'none', ...
        'name', 'DoC Parameters');
  
	handles.handles.DoCSettingsTitleText(2) = uicontrol('Style', 'text', ...
        'String', '_____________________', 'parent', handles.handles.DoCSettingsFig,...
        'Position', [0 135 200 20], 'horizontalalignment', 'center', 'Fontsize', 10);

	handles.handles.DoCSettingsTitleText(1) = uicontrol('Style', 'text', ...
        'String', 'Degree of Colocalization Parameters', 'parent', handles.handles.DoCSettingsFig,...
        'Position', [0 145 200 35], 'horizontalalignment', 'center', 'Fontsize', 10);
    
    %%%%%%
    
    handles.handles.DoCSettingsText(1) = uicontrol('Style', 'text', ...
        'String', 'L(r) - r radius (nm):', 'parent', handles.handles.DoCSettingsFig,...
        'Position', [0 100 100 20], 'horizontalalignment', 'right');
    
    handles.handles.DoCSettingsText(2) = uicontrol('Style', 'text', ...
        'String', 'Rmax (nm):', 'parent', handles.handles.DoCSettingsFig,...
        'Position', [0 70 100 20], 'horizontalalignment', 'right');
    
    handles.handles.DoCSettingsText(3) = uicontrol('Style', 'text', ...
        'String', 'Step (nm):', 'parent', handles.handles.DoCSettingsFig,...
        'Position', [0 40 100 20], 'horizontalalignment', 'right');
    
	%%%%%%%%%%
    
    handles.handles.DoCSettingsEdit(1) = uicontrol('Style', 'edit', ...
        'String', num2str(handles.DoC.Lr_rRad), 'parent', handles.handles.DoCSettingsFig,...
        'Position', [120 100 60 20]);
    
    handles.handles.DoCSettingsEdit(2) = uicontrol('Style', 'edit', ...
        'String', num2str(handles.DoC.Rmax), 'parent', handles.handles.DoCSettingsFig,...
        'Position', [120 70 60 20]);
    
    handles.handles.DoCSettingsEdit(3) = uicontrol('Style', 'edit', ...
        'String', num2str(handles.DoC.Step), 'parent', handles.handles.DoCSettingsFig,...
        'Position', [120 40 60 20]);
    
    
    set(handles.handles.DoCSettingsEdit, 'Callback', @DoCCheckEditBox);
    
    %%%%%%
    
    
    handles.handles.DoCSettingsButton = uicontrol('Style', 'pushbutton', ...
        'String', 'Continue', 'parent', handles.handles.DoCSettingsFig, ...
        'Position', [113 2 85 30], 'Callback', @DoCSetAndContinue);

    set(handles.handles.DoCSettingsFig, 'CloseRequestFcn', @DoCCloseOutWindow);
    
    uiwait;
    
    function DoCCloseOutWindow(varargin)
        % Cancel, don't execute further
        returnValue = 0;
        uiresume;
        delete(handles.handles.DoCSettingsFig);
    end

    function DoCCheckEditBox(hObj, varargin)
        
        input = str2double(get(hObj,'string'));
        if isnan(input) 
            
            errordlg('You must enter a numeric value','Invalid Input','modal');
%             return;
        elseif input < 0
            
            errordlg('Value must be positive','Invalid Input','modal');
%             return;
        else
            % continue
        end

    end


    function DoCSetAndContinue(varargin)
        
        % Collect inputs and set parameters in guidata
     	handles.DoC.Lr_rRad = str2double(get(handles.handles.DoCSettingsEdit(1),'string'));
        handles.DoC.Rmax = str2double(get(handles.handles.DoCSettingsEdit(2),'string'));
        handles.DoC.Step = str2double(get(handles.handles.DoCSettingsEdit(3),'string'));
                
        returnValue = 1;
        guidata(handles.handles.MainFig, handles);
        uiresume;
        delete(handles.handles.DoCSettingsFig);
        
    end    
end

% Function Ripley K Test for active ROI
function RipleyKtest(~, ~, ~)

    handles = guidata(findobj('Tag', 'PALM GUI'));
    
    fprintf(1, 'Ripley K test on Selected ROI\n');
    set(handles.handles.MainFig, 'pointer', 'watch');
    set(findobj('parent', handles.handles.b_panel), 'enable', 'off');
    drawnow;

    CellVal = handles.handles.popupCell2.Value;
    CurrentROI = getPosition(handles.hROI);
    
    [ xCh1, ~] = Cropping_Fun(handles.CellData{CellVal}(handles.CellData{CellVal}(:,12) == 1,5:6), CurrentROI);

    [ xCh2, ~] = Cropping_Fun(handles.CellData{CellVal}(handles.CellData{CellVal}(:,12) == 2,5:6), CurrentROI);

    % RipleyK parameter
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Launch GUI window to change the set parameters, if desired

    returnVal = setRipleyKParameters(handles);

    if returnVal == 0
        set(handles.handles.MainFig, 'pointer', 'arrow');
        set(findobj('parent', handles.handles.b_panel), 'enable', 'on');
        fprintf(1, 'Ripley K test cancelled.\n');
        drawnow;
        return;
    elseif returnVal == 1
        
        try 

            handles.RipleyK.size_ROI = handles.CurrentROI(3:4);
            handles.RipleyK.Area = handles.CurrentROI(3)*handles.CurrentROI(4);
            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Sub-sample each Ch1 and Ch2 points to improve RipleyK calculation
            % speed, provide even density between samples
            if size(xCh1, 1) > handles.RipleyK.MaxSampledPts
                rKsubsample = randsample(1:size(xCh1, 1), handles.RipleyK.MaxSampledPts);
                xCh1 = xCh1(rKsubsample, :);
            end

            if size(xCh2, 1) > handles.RipleyK.MaxSampledPts
                rKsubsample = randsample(1:size(xCh2, 1), handles.RipleyK.MaxSampledPts);
                xCh2 = xCh2(rKsubsample, :);
            end

            %Ch1
            % RipleyK function

            handles.RipleyK.r = zeros(((handles.RipleyK.End - handles.RipleyK.Start)/handles.RipleyK.Step + 1), ...
                handles.Nchannels);

            handles.RipleyK.Lr_r = zeros(((handles.RipleyK.End - handles.RipleyK.Start)/handles.RipleyK.Step + 1), ...
                handles.Nchannels);

            [handles.RipleyK.r(:,1), handles.RipleyK.Lr_r(:,1)] = RipleyKFun( xCh1, handles.RipleyK.Area, ...
                handles.RipleyK.Start, handles.RipleyK.End, handles.RipleyK.Step, ...
                handles.RipleyK.size_ROI);

            % Plot
            handles.handles.RipleyKCh1Fig = figure('Name','Active ROI Ch1', 'color', [1 1 1]); 
            handles.handles.RipleyKCh1Ax = axes('parent', handles.handles.RipleyKCh1Fig);
            plot(handles.handles.RipleyKCh1Ax, handles.RipleyK.r(:,1), handles.RipleyK.Lr_r(:,1), ...
                'linewidth', 2, 'color', handles.Chan1Color);
            set(handles.handles.RipleyKCh1Ax, 'NextPlot', 'add', 'fontsize', 12);
            title_name = sprintf('%.0d points in %.0f x %.0f nm Area', size(xCh1, 1), handles.CurrentROI(3), handles.CurrentROI(4));
            title(title_name);
            xlabel(handles.handles.RipleyKCh1Ax, 'r (nm)', 'fontsize', 12);
            ylabel(handles.handles.RipleyKCh1Ax, 'L(r)-r', 'fontsize', 12);
            set(handles.handles.RipleyKCh1Ax, 'NextPlot', 'replace');

            if handles.Nchannels == 2
                %Ch2
                % RipleyK function
                [handles.RipleyK.r(:,2), handles.RipleyK.Lr_r(:,2)] = RipleyKFun( xCh2, handles.RipleyK.Area, ...
                handles.RipleyK.Start, handles.RipleyK.End, handles.RipleyK.Step, ...
                handles.RipleyK.size_ROI);
                % Plot
                handles.handles.RipleyKCh2Fig = figure('Name','Active ROI Ch2', 'color', [1 1 1]); 
                handles.handles.RipleyKCh2Ax = axes('parent', handles.handles.RipleyKCh2Fig, 'fontsize', 12);
                plot(handles.handles.RipleyKCh2Ax, handles.RipleyK.r(:,2), handles.RipleyK.Lr_r(:,2), ...
                     'linewidth', 2, 'color', handles.Chan2Color);
                set(handles.handles.RipleyKCh2Ax, 'NextPlot', 'add', 'fontsize', 12);
                title_name = sprintf('%.0d points in %.0f x %.0f nm Area', size(xCh2, 1), handles.CurrentROI(3), handles.CurrentROI(4));
                title(title_name);
                xlabel(handles.handles.RipleyKCh2Ax, 'r (nm)', 'fontsize', 12);
                ylabel(handles.handles.RipleyKCh2Ax, 'L(r)-r', 'fontsize', 12);
                set(handles.handles.RipleyKCh2Ax, 'NextPlot', 'replace');

            end

            set(handles.handles.MainFig, 'pointer', 'arrow');
            set(findobj('parent', handles.handles.b_panel), 'enable', 'on');
            drawnow;
            fprintf(1, 'Ripley K test completed.\n');
            
        catch mError
            
            set(handles.handles.MainFig, 'pointer', 'arrow');
            set(findobj('parent', handles.handles.b_panel), 'enable', 'on');
            drawnow;
            
            display('Ripley K test exited with errors');
            rethrow(mError);
            
        end

        
    end

    guidata(handles.handles.MainFig, handles);
    
end

% Function DBSCAN Test for active ROI
function DBSCAN_Test(~, ~, ~)

    handles = guidata(findobj('Tag', 'PALM GUI'));
    
    set(handles.handles.MainFig, 'pointer', 'watch');
    set(findobj('parent', handles.handles.b_panel), 'enable', 'off');
    drawnow;
    
    % get ROI Position and crop the Data of current cell

    CellVal = handles.handles.popupCell2.Value;
    CurrentROI = getPosition(handles.hROI);
    
    [ ~, cropIdx] = Cropping_Fun(handles.CellData{CellVal}(:,5:6), CurrentROI);
    dataCropped = handles.CellData{CellVal}(cropIdx,:);

    
    handles.DBSCAN.UseLr_rThresh = false;
    handles.DBSCAN.DoStats = false;
    returnVal = setDBSCANParameters(handles);
    handles = guidata(findobj('Tag', 'PALM GUI'));
    
    if returnVal == 0
        set(handles.handles.MainFig, 'pointer', 'arrow');
        set(findobj('parent', handles.handles.b_panel), 'enable', 'on');
        fprintf(1, 'DBSCAN test cancelled.\n');
        drawnow;
        return;
    elseif returnVal == 1
        
        try

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Test this!

            dbscanParams = handles.DBSCAN;
            dbscanParams.Outputfolder = handles.Outputfolder;
            dbscanParams.CurrentChannel = 1;


            %DBSCAN function
            [~, ~, ~, figOut] = DBSCANHandler(dataCropped(dataCropped(:,12) == 1, 5:6), dbscanParams); 

            set(figOut, 'Name', 'DBSCAN Active ROI Ch1')

            if handles.Nchannels == 2

                dbscanParams.CurrentChannel = 2;
                [~, ~, ~, figOut] = DBSCANHandler(dataCropped(dataCropped(:,12) == 2, 5:6), dbscanParams);
                set(figOut, 'Name', 'DBSCAN Active ROI Ch2')

            end

            set(handles.handles.MainFig, 'pointer', 'arrow');
            set(findobj('parent', handles.handles.b_panel), 'enable', 'on');
            drawnow;
            fprintf(1, 'DBSCAN test completed.\n');
            
        catch mError
           
            set(handles.handles.MainFig, 'pointer', 'arrow');
            set(findobj('parent', handles.handles.b_panel), 'enable', 'on');
            drawnow;
            
            display('DBSCAN text exited with errors');
            rethrow(mError);
            
        end
            
        
    end
    
    set(handles.handles.MainFig, 'pointer', 'arrow');
    set(findobj('parent', handles.handles.b_panel), 'enable', 'on');
    drawnow;
    
    guidata(handles.handles.MainFig, handles);
    
end

% Load the existing Ripley data or calculate the Ripley
function RipleyK_All(~, ~, ~)

    handles = guidata(findobj('Tag', 'PALM GUI'));

    set(handles.handles.MainFig, 'pointer', 'watch');
    set(get(handles.handles.b_panel, 'children'), 'enable', 'off');
    drawnow;

    returnVal = setRipleyKParameters(handles); % re-set RipleyK parameters if desired
    handles = guidata(findobj('Tag', 'PALM GUI'));
    
    if returnVal == 0
        
        set(handles.handles.MainFig, 'pointer', 'arrow');
        set(get(handles.handles.b_panel, 'children'), 'enable', 'on');
        drawnow;
        return
        
    elseif returnVal == 1
        
        try
    
            % Ripley K calculation
            % Iterate through cells + ROIs

            % Code inside loop is from RipleyKmultiData_GUIFunV2.m 
            % Moving here to create more reasonable workflow
            % create the output folder 'RipleyKGUI_Result
            Fun_OutputFolder_name = fullfile(handles.Outputfolder, 'RipleyKGUI_Result');
            if ~(exist(Fun_OutputFolder_name, 'dir') == 7)
                mkdir(Fun_OutputFolder_name);
                mkdir(fullfile(Fun_OutputFolder_name, 'RipleyK Plots', 'Ch1'));
                mkdir(fullfile(Fun_OutputFolder_name, 'RipleyK Plots', 'Ch2'));
                mkdir(fullfile(Fun_OutputFolder_name, 'RipleyK Results', 'Ch1'));
                mkdir(fullfile(Fun_OutputFolder_name, 'RipleyK Results', 'Ch2'));
            end

            [~] = RipleyKHandler(handles.ROIPos, handles.CellData, handles.RipleyK.Start, ...
                handles.RipleyK.End, handles.RipleyK.Step, handles.RipleyK.MaxSampledPts, ...
                handles.Chan1Color, handles.Chan2Color, Fun_OutputFolder_name);
            
        catch mError
           
            set(handles.handles.MainFig, 'pointer', 'arrow');
            set(get(handles.handles.b_panel, 'children'), 'enable', 'on');
            drawnow;
            
            display('Ripley K processing exited with errors');
            rethrow(mError);
            
            
        end

    end

    set(handles.handles.MainFig, 'pointer', 'arrow');
    set(get(handles.handles.b_panel, 'children'), 'enable', 'on');
    drawnow;
    
    guidata(handles.handles.MainFig, handles);
    
end

% Calculate DBSCAN  for selected data or loaded data
function DBSCAN_All(~, ~, ~)

    handles = guidata(findobj('Tag', 'PALM GUI'));

    set(handles.handles.MainFig, 'pointer', 'watch');
    set(get(handles.handles.b_panel, 'children'), 'enable', 'off');
    drawnow;

    if ~(exist(strcat(handles.Outputfolder, '\DBSCAN Results'), 'dir') == 7)
        mkdir(fullfile(handles.Outputfolder, 'DBSCAN Results'));
    end

%     [AllDataCh1, AllDataCh2] = Extract_Ch1_Ch2(ROIData);

    handles.DBSCAN.UseLr_rThresh = true;
    handles.DBSCAN.DoStats = true;
    
    returnVal = setDBSCANParameters(handles);
    handles = guidata(findobj('Tag', 'PALM GUI'));

    if returnVal == 0
        % Cancel.  Reset GUI
        set(handles.handles.MainFig, 'pointer', 'arrow');
        set(get(handles.handles.b_panel, 'children'), 'enable', 'on');
        drawnow;
        return;

    elseif returnVal == 1
        
        % Do DBSCAN on each cell, ROI, and channel
        % Can parfor this?
        
        try
        
            roiList = unique(handles.ROIPos(:,2));

            Result = cell(numel(roiList), size(handles.CellData, 1));
            ClusterSmoothTable = cell(numel(roiList), size(handles.CellData, 1));

            dbscanParams = handles.DBSCAN;
            dbscanParams.Outputfolder = handles.Outputfolder;
            

            for chan = 1:handles.Nchannels
                
                dbscanParams.CurrentChannel = chan;
                
                if chan == 1
                    clusterColor = handles.Chan1Color;
                elseif chan == 2
                    clusterColor = handles.Chan2Color;
                end
            
                for c = 1:size(handles.CellData, 1);

                    for roiInc = 1:numel(roiList);

                        roi = roiList(roiInc);

                        [ ~, cropIdx] = Cropping_Fun(handles.CellData{c}(:,5:6), ...
                            handles.ROIPos((handles.ROIPos(:,1) == c) & (handles.ROIPos(:,2) == roi), 3:6));
                        dataCropped = handles.CellData{c}(cropIdx,:);

                        if ~exist(fullfile(handles.Outputfolder, 'DBSCAN Results', sprintf('Ch%d', chan)),'dir')
                            mkdir(fullfile(handles.Outputfolder, 'DBSCAN Results', sprintf('Ch%d', chan)));
                            mkdir(fullfile(handles.Outputfolder, 'DBSCAN Results', sprintf('Ch%d', chan), 'Cluster maps')); 
                            mkdir(fullfile(handles.Outputfolder, 'DBSCAN Results', sprintf('Ch%d', chan), 'Cluster density maps'));                        
                        end

                        if ~isempty(dataCropped)
                            
                            % DBSCANHandler(Data, DBSCANParams, varargin)
                            %         p = varargin{1}; % Labeling only
                            %         q = varargin{2}; % Labeling only
                            %         display1 = varargin{3};
                            %         display2 = varargin{4};
                            %         clusterColor = varargin{5}
                            
                            [~, ClusterSmoothTable{roi, c}, ~, ~, ~, ~, Result{roi, c}] = ...
                                DBSCANHandler(dataCropped(dataCropped(:,12) == chan, 5:6), dbscanParams, c, roi, true, true, clusterColor);

                        end

                    drawnow;
                        
                    end % ROI
                end % Cell

                ExportDBSCANDataToExcelFiles(handles.ROIPos, Result);

                save(fullfile(handles.Outputfolder, 'DBSCAN Results', sprintf('Ch%d', chan), ...
                                    'DBSCAN_Cluster_Result.mat'),'ClusterSmoothTable','Result','-v7.3');
                            
            end % Channel
                            
        catch mError
            
            set(handles.handles.MainFig, 'pointer', 'arrow');
            set(get(handles.handles.b_panel, 'children'), 'enable', 'on');
            drawnow;
            
            display('DBSCAN processing exited with errors.');
            rethrow(mError);
            
            
        end
        
        
    end % returnVal

    set(handles.handles.MainFig, 'pointer', 'arrow');
    set(get(handles.handles.b_panel, 'children'), 'enable', 'on');
    drawnow;
    
    guidata(handles.handles.MainFig, handles);

end

% Calculate DoC  for selected data or loaded data
function DoC_All(~, ~, ~)

    handles = guidata(findobj('Tag', 'PALM GUI'));
    set(handles.handles.MainFig, 'pointer', 'watch');
    set(get(handles.handles.b_panel, 'children'), 'enable', 'off');
    drawnow;
    
    if ~(exist(strcat(handles.Outputfolder, '\Clus-DoC Results'), 'dir') == 7)
        mkdir(fullfile(handles.Outputfolder, 'Clus-DoC Results'));
        mkdir(fullfile(handles.Outputfolder, 'Clus-DoC Results', 'DoC histograms'));
        mkdir(fullfile(handles.Outputfolder, 'Clus-DoC Results', 'DBSCAN Results'));
        mkdir(fullfile(handles.Outputfolder, 'Clus-DoC Results', 'DBSCAN Results', 'Ch1'));
        mkdir(fullfile(handles.Outputfolder, 'Clus-DoC Results', 'DBSCAN Results', 'Ch1', 'Cluster maps'));
        mkdir(fullfile(handles.Outputfolder, 'Clus-DoC Results', 'DBSCAN Results', 'Ch2'));
        mkdir(fullfile(handles.Outputfolder, 'Clus-DoC Results', 'DBSCAN Results', 'Ch2', 'Cluster maps'));
        mkdir(fullfile(handles.Outputfolder, 'Clus-DoC Results', 'DoC Statistics and Plots'));
    end
    
    % Input parameters for calculating DoC scores for all points
        
	returnVal = setDoCParameters(handles);
        
    if returnVal == 0
        
        set(handles.handles.MainFig, 'pointer', 'arrow');
        set(get(handles.handles.b_panel, 'children'), 'enable', 'on');
        drawnow;
        return;
        
    elseif returnVal == 1
        
        try
            
            % cd to DoC_Result
            
            % Input parameters:
            % Lr_rad - radius for Lr thresholding check - 20 default
            % Rmax - max distance for DoC Calc (nm) - 500 default
            % Step - step size for DoC Calc (nm) - 10 default
            % ColoThres - threshold for DoC/notDoC - 0.4 default
            % Nb - Num particles with DoC score above threshold to be a 'colocalised' cluster
            % DBSCAN_Radius=20 - epsilon
            % DBSCAN_Nb_Neighbor=3; - minPts ;
            % threads = 2
                    
            [Data_DoC, DensityROI] = DoCHandler(handles.ROIPos, handles.CellData, ... 
                handles.DoC.Lr_rRad, handles.DoC.Rmax, handles.DoC.Step, ...
                handles.Chan1Color, handles.Chan2Color, handles.Outputfolder);
            
            %%%%%%%%%%%%%%%
            % Plotting, segmentation, and statistics start here
            
            ResultTable = Fun_Map_DoC_GUIV2(handles.ROIData, Data_DoC, DensityROI, strcat(handles.Outputfolder, '\Clus-DoC Results'));
            
            [ClusterTableCh1, ClusterTableCh2] = Fun_DBSCAN_DoC_GUIV2(handles.ROIData, Data_DoC, ...
                strcat(handles.Outputfolder, '\Clus-DoC Results'), handles.Chan1Color, handles.Chan2Color);
            
            % ^ Doesn't quite capture all of the stats that
            % FunDBSCAN4DoC_GUIV2.m does in ClusterTable.  Let's see
            % if/when it falls apart
            
            Fun_Stat_DBSCAN_DoC_GUIV2(ClusterTableCh1,1);
            Fun_Stat_DBSCAN_DoC_GUIV2(ClusterTableCh2,2);
            
            %
            %%%%%%%%%%%%%%
            
            handles.Data_DoC = Data_DoC;
            handles.DensityROI = DensityROI;
            
        catch mError
            
            set(handles.handles.MainFig, 'pointer', 'arrow');
            set(get(handles.handles.b_panel, 'children'), 'enable', 'on');
            drawnow;
            
            display('DoC exited with errors');
            rethrow(mError);
            
        end
    end

    set(handles.handles.MainFig, 'pointer', 'arrow');
    set(get(handles.handles.b_panel, 'children'), 'enable', 'on');
    drawnow;
    
    guidata(handles.handles.MainFig, handles);

end





% Reset the handles and the graph the starting point... Ready to go!
function Reset(~,~,~)

    handles = guidata(findobj('Tag', 'PALM GUI'));

    set(handles.handles.popupROI2,'String', {'ROI'},'Value',1);
    set(handles.handles.popupCell2,'String',{'Cell'},'Value',1);

    guidata(findobj('Tag', 'PALM GUI'), handles);

    DoCGUIInitialize();

end

function CloseGUIFunction(varargin)

    delete(findobj('Tag', 'ClusDoC'));
    delete(findobj('Tag', 'PALM GUI'));
    
end


