#include "mex.h"

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[]){ 
	double *img = mxGetPr(prhs[0]); 
    double *numBin = mxGetPr(prhs[1]);
    
	int M,N; 
	M = mxGetM(prhs[0]); 
	N = mxGetN(prhs[0]);
	
	/* Create a matrix for the return argument */ 
    int C = numBin[0];
	plhs[0] = mxCreateDoubleMatrix(M * N, C, mxREAL); 
    double *output = mxGetPr(plhs[0]);

	/* Do the actual computations in a subroutine */
	for (int i = 0; i < M; i++){
        for (int j = 0; j < N; j++){
            int bin = img[i + j * M];
            if ( i == 0 && j == 0){
                output[i + j * M + bin * M * N] = 1;
            } else if (i == 0){
                for (int k = 0; k < C; k++){
                    output[i + j * M + k * M * N] = output[i + (j - 1) * M + k * M * N] + (bin == k);
                }
            } else if (j == 0){
                for (int k = 0; k < C; k++){
                    output[i + j * M + k * M * N] = output[(i - 1) + j * M + k * M * N] + (bin == k);
                }
            } else {
                for (int k = 0; k < C; k++){
                    output[i + j * M + k * M * N] = output[i + (j - 1) * M + k * M * N]  
                                                  + output[(i - 1) + j * M + k * M * N] 
                                                  - output[(i - 1) + (j - 1) * M + k * M * N] 
                                                  + (bin == k);
                }
            }
        }
    }
	return;

}