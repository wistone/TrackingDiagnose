
opt.condenssig = 0.05;
opt.useNormalSize = true;
opt.normalWidth = 320;
opt.normalHeight = 240;

opt.FeatureExtractor.tmplsize = [32, 32];
opt.FeatureExtractor.NumBins = 8; 

opt.HaarExtractor.M = 512;
opt.HaarExtractor.maxNumRect = 6;
opt.HaarExtractor.minNumRect = 2;

opt.Sampler.NegSlidingWindowSampler.NegSlidingH = 100;
opt.Sampler.NegSlidingWindowSampler.NegSlidingW = 100;
opt.Sampler.NegSlidingWindowSampler.NegStride = 5;
opt.Sampler.NegSlidingWindowSampler.excludeNegRatio = 0.3;

opt.Sampler.PosSlidingWindowSampler.PosSlidingH = 5;
opt.Sampler.PosSlidingWindowSampler.PosSlidingW = 5;

opt.MotionModel.SlidingWindowMotionModel.slidingH = 30;
opt.MotionModel.SlidingWindowMotionModel.slidingW = 30;
opt.MotionModel.SlidingWindowMotionModel.stride = 2;

opt.MotionModel.RadiusSlidingWindowMotionModel.radius = 20; 
opt.MotionModel.RadiusSlidingWindowMotionModel.stride = 2;

opt.MotionModel.ParticleFilterMotionModel.N = 400;
opt.MotionModel.ParticleFilterMotionModel.affsig = [6,6, 0.01, 0.001];

opt.ClassificationScoreJudger.thresold = 0.95;
opt.UpdateCorrectJudger.thresold = 0.95;
opt.UpdateDifferenceJudger.thresold = 0.2;

opt.useFirstFrame = true;
% opt.ClassificationScoreJudger.thresold = 10; % SOSVM

opt.KernelRidge.ker = 'rbf';
opt.KernelRidge.RegulationTerm = 1;
opt.KernelRidge.rbfSigma = 1;
opt.KernelRidge.polyParameters = [1 2];