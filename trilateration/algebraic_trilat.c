#include "stdio.h"
#include "math.h"
#include "stdlib.h"
#include "time.h"

#include "trilat.h"


#define uint8_t unsigned char

float matrixDeterminant(float a[][3])
{
	 int i,j,j1,j2;
	 float dd = 0;
   float m[3][3];
	 uint8_t ii=0;
	 uint8_t jj=1;

	 for (j1=0;j1<3;j1++)
	 {
     for (i=1;i<3;i++)
		  {
         j2 = 0;
         for (j=0;j<3;j++)
				 {
           if (j == j1)
             continue;
           m[i-1][j2] = a[i][j];
           j2++;
          }
      }
			if ((j1%2)== 0)
        dd +=  a[0][j1] * (m[ii][ii] * m[jj][jj] - m[jj][ii] * m[ii][jj]);
			else
				dd -=  a[0][j1]* (m[ii][ii] * m[jj][jj] - m[jj][ii] * m[ii][jj]) ;
	 }

	 return dd;
}

void matrixCofactor(float a[][3],float a_cof[][3])
{
   int i,j,ii,jj,i1,j1;
	 float det3;
   float c [3][3];

   for (j=0;j<3;j++)
	{
    for (i=0;i<3;i++)
		 {
       // Form the adjoint a_ij
       i1 = 0;
       for (ii=0;ii<3;ii++)
			 {
         if (ii == i)
           continue;
           j1 = 0;
         for (jj=0;jj<3;jj++)
				 {
           if (jj == j)
            continue;
           c[i1][j1] = a[ii][jj];
           j1++;
         }
            i1++;
        }

         det3 = c[1][1]*c[0][0] - c[1][0]*c[0][1];

				// Fill in the elements of the cofactor
				 if (((i+j)%2)== 0)
					a_cof[i][j] = det3;
				 else
					a_cof[i][j] = - det3;

      }
   }
}

void matrixTranspose(float a[][3],float a_t[][3])
{
   int i,j;

   for (i=0;i<3;i++)
    for (j=0;j<3;j++)
			a_t[i][j] = a[j][i];
}


void matrixInverse(float a[][3],float a_inv[][3])
{
	float det;
	int i;
	int j;
  float a_cofactor[3][3]; // cofactor matrix of the matrix 'a'
	float a_cof_transpose[3][3]; // transpose of the matrix 'a_cofactor'

	det = matrixDeterminant(a); // compute the determinant of the matrix 'a' and return it
	matrixCofactor(a,a_cofactor); // compute the cofactor matrix of the matrix 'a' and store it in a_cofactor
	matrixTranspose(a_cofactor,a_cof_transpose); // compute the transpose of the matrix 'a_cofactor' and store it in a_cof_transpose

	for (i=0; i<3; i++)
		for (j=0; j<3; j++)
			a_inv[i][j] = a_cof_transpose[i][j]/det;
}



int computePosition_mm(float d1,float d2,float d3,float d4, vec3d *best_solution2 )
{
	uint8_t j,i;
	float A_inv[3][3];
	float A[3][3];
	float b[3];
	float p_mm[3]={0,0,0}; // position (x,y,z) in mm
	//float A_mm[3] = {0,0,0}; // reference tower. The origin of the system reference
	//float B_mm[3] = {1616,1225,360}; // position (x,y,z) in mm of tower B respect tower A
	//float C_mm[3] = {1500,4000,0}; // position (x,y,z) in mm of tower C respect tower A
	//float D_mm[3] = {4000,0,0}; // position (x,y,z) in mm of tower D respect tower A


	float A_mm[3] = {0,0,0}; // reference tower. The origin of the system reference
	float B_mm[3] = {0,2.981,0}; // position (x,y,z) in mm of tower B respect tower A
	float C_mm[3] = {4722,1721,0}; // position (x,y,z) in mm of tower C respect tower A
	float D_mm[3] = {143,1642,2224}; // position (x,y,z) in mm of tower D respect tower A





	// fill the matrix A
	for(j=0; j<3; j++)
	{
		A[0][j] = A_mm[j] - B_mm[j];
		A[1][j] = A_mm[j] - C_mm[j];
		A[2][j] = A_mm[j] - D_mm[j];
	}

	// compute the inverse of matrix A and store it in A_inv
	matrixInverse(A,A_inv);

	// resolve the multilateration problem

    b[0] = ((A_mm[0]* A_mm[0])-(B_mm[0]*B_mm[0])+ (A_mm[1]*A_mm[1])- (B_mm[1]*B_mm[1])+ (A_mm[2]*A_mm[2])- (B_mm[2]* B_mm[2])+ (d2*d2)- (d1*d1))/2;
	b[1] = ((A_mm[0]* A_mm[0])-(C_mm[0]*C_mm[0])+ (A_mm[1]*A_mm[1])- (C_mm[1]*C_mm[1])+ (A_mm[2]*A_mm[2])- (C_mm[2]* C_mm[2])+ (d3*d3)- (d1*d1))/2;
	b[2] = ((A_mm[0]* A_mm[0])-(D_mm[0]*D_mm[0])+ (A_mm[1]*A_mm[1])- (D_mm[1]*D_mm[1])+ (A_mm[2]*A_mm[2])- (D_mm[2]* D_mm[2])+ (d4*d4)- (d1*d1))/2;

	for (i=0; i<3; i++)
  {
		p_mm[i] = 0;

		for(j=0; j<3; j++)
			p_mm[i]+= A_inv[i][j]* b[j];
  }
    	posizioni.x = p_mm[0];
    	posizioni.y = p_mm[1];
    	posizioni.z = p_mm[2]+ 785;

    	*best_solution2 = posizioni;

    return 1;
}

int computePosition_mm_wAnchorPos(double anchorpos[12],float d1,float d2,float d3,float d4, vec3d *best_solution2 )
{
	uint8_t j,i;
	float A_inv[3][3];
	float A[3][3];
	float b[3];
	float p_mm[3]={0,0,0}; // position (x,y,z) in mm
	//float A_mm[3] = {0,0,0}; // reference tower. The origin of the system reference
	//float B_mm[3] = {1616,1225,360}; // position (x,y,z) in mm of tower B respect tower A
	//float C_mm[3] = {1500,4000,0}; // position (x,y,z) in mm of tower C respect tower A
	//float D_mm[3] = {4000,0,0}; // position (x,y,z) in mm of tower D respect tower A


	float A_mm[3] = {anchorpos[0]*1000.0, anchorpos[1]*1000.0, anchorpos[2]*1000.0}; // reference tower. The origin of the system reference
	float B_mm[3] = {anchorpos[3]*1000.0, anchorpos[4]*1000.0, anchorpos[5]*1000.0}; // position (x,y,z) in mm of tower B respect tower A
	float C_mm[3] = {anchorpos[6]*1000.0, anchorpos[7]*1000.0, anchorpos[8]*1000.0}; // position (x,y,z) in mm of tower C respect tower A
	float D_mm[3] = {anchorpos[9]*1000.0, anchorpos[10]*1000.0, anchorpos[11]*1000.0}; // position (x,y,z) in mm of tower D respect tower A



	// fill the matrix A
	for(j=0; j<3; j++)
	{
		A[0][j] = A_mm[j] - B_mm[j];
		A[1][j] = A_mm[j] - C_mm[j];
		A[2][j] = A_mm[j] - D_mm[j];
	}

	// compute the inverse of matrix A and store it in A_inv
	matrixInverse(A,A_inv);

	// resolve the multilateration problem

    b[0] = ((A_mm[0]* A_mm[0])-(B_mm[0]*B_mm[0])+ (A_mm[1]*A_mm[1])- (B_mm[1]*B_mm[1])+ (A_mm[2]*A_mm[2])- (B_mm[2]* B_mm[2])+ (d2*d2)- (d1*d1))/2;
	b[1] = ((A_mm[0]* A_mm[0])-(C_mm[0]*C_mm[0])+ (A_mm[1]*A_mm[1])- (C_mm[1]*C_mm[1])+ (A_mm[2]*A_mm[2])- (C_mm[2]* C_mm[2])+ (d3*d3)- (d1*d1))/2;
	b[2] = ((A_mm[0]* A_mm[0])-(D_mm[0]*D_mm[0])+ (A_mm[1]*A_mm[1])- (D_mm[1]*D_mm[1])+ (A_mm[2]*A_mm[2])- (D_mm[2]* D_mm[2])+ (d4*d4)- (d1*d1))/2;

	for (i=0; i<3; i++)
  {
		p_mm[i] = 0;

		for(j=0; j<3; j++)
			p_mm[i]+= A_inv[i][j]* b[j];
  }
    	posizioni.x = p_mm[0];
    	posizioni.y = p_mm[1];
    	posizioni.z = p_mm[2]; // + anchorpos[11] - anchorpos[2];

    	*best_solution2 = posizioni;

    return 1;
}
