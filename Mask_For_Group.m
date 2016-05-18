function [NbTable_Trig,Area_Trig,DensityNbA_Trig,NbTable_NonTrig,Area_NonTrig,DensityNbA_NonTrig]=Mask_For_Group
%% Just run the function using the following line
% [NbTable_Trig,Area_Trig,DensityNbA_Trig,NbTable_NonTrig,Area_NonTrig,DensityNbA_NonTrig]=Mask_For_Group;
% First you are ask to choose the file ClusterSmoothTableCh1 (or Ch2) of the ungrouped data
% Then Choose the Region_and_Data in the grouped data folder
% Then use the script Plot_Mask_for_Grouped to plot the graph. Do this you
% will be able to chnage the threshold and the limit for the graph


        [File_name,Path_name] = uigetfile({'*.mat'},'Choose ClusterSmoothTableCh1 for Ungrouped Data');
        cd(Path_name)
        Data=load(File_name);
        ClusterSmoothTableCh1= Data.ClusterSmoothTableCh1;
        
        [File_name,Path_name] = uigetfile({'*.mat'},'Region_and_Data for Grouped Data');
        cd(Path_name)
        Data=load(File_name);
        ROIData=Data.ROIData;
        
        cd ..
        mkdir('Grouped_Param_from_Mask')
        cd('Grouped_Param_from_Mask')
        
[ROI, CELL]=size(ClusterSmoothTableCh1);

%% Get Triggered Cluster Contour Area

    for cell=1:CELL    
        for roi=1:ROI
            A=ClusterSmoothTableCh1{roi,cell};

            if ~isempty(A)
                                 
                A2=cellfun(@(x) x(x.Nb_In>=10),A,'UniformOutput',0);
                A2=A2(~cellfun('isempty',A2));
                TrigCluster{roi,cell}=A2;
                
                ContourTrig{roi,cell}=cellfun(@(x) x.Contour ,A2,'UniformOutput',0);
                Area_Trig{roi,cell}=cellfun(@(x) x.Area ,A2,'UniformOutput',1);
                Density_Trig{roi,cell}=cellfun(@(x) mean(x.Data_DoCi.Density) ,A2,'UniformOutput',1);
                
            end        
        end    
    end
    
%% Triggered Number of localisation per cluster for the grouped Data

    for cell=1:CELL   
          for roi=1:ROI
              B=ROIData{roi,cell};
              BB=ContourTrig{roi,cell};
              if ~isempty(B)
                  in={};
                  for i=1:length(BB)

                      in{i,1}=inpolygon(B(:,5),B(:,6),BB{i}(:,1),BB{i}(:,2));

                  end

                  Nb=cellfun(@(x) length(find(x==1)), in,'UniformOutput', 1);
                  NbTable_Trig{roi,cell}= Nb;
                  DensityNbA_Trig{roi,cell}=Nb./Area_Trig{roi,cell};
              end

          end
    end

%% %%%%%%%%%%%%%%%%%%%%%%%%

%figure;hist(histmask,100)
% Plot histogram and adjust the 
%histmask=histmask(histmask<100);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% NonTriggered Cluster 

%% Get Triggered Cluster Contour Area

    for cell=1:CELL    
        for roi=1:ROI
            A=ClusterSmoothTableCh1{roi,cell};

            if ~isempty(A)
                                 
                A2=cellfun(@(x) x(x.Nb_In<10),A,'UniformOutput',0);
                A2=A2(~cellfun('isempty',A2));
                NonTrigCluster{roi,cell}=A2;
                
                ContourNonTrig{roi,cell}=cellfun(@(x) x.Contour ,A2,'UniformOutput',0);
                Area_NonTrig{roi,cell}=cellfun(@(x) x.Area ,A2,'UniformOutput',1);
                Density_NonTrig{roi,cell}=cellfun(@(x) mean(x.Data_DoCi.Density) ,A2,'UniformOutput',1);
            end        
        end    
    end
    
%% Triggered Number of localisation per cluster for the grouped Data

    for cell=1:CELL   
          for roi=1:ROI
              B=ROIData{roi,cell};
              BB=ContourNonTrig{roi,cell};
              if ~isempty(B)
                  in={};
                  for i=1:length(BB)

                      in{i,1}=inpolygon(B(:,5),B(:,6),BB{i}(:,1),BB{i}(:,2));

                  end

                  Nb=cellfun(@(x) length(find(x==1)), in,'UniformOutput', 1);
                  NbTable_NonTrig{roi,cell}= Nb;
                  DensityNbA_NonTrig{roi,cell}=Nb./Area_NonTrig{roi,cell};
              end

          end
    end

end

