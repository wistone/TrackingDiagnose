function model = SOSVMTrain(dataPos, dataNeg, model)

featPos         = dataPos.feat;
featNeg         = dataNeg.feat;
rectPos         = dataPos.tmpl;
rectNeg         = dataNeg.tmpl;

data.feat       = [featPos, featNeg]';
data.tmpl       = [rectPos; rectNeg];
data.tmpl(:,1)  = data.tmpl(:,1) - data.tmpl(:, 3) / 2;
data.tmpl(:,2)  = data.tmpl(:,2) - data.tmpl(:, 4) / 2;

if nargin <= 2
    mexSOSVMLearn(data.tmpl, data.feat, 'batchTrain', '-b 100 -c 100.0');
    model = [];
else
    mexSOSVMLearn(data.tmpl, data.feat, 'onlineTrain');
end
