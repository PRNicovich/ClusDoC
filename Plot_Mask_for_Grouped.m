%%
% Triggered plot

%% Number of particle per cluster
histmask_Trig=NbTable_Trig(:);
histmask_Trig=histmask_Trig(~cellfun('isempty',histmask_Trig));
histmask_Trig=cell2mat(histmask_Trig);
Mean_Nb_Trig=mean(histmask_Trig)
% Plot histogram and adjust the size 
figure
histmask_Trig=histmask_Trig(histmask_Trig<160); % change the limit for the plot
hist(histmask_Trig,100) % change the binning , number of bar displayed
title('Triggered : Number of particle per cluster')

%% Area per cluster
Area_histmask_Trig=Area_Trig(:);
Area_histmask_Trig=Area_histmask_Trig(~cellfun('isempty',Area_histmask_Trig));
Area_histmask_Trig=cell2mat(Area_histmask_Trig);
Mean_Area_Trig=mean(Area_histmask_Trig)
% Plot histogram and adjust the size 
figure
Area_histmask_Trig=Area_histmask_Trig(Area_histmask_Trig<8E4);
hist(Area_histmask_Trig,100)
title('Triggerd : Area per cluster')

%% Density (Nb/A) per cluster
Density_histmask_Trig=DensityNbA_Trig(:);
Density_histmask_Trig=Density_histmask_Trig(~cellfun('isempty',Density_histmask_Trig));
Density_histmask_Trig=cell2mat(Density_histmask_Trig);
Mean_Density_Trig=mean(Density_histmask_Trig)
% Plot histogram and adjust the size 
figure

hist(Density_histmask_Trig,100)
title('Triggered : Density (Nb/A) per cluster')

%% Density local per cluster
Density2_histmask_Trig=Density_Trig(:);
Density2_histmask_Trig=Density2_histmask_Trig(~cellfun('isempty',Density2_histmask_Trig));
Density2_histmask_Trig=cell2mat(Density2_histmask_Trig);
Mean_Density_Trig=mean(Density2_histmask_Trig)
% Plot histogram and adjust the size 
figure
Density2_histmask_Trig=Density2_histmask_Trig(Density2_histmask_Trig<0.05);
hist(Density2_histmask_Trig,100)
title('Triggered : Density (local) per cluster')

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% NonTriggered plot

%% Number of particle per cluster
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
Area_histmask_NonTrig=Area_NonTrig(:);
Area_histmask_NonTrig=Area_histmask_NonTrig(~cellfun('isempty',Area_histmask_NonTrig));
Area_histmask_NonTrig=cell2mat(Area_histmask_NonTrig);
Mean_Area_NonTrig=mean(Area_histmask_NonTrig)
% Plot histogram and adjust the size 
figure
Area_histmask_NonTrig=Area_histmask_NonTrig(Area_histmask_NonTrig<2.5E5);
hist(Area_histmask_NonTrig,100)
title('NonTriggerd : Area per cluster')

%% Density (Nb/A) per cluster
Density_histmask=DensityNbA_NonTrig(:);
Density_histmask=Density_histmask(~cellfun('isempty',Density_histmask));
Density_histmask=cell2mat(Density_histmask);
Mean_Density_NonTrig=mean(Density_histmask)
% Plot histogram and adjust the size 
figure
Density_histmask(Density_histmask==0)=[];
%Density_histmask=Density_histmask(Density_histmask<0.007);
hist(Density_histmask,100)
title('NonTriggered : Density (Nb/A) per cluster')


%% Density local per cluster
Density2_histmask=Density_NonTrig(:);
Density2_histmask=Density2_histmask(~cellfun('isempty',Density2_histmask));
Density2_histmask=cell2mat(Density2_histmask);
Mean_Density_NonTrig=mean(Density2_histmask)
% Plot histogram and adjust the size 
figure
Density2_histmask(Density2_histmask==0)=[];
Density2_histmask=Density2_histmask(Density2_histmask<0.05);
hist(Density2_histmask,100)
title('NonTriggered : Density (local) per cluster')





