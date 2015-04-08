function feat = extractHistogramFeatures(im, CellSize, CellOverlap, NumBins, sz)
im              = (im - min(im(:))) / (max(im(:)) - min(im(:)));
im(im == 1)     = 0.99;
im              = floor(im * NumBins) + 1;
CellPerImage    = floor((sz - CellSize)./(CellSize - CellOverlap) + 1);
feat            = zeros(prod(CellPerImage), NumBins);

for i = 1 : NumBins
    I = (im == i);
    J = integralImage(I);
    J = J(2:end, 2:end);
    
    featTemp = J(1:(CellSize-CellOverlap):(sz(1)-CellOverlap), 1:(CellSize-CellOverlap):(sz(2)-CellOverlap)) + ...
        J(CellSize:(CellSize-CellOverlap):sz(1), CellSize:(CellSize-CellOverlap):sz(2)) -...
        J(1:(CellSize-CellOverlap):(sz(1)-CellOverlap), CellSize:(CellSize-CellOverlap):sz(2)) - ...
        J(CellSize:(CellSize-CellOverlap):sz(1), 1:(CellSize-CellOverlap):(sz(2)-CellOverlap));
    feat(:, i) = featTemp(:);
end

end