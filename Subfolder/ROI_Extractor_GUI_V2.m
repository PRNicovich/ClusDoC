        
function [Cell_Ind,ROI,ROIPos,CellData, ROIData]=ROI_Extractor_GUI_V2()
%% Import the Region file
ROIData=[];
% Dialogue box for region size
prompt = {'Enter size of ROI(nm):'};
dlg_title = 'Input';
num_lines = 1;
def = {'4000'};% Default value sizeROI=4000 in nm
answer = inputdlg(prompt,dlg_title,num_lines,def);
sizeROI=str2double(answer{1});

% Dialogue box for coordinate file import
[File_name,Path_name,Filter_index] = uigetfile({'*.txt','TXT Data Files'},'Choose the coordinate file (ROI position) ');
drawnow; pause(0.05);
filename =fullfile(Path_name, File_name);
cd(Path_name);
Coordinates=importdata(filename);
RegionXY=Coordinates.data(:,2:3);
Table_nb=Coordinates.data(:,1);

% Import different Tables 
Table_index=unique(Table_nb);
for i=Table_index'
filename=strcat(Path_name,num2str(i),'.txt');
Imported_Data=importdata(filename);
TableData{i,1}=Imported_Data.data;
%XYTable{i,1}=Imported_Data.data(:,5:6);
end

%% Create vector for ROI name

[val indx]=unique(Table_nb);
Cell_Ind=val;
indx=[indx ; length(Table_nb)+1];
Numb_El=diff(indx);
RegionName=[];

for i=Numb_El'
    RegionName=[RegionName ; [1:i]'];
end
Table_nb(:,2)=RegionName;

ROI=10*RegionXY;
%i=size(ROI,2);
ROI(:,2)=25600-ROI(:,2);
ROI(:,3:4)=ROI;
ROI(:,1:2)=Table_nb;
ROIPos=ROI(:,1:2);
%% Create the "Extracted Region" folder   
        if ~exist(strcat(Path_name,'Extracted_Region'),'dir')
            mkdir('Extracted_Region');
        end

%% 
for i=1:size(ROI,1)
    %xroi = [ROI(i,1)-sizeROI ROI(i,1)+sizeROI ROI(i,1)+sizeROI ROI(i,1)-sizeROI ROI(i,1)-sizeROI];
    %yroi = [ROI(i,2)+sizeROI ROI(i,2)+sizeROI ROI(i,2)-sizeROI ROI(i,2)-sizeROI ROI(i,2)+sizeROI];
    xroi = [ROI(i,3)-sizeROI/2 ROI(i,3)-sizeROI/2 ROI(i,3)+sizeROI/2 ROI(i,3)+sizeROI/2 ROI(i,3)-sizeROI/2];
    yroi = [ROI(i,4)-sizeROI/2 ROI(i,4)+sizeROI/2 ROI(i,4)+sizeROI/2 ROI(i,4)-sizeROI/2 ROI(i,4)-sizeROI/2];
    
    ROIPos(i,3:6) =[ROI(i,3)-sizeROI/2 ROI(i,4)-sizeROI/2 sizeROI sizeROI];
    XYROI=[xroi' yroi'];
    
    TableOI=TableData{Table_nb(i,1),1};
    x=TableOI(:,5);
    y=TableOI(:,6);
    XYin = inpolygon(x,y,XYROI(:,1),XYROI(:,2));
 
     Grand_Table{i,1}=Table_nb(i,1);
     Grand_Table{i,2}=Table_nb(i,2);
     Grand_Table{i,3}=XYROI;
     Grand_Table{i,4}=TableOI;
     Grand_Table{i,5}=TableOI(XYin,:);
     TableIndex=Table_nb(i);
     RegionIndex=Table_nb(i);
     AllData(Table_nb(i,2),Table_nb(i,1))=Grand_Table(i,5);
     CellData=TableData;
     ROIData=AllData;
     
%     hold on
%     plot(xroi,yroi) % redraw in dataspace units
% array=[{'index'},	{'first frame'},	{'number frames'},	{'frames missing'},	{'x'},	{'y'},	{'precision'},...
%     {'photons'}, {'background var'},	{'chi square'},	{'PSF width'},	{'channel'}];
% 
%     
% RegionName=strcat('Cell',num2str(Table_nb(i,1)),'_ROI',num2str(Table_nb(i,2)));
% xlswrite('Region',array,RegionName,'A1');
% xlswrite('Region',Grand_Table{i,5},RegionName,'A2');
    
end

save(['Extracted_Region/' 'AllData.mat'],'AllData');
save(['Extracted_Region/' 'Grand_Table.mat'],'Grand_Table');
save(['Extracted_Region/' 'Region_and_Data.mat'],'Cell_Ind','ROI','CellData', 'ROIData','ROIPos');

end
        




