function [data, opt] = HogColorExtractor(im, tmpl, opt)

[dataHog] = HogExtractor(im, tmpl, opt);

if (norm(im(:,:,1) - im(:,:,2)) > 1e-6)
    [dataLAB] = LabHistogramExtractor(im, tmpl, opt);
    data.feat = [dataHog.feat; dataLAB.feat];
    dataNorm = sqrt(sum(data.feat .* data.feat));
    data.feat = bsxfun(@rdivide, data.feat, dataNorm);
    data.tmpl = dataHog.tmpl;
else
%     [dataLAB] = GrayHistogramExtractor(im, tmpl, opt);
    data = dataHog;
end

