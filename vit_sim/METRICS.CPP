				  //////////////////////
				  //   metrics.cpp    //
				  /////////////////////

#include "decoder.h"
#ifndef M_PI
#define M_PI 3.141592
#endif

double mettab[2][256];
double p(int r,int c, double var);

void metric_gen()
{
	for(int c=0;c<2;c++)
		for(int r=0;r<256;r++)
			mettab[c][r]=((p(r,c,VARIANCE)-.063669)*200);
}

double p(int r,int c,double var)
{

	double met,a1,a2,a3,a4;
	double R;
	R=((double)r)/255;

	a1 = sqrt(2 * M_PI) * var ;
	a2 = -(R-c);
	a4 = R-c;
	a3 = 2*var*var;
	met = exp(a2*a4/a3)/a1/5.0;
	return met;

}