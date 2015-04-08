function [data, opt] = HaarExtractor(im, tmpl, opt)

im = rgb2gray(im);
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

M = opt.HaarExtractor.M;
maxNumRect = opt.HaarExtractor.maxNumRect;
minNumRect = opt.HaarExtractor.minNumRect;


if ~isfield(opt, 'HaarOpt')
    clfparams.width = tmpl(1, 3);
    clfparams.height= tmpl(1, 4);
    opt.HaarOpt = HaarFtr(clfparams,maxNumRect,minNumRect, M);    
end

px = opt.HaarOpt.px;
py = opt.HaarOpt.py;
ph = opt.HaarOpt.ph;
pw = opt.HaarOpt.pw;
pwt = opt.HaarOpt.pwt;

integralIm = integralImage(im);
features = zeros(M, size(tmpl, 1));

for i = 1 : size(tmpl, 1)
    hMin = tmpl(i, 2) - tmpl(i, 4) / 2;
    wMin = tmpl(i, 1) - tmpl(i, 3) / 2;
    h = tmpl(i, 4);
    w = tmpl(i, 3);
%     for j = 1: M
%         for k = 1:maxNumRect
%             ht = round(hMin + py(j, k) * h);
%             wl = round(wMin + px(j, k) * w);
%             hb = round(hMin + ph(j, k) * h);
%             wr = round(wMin + pw(j, k) * w);
%             features(j, i) = features(j, i) + pwt(j, k) * ...
%                 (integralIm(ht, wl) + integralIm(hb, wr) - integralIm(ht, wr) - integralIm(hb, wl));
%         end
%     end
    features(:, i) = haar(hMin, wMin, h, w, py, px, ph, pw, pwt, integralIm);

    features(:, i) = features(:, i) / w / h;
end
data.feat = features;
data.tmpl = tmpl;