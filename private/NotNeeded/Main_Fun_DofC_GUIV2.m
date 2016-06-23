function [Data_DofC,DensityROI]=Main_Fun_DofC_GUIV2(ROIData)
%% Colocalization Malkusch (Histochem Cell Biol)
       
        Path_name=pwd;
        if ~exist(strcat(Path_name,'Image from DofC'),'dir')
            mkdir('Image from DofC');
        end
        
        [ region_nb,table_nb ]=size(ROIData);
        r=20;
%% 

for nt=1:table_nb
    
    for k=1:region_nb
        
         Data=ROIData{k,nt};
        if ~isempty(Data)
        Data(isnan(Data(:,12)),:)=[];
        
        Data_DegColoc1=[]; % Data_DegColoc1 =[X Y Lr Kr Ch Density DofC D1_D2]
        [ Data_DegColoc1, SizeROI1 ] = Fun_DofC_GUIV2( Data, r );
        
        CA1=Data_DegColoc1.DofC(Data_DegColoc1.Ch==1);
        CA2=Data_DegColoc1.DofC(Data_DegColoc1.Ch==2);
 
        figure
        subplot(2,1,1);
        %h1=histfit(CA1,100,'kernel');
        hist(CA1,100);
        xlim([-1 1])
        ylabel('Frequency','FontSize',20,'FontWeight','bold');
        set(gca,'FontSize',20)
            
%             xdata1 = get(h1(2), 'XData');  %data from low-level grahics objects
%             ydata1 = get(h1(2), 'YData');  %data from low-level grahics objects
%             Mean1=mean(CA1);
%             Mode1=xdata1(ydata1==max(ydata1));
%             Meanvalue1=[Meanvalue1;Mean1 Mode1];
%             title(strcat('Colocalization Ch1, Mean = ', num2str(Mean1), ', Mode = ', num2str(Mode1)))
            
        subplot(2,1,2)
        %h2=histfit(CA2,100,'kernel'); 
        hist(CA2,100);
        xlim([-1 1])
        xlabel('Degree of Colocalisation','FontSize',20,'FontWeight','bold');
        ylabel('Frequency','FontSize',20,'FontWeight','bold');
        set(gca,'FontSize',20)
            
%             xdata2 = get(h2(2), 'XData');  %data from low-level grahics objects
%             ydata2 = get(h2(2), 'YData');  %data from low-level grahics objects
%             Mean2=mean(CA2);
%             Mode2=xdata2(ydata2==max(ydata2));
%             Meanvalue2=[Meanvalue2;Mean2 Mode2];
%             title(strcat('Colocalization Ch2, Mean = ', num2str(Mean2), ', Mode = ', num2str(Mode2)))

            % Save the figure
            Name=strcat('Table_',num2str(nt),'_Region_',num2str(k),'_Hist'); %t

            set(gcf,'Color','w') 
            set(gcf,'inverthardcopy','off'); 
            tt = getframe(gcf);
            imwrite(tt.cdata, strcat('Image from DofC/',Name,'_Hist.tif'))
            %export_fig(strcat('Degree_of_Colocalisation/',Name,'_Hist.pdf'));

        Data_DofC{k,nt}=Data_DegColoc1;
        
        close gcf
        
        % Average density for each region
        AvDensityROI12=size([CA1;CA2],1)/SizeROI1^2;
        AvDensityROI1 =size(CA1,1)/SizeROI1^2;
        AvDensityROI2 =size(CA2,1)/SizeROI1^2;
        
        A= [AvDensityROI12 AvDensityROI1 AvDensityROI2];
        DensityROI{k,nt}= A;
        
        end        
        %AvDensityCell(nt,:)=mean (DensityROI,1);        
    end     
end

A=Data_DofC(~cellfun('isempty', Data_DofC(:)));
DoC1=cell2mat(cellfun(@(x) x.DofC(x.Ch==1),A(:),'UniformOutput',0));
DoC2=cell2mat(cellfun(@(x) x.DofC(x.Ch==2),A(:),'UniformOutput',0));
DoC1(DoC1==0)=[];
DoC2(DoC2==0)=[];       

figure
        subplot(2,1,1);
        %h1=histfit(DoC1,100,'kernel');
        hist(DoC1,100);
        xlim([-1 1])
        ylabel('Frequency','FontSize',20,'FontWeight','bold');
        set(gca,'FontSize',20)
        
%         xdata1 = get(h1(2), 'XData');  %data from low-level grahics objects
%         ydata1 = get(h1(2), 'YData');  %data from low-level grahics objects
%         Mean1=mean(DoC1);
%         Mode1=xdata1(ydata1==max(ydata1));
%         %Meanvalue1=[Meanvalue1;Mean1 Mode1];
%         %title(strcat('Colocalization Ch1, Mean = ', num2str(Mean1), ', Mode = ', num2str(Mode1)))


        subplot(2,1,2)
        %h2=histfit(DoC2,100,'kernel'); 
        hist(DoC2,100);
        xlim([-1 1])
        xlabel('Degree of Colocalisation','FontSize',20,'FontWeight','bold');
        ylabel('Frequency','FontSize',20,'FontWeight','bold');
        set(gca,'FontSize',20)
        
%         xdata2 = get(h2(2), 'XData');  %data from low-level grahics objects
%         ydata2 = get(h2(2), 'YData');  %data from low-level grahics objects
%         Mean2=mean(DoC2);
%         Mode2=xdata2(ydata2==max(ydata2));
%         %Meanvalue2=[Meanvalue2;Mean2 Mode2];
%         %title(strcat('Colocalization Ch2, Mean = ', num2str(Mean2), ', Mode = ', num2str(Mode2)))

        % Save the figure
        
        set(gcf,'Color','w') 
        set(gcf,'inverthardcopy','off'); 
        tt = getframe(gcf);
        imwrite(tt.cdata, strcat('Image from DofC/','1_Pool_Data_Hist.tif'))
close gcf

    save( 'Data_for_Cluster_Analysis.mat','Data_DofC','ROIData','DensityROI');
    

end  
    
    