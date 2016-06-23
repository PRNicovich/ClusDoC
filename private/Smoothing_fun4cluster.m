function [ClusImage,  AreaC, Circularity, Nb, Contour, edges, Cutoff_point] = Smoothing_fun4cluster(ClusterOI, DBSCANParams, display1, display2)

% Smoothing function for clusters version V2C_1_3

% Particles forming the cluster
% From previous version, Circularity has been added.

% ClusterOI=Cluster{330};

    Nb = size(ClusterOI, 1);
    sigmas = DBSCANParams.SmoothingRad;
    % Size of the box
    xmin = min(ClusterOI(:,1));
    xmax = max(ClusterOI(:,1));
    ymin = min(ClusterOI(:,2));
    ymax = max(ClusterOI(:,2));

    xlength = xmax - xmin;
    ylength = ymax - ymin;

    boxsize = max([xlength, ylength], [], 2);
    
    xcenter = (xmax + xmin)/2;
    ycenter = (ymax + ymin)/2;
    epsilon = DBSCANParams.epsilon;              
    xminbox = xcenter - (0.5*boxsize + epsilon + 10);
    xmaxbox = xcenter + (0.5*boxsize + epsilon + 10);
    yminbox = ycenter - (0.5*boxsize + epsilon + 10);
    ymaxbox = ycenter + (0.5*boxsize + epsilon + 10);


    %% Create the grid

    xx1 = floor(xminbox):ceil(xmaxbox);
    yy1 = floor(yminbox):ceil(ymaxbox);

    %% Create a histogram of positions (optionally weighted by the intensity)

    pos = ClusterOI(:,1:2);
    edges{1} = xx1;
    edges{2} = yy1;
    aux = hist3(pos,'Edges',edges)';
    Ih = aux(1:end-1,1:end-1);


    %% convolve the histogram with Gaussian kernel using its separability
    q = 3; % half-size of the kernel in terms of number of standard deviations (6 sigmas= 99.8% of the Normal distribution)
    Nk = ceil(q*sigmas)*2+1; % number of point for the binning
    aux1 = linspace(-q*sigmas, q*sigmas,Nk);     % x^2
    Ik = exp(-aux1.^2/(2*sigmas^2));  % exp( - (x^2+y^2)/(2*sigma^2) )
    hcol = Ik(:);
    hrow = hcol';
    ClusImage = conv2(hcol,hrow,Ih,'same');

    % create interpolation of the grid to assess value at the points
    % (real positions)
    Intensity = interp2(edges{1}(1:end-1), fliplr(edges{2}(1:end-1)), flipud(ClusImage), ClusterOI(:,1), ClusterOI(:,2));

    %% Choose the smallest contour taking all the points

    Cutoff_point = min(Intensity(:));
    %C_min_val=contourc(edges{1}(1:end-1),edges{2}(1:end-1),Ipd1,[Cutoff_point, Cutoff_point]);


    %% Cluster analysis

    %C1=C_min_val(:,2:end)';
    %Area=polyarea(C1(:,1),C1(:,2));
    %Contour1=C1;
    Cout = contourcs(edges{1}(1:end-1), edges{2}(1:end-1), ClusImage, [Cutoff_point, Cutoff_point]);

    %% Take the bigger cluster

    Length = arrayfun(@(x) x.Length,Cout);
    [~, index] = max(Length);
    Contour = [Cout(index).XCont' Cout(index).YCont'];
    AreaC = polyarea(Contour(:,1),Contour(:,2));

    %[AreaC index]=max(Area);
    %Cluster=table(Area,N,D);
    %Cluster=Cluster(index,:);
    %Contour=Contour{index};

    % Perimter Circularity calculation
    dx = diff(Contour(:,1));
    dy = diff(Contour(:,2));
    Perimeter = sum(sqrt(dx.^2 + dy.^2));
    Circularity = 4*pi*AreaC/Perimeter^2;

    %% Display
    % Need to specfy what each of these two plots actually generates
    if display1
        figure;
        set(gca, 'NextPlot', 'add');
        imagesc(edges{1}(1:end-1),fliplr(edges{2}(1:end-1)),flipud(ClusImage))
        plot( ClusterOI(:,1), ClusterOI(:,2), 'Marker', '+', 'MarkerSize', 4, ...
            'LineStyle', 'none', 'color', 'black');
        colorbar;
        axis equal
        axis tight
    end

    if display2
        %figure; hold on
        %scatter(x,y,8,Intensity,'fill')
        contour(edges{1}(1:end-1), edges{2}(1:end-1), ClusImage, Cutoff_point, 'color', 'black');
        colorbar
        axis equal
        axis tight
    end

end

%