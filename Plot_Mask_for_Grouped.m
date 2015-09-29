%%
% Triggered plot

%% Number of particle per cluster
histmask_Trig=NbTable_Trig(:);
histmask_Trig=histmask_Trig(~cellfun('isempty',histmask_Trig));
histmask_Trig=cell2mat(histmask_Trig);
Mean_Nb_Trig=mean(histmask_Trig)
% Plot histogram and adjust the size 
figure
histmask_Trig=histmask_Trig(histmask_Trig<200); % change the limit for the plot
hist(histmask_Trig,100) % change the binning , number of bar displayed
title('Triggered : Number of particle per cluster')

%% Area per cluster
Area_histmask_Trig=Area_Trig(:);
Area_histmask_Trig=Area_histmask_Trig(~cellfun('isempty',Area_histmask_Trig));
Area_histmask_Trig=cell2mat(Area_histmask_Trig);
Mean_Area_Trig=mean(Area_histmask_Trig)
% Plot histogram and adjust the size 
figure
%Density_histmask=Density_histmask(Density_histmask<200);
hist(Area_histmask_Trig,100)
title('Triggerd : Area per cluster')

%% Density (Nb/A) per cluster
Density_histmask_Trig=DensityNbA_Trig(:);
Density_histmask_Trig=Density_histmask_Trig(~cellfun('isempty',Density_histmask_Trig));
Density_histmask_Trig=cell2mat(Density_histmask_Trig);
Mean_Density_Trig=mean(Density_histmask_Trig)
% Plot histogram and adjust the size 
figure
%Density_histmask=Density_histmask(Density_histmask<200);
hist(Density_histmask_Trig,100)
title('Triggered : Density (Nb/A) per cluster')

%% NonTriggered plot
histmask_NonTrig=NbTable_NonTrig(:);
histmask_NonTrig=histmask_NonTrig(~cellfun('isempty',histmask_NonTrig));
histmask_NonTrig=cell2mat(histmask_NonTrig);
mean(histmask_NonTrig)
% Plot histogram and adjust the
figure
histmask_NonTrig=histmask_NonTrig(histmask_NonTrig<200);
hist(histmask_NonTrig,100)
title('NonTriggered : Number of particle per cluster')

%% Area per cluster
Area_histmask_Trig=Area_NonTrig(:);
Area_histmask_Trig=Area_histmask_Trig(~cellfun('isempty',Area_histmask_Trig));
Area_histmask_Trig=cell2mat(Area_histmask_Trig);
Mean_Area_Trig=mean(Area_histmask_Trig)
% Plot histogram and adjust the size 
figure
%Density_histmask=Density_histmask(Density_histmask<200);
hist(Area_histmask_Trig,100)
title('NonTriggerd : Area per cluster')

%% Density (Nb/A) per cluster
Density_histmask=DensityNbA_NonTrig(:);
Density_histmask=Density_histmask(~cellfun('isempty',Density_histmask));
Density_histmask=cell2mat(Density_histmask);
Mean_Density_NonTrig=mean(Density_histmask)
% Plot histogram and adjust the size 
figure
Density_histmask=Density_histmask(Density_histmask<0.007);
hist(Density_histmask,100)
title('NonTriggered : Density (Nb/A) per cluster')