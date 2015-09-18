%%
clearvars -except ClusterSmoothTableCh1 ROIData
%% All contour    
    
    [ROI, CELL]=size(ClusterSmoothTableCh1);
    Contour1={};
    for cell=1:CELL    
        for roi=1:ROI
            A=ClusterSmoothTableCh1{roi,cell};

            if ~isempty(A)
                                
                ContourAll{roi,cell}=cellfun(@(x) [x.Contour;NaN NaN],A,'UniformOutput',0);
                ContourAll2{roi,cell}=cell2mat(cellfun(@(x) [x.Contour;NaN NaN],A,'UniformOutput',0));
            end        
        end    
    end

%% Triggered Cluster 

[ROI, CELL]=size(ClusterSmoothTableCh1);
TrigCluster={};

    for cell=1:CELL    
        for roi=1:ROI
            A=ClusterSmoothTableCh1{roi,cell};

            if ~isempty(A)
                                
                A2=cellfun(@(x) x(x.Nb_In>10),A,'UniformOutput',0);
                A2=A2(~cellfun('isempty',A2));
                
                TrigCluster{roi,cell}=A2;
                
            end        
        end    
    end
    
%% Triggered Contour 

    [ROI, CELL]=size(TrigCluster);
    ContourTrig={};
    for cell=1:CELL    
        for roi=1:ROI
            A=TrigCluster{roi,cell};

            if ~isempty(A)
                                
                ContourTrig{roi,cell}=cellfun(@(x) [x.Contour;NaN NaN],A,'UniformOutput',0);
                ContourTrig2{roi,cell}=cell2mat(cellfun(@(x) [x.Contour;NaN NaN],A,'UniformOutput',0));
                
            end        
        end    
    end
       
%% Triggered Number of localisation per cluster for the grouped Data

    [ROI, CELL]=size(TrigCluster);

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
                  NbTable{roi,cell}= Nb;
                  
              end

          end
    end

%% Triggered plot
histmask=NbTable(:);
histmask=histmask(~cellfun('isempty',histmask));
histmask=cell2mat(histmask);
mean(histmask)
% Plot histogram and adjust the 
figure
histmask=histmask(histmask<200);
hist(histmask,100)

%figure;hist(histmask,100)
% Plot histogram and adjust the 
%histmask=histmask(histmask<100);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Nontriggered
clearvars -except ClusterSmoothTableCh1 ROIData
%% All contour    

    [ROI, CELL]=size(ClusterSmoothTableCh1);
    Contour1={};
    for cell=1:CELL    
        for roi=1:ROI
            A=ClusterSmoothTableCh1{roi,cell};

            if ~isempty(A)
                                
                ContourAll{roi,cell}=cellfun(@(x) [x.Contour;NaN NaN],A,'UniformOutput',0);
                ContourAll2{roi,cell}=cell2mat(cellfun(@(x) [x.Contour;NaN NaN],A,'UniformOutput',0));
            end        
        end    
    end

%% NonTriggered Cluster 

[ROI, CELL]=size(ClusterSmoothTableCh1);
NonTrigCluster={};

    for cell=1:CELL    
        for roi=1:ROI
            A=ClusterSmoothTableCh1{roi,cell};

            if ~isempty(A)
                                
                A2=cellfun(@(x) x(x.Nb_In<10),A,'UniformOutput',0);
                A2=A2(~cellfun('isempty',A2));
                
                NonTrigCluster{roi,cell}=A2;
                
            end        
        end    
    end
    
%% NonTriggered Contour 

    [ROI, CELL]=size(NonTrigCluster);
    ContourNonTrig={};
    for cell=1:CELL    
        for roi=1:ROI
            A=NonTrigCluster{roi,cell};

            if ~isempty(A)
                                
                ContourNonTrig{roi,cell}=cellfun(@(x) [x.Contour;NaN NaN],A,'UniformOutput',0);
                ContourNonTrig2{roi,cell}=cell2mat(cellfun(@(x) [x.Contour;NaN NaN],A,'UniformOutput',0));
                
            end        
        end    
    end
       
%% Triggered Number of localisation per cluster for the grouped Data

    [ROI, CELL]=size(NonTrigCluster);

    for cell=1:CELL   
          for roi=1:ROI
              B=ROIData{roi,cell};
              BB=ContourNonTrig{roi,cell};
              in={};
              for i=1:length(BB)

                  in{i,1}=inpolygon(B(:,5),B(:,6),BB{i}(:,1),BB{i}(:,2));

              end

              Nb=cellfun(@(x) length(find(x==1)), in,'UniformOutput', 1);
              NbTable{roi,cell}= Nb;

          end
    end

%% NonTriggered plot
histmask_NonTrig=NbTable(:);
histmask_NonTrig=histmask_NonTrig(~cellfun('isempty',histmask_NonTrig));
histmask_NonTrig=cell2mat(histmask_NonTrig);
mean(histmask_NonTrig)
% Plot histogram and adjust the
figure
histmask_NonTrig=histmask_NonTrig(histmask_NonTrig<200);
hist(histmask_NonTrig,100)




