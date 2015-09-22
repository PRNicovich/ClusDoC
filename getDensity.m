function [Trig, NonTrig, Result] = getDensity( ClusterSmoothTableCh1,case1 )
% Function extract the density from the cell/structure data  ClusterSmoothTableCh1
% density for Triggered and NonTriggered molecules
% and calculate the histograms
%   Detailed explanation goes here

    [row, column]=size(ClusterSmoothTableCh1);
    for i=1:column    
        for j=1:row
            A=ClusterSmoothTableCh1{j,i};

            if ~isempty(A)

                % Population of cluster with Nb>10  
                Ch1=cellfun(@(x) x(x.Nb>10), A,'UniformOUtput',0);
                A=A(~cellfun('isempty', Ch1));

                % Cluster with Nb(Dof>0.4) >10          
                Cluster_Trig=cellfun(@(x) x(x.Nb_In>10), A,'UniformOUtput',0);
                Cluster_Trig=Cluster_Trig(~cellfun('isempty', Cluster_Trig));

                % Density for cluster Nb(Dof>0.4) >10    

                if case1==1 % Case 1 : desnity Nb/A, 
                Density_Trig{j,i}=cellfun(@(x) (x.RelativeDensity_Nb_A)*ones(x.Nb,1), Cluster_Trig,'UniformOutput',0);
                elseif case1==2% Case 2 : desnity Nb/A, 
                Density_Trig{j,i}=cellfun(@(x) x.RelativeDensity20, Cluster_Trig,'UniformOutput',0);
                end
                
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                % Cluster with Nb(Dof>0.4) <10
                Cluster_NonTrig=cellfun(@(x) x(x.Nb_In<=10), A,'UniformOUtput',0);
                Cluster_NonTrig=Cluster_NonTrig(~cellfun('isempty', Cluster_NonTrig));

                if case1==1 
                Density_NonTrig{j,i}=cellfun(@(x) (x.RelativeDensity_Nb_A)*ones(x.Nb,1), Cluster_NonTrig,'UniformOutput',0);   
                elseif case1==2
                Density_NonTrig{j,i}=cellfun(@(x) x.RelativeDensity20, Cluster_NonTrig,'UniformOutput',0);   
                end
            end        
        end    
    end
    
    Trig=cell2mat(cellfun(@(x) cell2mat(x), Density_Trig(:),'UniformOutput',0));
    NonTrig=cell2mat(cellfun(@(x) cell2mat(x), Density_NonTrig(:),'UniformOutput',0));
    
    Density_Thres=prctile(NonTrig,95);
    NbTrig_above_Thres=length(find(Trig>Density_Thres));
    Nb_NonTrig_above_Thres=length(find(NonTrig>Density_Thres));
    Per_Trig_Above_Density_Thres1=NbTrig_above_Thres/length(Trig);
    Per_NonTrig_Above_Density_Thres1=Nb_NonTrig_above_Thres/length(NonTrig);
    Result=table(Density_Thres, Per_Trig_Above_Density_Thres1, NbTrig_above_Thres, Per_NonTrig_Above_Density_Thres1);
    
    figure
    hist(Trig,100) % Hist does not return a handle, but creates an axes with a child of type Patch
    patch1 = findobj(gca,'type','Patch'); % The child object of axes is a Patch Object
    set(patch1(1),'FaceColor','r');

    hold on     
    hist(NonTrig,100)
    patch2 = findobj(gca,'type','Patch'); % The child object of axes is a Patch Object
    set(patch2,'FaceAlpha',0.2);
    set(patch2(1),'FaceColor','b');
    X=Density_Thres*ones(2,1);
    Y=ylim;
    hold on;line(X,Y,'Color','red','LineWidth',1)
    
    tt = getframe(gcf);
    imwrite(tt.cdata, 'Hist_Trig_NonTrig_Ch1.tif');
    

    
    
    
    
    
    
end

