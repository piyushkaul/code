				////////////////////////
				//	CIRCUITS.CPP    //
				////////////////////////

#include "decoder.h"

void add_zeros (char num[], int len)
/*
	Adds leading zeros to its first argument so as to make the resultant
	string have a length specified in the second argument
*/
{
	int i, diff = len - strlen (num);
	char *temp_Ptr = new char[len+1];

	for (i = 0; i < diff; i++)
		temp_Ptr[i] = '0';

	temp_Ptr[i] = '\0';
	strcat (temp_Ptr, num);
	strcpy (num, temp_Ptr);
}

void draw_circuits()
/*
	Draws the circuits corresponding to PN-generators and convolutional
	encoders that are currently being used by the program
*/
{
	int i,xco=250,yco=50,wid=10,rad=12;
	char text[2];
	text[1] = '\0';
	char *data1, *data2, *con1, *con2;
	data1 = (char *)malloc(DEG+1);
	data2 = (char *)malloc(DEG+1);
	con1 = (char *)malloc(DEG+1);
	con2 = (char *)malloc(DEG+1);
	ultoa(INIT_STATE1, data1, 2);
	add_zeros(data1, DEG);
	ultoa(INIT_STATE2, data2, 2);
	add_zeros(data2, DEG);
	ultoa(CONNECT1, con1, 2);
	add_zeros(con1, DEG);
	ultoa(CONNECT2, con2, 2);
	add_zeros(con2, DEG);
	setcolor(WHITE);
	setlinestyle(SOLID_LINE, 0, NORM_WIDTH);
	setfillstyle(SOLID_FILL,DARKGRAY);
	settextstyle(TRIPLEX_FONT, HORIZ_DIR, 1);
	settextjustify(CENTER_TEXT, TOP_TEXT);
	moveto(320,0);
	outtext("Circuit used to generate PN sequences");
	moveto(320,260);
	outtext("Circuit used to perform Convolutional encoding");

	settextstyle(SMALL_FONT, HORIZ_DIR, 4);
	settextjustify(CENTER_TEXT, CENTER_TEXT);
	circle(xco, yco, rad);
	outtextxy(xco, yco, "+");
	yco = 100;
	for(i=DEG/2;i<DEG;i++)
	{
		rectangle(xco-wid,yco-wid,xco+wid,yco+wid);
		floodfill(xco,yco,WHITE);
		setcolor(BLACK);
		text[0] = data1[i];
		outtextxy(xco,yco,text);
		setcolor(WHITE);
		xco += 2*wid;
	}

	int x = xco+4*wid;
	line(xco-wid, yco, x, yco);
	line(x, yco, x, yco+50-rad);
	line(x, yco+50-rad, x-wid/2, yco+50-rad-wid/2);
	line(x, yco+50-rad, x+wid/2, yco+50-rad-wid/2);
	circle(x, yco+50, rad);
	outtextxy(x, yco+50, "+");
	xco = 250-2*wid;

	for(i=0; i<DEG/2; i++)
	{
		rectangle(xco-wid, yco-wid, xco+wid, yco+wid);
		floodfill(xco, yco, WHITE);
		setcolor(BLACK);
		text[0] = data1[DEG/2-1-i];
		outtextxy(xco, yco, text);
		setcolor(WHITE);
		xco -= 2*wid;
	}

	line(250-rad, 50, xco-wid, 50);
	line(xco-wid, 50, xco-wid, yco);
	line(xco-wid, yco, xco+wid, yco);
	line(xco+wid, yco, xco+wid-wid/2, yco-wid/2);
	line(xco+wid, yco, xco+wid-wid/2, yco+wid/2);


	xco += 2*wid;
	float theta;
	for(i=0; i<DEG; i++)
	{
		theta = (DEG/2-i)*PI/DEG;

		if(con1[i] == '1')
			line(xco, yco-wid, 250-rad*sin(theta), 50+rad*cos(theta));

		xco+=2*wid;
	}

	xco = 250;
	yco = 250;
	circle(xco, yco, rad);
	outtextxy(xco, yco, "+");
	yco -= 50;
	for(i=DEG/2;i<DEG;i++)
	{
		rectangle(xco-wid,yco-wid,xco+wid,yco+wid);
		floodfill(xco,yco,WHITE);
		setcolor(BLACK);
		text[0] = data2[i];
		outtextxy(xco,yco,text);
		setcolor(WHITE);
		xco += 2*wid;
	}

	line(xco-wid, yco, x, yco);
	line(x, yco, x, yco-50+rad);
	line(x, yco-50+rad, x-wid/2, yco-50+rad+wid/2);
	line(x, yco-50+rad, x+wid/2, yco-50+rad+wid/2);

	xco = 250-2*wid;
	for(i=0;i<DEG/2;i++)
	{
		rectangle(xco-wid, yco-wid, xco+wid, yco+wid);
		floodfill(xco, yco, WHITE);
		setcolor(BLACK);
		text[0] = data2[DEG/2-1-i];
		outtextxy(xco, yco, text);
		setcolor(WHITE);
		xco -= 2*wid;
	}

	line(250-rad, 250, xco-wid, 250);
	line(xco-wid, 250, xco-wid, yco);
	line(xco-wid, yco, xco+wid, yco);
	line(xco+wid, yco, xco+wid-wid/2, yco-wid/2);
	line(xco+wid, yco, xco+wid-wid/2, yco+wid/2);


	xco += 2*wid;

	for(i=0; i<DEG; i++)
	{
		theta = (DEG/2-i)*PI/DEG;

		if(con2[i] == '1')
			line(xco, yco+wid, 250-rad*sin(theta), 250-rad*cos(theta));

		xco+=2*wid;
	}

	moveto(x+rad, 150);
	lineto(x+rad+4*wid, 150);
	lineto(x+rad+4*wid-wid/2, 150-wid/2);
	line(x+rad+4*wid, 150, x+rad+4*wid-wid/2, 150+wid/2);
	settextstyle(SMALL_FONT, HORIZ_DIR, 5);
	settextjustify(LEFT_TEXT, BOTTOM_TEXT);
	moveto(x+rad+3, 147);
	outtext("Gold Code");
	moveto(x-4*wid-5, 96);
	outtext("m-sequence 1");
	moveto(x-4*wid-5, 209);
	outtext("m-sequence 2");


	strcpy(con1, "1101");
	xco = 250;
	yco = 450;
	circle(xco, yco, rad);
	settextjustify(CENTER_TEXT, CENTER_TEXT);
	outtextxy(xco, yco, "+");
	yco -= 50;
	for(i=2;i<4;i++)
	{
		rectangle(xco,yco-wid,xco+2*wid,yco+wid);
		floodfill(xco+wid,yco,WHITE);
		xco += 2*wid;
	}

	line(250+rad, 450, xco+4*wid, 450);
	line(xco+4*wid, 450, xco+4*wid, yco+2*wid);
	line(xco+4*wid, yco+2*wid, xco+4*wid-wid/2, yco+2*wid+wid/2);
	line(xco+4*wid, yco+2*wid, xco+4*wid+wid/2, yco+2*wid+wid/2);
	rectangle(xco+4*wid-2*wid, yco+2*wid-4*wid, xco+4*wid+2*wid, yco+2*wid);
	line(xco+4*wid+2*wid, yco, xco+10*wid, yco);
	line(xco+10*wid, yco, xco+10*wid-wid/2, yco-wid/2);
	line(xco+10*wid, yco, xco+10*wid-wid/2, yco+wid/2);
	outtextxy(xco+4*wid, yco, "MPLXR");

	xco = 250;
	for(i=0;i<2;i++)
	{
		rectangle(xco, yco-wid, xco-2*wid, yco+wid);
		floodfill(xco-wid, yco, WHITE);
		xco -= 2*wid;
	}

	line(xco-4*wid, yco, xco, yco);
	line(xco, yco, xco-wid/2, yco-wid/2);
	line(xco, yco, xco-wid/2, yco+wid/2);


	xco += wid;
	x = xco;
	theta = PI/2;
	for(i=0; i<4; i++)
	{
		if(con1[i] == '1')
			line(xco, yco+wid, 250-rad*sin(theta), 450-rad*cos(theta));

		xco+=2*wid;
		theta -= PI/3;
	}

	circle(250, 350, rad);
	outtextxy(250, 350, "+");

	theta = PI/2;
	for(i=0; i<4; i++)
	{
		line(x, yco-wid, 250-rad*sin(theta), 350+rad*cos(theta));
		x+=2*wid;
		theta -= PI/3;
	}
	line(250+rad, 350, xco+3*wid, 350);
	line(xco+3*wid, 350, xco+3*wid, yco-2*wid);
	line(xco+3*wid, yco-2*wid, xco+3*wid-wid/2, yco-2*wid-wid/2);
	line(xco+3*wid, yco-2*wid, xco+3*wid+wid/2, yco-2*wid-wid/2);

	settextjustify(RIGHT_TEXT, CENTER_TEXT);
	moveto(250-8*wid-1, yco);
	outtext("i/p");

	settextjustify(LEFT_TEXT, CENTER_TEXT);
	moveto(250+14*wid+3, yco);
	outtext("o/p");

	settextjustify(CENTER_TEXT,CENTER_TEXT);
	moveto(320,470);

	while(!kbhit())
	{
		setcolor(WHITE);
		outtext("Press a key to continue");
		delay(300);
		setcolor(BLACK);
		outtext("Press a key to continue");
		delay(300);
	}
	getch();
	cleardevice();
}

