function [Lr_r_Result,r]=RipleyKmultiData_GUIFun (AllData,Path_name)
      
        % create the output folder 'RipleyKGUI_Result
        if ~exist(strcat(Path_name,'RipleyKGUI_Result'),'dir')
            mkdir('RipleyKGUI_Result');
        end
        
        sizeData=size(AllData);
        cd(fullfile(Path_name,'RipleyKGUI_Result'))
        mkdir('RipleyK_Plots');
%%
i=0;
for p=1:sizeData(2)
    for q=1:sizeData(1)
        
        Data=AllData{q,p};
        if ~isempty(Data)
            i=i+1;
            x=Data(:,5:6);
            ROIsize=ceil((max(x)-min(x))/10)*10;

            Start=0;
            End=1000;
            Step=10;
            size_ROI=[4000 4000];
            A=ROIsize(2)^2; 
            [r Lr_r]=RipleyFunV2( x,A,Start,End,Step,size_ROI); 

            figure; plot( r, Lr_r,'red');hold on
            [MaxLr_r Index]=max(Lr_r);
            Max_Lr(i)=MaxLr_r;
            Max_r(i)=r(Index);
            Lr_r_Result(:,i)=Lr_r;

    %%
             str1={strcat('Max L :',num2str(MaxLr_r)),strcat('Max R :',num2str(Max_r(i)))};
             annotation('textbox', [0.65,0.8,0.22,0.1],'String', str1,'FitBoxToText','on');         
             set(gcf,'Color',[1 1 1])
             tt = getframe(gcf);
             imwrite(tt.cdata, strcat('RipleyK_Plots','Ripley_',num2str(p),'Region_',num2str(q) ,'.tif'))
             close gcf

            Array=[{'r'},{'Lr-r'}];
            Matrix_Result=[r Lr_r];
            SheetName=strcat('Cell_',num2str(p),'Region_',num2str(q));
            xlswrite('Ripley_Result',Array,SheetName,'A1');
            xlswrite('Ripley_Result',Matrix_Result,SheetName,'A2');
        end
         
    end
end
       
%% Pooling Data
Average_Lr_r(:,1)=r;
Average_Lr_r(:,2)=mean(Lr_r_Result,2);
Std_Lr_r(:,2)=std(Lr_r_Result,0,2);

Max_r_Ave=[mean(Max_r) std(Max_r)];
Max_Lr_Ave=[mean(Max_Lr) std(Max_Lr)];

    % Data average on all the regions and cells 
    Array1=[{'r'},{'Lr-r'}];
    Matrix_Result1=Average_Lr_r;
    SheetName1='Pool_data';
    xlswrite('Ripley_Result',Array1,SheetName1,'A1');
    xlswrite('Ripley_Result',Matrix_Result1,SheetName1,'A2');
    
    % average for max Lr-r and r(max Lr-r)
    Array2=[{'r(max_Lr)'},{'Max_Lr'}];
    Array3=[{'Mean'},{'Std'}]';
    Matrix_Result1=[Max_r_Ave' Max_Lr_Ave'];
    xlswrite('Ripley_Result',Array3,SheetName1,'D3');
    xlswrite('Ripley_Result',Array2,SheetName1,'E2');
    xlswrite('Ripley_Result',Matrix_Result1,SheetName1,'E3');
    
    % max Lr-r and r(max Lr-r) for each region
    Matrix_Result2=[Max_r; Max_Lr]';
    xlswrite('Ripley_Result',Array2,SheetName1,'E6');
    xlswrite('Ripley_Result',Matrix_Result2,SheetName1,'E7');

Lr_Ave=[Average_Lr_r Std_Lr_r(:,2)];
figure; plot( Lr_Ave(:,1), Lr_Ave(:,2),'red');hold on
plot( Lr_Ave(:,1), Lr_Ave(:,2)+Lr_Ave(:,3),'b:');
plot( Lr_Ave(:,1), Lr_Ave(:,2)-Lr_Ave(:,3),'b:');

str1={strcat('Max L :',num2str(Max_Lr_Ave(1))),strcat('Max R :',num2str(Max_r_Ave(1)))};
annotation('textbox', [0.65,0.8,0.22,0.1],'String', str1,'FitBoxToText','on');

         set(gcf,'Color',[1 1 1])
         tt = getframe(gcf);
         imwrite(tt.cdata, strcat('Ripley_Average.tif'))
         close gcf
         

end
