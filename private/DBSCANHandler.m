function [datathr, ClusterSmooth, SumofContour, classOut, varargout] = DBSCANHandler(Data, DBSCANParams, varargin)

% vargout = {fig1Handle, fig2Handle, fig3Handle, Results}

try 

    %   Data = Zen format
        % Routine for DBSCAN apply on the Zen data
        % Formerly FunDBSCAN_GUIV2.m

        % Inputs are Data for this ROI, DBSCAN parameters (handles.DBSCAN
        % structure) and varargin for display (cellNum, roiNum, display1,
        % display2)
        
        classOut = zeros(size(Data, 1), 1);

        if nargin == 3
            % Test mode
            % Fun_DBSCAN_Test
            cellNum = []; % Labeling only
            ROINum = []; % Labeling only
            display1 = false;
            display2 = false;
            printOutFig = false;
            clusterColor = rgb(46, 204, 113);
            maskVector = varargin{1};
        elseif nargin > 3
            % FullCalc mode
            % Follow FunDBSCAN_GUIV2
            cellNum = varargin{1}; % Labeling only, Cell number
            ROINum = varargin{2}; % Labeling only, ROI number
            display1 = varargin{3};
            display2 = varargin{4};
            printOutFig = true;
            clusterColor = varargin{5};
            maskVector = varargin{6};
            
            printOutFigDest = 'DBSCAN Results';
            
            if nargin == 10
                Density = varargin{7}; % Data is an input
                DoCScore = varargin{8};
                printOutFigDest = 'Clus-DoC Results\DBSCAN Results';
            end

        end
       

        % Calculate Lr for cumulated channels ch1
        % 

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
        % DBSCAN, plot of the contour, cluster centre identification
         % Parameters 1
        %figure1=[];

        if display1 || ~printOutFig
            fig1 = figure();
            varargout{1} = fig1;
            ax1 = axes('parent',fig1);
            set(ax1, 'NextPlot', 'add');
            plot(ax1, Data(:,1), Data(:,2), 'Marker', '.', 'MarkerSize', 5, 'LineStyle', 'none', 'color', rgb(127, 140, 141)); 
            axis image tight
        end


        %% Threshold for the DBSCAN_Nb_Neighbor on density
        xsize = ceil (max(Data(:,1)) - min(Data(:,1)));
        ysize = ceil (max(Data(:,2)) - min(Data(:,2)));
        SizeROI = max([xsize, ysize]);
        try
            AvDensity = size(Data, 1)/(xsize*ysize);
        catch mError
            assignin('base', 'Data', Data);
            rethrow(mError);
        end
        Nrandom = AvDensity*pi*DBSCANParams.Lr_rThreshRad^2;

        % if Nrandom<3
        %     Nrandom=3;
        % end

        %% L(r) thresholding

        if DBSCANParams.UseLr_rThresh
            %% Calculate Lr for cumulated channels ch1 
            %  Threshold the Lr at Lr_Threshold

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Use Lr(rad) value at each point to remove background points
            % Typically rad = 50 nm. 

            Lr_Threshold = sqrt((SizeROI)^2 * Nrandom / (size(Data, 1)-1)/pi);
            [data, idx, ~, Density ] = Lr_fun(Data(:,1), Data(:,2), Data(:,1), Data(:,2), DBSCANParams.Lr_rThreshRad, SizeROI); % data=[X2 Y2 Lr Kfuncans];
            %
            data(:,5) = ones(size(Data, 1), 1)*DBSCANParams.CurrentChannel; % channel index
            data(:,6) = Density;

            %       Include the points count in the search radius r for a point of interest

            dataThreshVector = unique(cell2mat(idx(data(:,3) > Lr_Threshold)'));
            datathr = data(dataThreshVector, :);

            Density = datathr(:,6);
        else
            dataThreshVector = true(size(Data, 1), 1);
            datathr = Data(dataThreshVector, 1:2);
        end
        
        if nargout == 9;
            disp('export dataThreshVector');
            varargout{5} = dataThreshVector;
        end

        % Data4dbscan = datathr(:,1:2);
        % DBSCAN_Radius = r2;%20;
        % DBSCAN_Nb_Neighbor = Epsilon;%3;%ceil(Nrandom);

        % FAST DBSCAN CALL

        class = t_dbscan(datathr(:,1), datathr(:, 2), DBSCANParams.minPts, DBSCANParams.epsilon, DBSCANParams.threads);
        classOut(dataThreshVector) = class;
        classOut(~dataThreshVector) = -1;

        SumofBigContour=[];
        SumofSmallContour=[];
        ClusterSmooth=cell(max(class),1);

        for i = 1:max(class)

            xin = datathr(class == i,:); % Positions contained in the cluster i

    %         assignin('base', 'xin', xin);

            if display1 || ~printOutFig
                plot(ax1,xin(:,1), xin(:,2),'Marker', '.', 'MarkerSize', 5,'LineStyle', 'none', 'color', clusterColor);
            end   

            [dataT, idxT, DisT, Density20 ] = Lr_fun(xin(:,1), xin(:,2), xin(:,1), xin(:,2) , 20, SizeROI); % Included in FunDBSCAN4DoC_GUIV2
                                                                                                                % Unsure how this is carried forward
            
            [ClusImage,  Area, Circularity, Nb, contour, edges, Cutoff_point] = Smoothing_fun4cluster(xin(:,1:2), DBSCANParams, false, false); % 0.1*max intensity 

            ClusterSmooth{i,1}.ClusterID = i;
            ClusterSmooth{i,1}.Points = xin(:,1:2);
            ClusterSmooth{i,1}.Image = ClusImage;
            ClusterSmooth{i,1}.Area = Area;%
            ClusterSmooth{i,1}.Nb = Nb;%
            ClusterSmooth{i,1}.edges = edges;%
            ClusterSmooth{i,1}.Cutoff_point = Cutoff_point;
            ClusterSmooth{i,1}.Contour = contour;%
            ClusterSmooth{i,1}.Circularity = Circularity;%
            ClusterSmooth{i,1}.TotalAreaDensity = AvDensity;%
            ClusterSmooth{i,1}.Density_Nb_A = Nb/Area;%
            ClusterSmooth{i,1}.RelativeDensity_Nb_A=Nb/Area/AvDensity;%
            ClusterSmooth{i,1}.NInsideMask = sum(maskVector(class == i));
            ClusterSmooth{i,1}.NOutsideMask = sum(~maskVector(class == i));

            ClusterSmooth{i,1}.Density20 = Density20;%
            
            ClusterSmooth{i,1}.RelativeDensity20 = Density20 / AvDensity;%
            
            
            ClusterSmooth{i,1}.AvRelativeDensity20 = mean(Density20/AvDensity); %

            if DBSCANParams.UseLr_rThresh
                ClusterSmooth{i,1}.Density = Density(class == i);%
                ClusterSmooth{i,1}.RelativeDensity = Density(class == i)/AvDensity;%
                ClusterSmooth{i,1}.RelativeDensity = Density(class == i)/AvDensity;
                ClusterSmooth{i,1}.Mean_Density = mean(Density(class == i));
                ClusterSmooth{i,1}.AvRelativeDensity = mean(Density(class == i)/AvDensity);%
                 
            end
            
            if nargin == 10 % DoC analysis.  Vector of DoC scores for each point is an input.
              
                ClusterSmooth{i,1}.Density = Density(class == i);%
                ClusterSmooth{i,1}.MeanDoC = mean(DoCScore(class == i));
                
                Point_In = xin(DoCScore(class == i) >= DBSCANParams.DoCThreshold, 1:2);
                Nb_In = size(Point_In,1);

                if Nb_In > 1
                    Density20_In = Density20(DoCScore(class == i) >= DBSCANParams.DoCThreshold);
%                     [Contour_In] = Smoothing_fun4clusterV3_3(Point_In, 0,0);
                    
                    [~,  ~, ~, ~, Contour_In, ~, ~] = Smoothing_fun4cluster(Point_In, DBSCANParams, 0, 0);

                    Area_In = polyarea(Contour_In(:,1),Contour_In(:,2));


                    ClusterSmooth{i,1}.Nb_In = Nb_In;
                    ClusterSmooth{i,1}.Area_In = Area_In;
                    ClusterSmooth{i,1}.AvRelativeDensity20_In = mean(Density20_In/AvDensity);

%                     plot(ax1,Contour_In(:,1),Contour_In(:,2),'r');

%                     DoCOut = Data_DoCi(Data_DoCi.DoC<0.4,:);
                    Density20_Out = Density20(DoCScore(class == i) >= DBSCANParams.DoCThreshold);

                    Nb_Out = length(Density20_Out);
                    ClusterSmooth{i,1}.Nb_Out = Nb_Out;
                    ClusterSmooth{i,1}.AvRelativeDensity20_Out = mean(Density20_Out/AvDensity);

                    ClusterSmooth{i,1}.DensityRatio = mean(Density20_In/AvDensity)/mean(Density20_Out/AvDensity);
                    ClusterSmooth{i,1}.Contour_In = Contour_In;

                    else
                        ClusterSmooth{i,1}.Nb_In = Nb_In;
                        ClusterSmooth{i,1}.Area_In = 0;
                        ClusterSmooth{i,1}.AvRelativeDensity20_In = 0;

                        ClusterSmooth{i,1}.DensityRatio =0;
                        ClusterSmooth{i,1}.Contour_In = 0; 
                end
                                    
                
            end
            
            
            
            
            

            if Nb >= DBSCANParams.Cutoff
                SumofBigContour = [SumofBigContour; contour; NaN NaN ];
            else
                SumofSmallContour = [SumofSmallContour; contour; NaN NaN ];  
            end
            SumofContour={SumofBigContour, SumofSmallContour};

            % Plot the contour

            if display1 || ~printOutFig

                if length(Nb) > DBSCANParams.Cutoff % Does this switch do anything?
                    plot(ax1, contour(:,1), contour(:,2), 'color', 'red');
                    set(ax1, 'box', 'on', 'XTickLabel', [], 'XTick', [], 'YTickLabel', [], 'YTick', []);
                else
                    plot(ax1, contour(:,1), contour(:,2), 'color', rgb(44, 62, 80));
                end

            end

        end
             ClusterSmooth = ClusterSmooth(~cellfun('isempty', ClusterSmooth));

             % Plot DBSCAN results
             Name = strcat('Cell', num2str(cellNum), '_Region', num2str(ROINum), 'Region_with_Cluster.tif');
             set(ax1, 'box', 'on','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[])
             set(fig1, 'Color', [1 1 1], 'Tag', 'ClusDoC')
             if printOutFig
                print(fullfile(DBSCANParams.Outputfolder, printOutFigDest, sprintf('Ch%d', DBSCANParams.CurrentChannel), 'Cluster maps', Name), fig1, '-dtiff');
                close(fig1);
             end


        %      s=cellfun('size', Cluster,1); % sort cluster by size
        %      [dummy index]=sort(s);
        %      Cluster=Cluster(index);
        %%

        if display2

            Density = datathr(:,6);
    %         assignin('base', 'Density', Density);
    %         assignin('base', 'datathr', datathr);
    %         
            fig2 = figure();
            varargout{2} = fig2;
            clf(fig2);
            ax2 = axes('parent',fig2); hold on;
            scatter(datathr(:,1), datathr(:,2), 2, Density);
            if ~isempty(SumofBigContour)
                plot(ax2, SumofBigContour(:,1),SumofBigContour(:,2), 'r');
            end
            if ~isempty(SumofSmallContour)
                plot(ax2, SumofSmallContour(:,1),SumofSmallContour(:,2), 'k');
            end

            c = colorbar;
            ylabel(c, 'Absolute Cluster Density');
            axis equal
            axis tight

            set(ax2, 'box', 'on', 'XTickLabel', [], 'XTick', [], 'YTickLabel', [], 'YTick', [], ...
                'XLim', [min(Data(:,1)), max(Data(:,1))], 'YLim', [min(Data(:,2)), max(Data(:,2))]);
            set(fig2, 'Color', [1 1 1], 'Tag', 'ClusDoC')

            Name = strcat('Cell',num2str(cellNum),'_Region',num2str(ROINum), '_Density_map.tif');
            print(fullfile(DBSCANParams.Outputfolder, 'DBSCAN Results', ...
                sprintf('Ch%d', DBSCANParams.CurrentChannel), 'Cluster density maps', Name), fig2, '-dtiff');
            close(fig2);

            Norm_Density = Density./max(Density(:));
            fig3 = figure;
            varargout{3} = fig3;
            ax3 = axes('parent',fig3, 'NextPlot', 'add');
            scatter(datathr(:,1), datathr(:,2), 2, Norm_Density);

            if ~isempty(SumofBigContour)
                plot(ax3, SumofBigContour(:,1),SumofBigContour(:,2), 'r');
            end
            if ~isempty(SumofSmallContour)
                plot(ax3, SumofSmallContour(:,1),SumofSmallContour(:,2), 'k');
            end

            c = colorbar;
            ylabel(c, 'Normalized Cluster Density');
            axis equal
            axis tight

            set(ax3, 'box', 'on', 'XTickLabel', [], 'XTick', [], 'YTickLabel', [], 'YTick', [], ...
                'XLim', [min(Data(:,1)), max(Data(:,1))], 'YLim', [min(Data(:,2)), max(Data(:,2))]);
            set(fig3, 'Color', [1 1 1], 'Tag', 'ClusDoC');

            Name = strcat('Cell',num2str(cellNum),'_Region',num2str(ROINum), '_Norm_Density_map.tif');
            print(fullfile(DBSCANParams.Outputfolder, 'DBSCAN Results', ...
                sprintf('Ch%d', DBSCANParams.CurrentChannel), 'Cluster density maps', Name), fig3, '-dtiff');
            close(fig3);

        end

        if DBSCANParams.DoStats

            Result.Number_Cluster = numel(ClusterSmooth);
            Result.Number(1) = mean(cell2mat(cellfun(@(x) x.Nb(x.Nb > DBSCANParams.Cutoff), ClusterSmooth, 'UniformOutput', false)));
            Result.Area(1) = mean(cell2mat(cellfun(@(x) x.Area(x.Nb > DBSCANParams.Cutoff), ClusterSmooth, 'UniformOutput', false)));
            Result.Mean_Circularity(1) = mean(cell2mat(cellfun(@(x) x.Circularity(x.Nb > DBSCANParams.Cutoff), ClusterSmooth, 'UniformOutput', false)));
            Result.Density = mean(cell2mat(cellfun(@(x) x.Density(x.Nb > DBSCANParams.Cutoff), ClusterSmooth, 'UniformOutput', false)));
            
            if DBSCANParams.UseLr_rThresh
            
                Result.RelativeDensity = mean(cell2mat(cellfun(@(x) x.RelativeDensity(x.Nb > DBSCANParams.Cutoff), ClusterSmooth, 'UniformOutput', false)));
                
            else
                
                Result.RelativeDensity = NaN;
                
            end
            
            Result.TotalNumber = size(Data,1);
            Result.Percent_in_Cluster = sum(cell2mat(cellfun(@(x) x.Nb, ClusterSmooth, 'UniformOutput', false)))/length(Data);

            varargout{4} = Result;

        end
        
        
        
catch mError
    assignin('base', 'DBSCANData', Data);
    assignin('base', 'DBSCANParams', DBSCANParams);
    assignin('base', 'DBSCANInputArgs', varargin);

    display('DBSCANHandler failed with errors');
    rethrow(mError);
end


end

% Adding Lr_fun here to avoid issues with private function calls

function [ data,idx,Dis,Density] = Lr_fun(X1, Y1, X2, Y2, r, SizeROI)

% SizeROI= size of the square (inmost case 4000nm)
       
        if isempty(X1) || isempty(X2)
            data = [];
            idx = [];
            Dis = [];
            Density = [];
        else
            
           if length(X1) ~= length(X2) 
               k = 0;
           elseif X1 ~= X2
               k = 0;
           elseif X1 == X2
               k = 1;
           end
               
        [idx, Dis] = rangesearch([X1, Y1], [X2, Y2], r); % find element of [x y] in a raduis of r from element of [x y]
        Kfuncans = cellfun('length', idx) - k;     % remove the identity
        Density = cellfun('length', idx) / (pi*r^2); %/(length(X2)/SizeROI^2); % Relative Density
        
        Lr = ((SizeROI)^2*Kfuncans / (length(X2) - 1)/pi).^0.5;     % calculate L(r)
        data=[X2, Y2, Lr];

        end 
end

function colorOut = rgb(a, b, c)

colorOut = [a, b, c]/255;

end




