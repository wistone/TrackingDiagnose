function [data, opt] = LabHistogramExtractor(im, tmpl, opt)

NumBins   =  opt.FeatureExtractor.NumBins;
data.tmpl = tmpl;

% pad
minW = min(round(tmpl(:, 1) - tmpl(:, 3) / 2)) - 1;
maxW = max(round(tmpl(:, 1) + tmpl(:, 3) / 2)) + 1;
minH = min(round(tmpl(:, 2) - tmpl(:, 4) / 2)) - 1;
maxH = max(round(tmpl(:, 2) + tmpl(:, 4) / 2)) + 1;
[h, w, c] = size(im);
if (minW < 1)
    im_new = zeros(h, w + abs(minW) + 1, c);
    im_new(:, abs(minW) + 2:end, :) = im;
    im = im_new;
    tmpl(:, 1) = tmpl(:, 1) + abs(minW) + 1;
end
if (maxW > w)
    im_new = zeros(h, size(im, 2) + maxW - w, c);
    im_new(:, 1:size(im, 2), :) = im;
    im = im_new;
end
if (minH < 1)
    im_new = zeros(h + abs(minH) + 1, size(im, 2), c);
    im_new(abs(minH) + 2:end, :, :) = im;
    im = im_new;
    tmpl(:, 2) = tmpl(:, 2) + abs(minH) + 1;
end
if (maxH > h)
    im_new = zeros(size(im, 1) + maxH - h, size(im, 2), c);
    im_new(1:size(im, 1), :, :) = im;
    im = im_new;
end

hMinAll = min(round(tmpl(:, 2) - tmpl(:, 4) / 2));
hMaxAll = max(round(tmpl(:, 2) + tmpl(:, 4) / 2));
wMinAll = min(round(tmpl(:, 1) - tmpl(:, 3) / 2));
wMaxAll = max(round(tmpl(:, 1) + tmpl(:, 3) / 2));
imSmall = im(hMinAll:hMaxAll, wMinAll:wMaxAll, :);

lab             = RGB2Lab(imSmall);
minLab  =  [0, -0.6753,  -0.9709];
maxLab  =  [1, 1.8397, 1.7884];
for imIdx = 1 : 3
    im              = lab(:,:,imIdx);
    im              = (im - minLab(imIdx)) / (maxLab(imIdx) - minLab(imIdx));
    im(im == 1)     = 0.99;
    lab(:,:,imIdx)  = floor(im * NumBins);
end
% imSmall = lab(:,:,1) * NumBins * NumBins + lab(:,:,2) * NumBins + lab(:,:,3);
imSmall = lab(:,:,2) * NumBins + lab(:,:,3);

% integralIm = zeros(hMaxAll - hMinAll + 1, wMaxAll - wMinAll + 1, NumBins^3);
integralIm = zeros(hMaxAll - hMinAll + 1, wMaxAll - wMinAll + 1, NumBins^2);

% for i = 0 : (NumBins^3 - 1)
for i = 0 : (NumBins^2 - 1)
    I = (imSmall == i);
    if (sum(I(:)) > 0)
        J = integralImage(I);
        integralIm(:, :, i + 1) = J(2:end, 2:end);
    end
end

% features = zeros(NumBins^3, size(tmpl, 1));
features = zeros(NumBins^2, size(tmpl, 1));

for i = 1:size(tmpl, 1)
    midW    = tmpl(i, 1);
    midH    = tmpl(i, 2);
    w       = tmpl(i, 3);
    h       = tmpl(i, 4);

    hMin    = round(midH-h/2) - hMinAll + 1;
    hMax    = round(midH+h/2) - hMinAll + 1;
    wMin    = round(midW-w/2) - wMinAll + 1;
    wMax    = round(midW+w/2) - wMinAll + 1;
    feat    = integralIm(hMin, wMin, :) + integralIm(hMax, wMax, :)...
                - integralIm(hMin, wMax, :) - integralIm(hMax, wMin, :);
    feat    = feat / norm(feat(:));
    features(:, i) = feat(:);
%     features(:, i) = features(:, i) / norm(features(:, i));
end


data.feat = features;

end

