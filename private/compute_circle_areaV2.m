function [o]=compute_circle_areaV2(xcenter,ycenter,r,size_ROI)
%this function takes a list of  circles centered (xcenter, ycenter) with radius r
%and calculate the relative area in the rectangle with size sizeROI xmax/ymax 1024x1024.
%rectangle size can be changed
%main strength of this function is by its speed of clculation.
%average computation time is about 0.3s
%This was achieved by aproximating the circle area into
%3rd order polynoms instead of integrating
%the circle equation for finding the area below the axis.
%%example
% %    x=1024*rand(1,10000);
% %    y=1024*rand(1,10000);
% %    radius=50;
% %    tic;
% %    relative_area=compute_circle_area2(x,y,radius);
% %    toc;          %Elapsed time is 0.193961 seconds.
%%%%%%%%%%%%%%%%%%%%%%%
%%

%ymax=200; xmax=200;
ymax=size_ROI(1);xmax=size_ROI(2);
output=zeros(length(xcenter),1);


%mirroring the original circles location near the axis origins x=0 and y=0
indx = xcenter > xmax/2;
indy = ycenter > ymax/2;
xcenter(indx)=-(xcenter(indx)-xmax);
ycenter(indy)=-(ycenter(indy)-ymax);

%this is the vector which indicate 5 possible case of circle and axis
%intersections. case:0 no intersection, case 1 and 2 intersevting with one
%of the axises, case 3 intersevting with both axises case 4 intersecting
%with both axises and entering the 4th quarter (x negatine and y negating )
case_vector=zeros(length(xcenter),1);

ycut = find(xcenter < r);
xcut = find(ycenter < r);
[ind] = union(xcut,ycut);
case3 = intersect(ycut,xcut);
[c,ia,ib]=setxor(xcut,ycut);

case1=xcut(ia);
case2=ycut(ib);
case4 = sqrt(xcenter.^2+ycenter.^2) < r;
case_vector(case1)=1;
case_vector(case2)=2;

%this is the case of interscetion of both axises but not in the 4th quarter
case_vector(case3)=3;

%this is the case of interscetion of both axises and also the 4th quarter
case_vector(case4)=4;

% when the is no intersection the relative area fo the circle is 1
output(case_vector==0)=1;


output(case_vector==1)=-0.209*(ycenter(case_vector==1)/r).^3+0.0966*(ycenter(case_vector==1)/r).^2+0.61414*(ycenter(case_vector==1)/r)+0.4992;
output(case_vector==2)=-0.209*(xcenter(case_vector==2)/r).^3+0.0966*(xcenter(case_vector==2)/r).^2+0.61414*(xcenter(case_vector==2)/r)+0.4992;
output(case_vector==3)=1-(...
    (0.209*(xcenter(case_vector==3)/r).^3-0.0966*(xcenter(case_vector==3)/r).^2-0.61414*(xcenter(case_vector==3)/r)+0.4992)+...
    (0.209*(ycenter(case_vector==3)/r).^3-0.0966*(ycenter(case_vector==3)/r).^2-0.61414*(ycenter(case_vector==3)/r)+0.4992));


%xstar ystar are the negative values where circle intersects with axis
ystar=-(sqrt(r^2-xcenter(case4).^2)-ycenter(case4));
xstar=-(sqrt(r^2-ycenter(case4).^2)-xcenter(case4));
Xstar=zeros(length(xstar),2); Ystar=zeros(length(xstar),2);
Xstar(:,1)=xstar'; Xstar(:,2)=0; Ystar(:,1)=0; Ystar(:,2)=ystar';

Triangle=(xstar.*ystar/2)/(pi()*r^2); %Triangle is the area of triangle at the 4th quarter
if isempty(Triangle )
    o=output;
    return
else
    L=distancePoints(Xstar,Ystar,'diag')'; %L is the distance between points of intersection on axisses.
    %L is used to calculate areaunder the line between these 2 points.
    Theta=2 *asin(L/(2*r));
    A=(r^2/2*(Theta-sin(Theta)))/(pi()*r^2);
    output(case_vector==4)=1-(...
        (0.209*(xcenter(case_vector==4)/r).^3-0.0966*(xcenter(case_vector==4)/r).^2-0.61414*(xcenter(case_vector==4)/r)+0.4992)+...
        (0.209*(ycenter(case_vector==4)/r).^3-0.0966*(ycenter(case_vector==4)/r).^2-0.61414*(ycenter(case_vector==4)/r)+0.4992))+...
        Triangle+A;
    o=output;
    return
end


end