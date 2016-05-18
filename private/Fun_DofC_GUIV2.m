function [ Data_DegColoc, SizeROI ] = Fun_DofC_GUIV2( Data,r )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here


Meanvalue1=[];
Meanvalue2=[];
%regionsize=4000; % (in nm)

Data(isnan(Data(:,12)),:)=[];
x=Data(:,5); %  data from 2 channels
y=Data(:,6); %  data from 2 channels
x1i=Data(Data(:,12)==1,5); % x channel 1 original data
y1i=Data(Data(:,12)==1,6); % y channel 1 original data
x2i=Data(Data(:,12)==2,5); % x channel 2 original data
y2i=Data(Data(:,12)==2,6); % y channel 2 original data

%%%%%%% Threshold measure at the randomness
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Threshold measure at the randomness... \n');

xsize=ceil (max(x)-min(x));
ysize=ceil (max(y)-min(y));
SizeROI = max(xsize, ysize);

AvDensity = length(x)/SizeROI^2;
AvDensity1= length(x1i)/SizeROI^2;
AvDensity2= length(x2i)/SizeROI^2;
Nrandom=AvDensity*pi*r^2; % 

% All the value (data, idx, Dis, Density) are calculated for the
% total number of particle regardless which channel they belong to
[data, idx, Dis, Density ] = Lr_fun(x,y,x,y,r,SizeROI); % data=[X Y Lr Kfuncans], Density=global;

% Value calculated for a specific channel
[data1, idx1, Dis1, Density1 ] = Lr_fun(x1i,y1i,x1i,y1i,r,SizeROI); % data=[X Y Lr ],Density=global;
[data2, idx2, Dis2, Density2 ] = Lr_fun(x2i,y2i,x2i,y2i,r,SizeROI); % data=[X Y Lr ],Density=global;

data(:,4)=Data(:,12); % channel index
data(:,5)=Density;
data(:,7)=[Density1; Density2];

% Threshold at the randomness

 Lr_Threshold=((SizeROI)^2*Nrandom/(length(x)-1)/pi).^0.5;
 idxthr=find(data(:,3)>Lr_Threshold); % Index corresponding to the threshold data on Lr

datathr=data(idxthr,:);

  idxthr_friends=idx(idxthr);
  idxthr_friends2=cell2mat(idxthr_friends');
  Index_thr=unique(idxthr_friends2);
  datathr=data(Index_thr,:);
  
  % Remove Threshold
  datathr=data;
 
 %datathr=data;
 x1=datathr(datathr(:,4)==1,1);y1=datathr(datathr(:,4)==1,2); % data threshold for channel 1
 x2=datathr(datathr(:,4)==2,1);y2=datathr(datathr(:,4)==2,2); % data threshold for channel 2



clearvars data data1 data2 idx idx1 idx2 Dis Dis1 Dis2 Density Density1 Density2 idxthr_friends idxthr_friends2



 %% Centered on Channel 1        
Rmax=500;
%[idx1,Dis]=rangesearch([x1 y1],[x1 y1],Rmax);
%D1max=(cellfun(@length,idx1)-1)/(Rmax^2);
D1max=length(x1)/SizeROI^2;

%[idx2,Dis]=rangesearch([x2 y2],[x1 y1],Rmax);
%D2max=(cellfun(@length,idx2))/(Rmax^2);
D2max=length(x2)/SizeROI^2;

%i=0;
N11=zeros(length(x1), 50);
N12=zeros(length(x1), 50);
SA1=[];
fprintf('Centered on chanel 1 \n');
fprintf('rangesearch loop... \n');
tic

parfor i=1:50
    
    r = 10*i;
    fprintf('r=%d \n', r);
    
    num_points = kdtree2rnearest(x1, y1, x1, y1, r)-1;
    N11(:, i) = num_points ./ (D1max*r^2);
    
    num_points = kdtree2rnearest(x2, y2, x1, y1, r);
    N12(:, i) = num_points ./ (D2max*r^2);

    %{
    [idx]=rangesearch([x1 y1],[x1 y1],r);
    N11(:,i)=(cellfun(@length,idx)-1)./(D1max*r^2);
    
    [idx]=rangesearch([x2 y2],[x1 y1],r);
    N12(:,i)=(cellfun(@length,idx))./(D2max*r^2);
    %}    
end

fprintf('corr loop... \n');
parfor i=1:length(x1)
    
    %fprintf('i: %d\n', i);
    SA1(i,1)=corr(N11(i,:)',N12(i,:)','type','spearman');

end
SA1a=SA1;
SA1(isnan(SA1))=0;

[idxNND1, NND1] =knnsearch([x2 y2],[x1 y1]);
CA1=SA1.*exp(-NND1/Rmax);

DofCcoef.SA1a=SA1a;
DofCcoef.SA1=SA1;
DofCcoef.CA1=CA1;

toc

% clean mem
clearvars idxNND1 NND1

%% Centered on Channel 2        
%[idx1]=rangesearch([x2 y2],[x2 y2],Rmax);
%D1max=(cellfun(@length,idx1)-1)/(Rmax^2);
%D1max=length(x2)/(regionsize^2);

[idx2]=rangesearch([x1 y1],[x2 y2],Rmax);
D2max=(cellfun(@length,idx2))/(Rmax^2);
D1max=length(x1)/(SizeROI^2);

clearvars idx2;

N22=zeros(length(x2), 50);
N21=zeros(length(x2), 50);
SA2=[];
fprintf('Centered on chanel 2 \n');
fprintf('rangesearch loop... \n');
tic

parfor i=1:50

    r = 10*i;
    
    fprintf('r=%d \n', r);
    
    num_points = kdtree2rnearest(x2, y2, x2, y2, r)-1;
    N22(:, i) = num_points ./ (D1max*r^2);
    
    num_points = kdtree2rnearest(x1, y1, x2, y2, r);
    N21(:, i) = num_points' ./ (D2max*r^2);

    %{
    [idx]=rangesearch([x2 y2],[x2 y2],r);
    N22(:,i)=(cellfun(@length,idx)-1)./(D1max*r^2);

    [idx]=rangesearch([x1 y1],[x2 y2],r);
    N21(:,i)=(cellfun(@length,idx))./(D2max*r^2); 
    %}
   
end

fprintf('corr loop... \n');
parfor i=1:length(x2)

    %fprintf('i: %d\n', i);
    SA2(i,1)=corr(N22(i,:)',N21(i,:)','type','spearman');

end

SA2a=SA2;
SA2(isnan(SA2))=0;

[idxNND2, NND2] =knnsearch([x1 y1],[x2 y2]);
CA2=SA2.*exp(-NND2/Rmax);

DofCcoef.SA2a=SA2a;
DofCcoef.SA2=SA2;
DofCcoef.CA2=CA2;

toc

  
        datathr(:,6)=[CA1;CA2];
        
        datathr = array2table(datathr,'VariableNames',{'X' 'Y' 'Lr' 'Ch' 'Density' 'DofC' 'D1_D2'});
        
        Data_DegColoc=datathr;% datathr=[X Y Lr Kf Ch Density ColocalCoef]
        
end

