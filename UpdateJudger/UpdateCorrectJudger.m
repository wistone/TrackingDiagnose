function shouldUpdate = UpdateCorrectJudger(model, opt)
model.lastProb
if (model.lastProb > opt.UpdateCorrectJudger.thresold)
    shouldUpdate = true;
else
    shouldUpdate = false;
end