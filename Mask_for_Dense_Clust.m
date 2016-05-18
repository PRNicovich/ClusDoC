%% Mask for Dense and not Dense cluster

[ROI, CELL]=size(ClusterSmoothTableCh1);
 DenseCluster={};
Density_Threshold=6;
    for cell=1:CELL    
        for roi=1:ROI
            A=ClusterSmoothTableCh1{roi,cell};

            if ~isempty(A)
                
                % Dense Cluster
                Dense_t= cellfun(@(y) y(y.AvRelativeDensity20>Density_Threshold),A,'UniformOutput',0);
                Dense_t=Dense_t(~cellfun('isempty',Dense_t));
                
                DofC_DenseCluster{roi,cell}=cell2mat(cellfun(@(x) x.Data_DoCi.DofC,Dense_t,'UniformOutput',0));
                Dense_Contour{roi,cell}=cellfun(@(x) [x.Contour;NaN NaN],Dense_t,'UniformOutput',0);

                DenseCluster{roi,cell}=Dense_t;
                
                % NotDense Cluster
                NotDense_t= cellfun(@(y) y(y.AvRelativeDensity20<Density_Threshold),A,'UniformOutput',0);
                NotDense_t=NotDense_t(~cellfun('isempty',NotDense_t));
                
                DofC_NotDenseCluster{roi,cell}=cell2mat(cellfun(@(x) x.Data_DoCi.DofC,NotDense_t,'UniformOutput',0));
                NotDense_Contour{roi,cell}=cellfun(@(x) [x.Contour;NaN NaN],NotDense_t,'UniformOutput',0);
                
                NotDenseCluster{roi,cell}=Dense_t;
                  
            end        
        end    
    end


%% Dense Cluster

    [ROI, CELL]=size(Dense_Contour);
    
    for cell=1:CELL   
          for roi=1:ROI
              
              B=ROIData{roi,cell};
              if ~isempty(B)
              BCh2=B(B(:,12)==2,:);
              CDense=Dense_Contour{roi,cell};
              
                  in={};
                  for i=1:length(CDense)

                      in{i,1}=inpolygon(BCh2(:,5),BCh2(:,6),CDense{i}(:,1),CDense{i}(:,2));

                  end

                  Nb_In_Dense=cellfun(@(x) length(find(x==1)), in,'UniformOutput', 1);
                  Nb_In_Dense_Table{roi,cell}= Nb_In_Dense;
                  
              end

          end
    end


%% Not Dense Cluster

    [ROI, CELL]=size(NotDense_Contour);
    
    for cell=1:CELL   
          for roi=1:ROI
              
              B=ROIData{roi,cell};
              if ~isempty(B)
              BCh2=B(B(:,12)==2,:);
              CNotDense=NotDense_Contour{roi,cell};
              
                  in={};
                  for i=1:length(CNotDense)

                      in{i,1}=inpolygon(BCh2(:,5),BCh2(:,6),CNotDense{i}(:,1),CNotDense{i}(:,2));

                  end

                  Nb_In_NotDense=cellfun(@(x) length(find(x==1)), in,'UniformOutput', 1);
                  Nb_In_NotDense_Table{roi,cell}= Nb_In_NotDense;
                  
              end

          end
    end


%%

Ch2_in_Dense=cellfun(@(x) sum(x),Nb_In_Dense_Table);
Ch2_in_NotDense=cellfun(@(x) sum(x), Nb_In_NotDense_Table);

Ch2_in=Ch2_in_Dense+Ch2_in_NotDense;
Dense=Ch2_in_Dense./Ch2_in;
NotDense=Ch2_in_NotDense./Ch2_in;

Per_Ch2_In=table(Dense,NotDense);
save('Per_Ch2_In','Per_Ch2_In')
clearvars -except Per_Ch2_In





























































