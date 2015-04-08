%     loads data and initializes variables
%
% Copyright (C) Jongwoo Lim and David Ross.
% Modified by Naiyan Wang
% All rights reserved.

% DESCRIPTION OF OPTIONS:
%
% Following is a description of the options you can adjust for
% tracking, each proceeded by its default value.  For a new sequence
% you will certainly have to change p.  To set the other options,
% first try using the values given for one of the demonstration
% sequences, and change parameters as necessary.
%
% p = [px, py, sx, sy, theta]; The location of the target in the first
% frame.
% px and py are th coordinates of the centre of the box
% sx and sy are the size of the box in the x (width) and y (height)
%   dimensions, before rotation
% theta is the rotation angle of the box
%
% 'numsample',1000,   The number of samples used in the condensation
% algorithm/particle filter.  Increasing this will likely improve the
% results, but make the tracker slower.
%
% 'condenssig',0.01,  The standard deviation of the observation likelihood.
%
% 'affsig',[4,4,.02,.02,.005,.001]  These are the standard deviations of
% the dynamics distribution, that is how much we expect the target
% object might move from one frame to the next.  The meaning of each
% number is as follows:
%    affsig(1) = x translation (pixels, mean is 0)
%    affsig(2) = y translation (pixels, mean is 0)
%    affsig(3) = x & y scaling
%    affsig(4) = rotation angle
%    affsig(5) = aspect ratio
%    affsig(6) = skew angle
% clear all
close all;
name = 'Basketball'; 
% dataPath = ['../MEEMDataset/', name]; 
dataPath = ['trackingDataset/', name];
config;
% seq.init_rect = [p(1) - p(3) / 2, p(2) - p(4) / 2, p(3), p(4), p(5)];

% Load data
disp('Loading data...');
fullPath = [dataPath, '/img/'];
d = dir([fullPath, '*.jpg']);
if size(d, 1) == 0
    d = dir([fullPath, '*.png']);
end
if size(d, 1) == 0
    d = dir([fullPath, '*.bmp']);
end
if strcmp(name, 'Jogging') == 0
    rects = importdata([dataPath, '/groundtruth_rect.txt']);
else
    rects = importdata([dataPath, '/groundtruth_rect.1.txt']);
end
% rects = importdata([dataPath, '/', 	name,'.txt']);
p = rects(1,:);
% p = [p(1) - p(3) / 2, p(2) - p(4) / 2, p(3), p(4), 0];
seq.init_rect = [p(1), p(2), p(3), p(4), 0];
im = imread([fullPath, d(1).name]);
data = zeros(size(im, 1), size(im, 2), size(d, 1));
seq.s_frames = cell(size(d, 1), 1);
for i = 1 : size(d, 1)
    seq.s_frames{i} = [fullPath, d(i).name];
end
seq.opt = opt;
results = run_Diagnose(seq, '', false);