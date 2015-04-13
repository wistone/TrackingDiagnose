function shouldUpdate = UpdateDifferenceJudger(model, opt)
model.lastProb
if (model.lastProb - model.secondProb > opt.UpdateDifferenceJudger.thresold)
    shouldUpdate = true;
else
    shouldUpdate = false;
end