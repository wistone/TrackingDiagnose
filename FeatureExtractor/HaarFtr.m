function [optHaar] = HaarFtr(clfparams,maxNumRect,minNumRect,M)

% $Description:
%    -Compute harr feature
% $Agruments
% Input;
%    -clfparams: classifier parameters
%    -clfparams.width: width of search window 
%    -clfparams.height:height of search window
%    -ftrparams: feature parameters
%    -ftrparams.minNumRect: minimal number of feature rectangles
%    -ftrparams.maxNumRect: maximal ....
%    -M: totle number of features
% Output:
%    -px: x coordinate, size: M x ftrparms.maxNumRect
%    -py: y ...
%    -pw: corresponding width,size:...
%    -ph: corresponding height,size:...
%    -pwt:corresponding weight,size:....Range:[-1 1]
% $ History $
%   - Created by Kaihua Zhang, on April 22th, 2011
%   - Modified by Jianping SHI, on April 7th, 2015

width = round(clfparams.width);
height = round(clfparams.height);

px = zeros(M,maxNumRect);
py = zeros(M,maxNumRect);
pw = zeros(M,maxNumRect);
ph = zeros(M,maxNumRect);
pwt= zeros(M,maxNumRect);


for i=1:M
    numrects = randi([minNumRect,maxNumRect]);
    for j = 1:numrects
        px(i,j) = randi([1,width-3]);
        py(i,j) = randi([1,height-3]);
        pw(i,j) = randi([px(i,j) + 1,width]) / width;
        ph(i,j) = randi([py(i,j) + 1,height]) / height;
        px(i,j) = px(i,j) / width;
        py(i,j) = py(i,j) / height;
        pwt(i,j)= 2*unifrnd(0,1)-1;       
    end  
end

optHaar.px = px;
optHaar.py = py;
optHaar.pw = pw;
optHaar.ph = ph;
optHaar.pwt = pwt;