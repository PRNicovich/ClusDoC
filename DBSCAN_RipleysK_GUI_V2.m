function DBSCAN_RipleysK_GUI_V2


scrsz = get(0,'ScreenSize');

fig1 = figure('Name','DBSCAN RipleyK Analyzer', 'Tag', 'PALM GUI', 'Units', 'normalized',...
    'Position',[0.05 0.3 760/scrsz(3) 650/scrsz(4)] );
%set(fig1, 'Color',[1 1 1], 'DeleteFcn', @GUI_close); %'Colormap', [1 1 1]);
% Yields figure position in form [left bottom width height].

fig1_size = get(fig1, 'Position');

fig1_size_pixels = fig1_size.*scrsz;

panel_border = fig1_size_pixels(4)/max(fig1_size_pixels)-0.05;

b_panel2 = uipanel(fig1, 'Units', 'normalized', 'Position', [0 0.25, 1-panel_border, 0.75], ...
    'BackgroundColor', [0.75 0.75 0.75], 'BorderType', 'none', 'Tag', 'b_panel');

% b_panel1 = uipanel(fig1, 'Units', 'normalized', 'Position',[0 0, 1-panel_border, 0.5] , ...
%     'BackgroundColor', [0.5 0.5 0.5], 'BorderType', 'none', 'Tag', 'b_panel');


ax_panel = uipanel(fig1, 'Units', 'normalized', 'Position', [1-panel_border 0 panel_border 1], ...
    'BackgroundColor', [1 1 1], 'BorderType', 'none', 'Tag', 'ax_panel');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button
% Define buttons and position.  Can continute this down to add more buttons
% in the future.  Can modify button appearance here.  Addition of multiple 
% additional buttons may require an increase in figure size or decrease in
% button size to keep all visible. 

% Button Dimensions - now in relative units.  
butt_width = .96;
butt_height = .12;

space1 = 0.02;

if 1==0
% Button 1
%butt_n_vert_post = BVH(Butt_start(2), butt_top_border, button_counter, butt_border, butt_height);

% Button RipleyK
    h1=butt_height;w1=butt_width;
    xbutton=space1;ybutton=ybutton-(space1+h1);
    RipleyK_butt =     uicontrol(b_panel1, 'Units', 'normalized', 'Style', 'pushbutton', 'String', 'RipleyK',...
        'Position', [xbutton ybutton w1 h1],...
        'Callback', @RipleyK, 'Tag', 'RipleyK');
    
% Txt for Cell        
      h1=butt_height/2;w1=butt_width/2;
      xbutton=space1;ybutton=ybutton-(space1+h1);
    htext = uicontrol(b_panel1, 'Units', 'normalized','Style','pushbutton','String','Cell',...
 'Position',[xbutton ybutton w1 h1]);


% Popupmenu for Cell        
      h2=butt_height/2;w2=butt_width/2;
      xbutton2=space1+0.005+w1;ybutton=ybutton;
      popupCell =     uicontrol(b_panel1, 'Units', 'normalized', 'Style', 'popup', 'String', {'Cell'},...
        'Position', [xbutton2 ybutton w2 h2],...
        'Callback', @popupCell_Callback, 'Tag', 'SelectCell');
    

% Txt for ROI           
      h1=butt_height/2;w1=butt_width/2;
      xbutton=space1;ybutton=ybutton-(space1+h1);
    htext = uicontrol(b_panel1, 'Units', 'normalized','Style','pushbutton','String','ROI',...
 'Position',[xbutton ybutton w1 h1]);


% Popupmenu for ROI        
      h2=butt_height/2;w2=butt_width/2;
      xbutton2=space1+0.005+w1;ybutton=ybutton;
      popupROI =     uicontrol(b_panel1, 'Units', 'normalized', 'Style', 'popup', 'String', {'ROI'},...
        'Position', [xbutton2 ybutton w2 h2],...
        'Callback', @popupROI_Callback, 'Tag', 'SelectROI');

% Button Visualisation
    h1=butt_height;w1=butt_width;
    xbutton=space1;ybutton=ybutton-(space1+h1);
    Visualisation_butt =     uicontrol(b_panel1, 'Units', 'normalized', 'Style', 'pushbutton', 'String', 'Visualisation',...
        'Position', [xbutton ybutton w1 h1],...
        'Callback', @Visualisation, 'Tag', 'Visualisation');   
end    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part for manual selection

% Load Zen Data
h1=butt_height;w1=butt_width;
xbutton=space1;ybutton=1-(space1+h1);
Load_Butt =     uicontrol(b_panel2, 'Units', 'normalized', 'Style', 'pushbutton', 'String', '<html>Load Zen From<br> Coordinates File<html>',...
        'Position', [xbutton ybutton w1 h1],...
        'Callback', @Load_Data, 'Tag', 'Load_Data');

% Load a data set         
      h1=butt_height/2;w1=butt_width;
      xbutton=space1;ybutton=ybutton-(space1+h1);  
    hLoad_DataSet= uicontrol(b_panel2, 'Units', 'normalized','Style','pushbutton','String','Load Data Set',...
 'Position',[xbutton ybutton w1 h1],'Callback', @Load_DataSet, 'Tag', 'SelectROI','enable','on');

% Button Load individual cell
    h1=butt_height*2/3;w1=butt_width*2/3;
    xbutton=space1;ybutton=ybutton-(space1+h1);
    Load_cell =     uicontrol(b_panel2, 'Units', 'normalized', 'Style', 'pushbutton', 'String', 'Load Cell',...
        'Position', [xbutton ybutton w1 h1],...
        'Callback', @Load_1Cell, 'Tag', 'Load_Cell');
    
% Popupmenu for selected Cell      
      h2=butt_height/2;w2=butt_width/3;
      xbutton2=space1+0.005+w1;ybutton2=ybutton+h1/4;
      popupCell2 =     uicontrol(b_panel2, 'Units', 'normalized', 'Style', 'popup', 'String', {'Cell'},...
        'Position', [xbutton2 ybutton2 w2 h2],...
        'Callback', @popupCell_Callback2, 'Tag', 'SelectCell');
    align([Load_cell,popupCell2],'None','Center');
    
% PushButton to Create ROI           
      h1=butt_height*2/3;w1=butt_width*2/3;
      xbutton=space1;ybutton=ybutton-(space1+h1);
    hCreateROI = uicontrol(b_panel2, 'Units', 'normalized','Style','pushbutton','String','Create ROI',...
 'Position',[xbutton ybutton w1 h1],'Callback', @CreateROI, 'Tag', 'CreateROI','enable','off');

% Popupmenu for selected ROI        
      h2=butt_height/2;w2=butt_width/3;
      xbutton2=space1+0.005+w1;ybutton2=ybutton+h1/4;
      popupROI2 =     uicontrol(b_panel2, 'Units', 'normalized', 'Style', 'popup', 'String', {'ROI'},...
        'Position', [xbutton2 ybutton2 w2 h2],...
        'Callback', @popupROI_Callback2, 'Tag', 'SelectROI');
    
% Select ROI           
      h1=butt_height/2;w1=butt_width/2;
      xbutton=space1;ybutton=ybutton-(space1+h1);
    hSelectROI= uicontrol(b_panel2, 'Units', 'normalized','Style','pushbutton','String','Select',...
 'Position',[xbutton ybutton w1 h1],'Callback', @SelectROI, 'Tag', 'SelectROI','enable','off');

% Save Cells and ROIs set           
      h1=butt_height/2;w1=butt_width;
      xbutton=space1;ybutton=ybutton-(space1+h1);
    hSaveCellROI= uicontrol(b_panel2, 'Units', 'normalized','Style','pushbutton','String','Save Cells & ROI',...
 'Position',[xbutton ybutton w1 h1],'Callback', @SaveCellROI, 'Tag', 'SelectROI','enable','off');

% Button RipleyK test for Active ROI
    h1=butt_height/2;w1=butt_width;
    xbutton=space1;ybutton=ybutton-(space1+h1);
hRipleyActiveROI =     uicontrol(b_panel2, 'Units', 'normalized', 'Style', 'pushbutton', 'String', 'RipleyK Test',...
        'Position', [xbutton ybutton w1 h1],...
        'Callback', @RipleyKtest, 'Tag', 'RipleyK_test','enable','off');  
    
% Button DBSCAN test for Active ROI
    h1=butt_height/2;w1=butt_width;
    xbutton=space1;ybutton=ybutton-(space1+h1);
hDBSCANActiveROI =     uicontrol(b_panel2, 'Units', 'normalized', 'Style', 'pushbutton', 'String', 'DBSCAN Test',...
        'Position', [xbutton ybutton w1 h1],...
        'Callback', @DBSCAN_Test, 'Tag', 'DBSCAN_test','enable','off'); 
        
% Button RipleyK for Selected ROIs
      h1=butt_height/2;w1=butt_width;
      xbutton=space1;ybutton=ybutton-(space1+h1);
hRipleyK_All =     uicontrol(b_panel2, 'Units', 'normalized', 'Style', 'pushbutton', 'String', 'RipleyK for All',...
        'Position', [xbutton ybutton w1 h1],...
        'Callback', @RipleyK_All, 'Tag', 'RipleyK_ROI','enable','off');
    
% Button DBSCAN test for Active ROI
    h1=butt_height/2;w1=butt_width;
    xbutton=space1;ybutton=ybutton-(space1+h1);
hDBSCAN_All =     uicontrol(b_panel2, 'Units', 'normalized', 'Style', 'pushbutton', 'String', 'DBSCAN for All',...
        'Position', [xbutton ybutton w1 h1],...
        'Callback', @DBSCAN_All, 'Tag', 'DBSCAN_All','enable','off');     
    
    
% % Button DBSCAN test for Active ROI
%     h1=butt_height;w1=butt_width;
%     xbutton=space1;ybutton=ybutton-(space1+h1);
% hDBSCAN =     uicontrol(b_panel2, 'Units', 'normalized', 'Style', 'pushbutton', 'String', 'DBCSAN',...
%         'Position', [xbutton ybutton w1 h1],...
%         'Callback', @DBSCAN, 'Tag', 'RipleyK_test','enable','off');    
    
% Button Test
    h1=butt_height/2;w1=butt_width;
    xbutton=space1;ybutton=ybutton-(space1+h1);
htest =     uicontrol(b_panel2, 'Units', 'normalized', 'Style', 'pushbutton', 'String', 'Don''t Touch',...
        'Position', [xbutton ybutton w1 h1],...
        'Callback', @test, 'Tag', 'test','enable','on');      
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
if 1==0
% Button TEST
    h1=butt_height;w1=butt_width;
    xbutton=space1;ybutton=ybutton-(space1+h1);
Load_out =     uicontrol(b_panel2, 'Units', 'normalized', 'Style', 'pushbutton', 'String', 'test',...
        'Position', [xbutton ybutton w1 h1],...
        'Callback', @test, 'Tag', 'test');

% Last Button Handles Check
    h1=butt_height;w1=butt_width;
    xbutton=space1;ybutton=0.005;
butt_Handles_Check =     uicontrol(b_panel2, 'Units', 'normalized', 'Style', 'pushbutton', 'String', 'Handles_Check',...
        'Position', [xbutton ybutton w1 h1],...
        'Callback', @Handles_Check, 'Tag', 'Handles_Check');
end
% End of buttons
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Axes initialization

ax_h = axes('Parent', ax_panel, 'Position', [0.005 -0.02 .99 .99]);
set(ax_h, 'Tag', 'PALM GUI axis');
% initialize data to put into the axes on startup
z=peaks(1000);
z = z./max(abs(z(:)));
fill_image = imshow(z, 'Parent', ax_h, 'ColorMap', jet, 'DisplayRange', [min(z(:)) max(z(:))]);
set(fill_image, 'Tag', 'fill_image', 'HitTest', 'on');

% Get rid of tick labels
set(ax_h, 'xtick', [], 'ytick', [])
axis image % Freezes axis aspect ratio to that of the initial image - disallows skewing due to figure reshaping.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin call back to nested button functions.  Match these function calls
% to buttons above.  Each executes a single function, but more can easily
% be added later. 

% Initialize structure to pass values between GUI components
        handles = guidata(fig1);
        handles.CellData={};
        handles.ROIData=[];
        handles.ROIPos=[];
        handles.CurrentCellData=[];
        handles.CurrentROIData=[];
        
        
        guidata(fig1, handles);
        
        function GUI_deleted = GUI_close(~, ~, handles)
        
        handles = guidata(fig1);
        
        assignin('base', 'GUI_data', handles);
        
        disp('Variable GUI_data assigned in base workspace on GUI close.')

        end

    
    function Load_Data(~,~,~)
        
        handles = guidata(fig1);
        
        set(Load_Butt,'Backgroundcolor','red');
         hVector=[Load_Butt,Load_cell hCreateROI hSelectROI...
             hRipleyActiveROI hDBSCANActiveROI hRipleyK_All hDBSCAN_All hLoad_DataSet];
        set(hVector,'enable','off');

        
        Path_name = uigetdir([],'Select the folder containing your data and region from Zen');
        cd(Path_name)
        if exist('Extracted_Region/Region_and_Data.mat')
            load('Extracted_Region/Region_and_Data.mat')
        else
            [Cell_Ind,ROI,ROIPos,CellData, ROIData]=ROI_Extractor_GUI_V2(); 
        end
        unique(ROIPos(:,1));
        CellList=num2str(unique(ROIPos(:,1)));
        set(popupCell2,'String', CellList);
        CellVal=popupCell2.Value;
        ROIList=num2str(ROIPos(ROIPos(:,1)==CellVal,2));
        set(popupROI2,'String', ROIList);
        ROIVal=popupROI2.Value;
        
        % Plot the first cell
        Data1=CellData{1,1};
        x=Data1(:,5);
        y=Data1(:,6);
        dSTORM_plot = plot(ax_h, x,y,'Marker','.','MarkerSize',3,'LineStyle','none',...
            'color','red', 'Tag', 'dSTORM_plot');
        set(ax_h, 'xtick', [], 'ytick', [])
        axis image % Freezes axis aspect ratio to that of the initial image - 
        
        CurrentCellROI=ROIPos(ROIPos(:,1)==CellVal,3:6);
        CurrentData=ROIData{ROIVal,CellVal};
        for i=1:size(CurrentCellROI,1)    
        rectangle('Position',CurrentCellROI(i,:), 'LineWidth',1, 'EdgeColor','b');
        end
        
        CurrentROI=ROIPos(ROIPos(:,1)==CellVal & ROIPos(:,2)==ROIVal,3:6);
           
        % Create a ROI
        hROI = imrect(gca,CurrentROI);
        setColor(hROI,'m')
        fcn1=@(x) [x(1) x(2) ceil(x(3)/1000)*1000 ceil(x(3)/1000)*1000];
        fcn2 = makeConstrainToRectFcn('imrect',get(gca,'XLim'),get(gca,'YLim'));
        fcn3=@(x) (fcn2(fcn1(x)));
        setPositionConstraintFcn(hROI,fcn3)
        addNewPositionCallback(hROI,@(p)title(strcat('Number, height, width :',mat2str(numberPerROI(p)))));
        
        % Set the button
        set(Load_Butt,'Backgroundcolor',[.94 .94 .94]);
        hVector=[Load_Butt,Load_cell hCreateROI hSelectROI...
             hRipleyActiveROI hDBSCANActiveROI hRipleyK_All hDBSCAN_All hLoad_DataSet];
        set(hVector,'enable','on');

        % Choose the Output folder 
        Outputfolder=uigetdir(Path_name,'Choose or Create an output folder');
        cd(Outputfolder)
        
        handles.Path_name=Path_name;
        handles.hROI=hROI;
        handles.ROIPos=ROIPos;
        handles.CellData=CellData;
        handles.ROIData=ROIData;
        handles.CurrentData=CurrentData;
        handles.Outputfolder=Outputfolder;
        
        function Result=numberPerROI(CurrentROI)
            [ xy, Index_In] = Cropping_Fun(Data1(:,5:6),CurrentROI);
            N=length(xy);
            Result=[N CurrentROI(3) CurrentROI(4)];
        end
 
        guidata(fig1,handles)
    end

    function popupCell_Callback(~,~,handles)
        
        handles = guidata(fig1);
        %ROI=handles.ROI;
        ROIPos=handles.ROIPos;
        CellData=handles.CellData;
        ROIData=handles.ROIData;
        CellVal=popupCell.Value;
        
        ListROI=num2str(ROIPos(ROIPos(:,1)==CellVal,2));
        set(popupROI,'String', ListROI);
        set(popupROI,'Value', 1);
        ROIVal=popupROI.Value;
        % Plot the new selected cell
        
        Data1=CellData{CellVal};
        x=Data1(:,5);
        y=Data1(:,6);
        dSTORM_plot = plot(ax_h, x,y,'Marker','.','MarkerSize',3,'LineStyle','none',...
            'color','red', 'Tag', 'dSTORM_plot');
        set(ax_h, 'xtick', [], 'ytick', [])
        axis image % Freezes axis aspect ratio to that of the initial image - 
        
        % Plot ROI refering to the selected celll
        CurrentCellROIs=ROIPos(ROIPos(:,1)==CellVal,3:6);
        for i=1:size(CurrentCellROIs,1) 
            rectangle('Position',CurrentCellROIs(i,:), 'LineWidth',1, 'EdgeColor','b');
        end
        
        CurrentROI=ROIPos(ROIPos(:,1)==CellVal & ROIPos(:,2)==ROIVal,3:6);
           
        % Create a ROI
        hROI = imrect(gca,CurrentROI);
        setColor(hROI,'m')
        fcn1=@(x) [x(1) x(2) ceil(x(3)/1000)*1000 ceil(x(3)/1000)*1000];
        fcn2 = makeConstrainToRectFcn('imrect',get(gca,'XLim'),get(gca,'YLim'));
        fcn3=@(x) (fcn2(fcn1(x)));
        setPositionConstraintFcn(hROI,fcn3)
        addNewPositionCallback(hROI,@(p)title(strcat('Number, height, width :',mat2str(numberPerROI(p)))));
        
        
        CurrentData=ROIData{ROIVal,CellVal};
        title(strcat('Number per ROI :', num2str(size(CurrentData,1))));
        handles.CurrentData=CurrentData;
        handles.hROI=hROI;
        
        function Result=numberPerROI(CurrentROI)
            [ xy, Index_In] = Cropping_Fun(Data1(:,5:6),CurrentROI);
            N=length(xy);
            Result=[N CurrentROI(3) CurrentROI(4)];
        end
        
        guidata(fig1, handles);
    end   


    function popupROI_Callback(~,~,~)    
        
        handles = guidata(fig1);
        CellVal=popupCell.Value;
        ROIVal=popupROI.Value;
          
        ROIPos=handles.ROIPos;
        CellData=handles.CellData;
        ROIData=handles.ROIData;
        hROI=handles.hROI;         
        
        CurrentROI=ROIPos(ROIPos(:,1)==CellVal & ROIPos(:,2)==ROIVal,:);
        setPosition(hROI, CurrentROI(3:6));
        setColor(hROI,'m')
        
        CurrentData=ROIData{ROIVal,CellVal};

        handles.CurrentData=CurrentData;
        
        guidata(fig1, handles);        
    end   

% Load the existing Ripley data or calculate the Ripley
    function RipleyK(~, ~, handles) 
    
         handles = guidata(fig1);
         ROIData=handles.ROIData;
         PosROI=handles.PosROI;
         Path_name=handles.Path_name;
        
        if exist('RipleyKGUI_Result/Lr_r.mat')
            % if Ripley data exist load them
            S=load('RipleyKGUI_Result/Lr_r.mat');
            Lr_r=S.Lr_r;
            handles.Lr_r=Lr_r;
        else
            % if not use Ripley K Function
            tic
            [Lr_r_Result,r]=RipleyKmultiData_GUIFunV2 (ROIData,Path_name);
            handles.Lr_r=[r Lr_r_Result];
            toc
        end
        
        guidata(fig1, handles);      
    end

    function Visualisation(~, ~, handles) 
    
        handles = guidata(fig1);
        CellVal=popupCell.Value;
        ROIVal=popupROI.Value;
        Lr_r=handles.Lr_r;
        PosROI=handles.PosROI;
        r= Lr_r(:,1);
        Index=find(PosROI(:,1)==CellVal & PosROI(:,2)==ROIVal)
        Lr_r1=Lr_r(:,Index+1);
         
        Name=strcat('Cell_',num2str(CellVal),'ROI_',num2str(ROIVal))
        figure('Name',Name); plot(r,Lr_r1,'red');
         
        guidata(fig1, handles);      
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%button Function from the second panel
    function Load_DataSet(~, ~, ~)
        
        
        handles = guidata(fig1);
        
        Path_name = uigetdir([],'Select the folder containing your data');
        cd(Path_name)
        if exist('Extracted_Region/Region_and_Data.mat')
            
        S=load('Extracted_Region/Region_and_Data.mat');
        CellData=S.CellData;
        ROIData=S.ROIData;
        ROIPos=S.ROIPos;
        
        unique(ROIPos(:,1));
        CellList=num2str(unique(ROIPos(:,1)));
        set(popupCell2,'String', CellList);
        CellVal=popupCell2.Value;
        ROIList=num2str(ROIPos(ROIPos(:,1)==CellVal,2));
        set(popupROI2,'String', ROIList);
        ROIVal=popupROI2.Value;
        
        % Plot the first cell
        Data1=CellData{1,1};
        x=Data1(:,5);
        y=Data1(:,6);
        dSTORM_plot = plot(ax_h, x,y,'Marker','.','MarkerSize',3,'LineStyle','none',...
            'color','red', 'Tag', 'dSTORM_plot');
        set(ax_h, 'xtick', [], 'ytick', [])
        axis image % Freezes axis aspect ratio to that of the initial image - 
        
        CurrentCellROI=ROIPos(ROIPos(:,1)==CellVal,3:6);
        CurrentData=ROIData{ROIVal,CellVal};
        for i=1:size(CurrentCellROI,1)    
        rectangle('Position',CurrentCellROI(i,:), 'LineWidth',1, 'EdgeColor','b');
        end
        
        CurrentROI=ROIPos(ROIPos(:,1)==CellVal & ROIPos(:,2)==ROIVal,3:6);
           
        % Create a ROI
        hROI = imrect(gca,CurrentROI);
        setColor(hROI,'m')
        fcn1=@(x) [x(1) x(2) ceil(x(3)/1000)*1000 ceil(x(3)/1000)*1000];
        fcn2 = makeConstrainToRectFcn('imrect',get(gca,'XLim'),get(gca,'YLim'));
        fcn3=@(x) (fcn2(fcn1(x)));
        setPositionConstraintFcn(hROI,fcn3)
        addNewPositionCallback(hROI,@(p)title(strcat('Number, height, width :',mat2str(numberPerROI(p)))));
        
        set(hRipleyActiveROI,'enable','on');
        set(hDBSCANActiveROI,'enable','on');
        set(hRipleyK_All,'enable','on');
        set(hDBSCAN_All,'enable','on');

        Outputfolder=uigetdir(Path_name,'Choose or Create a Output folder');
        cd(Outputfolder)
               
        handles.Path_name=Path_name;
        handles.hROI=hROI;
        handles.ROIPos=ROIPos;
        handles.CellData=CellData;
        handles.ROIData=ROIData;
        handles.CurrentData=CurrentData;
        handles.Outputfolder=Outputfolder;

        
        else
          h = msgbox({'There is existing Data set' 'Load Cells'})  
        end
        
        function Result=numberPerROI(CurrentROI)
            [ xy, Index_In] = Cropping_Fun(Data1(:,5:6),CurrentROI);
            N=length(xy);
            Result=[N CurrentROI(3) CurrentROI(4)];
        end
        
        guidata(fig1,handles)
    end

    function Load_1Cell(~, ~, ~) 

        % Get path to file name.  Look only for .txt files in each folder.
        [File_name,Path_name,Filter_index] = uigetfile({'*.txt','TXT Data Files'},'Select a table file (e.g. 1.txt)');
        Load_name = fullfile(Path_name, File_name);
        cd(Path_name)
        FullData=importdata(Load_name);
        CurrentCellData=FullData.data;
        % Record Load_name to handles structure attached to fig1 for future
        % retreival by other functions.

        % plot
        x=CurrentCellData(:,5);
        y=CurrentCellData(:,6);
        dSTORM_plot = plot(ax_h, x,y,'Marker','.','MarkerSize',3,'LineStyle','none',...
            'color','red', 'Tag', 'dSTORM_plot');
        set(ax_h, 'xtick', [], 'ytick', [])
        axis image % Freezes axis aspect ratio to that of the initial image - == axis tight; axis equal 
        
        % Set the popupmenu
        % ROI
        set(popupROI2,'String', {'ROI'});
        set(popupROI2,'Value', 1);
        % Cell
        CellList=popupCell2.String;
        if strcmp(CellList{1},'Cell') 
            set(popupCell2,'String', {'1'});
            set(popupCell2,'Value', 1);
            %handles.CellData=CurrentCellData
            CellData{1}=CurrentCellData;
        else 
            CellData=handles.CellData;
            i=str2num(CellList{end})+1;
            CellList=[CellList;num2str(i)];
            CellData{i}=CurrentCellData;
            
            %handles.CellData=CellData;
            set(popupCell2,'String', CellList);
            set(popupCell2,'Value', i);
        end            
        
        % set the buttons allowance
        set(hCreateROI,'enable','on');
        set(hSelectROI,'enable','off');
        set(hSaveCellROI,'enable','off');
        set(hRipleyK_All,'enable','off');
        set(hRipleyActiveROI,'enable','off');
        set(hDBSCANActiveROI,'enable','off');
        handles = guidata(fig1);
        handles.CurrentROI=[];
        handles.Cell_name = File_name;
        handles.Path_name = Path_name;
        handles.CellData=CellData;
        handles.CurrentCellData=CurrentCellData;
        
        guidata(fig1, handles);
    end

    function popupCell_Callback2(~,~,~)    

        CellData=handles.CellData;
        ROIData=handles.ROIData;
        ROIPos=handles.ROIPos;
        
        CellVal=popupCell2.Value;
        CellString=popupCell2.String;
        
        if length(CellString)>1

            ListROI=cellstr(num2str(ROIPos(ROIPos(:,1)==CellVal,2)));
            set(popupROI2,'String', ListROI);
            set(popupROI2,'Value', 1);
            ROIVal=1;
            % Plot the new selected cell
            Data1=CellData{CellVal};
            x=Data1(:,5);
            y=Data1(:,6);
            dSTORM_plot = plot(ax_h, x,y,'Marker','.','MarkerSize',3,'LineStyle','none',...
                               'color','red', 'Tag', 'dSTORM_plot');
            set(ax_h, 'xtick', [], 'ytick', [])
            axis image % Freezes axis aspect ratio to that of the initial image - 

            % Plot ROI refering to the selected celll
            CurrentCellROIs=ROIPos(ROIPos(:,1)==CellVal,3:6);
            for i=1:size(CurrentCellROIs,1)    
            rectangle('Position',CurrentCellROIs(i,:), 'LineWidth',1, 'EdgeColor','b');
            end
            
            ROIPos2=ROIPos(ROIPos(:,1)==CellVal,:);
            CurrentROI=ROIPos2(ROIPos2(:,2)==ROIVal,3:6);

            % Create a ROI
            hROI = imrect(gca,CurrentROI);
            setColor(hROI,'m')
            fcn1=@(x) [x(1) x(2) ceil(x(3)/1000)*1000 ceil(x(3)/1000)*1000];
            fcn2 = makeConstrainToRectFcn('imrect',get(gca,'XLim'),get(gca,'YLim'));
            fcn3=@(x) (fcn2(fcn1(x)));
            %hROI = imrect(gca,'PositionConstraintFcn', fcn3);
            %hROI = imrect(gca,CurrentROI);
            setPositionConstraintFcn(hROI,fcn3)
            addNewPositionCallback(hROI,@(p)title(strcat('Number, height, width :',mat2str(numberPerROI(p)))));
            
            %CurrentData=ROIData{ROIVal};
            %title(strcat('Number per ROI :', num2str(size(CurrentData,1))));
            handles.CurrentCellData=Data1;
            handles.hROI=hROI;
            
            
        end
        guidata(fig1, handles);
        
        function Result=numberPerROI(CurrentROI)
                [ x, Index_In] = Cropping_Fun(Data1(:,5:6),CurrentROI);
                length(Data1);
                N=length(x);
                Result=[N CurrentROI(3) CurrentROI(4)];
        end
    end

    function CreateROI(~, ~, ~) 
         
        CellData=handles.CurrentCellData;
        % Create a ROI at 4000 nm
        fcn1=@(x) [x(1) x(2) ceil(x(3)/1000)*1000 ceil(x(3)/1000)*1000];
        fcn2 = makeConstrainToRectFcn('imrect',get(gca,'XLim'),get(gca,'YLim'));
        fcn3=@(x) (fcn2(fcn1(x)));
        hROI = imrect(gca,'PositionConstraintFcn', fcn3);
        addNewPositionCallback(hROI,@(p)title(strcat('Number, height, width :',mat2str(numberPerROI(p)))));
        setColor(hROI,'m')
        % Crop on the ROI and calculate the 
        Data1=CellData(:,5:6);
        
        set(hCreateROI,'enable','off');
        set(hSelectROI,'enable','on');
        set(hRipleyActiveROI,'enable','on');
        set(hDBSCANActiveROI,'enable','on');

        handles.hROI=hROI;
        guidata(fig1, handles);
        
        function Result=numberPerROI(CurrentROI)
            [ x, Index_In] = Cropping_Fun(Data1,CurrentROI);
            N=length(x);
            Result=[N CurrentROI(3) CurrentROI(4)];
        end
    end

    function SelectROI(~, ~, ~)
        
        CurrentCellData=handles.CurrentCellData;
        ROIData=handles.ROIData;
        ROIPos=handles.ROIPos;
        hROI=handles.hROI;
        CellValue=popupCell2.Value;
        ROIValue=popupROI2.Value;       
         
         % Crop the selection
        CurrentROI=getPosition(hROI);
        Data1=CurrentCellData(:,5:6);
        [ x, Index_In] = Cropping_Fun(Data1,CurrentROI);
        CurrentROIData=CurrentCellData(Index_In,:); 
          
        ROIList=popupROI2.String;
        if strcmp(ROIList{1},'ROI') 
            ROIList={'1'};
            handles.SavedROI=CurrentROI;
            
            ROIData{1,CellValue}=CurrentROIData;
            set(popupROI2,'Value', 1);
        else 
            ROIData=handles.ROIData;
            SavedROI=handles.SavedROI;
            
            i=str2num(ROIList{end})+1;
            ROIList=[ROIList;num2str(i)];
            
            handles.SavedROI=[SavedROI; CurrentROI];
            ROIData{i,CellValue}=CurrentROIData;
            set(popupROI2,'Value', i);
        end    
        
        rectangle('Position',CurrentROI, 'LineWidth',1, 'EdgeColor','b');
        setColor(hROI,'m')
        set(popupROI2,'String', ROIList);
        set(hSaveCellROI,'enable','on');
         
        ROIVal=popupROI2.Value;
        ROIPos=[ROIPos;[CellValue ROIVal CurrentROI]];
        CurrentData=ROIData{ROIVal,CellValue};
        handles.CurrentData=CurrentData;
        handles.ROIData=ROIData;
        handles.ROIPos=ROIPos;
        guidata(fig1, handles);
        
    end

    function popupROI_Callback2(~,~,~)    
        
        ROIVal=popupROI2.Value;
        CellVal=popupCell2.Value;
        ROIPos=handles.ROIPos;
        hROI=handles.hROI;
        ROIData=handles.ROIData;
         
        ROIPos2=ROIPos(ROIPos(:,1)==CellVal,:);
        CurrentROI=ROIPos2(ROIPos2(:,2)==ROIVal,3:6);
        setPosition(hROI,CurrentROI)
        setColor(hROI,'m')
        set(hRipleyActiveROI,'enable','on');
        set(hDBSCANActiveROI,'enable','on');


        guidata(fig1, handles);
        
    end

% Save the cell and ROI in matlab folder
    function SaveCellROI(~,~,~)
        
        set(hSaveCellROI,'enable','off');
        set(hSaveCellROI,'Backgroundcolor','r');
        ROIData=handles.ROIData;
        ROIPos=handles.ROIPos;
        CellData=handles.CellData;
        AllData=ROIData;
        
        Path_name=handles.Path_name;
        Outputfolder=uigetdir(Path_name,'Choose or Create a Output folder');
        cd(Outputfolder)
        
         if ~exist(strcat(Outputfolder,'\Extracted_Region'),'dir')
            mkdir('Extracted_Region');
         end
         
         save(['Extracted_Region/' 'Region_and_Data.mat'],'ROIPos', 'ROIData','CellData');
         save(['Extracted_Region/' 'AllData.mat'],'AllData');
         
        set(hSaveCellROI,'enable','on');
        set(hSaveCellROI,'Backgroundcolor',[0.94 0.94 0.94]);
        set(hRipleyK_All,'enable','on');
        set(hDBSCAN_All,'enable','on');
        
        handles.Outputfolder=Outputfolder;  
        guidata(fig1,handles)
    end

% Function Ripley K Test for active ROI
    function RipleyKtest(~, ~, ~)       

         CellData= handles.CellData;
         ROIData= handles.ROIData;
         hROI=handles.hROI;
         CellVal=popupCell2.Value;
         ROIVal=popupROI2.Value;
         
         CurrentROI=getPosition(hROI);
         Data1=CellData{CellVal}(:,5:6);
         [ x, Index_In] = Cropping_Fun(Data1,CurrentROI);
 
         % RipleyK parameter
         Start=0;
         End=1000;
         Step=10;
         size_ROI=max(CurrentROI(3:4))*[1 1];
         A=CurrentROI(3)^2; 
         
         % RipleyK function
         [r Lr_r]=RipleyFunV2( x,A,Start,End,Step,size_ROI);
         
         % Plot
         figure('Name','Active ROI'); plot( r, Lr_r,'red');hold on
         title_name=strcat(num2str(length(Index_In)),': Nb in :',num2str(CurrentROI(3)),...
             'x',num2str(CurrentROI(3)),'nm Area');
         title(title_name)
         xlabel('r (nm)')
         ylabel('L(r)-r')
         
         guidata(fig1, handles);
    end

% Function DBSCAN Test for active ROI
    function DBSCAN_Test(~, ~, ~)       

         CurrentCellData = handles.CurrentCellData;
         CellData = handles.CellData;
         ROIData= handles.ROIData;
         hROI=handles.hROI;
         CellVal=popupCell2.Value;
         ROIVal=popupROI2.Value;
         
         % get ROI Position and crop the Data of current cell
         CurrentROI=getPosition(hROI);
         Data1=CellData{CellVal}(:,5:6);
         [ x, Index_In] = Cropping_Fun(Data1,CurrentROI);
         Data=CellData{CellVal}(Index_In,:);
         
         %DBSCAN Parameter
         r=50;
         Cutoff=10;
         %DBSCAN function
         [datathr,ClusterSmooth,SumofContour] = Fun_DBSCAN_Test( Data,r,Cutoff);
         
         
         guidata(fig1, handles);
    end

 % Load the existing Ripley data or calculate the Ripley
    function RipleyK_All(~, ~, ~) 
    
         set(hRipleyK_All,'Backgroundcolor','red');
         hVector=[Load_cell hCreateROI hSelectROI...
             hRipleyActiveROI hDBSCANActiveROI hRipleyK_All hDBSCAN_All];
         
         
         ROIData=handles.ROIData;
         ROIPos=handles.ROIPos;
         Outputfolder=handles.Outputfolder;


            % Ripley K
            tic
            [Lr_r_Result,r]=RipleyKmultiData_GUIFunV2 (ROIData,Outputfolder);
            handles.Lr_r=[r Lr_r_Result];
            toc
            
        set(hRipleyK_All,'Backgroundcolor',[0.94 .94 .94]);
        hVector=[Load_cell hSelectROI...
             hRipleyActiveROI hDBSCANActiveROI hRipleyK_All hDBSCAN_All];
        set(hVector,'enable','on');    
        guidata(fig1, handles);      
    end

    function DBSCAN_All(~, ~, ~)
        
         set(hDBSCAN_All,'Backgroundcolor','red');
         hVector=[Load_cell hCreateROI hSelectROI...
             hRipleyActiveROI hDBSCANActiveROI hRipleyK_All hDBSCAN_All];
        ROIData=handles.ROIData;
        ROIPos=handles.ROIPos;
        Outputfolder=handles.Outputfolder;
        mkdir('DBSCAN_Result');
        
        set(0,'DefaultFigureColormap',jet)
        cd(Outputfolder)
        cd('DBSCAN_Result')
        Path_name=pwd;
        
        [AllDataCh1, AllDataCh2]=Extract_Ch1_Ch2(ROIData);
        
        for Channel=1:2;

            if Channel==1
                AllData=AllDataCh1;
                if ~exist(strcat(Path_name,'\Ch1'),'dir')
                    mkdir('Ch1');
                end
                cd('Ch1')

                [ClusterSmoothTable,Result]=DBSCAN_MultiData_GUIFunV2(AllDataCh1);
                Final_Result_Extractor_GUIV2(ROIPos,Result,ClusterSmoothTable);

            elseif Channel==2
                
                AllData=AllDataCh2;
                A=cellfun(@isempty,AllData);

                if length(find(A==0))~=0
                    
                    if ~exist(strcat(Path_name,'\Ch2'),'dir')
                        mkdir('Ch2');
                    end
                    cd('Ch2')

                    [ClusterSmoothTable,Result]=DBSCAN_MultiData_GUIFunV2(AllDataCh2);
                    Final_Result_Extractor_GUIV2(ROIPos,Result,ClusterSmoothTable);
                end
            end
            cd(Path_name)
        end
        set(hDBSCAN_All,'Backgroundcolor',[0.94 .94 .94]);
        hVector=[Load_cell hSelectROI...
             hRipleyActiveROI hDBSCANActiveROI hRipleyK_All hDBSCAN_All];
        set(hVector,'enable','on');  
        
       cd(Outputfolder)     
    end

    
    function test(~,~,~)    
        
        handles
        handles.ROIData
        h=msgbox('I say "Dont''t touch"')
    end
 




















    function Handles_Check (~,~,~)
        handles=guidata(fig1)
        
        
    end
end

