                        /////////////////////////
                        //     graphics.cpp    //
                        /////////////////////////


#include "decoder.h"
/*#include <stdlib.h>
#include <graphics.h>
#include <math.h>
#include <conio.h>
#define f(x) x*x */

void range(float co[], unsigned int indx, float& max, float& min)
{
	int i;
	max = 0;
	min = 0;

	for (i=0; i<indx; i++)
		if (co[i] >= max)
			max = co[i];

	for (i=0; i<indx; i++)
		if (co[i] <= min)
			min = co[i];
}

void draw_graph(float xco[], float yco[], unsigned int indx)
{
	int i;
	float xmax, ymax, xmin, ymin;
	float stepx, stepy;
	long g_stepx, g_stepy;
	long px,py;
	char textx[10], texty[10];

	range(xco, indx, xmax, xmin);
	range(yco, indx, ymax, ymin);
	stepx = (xmax-xmin)/630;
	stepy = (ymax-ymin)/470;
	g_stepx = 63*stepx;
	if((63*stepx-g_stepx) > 0.5)
		g_stepx++;

	g_stepy = 47*stepy;
	if((47*stepy-g_stepy) > 0.5)
		g_stepy++;

	setcolor(WHITE);
	setlinestyle(DASHED_LINE, 0, NORM_WIDTH);
	line(10, 470, 640, 470);
	line(10, 470, 10, 0);
	setlinestyle(SOLID_LINE, 0, THICK_WIDTH);

	for (i=0; i<=10; i++)
	{
		settextstyle(SMALL_FONT, HORIZ_DIR, 4);
		settextjustify(RIGHT_TEXT, TOP_TEXT);
		ltoa((int)xmin+i*g_stepx, textx, 10);
		ltoa((int)ymin+i*g_stepy, texty, 10);
		line(10+63*i, 468, 10+63*i, 472);
		outtextxy(10+63*i,470, textx);
		line(8, 470-47*i, 12, 470-47*i);
		settextstyle(SMALL_FONT, VERT_DIR, 4);
		settextjustify(RIGHT_TEXT, TOP_TEXT);
		if(i==0)
			settextjustify(RIGHT_TEXT, BOTTOM_TEXT);
		outtextxy(8,470-47*i, texty);
	}

	px = (int) (xco[0]-xmin)/stepx;
	py = (int) (yco[0]-ymin)/stepy;
	moveto(10+px, 470-py);
	setlinestyle(SOLID_LINE,0,NORM_WIDTH);
	for (i=0; i<indx; i++)
	{
		px = (int)(xco[i]-xmin)/stepx;
		py = (int)(yco[i]-ymin)/stepy;
		putpixel(10+px, 470-py, WHITE);
		lineto(10+px,470-py);
	}

}

/*void main()
{
	int driver = DETECT, mode;
	initgraph(&driver, &mode, "bgi");
	int indx = 100,i;
	float x[100], y[100];
	int p=0;
	for (i=0; i<indx; i++)
	{
	   x[i] = p;
	   y[i] = f(p);
	   p++;
	}
	draw_graph(x, y, indx);
	getch();
	closegraph();
} */
