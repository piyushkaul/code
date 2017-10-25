				///////////////////////////////
				//        INTRO.CPP	    //
				//////////////////////////////

#include "decoder.h"

const int w = 25; // "Half-Width" of rectangular boxes.

void draw_box(int xco, int yco, int scale, char text[])
/*
	This module is used by draw_intro() function to draw rectangular boxes
	with trailing arrow representing connection to next box as well as some
	text inside the box.
*/
{
	int i=0;
	char t[20];
	while(*text != '\n' && *text != '\0')
	{
		t[i] = *text;
		i++;
		text++;
	}
	t[i] = '\0';

	rectangle(xco, yco, xco+scale*2*w, yco+2*w);
	moveto(xco+scale*2*w, yco+w);
	lineto(xco+scale*2*w+w, yco+w);
	lineto(xco+scale*2*w+w-w/4, yco+w-w/4);
	line(xco+scale*2*w+w, yco+w, xco+scale*2*w+w-w/4, yco+w+w/4);
	moveto(xco+scale*w, yco+3);
	outtext(t);
	moveto(xco+scale*w,yco+w+3);
	outtext(text);
	moveto(xco+scale*2*w+w, yco);
}

void draw_circ(int xco, int yco, char top[], char bottom[])
/*
	This module is used by draw_intro() function to draw circles with
	connected arrows representing mod-2 adders or correlators.
*/
{
	const int rad = 12;
	circle(xco+rad, yco, rad);
	settextjustify(CENTER_TEXT, CENTER_TEXT);
	moveto(xco+rad, yco);
	outtext("+");
	settextjustify(CENTER_TEXT, BOTTOM_TEXT);
	moveto(xco+rad, yco-rad-5);
	outtext(bottom);
	moveto(xco+rad, yco-rad-15);
	outtext(top);
	line(xco+rad, yco+rad, xco+rad, yco+rad+2*w);
	rectangle(xco+rad-2*w, yco+rad+2*w, xco+rad+2*w, yco+rad+4*w);
	settextjustify(CENTER_TEXT, TOP_TEXT);
	moveto(xco+rad, yco+rad+2*w+3);
	outtext("PN Code");
	moveto(xco+rad, yco+rad+3*w+3);
	outtext("Generator");
	moveto(xco+rad, yco+rad);
	lineto(xco+rad-w/4, yco+rad+w/4);
	moveto(xco+rad, yco+rad);
	lineto(xco+rad+w/4, yco+rad+w/4);
	moveto(xco+2*rad, yco);
	lineto(xco+2*rad+w, yco);
	line(xco+2*rad+w, yco, xco+2*rad+w-w/4, yco-w/4);
	line(xco+2*rad+w, yco, xco+2*rad+w-w/4, yco+w/4);
	moveto(xco+2*rad+w, yco-w);
}

void draw_intro()
/*
	Draws the introductory screen on the terminal followed by a block
	diagram of the digital communication system simulated.
*/
{
	setcolor(WHITE);
	settextstyle(TRIPLEX_FONT, HORIZ_DIR, 3);
	settextjustify(CENTER_TEXT, TOP_TEXT);
	moveto(320,0);
	outtext("Simulation of a Direct Sequence Spread Spectrum");
	moveto(320,25);
	outtext("System with Convolutional Coding & Viterbi Decoding");
	moveto(320,50);
	outtext("for the AWGN and Impulsive Noise Channels");
	settextstyle(SMALL_FONT,HORIZ_DIR,6);
	settextjustify(RIGHT_TEXT,TOP_TEXT);
	moveto(180,150);
	outtext("Submitted By:");
	moveto(180,300);
	outtext("Project Guide:");
	settextjustify(LEFT_TEXT,TOP_TEXT);
	moveto(140,170);
	outtext("Piyush Kaul           -       95EC73");
	moveto(140,190);
	outtext("Kapil Juneja          -       95EC64");
	moveto(140,210);
	outtext("Manish Soni           -       95EC65");
	moveto(140,230);
	outtext("Nidhir Kr. Aggarwal    -       95EC68");
	moveto(140,320);
	outtext("Dr. P.R. Chaddha");

	settextjustify(CENTER_TEXT,CENTER_TEXT);
	moveto(320,440);
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

	setcolor(WHITE);
	setlinestyle(SOLID_LINE, 0, NORM_WIDTH);
	settextstyle(TRIPLEX_FONT, HORIZ_DIR, 3);
	settextjustify(CENTER_TEXT, TOP_TEXT);
	moveto(320,0);
	outtext("Digital Communication System Model");
	settextstyle(SMALL_FONT, HORIZ_DIR, 5);
	settextjustify(CENTER_TEXT, TOP_TEXT);

	draw_box(10,70,2,"Information\nSource");
	draw_box(getx(),gety(),2,"Convolutional\nEncoder");
	draw_circ(getx(), gety()+w, "Mod-2", "Adder");
	draw_box(getx(), gety(), 2, "HF\nChannel");
	moveto(getx(), gety()+w);
	lineto(getx(), 250);
	lineto(10, 250);
	lineto(10, 350);
	lineto(40, 350);
	line(40-w/4, 350-w/4, 40, 350);
	line(40-w/4, 350+w/4, 40, 350);
	draw_circ(getx(), gety(), "PN", "Correlator");
	draw_box(getx(), gety(), 2, "Decision\nCircuits");
	draw_box(getx(), gety(), 2, "Viterbi\nDecoder");
	draw_box(getx(), gety(), 2, "Output\Data");

	settextjustify(CENTER_TEXT,CENTER_TEXT);
	moveto(320,440);
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


