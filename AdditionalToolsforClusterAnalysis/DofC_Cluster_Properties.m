function DofC_Cluster_Properties(ClusterSmoothTableCh1)
%% Identify untriggered and triggered clusters

%% How to use this function :


% -1-  load data from DBSCAN after DofC
%  it looks like this load('\DBSCAN for DoC Ch1_V3\DBSCAN for DoC Ch1.mat')
%  you get 2 ClusterSmoothTableCh1 and ClusterSmoothTableCh2
% 
% -2- Copy DofC_Cluster_Properties(ClusterSmoothTableCh1) in the command window
% for ch1 and DofC_Cluster_Properties(ClusterSmoothTableCh2) for ch2

[row, column]=size(ClusterSmoothTableCh1);
Cluster_Trig_Ch1=cell(row,column);
Cluster_nonTrig_Ch1=cell(row,column);

V_Ch1_DC=[];
V_Ch1_Relat_Density=[];
V_Ch1_Area=[];
V_Ch1_Nb=[];
            
V_Trig_Ch1_DC=[];
V_Trig_Ch1_Relat_Density=[];
V_Trig_Ch1_Area=[];
V_Trig_Ch1_Nb=[];

V_NonTrig_Ch1_DC=[];
V_NonTrig_Ch1_Relat_Density=[];
V_NonTrig_Ch1_Area=[];
V_NonTrig_Ch1_Nb=[];


for i=1:column    
    for j=1:row
        A_Ch1=ClusterSmoothTableCh1{j,i};

        if ~isempty(A_Ch1)
            
            % Population of cluster with Nb>10  
            Ch1=cellfun(@(x) x(x.Nb>10), A_Ch1,'UniformOUtput',0);
            A_Ch1=A_Ch1(~cellfun('isempty', Ch1));
            
            DC_Ch1{j,i}=cellfun(@(x) mean(x.Data_DoCi.DofC), A_Ch1,'UniformOutput',1);
            Relat_Density_Ch1{j,i}=cellfun(@(x) x.RelativeDensity_Nb_A, A_Ch1,'UniformOutput',1);
            Area_Ch1{j,i}=cellfun(@(x) x.Area, A_Ch1,'UniformOutput',1);
            Nb_Ch1{j,i}=cellfun(@(x) x.Nb, A_Ch1,'UniformOutput',1);
            
            V_Ch1_DC=[V_Ch1_DC; mean( DC_Ch1{j,i})];
            V_Ch1_Relat_Density=[V_Ch1_Relat_Density;mean(Relat_Density_Ch1{j,i})];
            V_Ch1_Area=[V_Ch1_Area; mean(Area_Ch1{j,i})];
            V_Ch1_Nb=[V_Ch1_Nb; mean(Nb_Ch1{j,i})];
            
            % Cluster with Nb(Dof>0.4) >10          
            Cluster_DofC_Ch1=cellfun(@(x) x(x.Nb_In>10), A_Ch1,'UniformOUtput',0);
            Cluster_DofC_Ch1=Cluster_DofC_Ch1(~cellfun('isempty', Cluster_DofC_Ch1));
            Cluster_Trig_Ch1{j,i}=Cluster_DofC_Ch1;
            
            % DC, RelatDensity Area Nb for trig Ch1
            DC_Trig_Ch1{j,i}=cellfun(@(x) mean(x.Data_DoCi.DofC), Cluster_DofC_Ch1,'UniformOutput',1);
            Relat_Density_Trig_Ch1{j,i}=cellfun(@(x) x.RelativeDensity_Nb_A, Cluster_DofC_Ch1,'UniformOutput',1);
            Area_Trig_Ch1{j,i}=cellfun(@(x) x.Area, Cluster_DofC_Ch1,'UniformOutput',1);
            Nb_Trig_Ch1{j,i}=cellfun(@(x) x.Nb, Cluster_DofC_Ch1,'UniformOutput',1);
            
            V_Trig_Ch1_DC=[V_Trig_Ch1_DC; mean( DC_Trig_Ch1{j,i})];
            V_Trig_Ch1_Relat_Density=[V_Trig_Ch1_Relat_Density;mean(Relat_Density_Trig_Ch1{j,i})];
            V_Trig_Ch1_Area=[V_Trig_Ch1_Area; mean(Area_Trig_Ch1{j,i})];
            V_Trig_Ch1_Nb=[V_Trig_Ch1_Nb; mean(Nb_Trig_Ch1{j,i})];
            
            % DofC for cluster Nb(Dof>0.4) >10    
           
            % DofC_Trig_Ch1=
                    
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           
            % Cluster with Nb(Dof>0.4) <10
            Cluster_Other_Ch1=cellfun(@(x) x(x.Nb_In<=10), A_Ch1,'UniformOUtput',0);
            Cluster_Other_Ch1=Cluster_Other_Ch1(~cellfun('isempty', Cluster_Other_Ch1));
            Cluster_nonTrig_Ch1{j,i}=Cluster_Other_Ch1;
            
            % DC, RelatDensity Area Nb for trig Ch1
            DC_NonTrig_Ch1{j,i}=cellfun(@(x) mean(x.Data_DoCi.DofC), Cluster_Other_Ch1,'UniformOutput',1);
            Relat_NonTrig_Density_Trig_Ch1{j,i}=cellfun(@(x) x.RelativeDensity_Nb_A, Cluster_Other_Ch1,'UniformOutput',1);
            Area_NonTrig_Ch1{j,i}=cellfun(@(x) x.Area, Cluster_Other_Ch1,'UniformOutput',1);
            Nb_NonTrig_Ch1{j,i}=cellfun(@(x) x.Nb, Cluster_Other_Ch1,'UniformOutput',1);
            
            V_NonTrig_Ch1_DC=[V_NonTrig_Ch1_DC; mean( DC_NonTrig_Ch1{j,i})];
            V_NonTrig_Ch1_Relat_Density=[V_NonTrig_Ch1_Relat_Density;mean(Relat_NonTrig_Density_Trig_Ch1{j,i})];
            V_NonTrig_Ch1_Area=[V_NonTrig_Ch1_Area; mean(Area_NonTrig_Ch1{j,i})];
            V_NonTrig_Ch1_Nb=[V_NonTrig_Ch1_Nb; mean(Nb_NonTrig_Ch1{j,i})];
            
            %DofC_NonTrig_Ch1{j,i}=cellfun(@(x) x.Data_DoCi.DofC, Cluster_Other_Ch1,'UniformOutput',0);                
        end        
    end    
end

T_All_Ch1=table(V_Ch1_DC, V_Ch1_Relat_Density, V_Ch1_Area,V_Ch1_Nb);
T_Trig_Ch1=table(V_Trig_Ch1_DC, V_Trig_Ch1_Relat_Density, V_Trig_Ch1_Area, V_Trig_Ch1_Nb);
T_NonTrig_Ch1=table(V_NonTrig_Ch1_DC, V_NonTrig_Ch1_Relat_Density, V_NonTrig_Ch1_Area, V_NonTrig_Ch1_Nb);

Hist_Relative_Density_Trig_Ch1=cell2mat(Relat_Density_Trig_Ch1(:));
Hist_Relative_Density_NonTrig_Ch1=cell2mat(Relat_NonTrig_Density_Trig_Ch1(:));

mkdir('Density_Trig_NonTrig')
cd('Density_Trig_NonTrig')

save('T_All_Ch1','T_All_Ch1')
save('T_Trig_Ch1','T_Trig_Ch1')
save('T_NonTrig_Ch1','T_NonTrig_Ch1')
save('Hist_Relative_Density_Trig_Ch1','Hist_Relative_Density_Trig_Ch1')
save('Hist_Relative_Density_NonTrig_Ch1','Hist_Relative_Density_NonTrig_Ch1')


figure
hist(Hist_Relative_Density_NonTrig_Ch1,100) % Hist does not return a handle, but creates an axes with a child of type Patch
patch1 = findobj(gca,'type','Patch'); % The child object of axes is a Patch Object

hold on     
hist(Hist_Relative_Density_Trig_Ch1,100)
patch2 = findobj(gca,'type','Patch'); % The child object of axes is a Patch Object
set(patch2,'FaceAlpha',0.2);
set(patch2(1),'FaceColor','r');
tt = getframe(gcf);
imwrite(tt.cdata, 'Hist_Density_Trig_NonTrig_Ch1.tif');
close gcf

figure
hist([Hist_Relative_Density_NonTrig_Ch1 ; Hist_Relative_Density_Trig_Ch1],100) % Hist does not return a handle, but creates an axes with a child of type Patch
patch1 = findobj(gca,'type','Patch'); % The child object of axes is a Patch Object

tt = getframe(gcf);
imwrite(tt.cdata, 'Hist_Density_All_Ch1.tif');
close gcf


clearvars -except ClusterSmoothTableCh1 ClusterSmoothTableCh2
