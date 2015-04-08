#include "mex.h"
#include <cmath>

/*
for j = 1: M
    for k = 1:maxNumRect
        ht = round(hMin + py(j, k) * h);
        wl = round(wMin + px(j, k) * w);
        hb = round(hMin + ph(j, k) * h);
        wr = round(wMin + pw(j, k) * w);
        features(j, i) = features(j, i) + pwt(j, k) * ...
            (integralIm(ht, wl) + integralIm(hb, wr) - integralIm(ht, wr) - integralIm(hb, wl));
    end
end
 *
 *feature(:, i) = haar(hMin, wMin, h, w, py, px, ph, pw, pwt, integralIm);
*/

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[]){ 
	double *hMin = mxGetPr(prhs[0]); 
    double *wMin = mxGetPr(prhs[1]);
    double *h = mxGetPr(prhs[2]); 
    double *w = mxGetPr(prhs[3]);
    double *py = mxGetPr(prhs[4]);
    double *px = mxGetPr(prhs[5]);
    double *ph = mxGetPr(prhs[6]);
    double *pw = mxGetPr(prhs[7]);
    double *pwt = mxGetPr(prhs[8]);
    double *integralIm = mxGetPr(prhs[9]);
    
    int M = mxGetM(prhs[4]);
    int N = mxGetN(prhs[4]);
    int imh = mxGetM(prhs[9]);
    int imw = mxGetN(prhs[9]);
    
    plhs[0] = mxCreateDoubleMatrix(M, 1, mxREAL); 
    double *output = mxGetPr(plhs[0]);
    
    for (int j = 0; j < M; j++){
        for (int k = 0; k < N; k++){
            int ht = round(hMin[0] + py[M * k + j] * h[0]) - 1;
            int wl = round(wMin[0] + px[M * k + j] * w[0]) - 1;
            int hb = round(hMin[0] + ph[M * k + j] * h[0]) - 1;
            int wr = round(wMin[0] + pw[M * k + j] * w[0]) - 1;
            output[j] += pwt[M * k + j] * (integralIm[ht + wl * imh] + 
                    integralIm[hb + wr * imh] - integralIm[ht + wr * imh] - integralIm[hb + wl * imh]);
        }
    }
}