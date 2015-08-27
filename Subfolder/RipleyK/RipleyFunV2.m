function [rvalue, Lr_r] = RipleyFunV2( x,A,Start,End,Step,size_ROI)
%Ripley Summary of this function goes here
%   This Function calculates the ripley value for the data set x.
%   x : nx2 matrix, n points, column 1 : x, column 2 : y
%   A area of the ROI of interest
%   Start : first search raduis
%   End : last search raduis
%   Step : step of search raduis
%   size_ROI : length and height e.g.(4000x4000)
%     x=1024*rand(1,10000);
%     y=1024*rand(1,10000);

% Waiting bar
tic
h = waitbar(0,'1','Name','Elapsed Time...');

 N=length(x);
 xmin=min(x);
 xcenter(:,1)=x(:,1)-xmin(1);
 ycenter(:,1)=x(:,2)-xmin(2);
 i_range=(End-Start)/Step;
 i_range=i_range+1;
 
 Lr_r=zeros(i_range,1);
 rvalue=zeros(i_range,1);
 
 %for r=Start:Step:End
 for i=1:i_range    

     
    waitbar(sqrt(i/i_range),h,sprintf('%f second',toc)) 
    r=(i-1)*10;
    relative_area=compute_circle_areaV2(xcenter',ycenter',r,size_ROI);
    %indexborder=find(relative_area<1);

    %[idx]=rangesearch(x,x,r);
    %Kfuncans1=(cellfun('length',idx)-1)./relative_area;     % remove the identity
    
    Kfuncans1 = (kdtree2rnearest(x(:,1), x(:,2),x(:,1), x(:,2), r)-1)'./relative_area;
    
    Kr=mean((Kfuncans1*A/N));     % calculate L(r)
    Lr_r(i,1)=(Kr/pi).^0.5-r;     % calculate L(r)
    rvalue(i,1)=r;
     
 end
 delete(h)
end
