/*---------------------------------------------------------------------------
   cvf.cl - OpenCL Cost Volume Filtering Kernels
  ---------------------------------------------------------------------------
   Author: Charles Leech
   Email: cl19g10 [at] ecs.soton.ac.uk
   Copyright (c) 2016 Charlie Leech, University of Southampton.
   All rights reserved.
  ---------------------------------------------------------------------------*/

/**
 * \brief Kernel function for element-wise multiplication of 3D and 3D Matricies.
 * \param[in] pIn_a -  First Input Matrix.
 * \param[in] pIn_b -  Second Input Matrix.
 * \param[in] width - Image Width.
 * \param[in] height - Image Height.
 * \param[out] pOut - Output Matrix.
 */

__kernel void EWMul_SameDim(__global const float* pIn_a,
							__global const float* pIn_b,
							const int width,
							const int height,
    	              		__global float* pOut)
{
    const int x = get_global_id(0);
    const int y = get_global_id(1);
    const int d = get_global_id(2);

    const int offset = (((d * height) + y) * width) + x;

	pOut[offset] = pIn_a[offset] * pIn_b[offset];
}

/**
 * \brief Kernel function for element-wise multiplication of 2D and 3D Matricies.
 * \param[in] pIn_a -  First Input Matrix (2D).
 * \param[in] pIn_b -  Second Input Matrix (3D).
 * \param[in] width - Image Width.
 * \param[in] height - Image Height.
 * \param[out] pOut - Output Matrix.
 */

__kernel void EWMul_DiffDim(__global const float* pIn_a,
							__global const float* pIn_b,
							const int width,
							const int height,
    	              		__global float* pOut)
{
    const int x = get_global_id(0);
    const int y = get_global_id(1);
    const int d = get_global_id(2);

    const int offset2D = (y * width) + x;
    const int offset3D = (((d * height) + y) * width) + x;

	pOut[offset3D] = pIn_a[offset2D] * pIn_b[offset3D];
}

/**
 * \brief Kernel function for element-wise division of 3D and 3D Matricies.
 * \param[in] pIn_a -  First Input Matrix.
 * \param[in] pIn_b -  Second Input Matrix.
 * \param[in] width - Image Width.
 * \param[in] height - Image Height.
 * \param[out] pOut - Output Matrix.
 */

__kernel void EWDiv_SameDim(__global const float* pIn_a,
							__global const float* pIn_b,
							const int width,
							const int height,
    	              		__global float* pOut)
{
    const int x = get_global_id(0);
    const int y = get_global_id(1);
    const int d = get_global_id(2);

    const int offset = (((d * height) + y) * width) + x;

	pOut[offset] = pIn_a[offset] / pIn_b[offset];
}

/**
 * \brief Kernel function for channel division of an RGB image
 * \param[in] pImg -  3-channel RGB Input image.
 * \param[in] width - Image Width.
 * \param[in] height - Image Height.
 * \param[out] pIr -  Red channel output.
 * \param[out] pIg -  Green channel output.
 * \param[out] pIb -  Blue channel output.
 */

__kernel void Split(__global const float* pImg,
					const int width,
					__global float* pIr,
					__global float* pIg,
					__global float* pIb)
{
    const int x = get_global_id(0) * 12;
    const int y = get_global_id(1);

    const int offset = (y * width) + x;

	pIr[offset] = pImg[offset];
	pIg[offset] = pImg[offset + 1];
	pIb[offset] = pImg[offset + 2];

	pIr[offset + 1] = pImg[offset + 3];
	pIg[offset + 1] = pImg[offset + 4];
	pIb[offset + 1] = pImg[offset + 5];

	pIr[offset + 2] = pImg[offset + 6];
	pIg[offset + 2] = pImg[offset + 7];
	pIb[offset + 2] = pImg[offset + 8];

	pIr[offset + 3] = pImg[offset + 9];
	pIg[offset + 3] = pImg[offset + 10];
	pIb[offset + 3] = pImg[offset + 11];
}

/**
 * \brief Kernel function for the subtraction of 2 matricies
 * \param[in] pIn_a -  First Input Matrix.
 * \param[in] pIn_b -  Second Input Matrix.
 * \param[in] width - Image Width.
 * \param[in] height - Image Height.
 * \param[out] pOut - Output Matrix.
 */

__kernel void Subtract(__global const float* pIn_a,
						__global const float* pIn_b,
						const int width,
						const int height,
    	              	__global float* pOut)
{
    const int x = get_global_id(0);
    const int y = get_global_id(1);
    const int d = get_global_id(2);

    const int offset = (((d * height) + y) * width) + x;

	pOut[offset] = pIn_a[offset] - pIn_b[offset];
}

/**
 * \brief Kernel function for the addition of 2 matricies
 * \param[in] pIn_a -  First Input Matrix.
 * \param[in] pIn_b -  Second Input Matrix.
 * \param[in] width - Image Width.
 * \param[in] height - Image Height.
 * \param[out] pOut - Output Matrix.
 */

__kernel void Add(__global const float* pIn_a,
					__global const float* pIn_b,
					const int width,
					const int height,
					__global float* pOut)
{
    const int x = get_global_id(0);
    const int y = get_global_id(1);
    const int d = get_global_id(2);

    const int offset = (((d * height) + y) * width) + x;

	pOut[offset] = pIn_a[offset] + pIn_b[offset];
}

/**
 * \brief Kernel function for the addition of a constant to a matrix
 * \param[in] pIn_a -  First Input Matrix.
 * \param[in] eps -  Constant offset.
 * \param[in] width - Image Width.
 * \param[in] height - Image Height.
 * \param[out] pOut - Output Matrix.
 */

__kernel void Add_Const(__global const float* pIn_a,
						const float eps,
						const int width,
						const int height,
    	              	__global float* pOut)
{
    const int x = get_global_id(0);
    const int y = get_global_id(1);
    const int d = get_global_id(2);

    const int offset = (((d * height) + y) * width) + x;

	pOut[offset] = pIn_a[offset] + eps;
}

/**
 * \brief Volume BoxFiltering kernel function.
 * \param[in] pIn -  Input data.
 * \param[in] width - Image Width.
 * \param[in] height - Image Height.
 * \param[out] pOut - Output filtered data.
 */
__kernel void boxfilter(__global const float* pIn,
						const int width,
						const int height,
                  		__global float* pOut)
{
    int load_rows = 9;
	int calc_rows = 1;

    /* [Kernel size] */
    /* Each kernel calculates a single output pixel.
     * column (x) is in the range [0, width].
     * row (y) is in the range [0, height].
     * disparity (d) is in the range [0, maxDis].
     */
    const int x = get_global_id(0) * 16;
    const int y = get_global_id(1) * calc_rows;
    const int d = get_global_id(2);

    const int offset = (((d * height) + y) * width) + x;

	float16 row[9][9];
	float16 res[1];

	for (int r=0; r<load_rows; r++)
	{
			row[r][0] = vload16(0, pIn + offset + width*r);
			row[r][8] = vload16(0, pIn + offset + width*r + 8);
			row[r][1] = (float16)(row[r][0].s12345678, row[r][8].s12345678);
			row[r][2] = (float16)(row[r][0].s23456789, row[r][8].s23456789);
			row[r][3] = (float16)(row[r][0].s3456789a, row[r][8].s3456789a);
			row[r][4] = (float16)(row[r][0].s456789ab, row[r][8].s456789ab);
			row[r][5] = (float16)(row[r][0].s56789abc, row[r][8].s56789abc);
			row[r][6] = (float16)(row[r][0].s6789abcd, row[r][8].s6789abcd);
			row[r][7] = (float16)(row[r][0].s789abcde, row[r][8].s789abcde);
	}

	for (int r=0; r<9; r++)
	{
		for (int c=0; c<9; c++)
		{
			for (int i=0; i<calc_rows; i++)
			{
				res[i] += row[r+i][c];
			}
		}
	}

	for (int i=0; i<calc_rows; i++)
	{
		res[i] /= 81;
		vstore16(res[i], 0, pOut + offset + width*i + 4);
	}
}

/**
 * \brief Volume Cost Volume Filter kernel function.
 */
__kernel void var_math(	__global const float* mean_Ir,
					__global const float* mean_Ig,
					__global const float* mean_Ib,
					__global const float* mean_Irr,
					__global const float* mean_Irg,
					__global const float* mean_Irb,
					__global const float* mean_Igg,
					__global const float* mean_Igb,
					__global const float* mean_Ibb,
					const int width,
					const int height,
		      		__global float* var_Irr,
		      		__global float* var_Irg,
		      		__global float* var_Irb,
		      		__global float* var_Igg,
		      		__global float* var_Igb,
		      		__global float* var_Ibb)
{
    const int x = get_global_id(0);
    const int y = get_global_id(1);
    const int d = get_global_id(2);
	
    const int offset = (((d * height) + y) * width) + x;
	
	var_Irr[offset] = mean_Irr[offset] - (mean_Ir[offset] * mean_Ir[offset]);
	var_Irg[offset] = mean_Irg[offset] - (mean_Ir[offset] * mean_Ig[offset]);
	var_Irb[offset] = mean_Irb[offset] - (mean_Ir[offset] * mean_Ib[offset]);
	var_Igg[offset] = mean_Igg[offset] - (mean_Ig[offset] * mean_Ig[offset]);
	var_Igb[offset] = mean_Igb[offset] - (mean_Ig[offset] * mean_Ib[offset]);
	var_Ibb[offset] = mean_Ibb[offset] - (mean_Ib[offset] * mean_Ib[offset]);
	
}

__kernel void cent_filter(__global const float* mean_Ir,
							__global const float* mean_Ig,
							__global const float* mean_Ib,
							__global const float* var_Irr,
							__global const float* var_Irg,
							__global const float* var_Irb,
							__global const float* var_Igg,
							__global const float* var_Igb,
							__global const float* var_Ibb,
							__global const float* cov_Ip_r,
							__global const float* cov_Ip_g,
							__global const float* cov_Ip_b,
							const int width,
							const int height,
							const float eps,
							__global float* a_r,
							__global float* a_g,
							__global float* a_b,
							__global float* mean_cv)
{
    const int x = get_global_id(0);
    const int y = get_global_id(1);
    const int d = get_global_id(2);
	
    const int offset3D = (((d * height) + y) * width) + x;
    const int offset2D = (y * width) + x;
	
	float c0 = cov_Ip_r[offset3D];
	float c1 = cov_Ip_g[offset3D];
	float c2 = cov_Ip_b[offset3D];
	float a11 = var_Irr[offset2D] + eps;
	float a12 = var_Irg[offset2D];
	float a13 = var_Irb[offset2D];
	float a21 = var_Irg[offset2D];
	float a22 = var_Igg[offset2D] + eps;
	float a23 = var_Igb[offset2D];
	float a31 = var_Irb[offset2D];
	float a32 = var_Igb[offset2D];
	float a33 = var_Ibb[offset2D] + eps;

	float DET = 1/ ( a11 * ( a33 * a22 - a32 * a23 ) -
		a21 * ( a33 * a12 - a32 * a13 ) +
		a31 * ( a23 * a12 - a22 * a13 ) );

	a_r[offset3D] = DET * (
		c0 * ( a33 * a22 - a32 * a23 ) +
		c1 * ( a31 * a23 - a33 * a21 ) +
		c2 * ( a32 * a21 - a31 * a22 )
		);
	a_g[offset3D] = DET * (
		c0 * ( a32 * a13 - a33 * a12 ) +
		c1 * ( a33 * a11 - a31 * a13 ) +
		c2 * ( a31 * a12 - a32 * a11 )
		);
	a_b[offset3D] = DET * (
		c0 * ( a23 * a12 - a22 * a13 ) +
		c1 * ( a21 * a13 - a23 * a11 ) +
		c2 * ( a22 * a11 - a21 * a12 )
		);

	mean_cv[offset3D] = mean_cv[offset3D] - (
		(a_r[offset3D] * mean_Ir[offset2D]) + 
		(a_g[offset3D] * mean_Ig[offset2D]) + 
		(a_b[offset3D] * mean_Ib[offset2D])
		);
}





