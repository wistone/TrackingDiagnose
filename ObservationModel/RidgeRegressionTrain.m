function model = RidgeRegressionTrain(dataPos, dataNeg, model)

featPos         = dataPos.feat;
featNeg         = dataNeg.feat;
numPos          = size(featPos, 2);
numNeg          = size(featNeg, 2);
featDim         = size(featPos, 1);
num             = numPos + numNeg;

feat            = [featPos, featNeg]';
label           = zeros(num, 1);
label(1:numPos) = 1;

% lambda          = opt.RidgeRegression.lambda;
lambda          = 0.01;
if nargin <= 2
    % A = X'X/n; B = X'y/n; beta = inv(A + lambda I) * B
    model.A        = feat' * feat / num;
    model.B        = feat' * label / num;
    model.lastNum  = num;
else
    model.A        = (model.A * model.lastNum + feat' * feat) / (model.lastNum + num);
    model.B        = (model.B * model.lastNum + feat' * label) / (model.lastNum + num);
    model.lastNum  = model.lastNum + num;
end

model.beta     = (model.A + lambda * eye(featDim)) \ model.B;
