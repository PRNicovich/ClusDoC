%% Calculate the NND between the clusters in each region and part the cluster in Triggered and NonTriggered category
% then calculate the average of the value per region and per
% cluster category

[row, column]=size(ClusterSmoothTableCh1);
for i=1:column    
    for j=1:row
        A_Ch1=ClusterSmoothTableCh1{j,i};

        if ~isempty(A_Ch1)
            
            % Population of cluster with Nb>10  
            Ch1=cellfun(@(x) x(x.Nb>10), A_Ch1,'UniformOUtput',0);
            A_Ch1=A_Ch1(~cellfun('isempty', Ch1));
                       
            % Calculate NND          
            Xcenter_Ch1=cellfun(@(x) mean(x.Data_DoCi.X), A_Ch1,'UniformOUtput',1);
            Ycenter_Ch1=cellfun(@(x) mean(x.Data_DoCi.Y), A_Ch1,'UniformOUtput',1);
            XY_Center_Ch1{j,i}=[Xcenter_Ch1 Ycenter_Ch1];
            [idx d] =knnsearch (XY_Center_Ch1{j,i},XY_Center_Ch1{j,i},'k',2);
            
            
            % Triggered Cluster with Nb(Dof>0.4) >10          
            Nb_in_Ch1=cellfun(@(x) x.Nb_In, A_Ch1,'UniformOUtput',1);
            Index_Trig=find(Nb_in_Ch1>10);
            %Cluster_DofC_Ch1=Cluster_DofC_Ch1(~cellfun('isempty', Cluster_DofC_Ch1));
            %nnd{j,i}=d(index_Trig_Ch1,2);
            NND_Trig{j,i}=d(Index_Trig,2);
            
            
            % Non-Triggered Cluster with Nb(Dof>0.4) <=10          
            Index_Trig=find(Nb_in_Ch1<=10);
            %Cluster_DofC_Ch1=Cluster_DofC_Ch1(~cellfun('isempty', Cluster_DofC_Ch1));
            %nnd{j,i}=d(index_Trig_Ch1,2);
            NND_NonTrig{j,i}=d(Index_Trig,2);
            
            
        end        
    end    
end


%%
NND_Trig_Ave=cellfun(@(x) mean(x), NND_Trig,'UniformOUtput',1);
NND_nonTrig_Ave=cellfun(@(x) mean(x), NND_NonTrig,'UniformOUtput',1);

NND=table(NND_Trig_Ave,NND_nonTrig_Ave);