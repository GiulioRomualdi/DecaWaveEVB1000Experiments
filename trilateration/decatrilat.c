/*=================================================================
 *
 * YPRIME.C	Sample .MEX file corresponding to YPRIME.M
 *	        Solves simple 3 body orbit problem
 *
 * The calling syntax is:
 *
 *		[yp] = yprime(t, y)
 *
 *  You may also want to look at the corresponding M-code, yprime.m.
 *
 * This is a MEX-file for MATLAB.
 * Copyright 1984-2011 The MathWorks, Inc.
 *
 *=================================================================*/
#include <math.h>
#include "mex.h"
#include "trilat.h"



// mex file for interfacing  to decawave trilateration algorithm





//matlab function [pos, result]=decatrilat(use4thAnchor,  range0, range1, range2, range3, anchorpos)


/* Input Arguments */
#define	use4thAnchor_IN	prhs[0]
#define	range0_IN	prhs[1]
#define	range1_IN	prhs[2]
#define	range2_IN	prhs[3]
#define	range3_IN	prhs[4]
#define	anchorpos_IN    prhs[5]
#define	use4thAnchor_for_tri_IN	prhs[6]


/* Output Arguments */
#define	POS_OUT	plhs[0]
#define	result_OUT	plhs[1]
#define	errornum_OUT	plhs[2]


#if !defined(MAX)
#define	MAX(A, B)	((A) > (B) ? (A) : (B))
#endif

#if !defined(MIN)
#define	MIN(A, B)	((A) < (B) ? (A) : (B))
#endif

static	double	mu = 1/82.45;
static	double	mus = 1 - 1/82.45;


static void yprime(
		   double	yp[],
		   double	*t,
 		   double	y[]
		   )
{
    double	r1,r2;

    (void) t;     /* unused parameter */

    r1 = sqrt((y[0]+mu)*(y[0]+mu) + y[2]*y[2]);
    r2 = sqrt((y[0]-mus)*(y[0]-mus) + y[2]*y[2]);

    /* Print warning if dividing by zero. */
    if (r1 == 0.0 || r2 == 0.0 ){
        mexWarnMsgIdAndTxt( "MATLAB:yprime:divideByZero",
                "Division by zero!\n");
    }

    yp[0] = y[1];
    yp[1] = 2*y[3]+y[0]-mus*(y[0]+mu)/(r1*r1*r1)-mu*(y[0]-mus)/(r2*r2*r2);
    yp[2] = y[3];
    yp[3] = -2*y[1] + y[2] - mus*y[2]/(r1*r1*r1) - mu*y[2]/(r2*r2*r2);
    return;
}

void mexFunction( int nlhs, mxArray *plhs[],
		  int nrhs, const mxArray*prhs[] )

{
    double *yp;
    double *t,*y, *pOut, *resOut;
    size_t m,n;

	vec3d best_solution;
	vec3d best_solution2;
    int res1;
    int res2;
    int res_error_num;

    /* Check for proper number of arguments */

    if (nrhs != 7) {
	    mexErrMsgIdAndTxt( "MATLAB:decatrilat:invalidNumInputs",
                "6 input arguments required.");
    } else if (nlhs != 3) {
	    mexErrMsgIdAndTxt( "MATLAB:decatrilat:maxlhs",
                "3 output arguments required.");
    }

    /* Check the dimensions of Y.  Y can be 4 X 1 or 1 X 4. */

	//controllare che m ed n dei vari matrici di input siano giusti
	m = mxGetM(use4thAnchor_IN);
    n = mxGetN(use4thAnchor_IN);

    if (!mxIsDouble(use4thAnchor_IN) || mxIsComplex(use4thAnchor_IN) ||
	(MAX(m,n) != 1) || (MIN(m,n) != 1)) {
	    mexErrMsgIdAndTxt( "MATLAB:decatrilat:invalid0",
                "decatrilat requires that use4thanchor be a 1 x 1 vector.");
    }

    m = mxGetM(use4thAnchor_for_tri_IN);
    n = mxGetN(use4thAnchor_for_tri_IN);

    if (!mxIsDouble(use4thAnchor_for_tri_IN) || mxIsComplex(use4thAnchor_for_tri_IN) ||
	(MAX(m,n) != 1) || (MIN(m,n) != 1)) {
	    mexErrMsgIdAndTxt( "MATLAB:decatrilat:invalid0",
                "decatrilat requires that use4thAnchor_for_tri be a 1 x 1 vector.");
    }

    
    
    
    m = mxGetM(range0_IN);
    n = mxGetN(range0_IN);

    if (!mxIsDouble(range0_IN) || mxIsComplex(range0_IN) ||
	(MAX(m,n) != 1) || (MIN(m,n) != 1)) {
	    mexErrMsgIdAndTxt( "MATLAB:decatrilat:invalid1",
                "decatrilat requires that range0 be a 1 x 1 vector.");
    }

    m = mxGetM(range1_IN);
    n = mxGetN(range1_IN);

    if (!mxIsDouble(range1_IN) || mxIsComplex(range1_IN) ||
	(MAX(m,n) != 1) || (MIN(m,n) != 1)) {
	    mexErrMsgIdAndTxt( "MATLAB:decatrilat:invalid2",
                "decatrilat requires that range1 be a 1 x 1 vector.");
    }

    m = mxGetM(range2_IN);
    n = mxGetN(range2_IN);

    if (!mxIsDouble(range2_IN) || mxIsComplex(range2_IN) ||
	(MAX(m,n) != 1) || (MIN(m,n) != 1)) {
	    mexErrMsgIdAndTxt( "MATLAB:decatrilat:invalid3",
                "decatrilat requires that range2 be a 1 x 1 vector.");
    }

    m = mxGetM(range3_IN);
    n = mxGetN(range3_IN);

    if (!mxIsDouble(range3_IN) || mxIsComplex(range3_IN) ||
	(MAX(m,n) != 1) || (MIN(m,n) != 1)) {
	    mexErrMsgIdAndTxt( "MATLAB:decatrilat:invalid4",
                "decatrilat requires that range3 be a 1 x 1 vector.");
    }

    m = mxGetM(anchorpos_IN);
    n = mxGetN(anchorpos_IN);

    if (!mxIsDouble(anchorpos_IN) || mxIsComplex(anchorpos_IN) ||
	(MAX(m,n) != 12) || (MIN(m,n) != 1)) {
	    mexErrMsgIdAndTxt( "MATLAB:decatrilat:invalid5",
                "decatrilat requires that anchorpos be a 1 x 12 vector.");
    }

    /* Create a matrix for the return argument */
    POS_OUT = mxCreateDoubleMatrix( 1, 6, mxREAL);
    result_OUT = mxCreateDoubleMatrix( 1, 2, mxREAL);
    errornum_OUT = mxCreateDoubleMatrix( 1, 1, mxREAL);

    /* Assign pointers to the various parameters */
    //pOut = mxGetPr(POS_OUT);
    //resOut = mxGetPr(result_OUT);

    //t = mxGetPr(T_IN);
    //y = mxGetPr(Y_IN);

    /* Do the actual computations in a subroutine */
    //yprime(yp,t,y);


    //int res = GetLocation_wAnchorPos(vec3d *best_solution, int use4thAnchor, int(mxGetPr(range0_IN)),int range1,int range2,int range3, double anchorpos[12])
    res1 = GetLocation_wAnchorPos(&best_solution, &res_error_num, (int)(mxGetPr(use4thAnchor_IN)[0]), (int)(mxGetPr(use4thAnchor_for_tri_IN)[0]), (int)(mxGetPr(range0_IN)[0]), (int)(mxGetPr(range1_IN)[0]), (int)(mxGetPr(range2_IN)[0]), (int)(mxGetPr(range3_IN)[0]), (double*)(mxGetPr(anchorpos_IN)) );
    res2 = computePosition_mm_wAnchorPos((double*)(mxGetPr(anchorpos_IN)), (float)(mxGetPr(range0_IN)[0]), (float)(mxGetPr(range1_IN)[0]), (float)(mxGetPr(range2_IN)[0]), (float)(mxGetPr(range3_IN)[0]), &best_solution2);

	mxGetPr(POS_OUT)[0] = best_solution.x;
    mxGetPr(POS_OUT)[1] = best_solution.y;
    mxGetPr(POS_OUT)[2] = best_solution.z;
    mxGetPr(POS_OUT)[3] = best_solution2.x;
    mxGetPr(POS_OUT)[4] = best_solution2.y;
    mxGetPr(POS_OUT)[5] = best_solution2.z;
 	mxGetPr(result_OUT)[0] = res1;
 	mxGetPr(result_OUT)[1] = res2;
 	mxGetPr(errornum_OUT)[0] = (double)res_error_num;

    return;

}
