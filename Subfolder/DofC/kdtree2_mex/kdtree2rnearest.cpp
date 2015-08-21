// this is actually just a single query

#ifndef CPPONLY
#include "mex.h"
#include "kdtree2.hpp"

void mexFunction(int nlhs, mxArray * plhs[], int nrhs, const mxArray * prhs[]){
	
	// num_points = kdtree_ball_query(x1_array, y1_array, x2_array, y2_array, radius)
	const mwSize *dims1;
	const mwSize *dims2;
	int N1, N2;  // number of input points
	double *x1, *y1, *x2, *y2;
	double *num_points;
	double radius = 0;
	double r2 = 0;

	// retrieve input points
	x1 = mxGetPr(prhs[0]);
	y1 = mxGetPr(prhs[1]);
	dims1 = mxGetDimensions(prhs[1]);
	N1 = (int)dims1[0];

	x2 = mxGetPr(prhs[2]);
	y2 = mxGetPr(prhs[3]);
	dims2 = mxGetDimensions(prhs[2]);
	N2 = (int)dims2[0];

	// retrieve the radius
	radius = mxGetScalar(prhs[4]);
	r2 = radius * radius;

	//associate outputs   
	plhs[0] = mxCreateDoubleMatrix(1, N2, mxREAL);
	num_points = mxGetPr(plhs[0]);

	// create tree
	array2dfloat input_data;
	for(int i=0; i<N1; i++)
	{
		vector<float> point(2);
		point[0] = (float)x1[i];
		point[1] = (float)y1[i];
		input_data.push_back(point);
	}
	kdtree2 *tree = new kdtree2(input_data, false);

	// retrieve the query points and calculate
	for (int i=0; i<N2; i++)
	{
		vector<float> point(2);
		point[0] = (float)x2[i];
		point[1] = (float)y2[i];

		kdtree2_result_vector result_vec;

 		tree->r_nearest( point, r2, result_vec );

 		num_points[i] = result_vec.size();
	}

    input_data.clear();

	// delete tree
	delete tree;
}
#endif
