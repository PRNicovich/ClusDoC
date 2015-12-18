function DofC_Cluster_Properties_V3(ClusterSmoothTableCh1,Cluster_Cutoff)
%% Identify untriggered and triggered clusters

%% How to use this function :


% -1-  load data from DBSCAN after DofC
%  it looks like this load('\DBSCAN for DoC Ch1_V3\DBSCAN for DoC Ch1.mat')
%  you get 2 ClusterSmoothTableCh1 and ClusterSmoothTableCh2
% 
% -2- Copy DofC_Cluster_Properties_V3(ClusterSmoothTableCh1,10) in the command window
% for ch1 and DofC_Cluster_Properties_V3(ClusterSmoothTableCh2,10) for ch2

[row, column]=size(ClusterSmoothTableCh1);
Cluster_DC_Above=cell(row,column);
Cluster_DC_Below=cell(row,column);

V_DC=[];
V_Relat_Density=[];
V_Area=[];
V_Nb=[];
            
V_DC_Above_DC=[];
V_Relat_Density_Above_DC=[];
V_Area_Above_DC=[];
V_Nb_Above_DC=[];

V_Below_DC=[];
V_Below_Relat_Density=[];
V_Below_Area=[];
V_Below1_Nb=[];

V_DC_Below_DC=[];
V_Relat_Density_Below_DC=[];
V_Area_Below_DC=[];
V_Nb_Below_DC=[];

for i=1:column    
    for j=1:row
        A=ClusterSmoothTableCh1{j,i};

        if ~isempty(A)

            %-- Population of cluster with Nb>Cluster_Cutoff  
            A=cellfun(@(x) x(x.Nb>Cluster_Cutoff), A,'UniformOUtput',0);
            A=A(~cellfun('isempty', A));
            if ~isempty(A)
                % Isolate value from the data
                DC_Temp=cellfun(@(x) x.Data_DoCi.DofC, A,'UniformOutput',0); 
                DC{j,i}=cell2mat(DC_Temp);
                
                Relat_Density_temp=cellfun(@(x) x.Data_DoCi.Density, A,'UniformOutput',0);
                Relat_Density{j,i}=cell2mat(Relat_Density_temp);
                
                %Rho_pearson{j,i}=corr(DC{j,i},Relat_Density{j,i},'type','Pearson');
                %Rho_Spearman{j,i}=corr(DC{j,i},Relat_Density{j,i},'type','Spearman');
                
                Ave_DC{j,i}=cellfun(@(x) mean(x.Data_DoCi.DofC), A,'UniformOutput',1);
                Ave_Density{j,i}=cellfun(@(x) mean(x.Density_Nb_A), A,'UniformOutput',1);
                Ave_RelaDensity{j,i}=cellfun(@(x) mean(x.RelativeDensity_Nb_A), A,'UniformOutput',1);
                
            elseif isempty(A)
                DC{j,i}=[];
                Relat_Density{j,i}=[];
                %Rho_pearson{j,i}=[];
                %Rho_Spearman{j,i}=[];
                
                Ave_DC{j,i}=[];
                Ave_Density{j,i}=[];
                Ave_RelaDensity{j,i}=[];
            end
        end        
    end    
end

%-- Save
mkdir('Density_Below_Above_DC')
cd('Density_Below_Above_DC')

save('DC','DC')
save('Relat_Density','Relat_Density')
%save('Rho','Rho_pearson','Rho_Spearman')

%-- Create a vector with the values for DC and relative density
Vector_DC=DC(:);
Vector_DC=Vector_DC(~cellfun('isempty', Vector_DC));
Vector_DC=cell2mat(Vector_DC);

Vector_Relat_Density=Relat_Density(:);
Vector_Relat_Density=Vector_Relat_Density(~cellfun('isempty', Vector_Relat_Density));
Vector_Relat_Density=cell2mat(Vector_Relat_Density);

Vector_Ave_DC=Ave_DC(:);
Vector_Ave_DC=Vector_Ave_DC(~cellfun('isempty', Vector_Ave_DC));
Vector_Ave_DC=cell2mat(Vector_Ave_DC);

Vector_Ave_Density=Ave_Density(:);
Vector_Ave_Density=Vector_Ave_Density(~cellfun('isempty', Vector_Ave_Density));
Vector_Ave_Density=cell2mat(Vector_Ave_Density);

Vector_Ave_RelaDensity=Ave_RelaDensity(:);
Vector_Ave_RelaDensity=Vector_Ave_RelaDensity(~cellfun('isempty', Vector_Ave_RelaDensity));
Vector_Ave_RelaDensity=cell2mat(Vector_Ave_RelaDensity);


save('Vector_DC','Vector_DC')
save('Vector_Relat_Density','Vector_Relat_Density')

save('Vector_Ave_DC','Vector_Ave_DC')
save('Vector_Ave_Density','Vector_Ave_Density')
save('Vector_Ave_RelaDensity','Vector_Ave_RelaDensity')


%-- Plot Scatter plot and display the correlation coefficient for spearman
%and pearson method
figure
plot(Vector_DC,Vector_Relat_Density,...
'Marker','.','MarkerSize',3,'LineStyle','none','color','red')
xlabel('DC')
ylabel('Relative Density')
tt = getframe(gcf);
imwrite(tt.cdata, 'Relative_Density_vs_DC_perMolecule.tif');
%close gcf

figure
plot(Vector_Ave_DC,Vector_Ave_Density,...
'Marker','.','MarkerSize',3,'LineStyle','none','color','red')
xlabel('DC per Cluster')
ylabel('Density per Cluster')
tt = getframe(gcf);
imwrite(tt.cdata, 'Density_vs_DC_perCluster.tif');
%close gcf

figure
plot(Vector_Ave_DC,Vector_Ave_RelaDensity,...
'Marker','.','MarkerSize',3,'LineStyle','none','color','red')
xlabel('DC per Cluster')
ylabel('Relative Density per Cluster')
tt = getframe(gcf);
imwrite(tt.cdata, 'Relat_Density_vs_DC_perCluster.tif');
%close gcf

Rho_pearson=corr(Vector_DC,Vector_Relat_Density,'type','Pearson')
Rho_Spearman=corr(Vector_DC,Vector_Relat_Density,'type','Spearman')

Rho_pearson=corr(Vector_Ave_DC,Vector_Ave_Density,'type','Pearson')
Rho_Spearman=corr(Vector_Ave_DC,Vector_Ave_Density,'type','Spearman')

Rho_pearson=corr(Vector_Ave_DC,Vector_Ave_Density,'type','Pearson')
Rho_Spearman=corr(Vector_Ave_DC,Vector_Ave_Density,'type','Spearman')

end

