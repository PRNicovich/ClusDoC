function [ClusImage,  AreaC, Circularity, Nb, Contour, edges, Cutoff_point]=Smoothing_fun4cluster_GUIV2(ClusterOI, display1,display2)

% Smoothing function for clusters version V2C_1_3

% Particles forming the cluster
% From previous version, Circularity has been added.

% ClusterOI=Cluster{330};


x =ClusterOI(:,1) ;
y =ClusterOI (:,2);
Nb=length(x);
dx=1;
dy=1;
sigmas=15;
% Size of the box
xmin=min(x);
xmax=max(x);
ymin=min(y);
ymax=max(y);

xlength=xmax-xmin;
ylength=ymax-ymin;

boxsize=max(xlength,ylength);
xcenter=(xmax+xmin)/2;
ycenter=(ymax+ymin)/2;
epsilon=30;
xminbox=xcenter-(boxsize/2+epsilon);
xmaxbox=xcenter+(boxsize/2+epsilon);
yminbox=ycenter-(boxsize/2+epsilon);
ymaxbox=ycenter+(boxsize/2+epsilon);


%% Create the grid

xx1 = floor(xminbox/dx)*dx:dx:ceil(xmaxbox/dx)*dx;
yy1 = floor(yminbox/dy)*dy:dy:ceil(ymaxbox/dy)*dy;

%% Create a histogram of positions (optionally weighted by the intensity)

    pos = [x,y];
    edges{1} = xx1;
    edges{2} = yy1;
    if 1==1 % yes if peaksprop2int=0 Proportional to intensity
        aux = hist3(pos,'Edges',edges)';
        Ih = aux(1:end-1,1:end-1);
    else % yes if peaksprop2int=1
        ix = floor((x-xmin)/dx)+1;
        iy = floor((y-ymin)/dy)+1;
        subs = [iy(:) ix(:)];
        sz = size(Ipd1);
        Ih = accumarray(subs,alpha,sz,@sum);
    end
%     figure;
%     hist3(pos,'Edges',edges);

    
    %% convolve the histogram with Gaussian kernel using its separability
    if 1==1 % if you want to smooth
        q = 3; % half-size of the kernel in terms of number of standard deviations (6 sigmas= 99.8% of the Normal distribution)
        Nk = ceil(q*sigmas/dx)*2+1; % number of point for the binning
        aux1 = linspace(-q*sigmas, q*sigmas,Nk);     % x^2
        Ik = exp(-aux1.^2/(2*sigmas^2));  % exp( - (x^2+y^2)/(2*sigma^2) )
        if 1==0 % normalize to unit energy by area
            Ik = Ik/sum(Ik(:));
        end
        hcol = Ik(:);
        hrow = hcol';
        Ipd1 = conv2(hcol,hrow,Ih,'same');
    else %% do not smooth. If the image is a histogram, return a matrix of integers
        if ~peaksproportional2intensity
            aux = max(Ih(:));
            aux1 = intmax('uint16');
            if aux>aux1
                warning(['Cannot store the image as an integer because value ',num2str(aux),' exceeds maximum ',num2str(aux1)]);
            else
                Ih = uint16(Ih);
            end
        end
        Ipd1 = Ih;
    end
    ClusImage=Ipd1;
    
    % create interpolation of the grid to assess value at the points
    % (real positions)
    Intensity=interp2(edges{1}(1:end-1),fliplr(edges{2}(1:end-1)),flipud(Ipd1),x,y);
    
    %% Choose the smallest contour taking all the points
    
    Cutoff_point=min(Intensity);
    %C_min_val=contourc(edges{1}(1:end-1),edges{2}(1:end-1),Ipd1,[Cutoff_point, Cutoff_point]);
    
    
    %% Cluster analysis
    
    %C1=C_min_val(:,2:end)';
    %Area=polyarea(C1(:,1),C1(:,2));
    %Contour1=C1;
    Cout = contourcs(edges{1}(1:end-1),edges{2}(1:end-1),Ipd1,[Cutoff_point, Cutoff_point]);
    
    %% Take the bigger cluster 
        % Put contours in a cell (array)
%         if 1==0
%     i=1;
%     k=0;
%     stop=0;
%     C_length=length(C_min_val(2,:));
%     while stop==0
%         
%         ContourLength=C_min_val(2,i);
%         k=k+1;
%         C1=C_min_val(:,i+1:i+ContourLength)';
%         Contour{k,1}=C1;
%         Area(k,1)=polyarea(C1(:,1),C1(:,2));
%         N(k,1)=length(find(inpolygon(x,y,C1(:,1),C1(:,2))>0));
%         D(k,1)=N(k)/Area(k);
%         
%         if  i+ContourLength==C_length
%             stop=1;
%         else
%             i=i+ContourLength+1;
%         end
%     end
%         end 
        
     %if 1==1
      % Other contourcs Calculation
      
     Length=arrayfun(@(x) x.Length,Cout);
     [value index]=max(Length);   
     Contour=[Cout(index).XCont' Cout(index).YCont'];  
     AreaC=polyarea(Contour(:,1),Contour(:,2));
    
    %[AreaC index]=max(Area);   
    %Cluster=table(Area,N,D);
    %Cluster=Cluster(index,:);
    %Contour=Contour{index};
    
    % Perimter Circularity calculation
    dx = diff(Contour(:,1));
    dy = diff(Contour(:,2));
    Perimeter = sum(sqrt(dx.^2 + dy.^2));
    Circularity=4*pi*AreaC/Perimeter^2;

    %% Display
    if display1==1
    figure;hold on
    imagesc(edges{1}(1:end-1),fliplr(edges{2}(1:end-1)),flipud(Ipd1))   
    plot( x, y,'Marker','+','MarkerSize',4,'LineStyle','none','color','black');
    colorbar
    axis equal
    axis tight  
    end
    
    if display2==1
    %figure; hold on
    %scatter(x,y,8,Intensity,'fill')
    C_min_val=contour(edges{1}(1:end-1),edges{2}(1:end-1),Ipd1,Cutoff_point,'color', 'black');
    colorbar
    axis equal
    axis tight  
    end
    
end
    
%     