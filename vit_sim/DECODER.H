				/////////////////////
				//	MAIN.H      //
				///////////////////

#include<fstream.h>
#include<sys\stat.h>
#include<errno.h>
#include<time.h>
#include<conio.h>
#include<stdio.h>
#include<process.h>
#include<stdlib.h>
#include<io.h>
#include<fcntl.h>
#include<string.h>
#include <math.h>
//#include<graphics.h>
#include<dos.h>
//#include<alloc.h>

#define MEAN 0
#define VARIANCE 1
#define PI 3.14159265
#define DEG 5
#define CONNECT1 011L
#define CONNECT2 033L
#define INIT_STATE1 1L
#define INIT_STATE2 30L
#define MAX_PN_ID 100
#define LEN 31

enum HS {hard,soft};
enum boolean {F,T};
extern HS HardSoft;
extern boolean cdm;

void awgn_gen(char[], double, long&, boolean);
void impulse(char[], long, double);
void metric_gen();
void vit_decode(char[], HS, boolean);
void draw_intro();
void draw_circuits();
void encode (char[]);
float file_comp (char[], char[]);
void draw_graph(double[], double[], unsigned int);
