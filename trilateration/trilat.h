// -------------------------------------------------------------------------------------------------------------------
//
//  File: trilateration.h
//
//  Copyright 2016 (c) Decawave Ltd, Dublin, Ireland.
//
//  All rights reserved.
//
//
// -------------------------------------------------------------------------------------------------------------------
//

#ifndef __TRILATERATION_H__
#define __TRILATERATION_H__

// #include "basetsd.h"
#include "stdio.h"

#define TRILATERATION (1)

#define REGRESSION_NUM (10)
#define SPEED_OF_LIGHT      (299702547.0)   // in m/s in air
#define NUM_ANCHORS (5)
#define REF_ANCHOR (5)	//anchor IDs are 1,2,3,4,5 etc. (don't start from 0!)


#define		TRIL_3SPHERES							3
#define		TRIL_4SPHERES							4

typedef struct vec3d	vec3d;
struct vec3d {
	double	x;
	double	y;
	double	z;
};

int use4thAnchor; // inizializza la quarta ancora

vec3d best_solution;
vec3d best_solution2; // vettori richiamati nella main

int Pos_tag;
int Pos_tag1; // 0 no trilaterazione 1 si trilaterazione

vec3d posizioni; // vettore di supporto in algebric_trilat.c

/* Return the difference of two vectors, (vector1 - vector2). */
vec3d vdiff(const vec3d vector1, const vec3d vector2);

/* Return the sum of two vectors. */
vec3d vsum(const vec3d vector1, const vec3d vector2);

/* Multiply vector by a number. */
vec3d vmul(const vec3d vector, const double n);

/* Divide vector by a number. */
vec3d vdiv(const vec3d vector, const double n);

/* Return the Euclidean norm. */
double vdist(const vec3d v1, const vec3d v2);

/* Return the Euclidean norm. */
double vnorm(const vec3d vector);

/* Return the dot product of two vectors. */
double dot(const vec3d vector1, const vec3d vector2);

/* Replace vector with its cross product with another vector. */
vec3d cross(const vec3d vector1, const vec3d vector2);

int GetLocation(vec3d *best_solution,int use4thAnchor, int range0, int range1, int range2, int range3);

int GetLocation_wAnchorPos(vec3d *best_solution, int* error_num, int use4thAnchor, int use4thAnchor_for_triangulation, int range0, int range1,int range2,int range3, double anchorpos[12]);
//int GetLocation_wAnchorPos(vec3d *best_solution, int use4thAnchor, int range0, int range1,int range2,int range3, double anchorpos[12]);

int computePosition_mm(float d1,float d2,float d3,float d4,vec3d *pippo);

int computePosition_mm_wAnchorPos(double anchorpos[12], float d1,float d2,float d3,float d4,vec3d *pippo);

double vdist(const vec3d v1, const vec3d v2);
#endif
