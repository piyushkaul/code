				///////////////////////////
				//       MAIN.CPP		//
				/////////////////////////

#include "decoder.h"

HS HardSoft;
boolean cdm;

void main()
{
	/*int driver = DETECT, mode;
	initgraph(&driver, &mode, "bgi");
	draw_intro();
	draw_circuits();
	closegraph();*/

	char infile[50];

	cout << "Enter the name of the file to perform the simulation on:\n";
	cin >> infile;
	cdm=F;
	char outfile[20],intermed_file[20],spread_file[20],unspread_file[20],encoded_file[20];
	int indx=0;

	while (infile[indx] != '.' && infile[indx] != '\0')
	{

		outfile[indx] = infile[indx];
		indx++;
	}

	outfile[indx] = '\0';
	strcpy(intermed_file,outfile);
	strcpy(spread_file,outfile);
	strcpy(unspread_file,outfile);
	strcpy(encoded_file,outfile);
	strcat(encoded_file,".vit");
	strcat(outfile,".out");
	strcat(intermed_file,".imd");
	strcat(spread_file,".pni");
	strcat(unspread_file,".pno");

	char chM,chS,chI,chD;
	double ebno,lvalue,hvalue,steps;
	double table[2][50];
	cout << "\nEnter ebno of the noise(Press R for a range):";
	cin >> chM;
	if(chM == 'r')
	{
		cout<<"\nEnter the following values";
		cout<<"\n[Min. Value]   [Max. Value]   [Steps]";
		cin>>lvalue>>hvalue>>steps;
	}
	else
	{
		cout<<"\nEnter Eb/No";
		cin>>ebno;
	}

	printf("\nSpread spectrum techniques to be used(y/n)");
	cin>>chS;
	if(chS=='y')
		cdm=T;
	cout<<"\nPerforming convolutional encoding ...";
	encode(infile);
	cout<<"\ndone";

	if(cdm==T)
	{
		printf("\nImpulse noise to be introduced(y/n)");
		cin>>chI;
	}

	cout<<"\nHard or Soft Decision";
	cin>>chD;
	long err;
	int iterations;
	if(cdm==F)
	{
		  if(chM=='r')
		  {
			iterations=floor((hvalue-lvalue)/steps+.5);
			for(int iter=0;iter<iterations;iter++)
			{
				awgn_gen(encoded_file,lvalue+iter*steps,err,cdm);
				vit_decode(intermed_file,HardSoft,cdm);
				table[0][iter] = lvalue+iter*steps;
				table[1][iter] = file_comp(outfile,infile);

			}
			//draw_graph(table[0],table[1],iterations-1);

		  }
		  else
		  {

		  }
	}

	if(cdm==T)
	{
	   /*	  if(multiple=T)
		  {
			iterations=floor((hvalue-lvalue)/steps+.5)
			for(int iter=0;iter<iterations;iter++);
			{
				trellis((lvalue+iter*steps),hard);
				trellis((lvalue+iter*steps),soft);
			}
		 }
		 else
		 {
			trellis((lvalue+iter*steps),hard);
		 }*/


	}


}





//}