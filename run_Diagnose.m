function results = run_Diagnose(seq, res_path, bSaveImage)
    configGlobalParam;
    config;
    seq.opt = opt;
    rect=seq.init_rect;
    p = [rect(1)+rect(3)/2, rect(2)+rect(4)/2, rect(3), rect(4)]; % Center x, Center y, height, width
    frame = imread(seq.s_frames{1});
    if size(frame,3)==1
        frame = repmat(frame,[1,1,3]);
    end
    frame = rgb2gray(frame);
    scaleHeight = size(frame, 1) / seq.opt.normalHeight;
    scaleWidth = size(frame, 2) / seq.opt.normalWidth;
    p(1) = p(1) / scaleWidth;
    p(3) = p(3) / scaleWidth;
    p(2) = p(2) / scaleHeight;
    p(4) = p(4) / scaleHeight;
    
    duration = 0;
    tic;
    reportRes = [];
    for f = 1:size(seq.s_frames, 1)
        
        frame = imread(seq.s_frames{f});
        if size(frame,3)==1
            frame = repmat(frame,[1,1,3]);
        end
%         frame = imresize(frame, [seq.opt.normalHeight, seq.opt.normalWidth]);
        frame = mexResize(frame, [seq.opt.normalHeight, seq.opt.normalWidth], 'auto');
        frame = im2double(frame);
        
        if (f ~= 1)
            tmpl    = globalParam.MotionModel(tmpl, prob, seq.opt);
            [feat, seq.opt] = globalParam.FeatureExtractor(frame, tmpl, seq.opt);
            prob    = globalParam.ObservationModelTest(feat, model);    
            
            [maxProb, maxIdx] = max(prob); 
            p = tmpl(maxIdx, :);
            model.lastOutput = p;
            model.lastProb = maxProb;
        else
            tmpl = globalParam.MotionModel(p, 1, seq.opt);
            prob = ones(1, size(tmpl, 1));
        end
             
        tmplPos = globalParam.PosSampler(p, seq.opt);
        tmplNeg = globalParam.NegSampler(p, seq.opt);
        [dataPos, seq.opt] = globalParam.FeatureExtractor(frame, tmplPos, seq.opt);
        [dataNeg, seq.opt] = globalParam.FeatureExtractor(frame, tmplNeg, seq.opt);
        
        if (f == 1)
            model   = globalParam.ObservationModelTrain(dataPos, dataNeg);  
        else
            if (globalParam.ConfidenceJudger(model, seq.opt))
                disp(f);
                model   = globalParam.ObservationModelTrain(dataPos, dataNeg, model);  
            end
        end
        
        figure(1),imagesc(frame);
        rectangle('position', [p(1) - p(3) / 2, p(2) - p(4) / 2, p(3), p(4)], ...
            'EdgeColor','r', 'LineWidth',2);
        p(1) = p(1) * scaleWidth;
        p(3) = p(3) * scaleWidth;
        p(2) = p(2) * scaleHeight;
        p(4) = p(4) * scaleHeight;
        rect = [p(1) - p(3) / 2, p(2) - p(4) / 2, p(3), p(4)];
        reportRes = [reportRes; round(rect)];
    end
    duration = duration + toc;
    fprintf('%d frames took %.3f seconds : %.3fps\n',f,duration,f/duration);
    results.res=reportRes;
    results.type='rect';
    results.fps = f/duration;
    
end