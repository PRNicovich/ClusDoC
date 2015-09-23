
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
    
%%
DenseCluster_per_DofC04=cellfun(@(x) length(find(x>0.4))/length(x),DofC_DenseCluster);
NotDenseCluster_per_DofC04=cellfun(@(x) length(find(x>0.4))/length(x),DofC_NotDenseCluster);
NotDense_Dense_per_DC04=table(DenseCluster_per_DofC04,NotDenseCluster_per_DofC04);
save('NotDense_Dense_per_DC04','NotDense_Dense_per_DC04');

%%
DenseDC04=cellfun(@(x) length(find(x>0.4)),DofC_DenseCluster);
Dense=cellfun(@(x) length(x),DofC_DenseCluster);
NotDenseDC04=cellfun(@(x) length(find(x>0.4)),DofC_NotDenseCluster);
NotDense=cellfun(@(x) length(x),DofC_NotDenseCluster);

NbAll=Dense+NotDense;
NbAllDC04=DenseDC04+NotDenseDC04;

perDense=Dense./NbAll;
perNotDense=NotDense./NbAll;

PerDenseDC04=DenseDC04./NbAllDC04;
PerNotDenseDC04=NotDenseDC04./NbAllDC04;

Per_NotDense_Dense=table(perDense,perNotDense,PerDenseDC04,PerNotDenseDC04);
save('Per_NotDense_Dense','Per_NotDense_Dense')



%%





