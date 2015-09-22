%% Calculate percentage of molecules per group (all molecules and molecule qith DC > 0.4
% in the different clusters categories noncluster, Nontriggered and
% triggered

%% NonCluster group

%load('F:\DATA_PALM\Sophie Data\9 region 1 cell\Isolated_Out_of_Cluster\Degree_Of_Colocalisation_V3\Data_for_Cluster_Analysis.mat')

DofC=cellfun(@(x) x.DofC,Data_DegColoc,'UniformOutput',0);
Nb_DofC04_NonClus=cellfun(@(x) length(x.DofC(x.DofC>0.4)),Data_DegColoc);
Nb_NonClus=cellfun(@(x) length(x.DofC),Data_DegColoc);
save('NonCluster','Nb_DofC04_NonClus','Nb_NonClus')


%% NonTriggered

load('DofC_NonTrig_Ch1.mat')
load('DofC_NonTrig_Ch2.mat')

A=DofC_NonTrig_Ch1(:);
A=A(~cellfun('isempty',A));
AA=cellfun(@(x) cell2mat(x),DofC_NonTrig_Ch1,'UniformOutput',0);
Nb_NonTrig=cellfun(@(x) length(x),AA);
Nb_DofC04_NonTrig=cellfun(@(x) length(x(x>0.4)),AA);



%% Triggered
A=[];AA=[];
load('DofC_Trig_Ch1.mat')
load('DofC_Trig_Ch2.mat')

A=DofC_Trig_Ch1(:);
A=A(~cellfun('isempty',A));
AA=cellfun(@(x) cell2mat(x),A,'UniformOutput',0);


Nb_Trig=cellfun(@(x) length(x),AA);
Nb_DofC04_Trig=cellfun(@(x) length(x(x>0.4)),AA);

%% Calculate percentages

Nb=Nb_NonClus+Nb_NonTrig+Nb_Trig; % all molecules of interest 
Nb_DofC04=Nb_DofC04_NonClus+Nb_DofC04_NonTrig+Nb_DofC04_Trig; %  molecules with DC>0.4

Per_DofC04_NonClus=Nb_DofC04_NonClus./Nb_DofC04;
Per_DofC04_NonTrig=Nb_DofC04_NonTrig./Nb_DofC04;
Per_DofC04_Trig=Nb_DofC04_Trig./Nb_DofC04;

Per_DofC04=table(Per_DofC04_NonClus,Per_DofC04_NonTrig,Per_DofC04_Trig...
     ,'VariableNames',{'NonClus' 'NonTrig' 'Trig'});

Per_NonClus=Nb_NonClus./Nb;
Per_NonTrig=Nb_NonTrig./Nb;
Per_Trig=Nb_Trig./Nb;
Per_All=table(Per_NonClus,Per_NonTrig,Per_Trig...
     ,'VariableNames',{'NonClus' 'NonTrig' 'Trig'});
 
 save('Per_NonClus_NonTrig_Trig','Per_DofC04','Per_All');
 
 
 
%% Calculate percentage of molecules per group (all molecules and molecule with DC > 0.4
% in the different clusters categories nondense and Dense. Relative Density
% Threshold = 6
 
 
 [ROI, CELL]=size(ClusterSmoothTableCh1);
 DenseCluster={};

    for cell=1:CELL    
        for roi=1:ROI
            A=ClusterSmoothTableCh1{roi,cell};

            if ~isempty(A)
                
                % Dense Cluster
                Dense_t= cellfun(@(y) y(y.AvRelativeDensity20>6),A,'UniformOutput',0);
                Dense_t=Dense_t(~cellfun('isempty',Dense_t));
                
                DofC_DenseCluster{roi,cell}=cell2mat(cellfun(@(x) x.Data_DoCi.DofC,Dense_t,'UniformOutput',0));

                DenseCluster{roi,cell}=Dense_t;
                % NotDense Cluster
                
                NotDense_t= cellfun(@(y) y(y.AvRelativeDensity20<6),A,'UniformOutput',0);
                NotDense_t=NotDense_t(~cellfun('isempty',NotDense_t));
                
                DofC_NotDenseCluster{roi,cell}=cell2mat(cellfun(@(x) x.Data_DoCi.DofC,NotDense_t,'UniformOutput',0));

                NotDenseCluster{roi,cell}=Dense_t;
                
            end        
        end    
    end
    

DenseCluster_per_DofC04=cellfun(@(x) length(find(x>0.4))/length(x),DofC_DenseCluster);
NotDenseCluster_per_DofC04=cellfun(@(x) length(find(x>0.4))/length(x),DofC_NotDenseCluster);
NotDense_Dense_per_DC04=table(DenseCluster_per_DofC04,NotDenseCluster_per_DofC04);
save('NotDense_Dense_per_DC04','NotDense_Dense_per_DC04');
