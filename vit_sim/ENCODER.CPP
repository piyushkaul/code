					/////////////////////
					//	ENCODER.CPP  //
					/////////////////////

#include "decoder.h"

void encode(char file[])
/*
	Performs convolutional encoding of the file. It creates a coded
	file with the same name as input file but with an extension of
	".vit".
*/
{
	char outfile[20];
	int indx=0;
	while (file[indx] != '.' && file[indx] != '\0')
	{
		outfile[indx] = file[indx];
		indx++;
	}

	outfile[indx] = '\0';
	strcat(outfile,".vit");

	unsigned  char data = 0x0;
	int OutputWord;     // 16-bit
	char char1,char2;
	struct reg
	{
		unsigned   :12;
		unsigned d :1;
		unsigned c :1;
		unsigned b :1;
		unsigned a :1;
	} shift_reg={0,0,0,0};

	struct func
	{
		unsigned bit1:1;
		unsigned bit2:1;
	} parity={0,0};

	int handleR ,handleW;

	if((handleW = open(outfile, O_RDWR|O_BINARY|O_CREAT|O_TRUNC, S_IREAD|S_IWRITE)) == -1)
	{
		fprintf(stderr, "Error! Couldn't create file %s.", outfile);
		exit(1);
	}

	if((handleR = open(file, O_RDWR | O_BINARY,S_IREAD|S_IWRITE)) == -1)
	{
		fprintf(stderr, "Error! couldn't open file %s.", file);
		close (handleW);
		exit(1);
	}

	else
	{
		while(!eof(handleR))
		{
			read(handleR, &data, sizeof(data));
			short unsigned dummy1 = 0x8000, dummy2 = 0x4000;
			OutputWord=0;

			for(int j=0;j<8;j++)
			{
				shift_reg.d = shift_reg.c;
				shift_reg.c = shift_reg.b;
				shift_reg.b = shift_reg.a;

				if ((data&0x80)==0)
					shift_reg.a=0;
				else
					shift_reg.a=1;

				parity.bit1=shift_reg.a ^ shift_reg.b
					^ shift_reg.c ^ shift_reg.d;

				parity.bit2=shift_reg.a ^ shift_reg.b
					^ shift_reg.d;

				OutputWord = (parity.bit1 * dummy1) +
					(parity.bit2 * dummy2) + OutputWord;

				dummy1= dummy1>>2;
				dummy2= dummy2>>2;
				data= data<<1;
			}

			char1 = (char)((0xff00&OutputWord)>>8);
			char2 = (char)(0x00ff&OutputWord);

			write (handleW,&char1,sizeof(char1));
			write (handleW,&char2,sizeof(char2));

		}

		close(handleR);
		close(handleW);
	}

}

