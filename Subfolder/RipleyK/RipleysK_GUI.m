function RipleysK_GUI


scrsz = get(0,'ScreenSize');

fig1 = figure('Name','PALM Analyzer', 'Tag', 'PALM GUI', 'Units', 'normalized',...
    'Position',[0.05 0.3 760/scrsz(3) 650/scrsz(4)] );
%set(fig1, 'Color',[1 1 1], 'DeleteFcn', @GUI_close); %'Colormap', [1 1 1]);
% Yields figure position in form [left bottom width height].

fig1_size = get(fig1, 'Position');

fig1_size_pixels = fig1_size.*scrsz;

panel_border = fig1_size_pixels(4)/max(fig1_size_pixels);
b_panel = uipanel(fig1, 'Units', 'normalized', 'Position', [0 0, 1-panel_border, 1], ...
    'BackgroundColor', [1 1 1], 'BorderType', 'none', 'Tag', 'b_panel');

ax_panel = uipanel(fig1, 'Units', 'normalized', 'Position', [1-(panel_border-0.02) 0.02 panel_border-0.02 1-0.02], ...
    'BackgroundColor', [1 1 1], 'BorderType', 'none', 'Tag', 'ax_panel');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button
% Define buttons and position.  Can continute this down to add more buttons
% in the future.  Can modify button appearance here.  Addition of multiple 
% additional buttons may require an increase in figure size or decrease in
% button size to keep all visible. 

% Button Dimensions - now in relative units.  
butt_width = .96;
butt_height = .06;

butt_left_pad = 0.01;

butt_border = .02; % Border between buttons (pixels)
butt_top_border = 0; % Additional border between first button and top of figure (pixels).  
                      % True border is butt_top_border + butt_border.

% Set position of first button.  All others relative to this one.  Values
% relative to bottom left corner of figure and of button.
Butt_start = [butt_left_pad+butt_border 1-butt_height];

% Subsequent buttons placed by this calculation:
% butt_n_vert_post = butt_top_border + (button_number * butt_border) + ((button_number-1) * butt_height)
BVH = @(BS, TB, BN, BB, BH) (BS - ((TB + (BN * BB) + ((BN-1) * BH))));

% all above is clever, but isn't the perfect way to align everything.  It
% requires certain units be relative to others and removes independent
% control between different parameters.  Good enough for now, though.

button_counter = 1;

% Button 1
butt_n_vert_post = BVH(Butt_start(2), butt_top_border, button_counter, butt_border, butt_height);
Load_Out =     uicontrol(b_panel, 'Units', 'normalized', 'Style', 'pushbutton', 'String', '<html>Load<br>Coordinates<html>',...
        'Position', [Butt_start(1) butt_n_vert_post butt_width butt_height],...
        'Callback', @Load_Data, 'Tag', 'Load Data');

    button_counter = button_counter + 1;

% Txt for Cell        
      butt_n_vert_post = BVH(Butt_start(2), butt_top_border, button_counter, butt_border, butt_height);  
    htext = uicontrol(b_panel, 'Units', 'normalized','Style','text','String','Cell',...
 'Position',[Butt_start(1) butt_n_vert_post butt_width/2 butt_height/2]);


% Popupmenu for Cell        
      butt_n_vert_post = BVH(Butt_start(2), butt_top_border, button_counter, butt_border, butt_height);
      popupCell =     uicontrol(b_panel, 'Units', 'normalized', 'Style', 'popup', 'String', {'Load Cell'},...
        'Position', [Butt_start(1)+0.5 butt_n_vert_post butt_width/2 butt_height/2],...
        'Callback', @popupCell_Callback, 'Tag', 'Load Cell');
    
      button_counter = button_counter + 1;
      
% Popupmenu for Coordinates        
      butt_n_vert_post = BVH(Butt_start(2), butt_top_border, button_counter, butt_border, butt_height);
      popupROI =     uicontrol(b_panel, 'Units', 'normalized', 'Style', 'popup', 'String', {'Load ROI'},...
        'Position', [Butt_start(1) butt_n_vert_post+0.03 butt_width butt_height],...
        'Callback', @popupROI_Callback, 'Tag', 'Load ROI');
    
      button_counter = button_counter + 1;

% Button 1
butt_n_vert_post = BVH(Butt_start(2), butt_top_border, button_counter, butt_border, butt_height);
Load_out =     uicontrol(b_panel, 'Units', 'normalized', 'Style', 'pushbutton', 'String', 'Load Data',...
        'Position', [Butt_start(1) butt_n_vert_post butt_width butt_height],...
        'Callback', @Load_Data, 'Tag', 'Load Data');

    button_counter = button_counter + 1;
    
% Button 2
     butt_n_vert_post = BVH(Butt_start(2), butt_top_border, button_counter, butt_border, butt_height);
     LoadROIButt =     uicontrol(b_panel, 'Units', 'normalized', 'Style', 'pushbutton', 'String', '<html>Load<br>ROIs<html>',...
        'Position', [Butt_start(1)  butt_n_vert_post butt_width/2 butt_height],...
        'Callback', @LoadROI, 'Tag', 'LoadROI');


   
% Button 2bis
     butt_n_vert_post = BVH(Butt_start(2), butt_top_border, button_counter, butt_border, butt_height);
     SelectROIButt =     uicontrol(b_panel, 'Units', 'normalized', 'Style', 'pushbutton', 'String', '<html>Select<br>ROIs<html>',...
        'Position', [Butt_start(1)+butt_width/2 butt_n_vert_post butt_width/2 butt_height],...
        'Callback', @SelectROI, 'Tag', 'ROI2');
    
    button_counter = button_counter + 1;
   
    
% % Popupmenu for the ROI             
%       butt_n_vert_post = BVH(Butt_start(2), butt_top_border, button_counter, butt_border, butt_height);
%       popupROI =     uicontrol(b_panel, 'Units', 'normalized', 'Style', 'popup', 'String', {'selectROI'},...
%         'Position', [Butt_start(1) butt_n_vert_post butt_width butt_height],...
%         'Callback', @popupROI_Callback, 'Tag', 'test');
%     
%       button_counter = button_counter + 1;
    

% Button 3             
butt_n_vert_post = BVH(Butt_start(2), butt_top_border, button_counter, butt_border, butt_height);
S.ed = uicontrol(b_panel,'Units', 'normalized','style','pushbutton','string','Save ROI',...
                 'position',[Butt_start(1) butt_n_vert_post butt_width butt_height],...
        'Callback', @SaveROI, 'Tag', 'Save ROI');

             button_counter = button_counter + 1;
             
% Button 4
butt_n_vert_post = BVH(Butt_start(2), butt_top_border, button_counter, butt_border, butt_height);
Load_out =     uicontrol(b_panel, 'Units', 'normalized', 'Style', 'pushbutton', 'String', 'RipleyK',...
        'Position', [Butt_start(1) butt_n_vert_post butt_width butt_height],...
        'Callback', @RipleyK, 'Tag', 'RipleyK');
    
    button_counter = button_counter + 1;

    
% Button 5 test
butt_n_vert_post = BVH(Butt_start(2), butt_top_border, button_counter, butt_border, butt_height);
Load_out =     uicontrol(b_panel, 'Units', 'normalized', 'Style', 'pushbutton', 'String', 'test',...
        'Position', [Butt_start(1) butt_n_vert_post butt_width butt_height],...
        'Callback', @test, 'Tag', 'test');
    
    button_counter = button_counter + 1;    



% function [] = pp_call(varargin)
% % Callback for the popup.
% S = varargin{3};  % Get the structure.
% P = get(S.pop,{'string','val'});  % Get the users choice.
% set(S.ed,'string',P{1}{P{2}});  % Assign the user's choice to the edit.

% End of buttons
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Axes initialization

ax_h = axes('Parent', ax_panel, 'Position', [0.002 .005 .994 .994]);
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
        handles.Cell_Ind=[];
        handles.ROI=[];
        handles.CellData=[];
        handles.ROIData=[];
        
        handles.Load_name = 'default';
        handles.Load_location = pwd;
        handles.CurrentROI = [];
        handles.SavedROI=[];
        handles.NbperROI=[];

        guidata(fig1, handles);
        
        function GUI_deleted = GUI_close(~, ~, handles)
        
        handles = guidata(fig1);
        
        assignin('base', 'GUI_data', handles);
        
        disp('Variable GUI_data assigned in base workspace on GUI close.')

        end

    function Load_Data(~,~,handles)
        
        handles = guidata(fig1);

        [Cell_Ind,ROI,CellData, ROIData]=ROI_Extractor_GUI();
        ListCell=num2str(Cell_Ind);
        set(popupCell,'String', ListCell);
        CellVal=popupCell.Value;
        ListROI=num2str(ROI(ROI(:,1)==CellVal,2));
        set(popupROI,'String', ListROI);
        % plot
        x=CellData{1,1}(:,5);
        y=CellData{1,1}(:,6);
        dSTORM_plot = plot(ax_h, x,y,'Marker','.','MarkerSize',3,'LineStyle','none',...
            'color','red', 'Tag', 'dSTORM_plot');
        
        axis equal
        axis tight
        set(ax_h, 'xtick', [], 'ytick', [])
        axis image % Freezes axis aspect ratio to that of the initial image - 
        %disallows skewing due to figure reshaping.
        %hold on
        handles.Cell_Ind=Cell_Ind;
        handles.ROI=ROI
        handles.CellData=CellData;
        handles.ROIData=ROIData;        
        guidata(fig1,handles)
    end

    function popupCell_Callback(~,~,handles)
        
         handles = guidata(fig1);
         Val=popupCell.Value;
         ROI=handles.ROI;
         CellData=handles.CellData;
        CellVal=popupCell.Value;
        ListROI=num2str(ROI(ROI(:,1)==CellVal,2));
        set(popupROI,'String', ListROI);
        x=CellData{CellVal}(:,5);
        y=CellData{CellVal}(:,6);
        dSTORM_plot = plot(ax_h, x,y,'Marker','.','MarkerSize',3,'LineStyle','none',...
            'color','red', 'Tag', 'dSTORM_plot');
        axis equal
        axis tight
        set(ax_h, 'xtick', [], 'ytick', [])
        axis image % Freezes axis aspect ratio to that of the initial image - 
        
%          N=handles.NbperROI(Val);
%          h=handles.hROI
%          ROI=handles.SavedROI(Val,:)
%          set(S.ed,'string',num2str(N));  % Assign the user's choice to the edit.
%          %h = imrect( ROI);
%          setConstrainedPosition(h,ROI); 
%         handles.CurrentROI=ROI;
        guidata(fig1, handles);
    end   

%         function popupCell_Callback(~,~,handles)
%         
%          handles = guidata(fig1);
%          Val=popupCell.Value;
%          ROI=handles.ROI;
%          CellData=handles.CellData;
%          ROIData=handles.ROIData; 
%          CellVal=popupCell.Value;
%          ROIVal=popupROI.Value;
%          %PosROI=
% 
%         
% %          N=handles.NbperROI(Val);
% %          h=handles.hROI
% %          ROI=handles.SavedROI(Val,:)
% %          set(S.ed,'string',num2str(N));  % Assign the user's choice to the edit.
% %          %h = imrect( ROI);
% %          setConstrainedPosition(h,ROI); 
% %         handles.CurrentROI=ROI;
%         guidata(fig1, handles);
%     end   






%     function Load_name = Load_Data(~, ~, handles) 
%         
%         % Function uses UI input to select file to analyze
%         
%         % Get path to file name.  Look only for .txt files in each folder.
%         [File_name,Path_name,Filter_index] = uigetfile({'*.txt','TXT Data Files'});
%         Load_name = fullfile(Path_name, File_name);
%         cd(Path_name)
%         FullData=importdata(Load_name);
%         Data=FullData.data;
%         % Record Load_name to handles structure attached to fig1 for future
%         % retreival by other functions.
% 
%         % plot
%         x=Data(:,5);
%         y=Data(:,6);
%         dSTORM_plot = plot(ax_h, x,y,'Marker','.','MarkerSize',3,'LineStyle','none',...
%             'color','red', 'Tag', 'dSTORM_plot');
%         
%         axis equal
%         axis tight
%         set(ax_h, 'xtick', [], 'ytick', [])
%         axis image % Freezes axis aspect ratio to that of the initial image - 
%         %disallows skewing due to figure reshaping.
%         %hold on
% 
%         
%         handles = guidata(fig1);
%         handles.Load_name = Load_name;
%         handles.Load_location = Path_name;
%         handles.Data=Data;
%         guidata(fig1, handles);
%         set(dSTORM_plot,'buttonDownfcn',@UpdateNb)
%         %disp(handles);
%  
%     end
    

    function LoadROI(~, ~, handles) 
        
        % Function Plot
         handles = guidata(fig1);
         Data=handles.Data;
         ROI=handles.CurrentROI;
        % Load the coordinate file
        
        
        % Create a ROI at 4000 nm
        h = imrect('PositionConstraintFcn', @(x) [x(1) x(2) 4000*[1 1]]);
        CurrentROI = getPosition(h);
        
        % Crop on the ROI and calculate the 
        Data1=Data(:,5:6);
        [ x, Index_In] = Cropping_Fun( Data1, CurrentROI);
        N=length(x);
        set(S.ed,'string',num2str(N));  % Assign the user's choice to the edit.
        
        %pos=[7100 8790 4000 4000];
        %rectangle('Position',pos, 'LineWidth',1, 'EdgeColor','b');
        handles.CurrentROI=CurrentROI;
        handles.hROI=h;
        guidata(fig1, handles);
        %disp(handles);
    end

    function SelectROI(~, ~, handles) 
        
        % Function Plot
         handles = guidata(fig1);
         Data=handles.Data;
         ROI=handles.CurrentROI;
        % Record Load_name to handles structure attached to fig1 for future
        % retrieval by other functions.
        %h=imrect;
        
        % Create a ROI at 4000 nm
        h = imrect('PositionConstraintFcn', @(x) [x(1) x(2) 4000*[1 1]]);
        CurrentROI = getPosition(h);
        
        % Crop on the ROI and calculate the 
        Data1=Data(:,5:6);
        [ x, Index_In] = Cropping_Fun( Data1, CurrentROI);
        N=length(x);
        set(S.ed,'string',num2str(N));  % Assign the user's choice to the edit.
        
        %pos=[7100 8790 4000 4000];
        %rectangle('Position',pos, 'LineWidth',1, 'EdgeColor','b');
        handles.CurrentROI=CurrentROI;
        handles.hROI=h;
        guidata(fig1, handles);
        %disp(handles);
    end

    function RipleyK(~, ~, handles) 
        tic
        % Function Plot
         handles = guidata(fig1);
         Data =handles.Data;
         ROI = handles.CurrentROI;
         val=popupROI.Value;
         Data1=Data(:,5:6);
         [ x, Index_In] = Cropping_Fun( Data1, ROI);

         Start=0;
         End=1000;
         Step=10;
         size_ROI=ROI(3:4);
         A=ROI(3)^2; 
         [r Lr_r]=RipleyFunV2( x,A,Start,End,Step,size_ROI);
         Name=strcat('ROI_',num2str(val))
         figure('Name',Name); plot( r, Lr_r,'red');hold on   
         
        guidata(fig1, handles);
        %disp(handles);
        toc
    end
   
    function UpdateNb (gcbo,eventdata,handles)
         % Function Plot
         handles = guidata(fig1);
         Data=handles.Data;
         %CurrentROI=handles.CurrentROI;
         h=handles.hROI;
         CurrentROI = getPosition(h);

        % Record Load_name to handles structure attached to fig1 for future
        % retrieval by other functions.
        %h=imrect;
        Data1=Data(:,5:6);
        [ x, Index_In] = Cropping_Fun( Data1, CurrentROI);
        N=length(x);
        set(S.ed,'string',num2str(N));  % Assign the user's choice to the edit.
        
        %rectangle('Position',pos, 'LineWidth',1, 'EdgeColor','b');
        handles.CurrentROI=CurrentROI;
        guidata(fig1, handles);
    end


    function SaveROI (~,~,handles)
         % Function Plot
         handles = guidata(fig1);
         Data=handles.Data;
         %CurrentROI=handles.CurrentROI;
         SavedROI=handles.SavedROI;
         NbperROI=handles.NbperROI;
         h=handles.hROI;
         CurrentROI = getPosition(h);
         
         Data1=Data(:,5:6);
         [ x, Index_In] = Cropping_Fun( Data1, CurrentROI);
         N=length(x);
         set(S.ed,'string',num2str(N));  % Assign the user's choice to the edit.   
         
         
        % Record Load_name to handles structure attached to fig1 for future
        % retrieval by other functions.
        %h=imrect;
        
        List=popupROI.String;
        if strcmp(List{1},'selectROI')
            List={'1'};
        else
            i=str2num(List{end})+1;
            List=[List;num2str(i)];         
        end    
        set(popupROI,'String', List);

        %handles.popupmenu1Object=hObject; % (1) see below
        %rectangle('Position',pos, 'LineWidth',1, 'EdgeColor','b');
        handles.CurrentROI=CurrentROI;
        handles.SavedROI=[SavedROI; CurrentROI];
        handles.NbperROI=[NbperROI; N];
        guidata(fig1, handles);
    end

    function popupROI_Callback(~,~,handles)
        
         handles = guidata(fig1);
         Val=popupROI.Value;
         N=handles.NbperROI(Val);
         h=handles.hROI
         ROI=handles.SavedROI(Val,:)
         set(S.ed,'string',num2str(N));  % Assign the user's choice to the edit.
         %h = imrect( ROI);
         setConstrainedPosition(h,ROI); 
        handles.CurrentROI=ROI;
        guidata(fig1, handles);
    end   


    function test(~,~,handles)
        
         handles = guidata(fig1);
         handles
         handles.NbperROI
    end   


























end

