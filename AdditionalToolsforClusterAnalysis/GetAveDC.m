function [ AveDC_Ch1, AveDC_Ch2 ] = GetAveDC
%% Extract and calculate the average DC for all the molecules for
% each channel Ch1 and Ch2
% Just run the function  and it will ask you the file to use, take the file Data_for_cluster_Analysis: 
%  located at e.g. Output1\DofC_Result\Data_for_cluster_Analysis
% Preferentially use the output from the GUI
        [File_name,Path_name] = uigetfile({'*.mat'},'Choose Data_for_Cluster_Analysis');
        cd(Path_name)
        Data=load(File_name);
        
                
A=Data.Data_DofC(:);
A=A(~cellfun('isempty',A));

%% Second field to extract in the Data_DoCi table, Lr Density DofC D1_D2
AveDC_Ch1= cellfun(@(x) mean(x(x.Ch==1,:).DofC) ,A);
AveDC_Ch2= cellfun(@(x) mean(x(x.Ch==2,:).DofC) ,A);

save('AveDC_Ch1_Ch2','AveDC_Ch1','AveDC_Ch2')
end

