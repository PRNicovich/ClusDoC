
%%
% Identify untriggered and triggered clusters
% 
% Ch1 and Ch2
% load data from DBSCAN after DofC
% load('F:\DATA_PALM\Sophie Data\Dataset for changes\ResultDofC_V3_with_Threshold\DBSCAN for DoC Ch1_V3\DBSCAN for DoC Ch1.mat')

%Ch1

[row, column]=size(ClusterSmoothTableCh1);
for i=1:column    
    for j=1:row
        A_Ch1=ClusterSmoothTableCh1{j,i};

        if ~isempty(A_Ch1)
            
            % Population of cluster with Nb>10  
            Ch1=cellfun(@(x) x(x.Nb>10), A_Ch1,'UniformOUtput',0);
            A_Ch1=A_Ch1(~cellfun('isempty', Ch1));
           
            % Cluster with Nb(Dof>0.4) >10          
            Cluster_DofC_Ch1=cellfun(@(x) x(x.Nb_In>10), A_Ch1,'UniformOUtput',0);
            Cluster_DofC_Ch1=Cluster_DofC_Ch1(~cellfun('isempty', Cluster_DofC_Ch1));
           
            % DofC for cluster Nb(Dof>0.4) >10    
           
            DofC_Trig_Ch1{j,i}=cellfun(@(x) x.Data_DoCi.DofC, Cluster_DofC_Ch1,'UniformOutput',0);
                    
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           
            % Cluster with Nb(Dof>0.4) <10
            Cluster_Other_Ch1=cellfun(@(x) x(x.Nb_In<=10), A_Ch1,'UniformOUtput',0);
            Cluster_Other_Ch1=Cluster_Other_Ch1(~cellfun('isempty', Cluster_Other_Ch1));
          
            DofC_NonTrig_Ch1{j,i}=cellfun(@(x) x.Data_DoCi.DofC, Cluster_Other_Ch1,'UniformOutput',0);                
        end        
    end    
end

%Ch2

[row, column]=size(ClusterSmoothTableCh2);
for i=1:column    
    for j=1:row
        A_Ch2=ClusterSmoothTableCh2{j,i};

        if ~isempty(A_Ch2)
            
            % Population of cluster with Nb>10  
            Ch2=cellfun(@(x) x(x.Nb>10), A_Ch2,'UniformOUtput',0);
            A_Ch2=A_Ch2(~cellfun('isempty', Ch2));
           
            % Cluster with Nb(Dof>0.4) >10          
            Cluster_DofC_Ch2=cellfun(@(x) x(x.Nb_In>10), A_Ch2,'UniformOUtput',0);
            Cluster_DofC_Ch2=Cluster_DofC_Ch2(~cellfun('isempty', Cluster_DofC_Ch2));
           
            % DofC for cluster Nb(Dof>0.4) >10    
           
            DofC_Trig_Ch2{j,i}=cellfun(@(x) x.Data_DoCi.DofC, Cluster_DofC_Ch2,'UniformOutput',0);
                    
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           
            % Cluster with Nb(Dof>0.4) <10
            Cluster_Other_Ch2=cellfun(@(x) x(x.Nb_In<=10), A_Ch2,'UniformOUtput',0);
            Cluster_Other_Ch2=Cluster_Other_Ch2(~cellfun('isempty', Cluster_Other_Ch2));
          
            DofC_NonTrig_Ch2{j,i}=cellfun(@(x) x.Data_DoCi.DofC, Cluster_Other_Ch2,'UniformOutput',0);                
        end        
    end    
end

%% Histogram for NonCluster, NonTriggerd, Triggered
% percent of molecules with dofC >=0.4 for each populations
mkdir('Trig_NonTrig')
cd('Trig_NonTrig')
fun1=@(x) length(find(x>=0.4))/length(x);

% Non_Triggered
% Ch1
save('DofC_NonTrig_Ch1','DofC_NonTrig_Ch1')

A=DofC_NonTrig_Ch1(:);
A=A(~cellfun('isempty',A));
DofC_NonTrig_Ch1=A;

hist_nonTrig_Ch1=cell2mat(cellfun(@(x) cell2mat(x),DofC_NonTrig_Ch1,'UniformOutput',0));
hist_nonTrig_Ch1(hist_nonTrig_Ch1==0)=[];
figure; hist(hist_nonTrig_Ch1,100)
tt = getframe(gcf);
imwrite(tt.cdata, 'Hist_nonTrig_Ch1.tif');
close gcf

NonTrig_percent_Ch1=cellfun(@(x) fun1(cell2mat(x)), DofC_NonTrig_Ch1);

Ave_DofC_NonTrig_Ch1=(cellfun(@(x) mean(cell2mat(x)), DofC_NonTrig_Ch1,'UniformOutput',0));

%Ch2
save('DofC_NonTrig_Ch2','DofC_NonTrig_Ch2')

A=DofC_NonTrig_Ch2(:);
A=A(~cellfun('isempty',A));
DofC_NonTrig_Ch2=A;

hist_nonTrig_Ch2=cell2mat(cellfun(@(x) cell2mat(x),DofC_NonTrig_Ch2,'UniformOutput',0));
hist_nonTrig_Ch2(hist_nonTrig_Ch2==0)=[];
figure; hist(hist_nonTrig_Ch2,100)
tt = getframe(gcf);
imwrite(tt.cdata, 'Hist_nonTrig_Ch2.tif');
close gcf

NonTrig_percent_Ch2=cellfun(@(x) fun1(cell2mat(x)), DofC_NonTrig_Ch2);

Ave_DofC_NonTrig_Ch2=(cellfun(@(x) mean(cell2mat(x)),DofC_NonTrig_Ch2,'UniformOutput',0));



% Triggered
% Ch1
save('DofC_Trig_Ch1','DofC_Trig_Ch1')

A=DofC_Trig_Ch1(:);
A=A(~cellfun('isempty',A));
DofC_Trig_Ch1=A;

hist_Trig_Ch1=cell2mat(cellfun(@(x) cell2mat(x),DofC_Trig_Ch1,'UniformOutput',0));
hist_Trig_Ch1(hist_Trig_Ch1==0)=[];
figure; hist(hist_Trig_Ch1,100)
tt = getframe(gcf);
imwrite(tt.cdata, 'Hist_Trig_Ch1.tif');
close gcf

Trig_percent_Ch1=cellfun(@(x) fun1(cell2mat(x)), DofC_Trig_Ch1);
Ave_DofC_Trig_Ch1=(cellfun(@(x) mean(cell2mat(x)),DofC_Trig_Ch1,'UniformOutput',0));
save('DofC_Trig_Ch1','DofC_Trig_Ch1')
save('Trig_percent_Ch1','Trig_percent_Ch1')
save('Ave_DofC_Trig_Ch1','Ave_DofC_Trig_Ch1')

%Ch2
save('DofC_Trig_Ch2','DofC_Trig_Ch2')

A=DofC_Trig_Ch2(:);
A=A(~cellfun('isempty',A));
DofC_Trig_Ch2=A;

hist_Trig_Ch2=cell2mat(cellfun(@(x) cell2mat(x),DofC_Trig_Ch2,'UniformOutput',0));
hist_Trig_Ch2(hist_Trig_Ch2==0)=[];
figure; hist(hist_Trig_Ch2,100)
tt = getframe(gcf);
imwrite(tt.cdata, 'Hist_Trig_Ch2.tif');
close gcf

Trig_percent_Ch2=cellfun(@(x) fun1(cell2mat(x)), DofC_Trig_Ch2);
Ave_DofC_Trig_Ch2=(cellfun(@(x) mean(cell2mat(x)),DofC_Trig_Ch2,'UniformOutput',0));
save('Trig_percent_Ch2','Trig_percent_Ch2')
save('Ave_DofC_Trig_Ch2','Ave_DofC_Trig_Ch2')

%%
figure
hist(hist_nonTrig_Ch1,100) % Hist does not return a handle, but creates an axes with a child of type Patch
patch1 = findobj(gca,'type','Patch'); % The child object of axes is a Patch Object


hold on     
hist(hist_Trig_Ch1,100)
patch2 = findobj(gca,'type','Patch'); % The child object of axes is a Patch Object
set(patch2,'FaceAlpha',0.2);
set(patch2(1),'FaceColor','r');
tt = getframe(gcf);
imwrite(tt.cdata, 'Hist_Trig_NonTrig_Ch1.tif');
close gcf

figure
hist(hist_nonTrig_Ch2,100) % Hist does not return a handle, but creates an axes with a child of type Patch
patch1 = findobj(gca,'type','Patch'); % The child object of axes is a Patch Object


hold on     
hist(hist_Trig_Ch2,100)
patch2 = findobj(gca,'type','Patch'); % The child object of axes is a Patch Object
set(patch2,'FaceAlpha',0.2);
set(patch2(1),'FaceColor','r');
tt = getframe(gcf);
imwrite(tt.cdata, 'Hist_Trig_NonTrig_Ch2.tif');
close gcf



