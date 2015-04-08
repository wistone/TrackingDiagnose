function [data, opt] = GrayHistogramExtractor(im, tmpl, opt)

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

im              = rgb2gray(im);
im              = (im - min(im(:))) / (max(im(:)) - min(im(:)));
im(im == 1)     = 0.99;
im              = floor(im * NumBins) + 1;

features = zeros(NumBins, size(tmpl, 1));

integralIm = zeros(size(im, 1), size(im, 2), NumBins);
for i = 1 : NumBins
    I = (im == i);
    J = integralImage(I);
    integralIm(:, :, i) = J(2:end, 2:end);
end
    
for i = 1:size(tmpl, 1)
    midW    = tmpl(i, 1);
    midH    = tmpl(i, 2);
    w       = tmpl(i, 3);
    h       = tmpl(i, 4);
    
    hMin    = round(midH-h/2);
    hMax    = round(midH+h/2);
    wMin    = round(midW-w/2);
    wMax    = round(midW+w/2);
    feat    = integralIm(hMin, wMin, :) + integralIm(hMax, wMax, :)...
                - integralIm(hMin, wMax, :) - integralIm(hMax, wMin, :);
    feat    = feat / sum(feat);
    features(:, i) = feat(:);
end

data.feat = features;

end

