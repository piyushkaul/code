				/////////////////////////
				//	  awgn.cpp	     //
				/////////////////////////
#include "decoder.h"

#define pie  3.14159265
#define pdf(x,m,var) (1/sqrt(pie * var* 2))*(exp(-(x-m)*(x-m)/(2*var)));

long int error_count;
class link
{
	public:
		float noise ;
		link* next;
};

link* first = NULL ;
link* p,*r;
int count=0;

double p_dist()
{
	double x=0.0;
	double prob=5;
	int val;

	while(prob>.01)
	{
		prob=pdf(x,MEAN,VARIANCE);
		val= ceil(100*prob);

		for(int j=0; j<val; j++)
		{
			p=(link*)malloc(sizeof(link));
			p->noise=x;
			p->next=first;
			first=p;
			count++;
		}
		x=0.01+x;
	}

	return x;
}


void noise_add(unsigned char *sym,int nsym, double EbNo,double max)
{
	unsigned char quant_noise;
	double quant_noise_r;

	double step= max/256;
	int no;
	srand(0xAAAA);
	for (int j=0;j<nsym;j++)
	{
		//no=random(count+1);
		no = rand();
		p= first;

		for(int i=0;i<=no;i++)
			p=p->next;

		if(step!=0)
			quant_noise_r=(p->noise/(step*EbNo));
		else
			quant_noise_r=0;

		quant_noise=(unsigned char)quant_noise_r;

		if (*sym)
		{
			*sym=255 -quant_noise;

			if (*sym<127)
				error_count++;
		}

		else
		{
			*sym=0 + quant_noise;
			if(*sym>127)
				error_count++;
		}

		sym++;
	}

}

void awgn_gen(char infile[], double ebno, long& err_count, boolean cdm)
/*
	Generates noise.
*/
{
	error_count = 0;
	int handleR,handleW;
	char outfile[20];
	int indx=0;
	char data_byte;

	while (infile[indx] != '.' && infile[indx] != '\0')
	{
		outfile[indx] = infile[indx];
		indx++;
	}

	outfile[indx] = '\0';
	strcat(outfile,".imd");

	if ((handleW = open(outfile, O_RDWR|O_BINARY|O_CREAT|O_TRUNC, S_IREAD|S_IWRITE))==-1)
	{
		fprintf(stderr, "Couldn't open file %s", outfile);
		exit(1);
	}

	if((handleR = open(infile, O_RDWR|O_BINARY, S_IREAD|S_IWRITE)) == -1)
	{
		fprintf(stderr, "Couldn't open file %s", infile);
		exit(1);
	}

	int ns=0,i=0;
	char ch[20],temp;
	unsigned char symbol[160] ,raw_sym[160];
	double  max= p_dist();
	while(!eof(handleR))
	{
		i=0;ns=0;
		while( (i<20) && (!eof(handleR)) )
			read(handleR,&ch[i++],1);

		 for(int j=0;j<i;j++)
		 {
			temp = ch[j];

			for(int k=0;k<8;k++)
			{
				symbol[ns]=(temp & 0x80)>>7;
				raw_sym[ns++]=(temp & 0x80)>>7;
				temp=temp<<1;
			}
		 }

		noise_add(symbol,ns,ebno,max);
		if (cdm==T)
		{
			for(j=0;j<ns;j++)
			{
				if (symbol[ns]>127)
					data_byte=(data_byte|0x80)>>1;
				else
					data_byte=(data_byte&0x4f)>>1;
				if((count%8==0)&&(count>1))
				{
					write(handleW,&data_byte,1);
					data_byte=0x00;
				}

			}
		}
		else
		{
			for(int k=0;k<ns ;k++)
			{
//				printf("%x\t%d\n",raw_sym[k],symbol[k] );
				write(handleW,&symbol[k],1);
			}

		 }
	}

	close(handleR);
	close(handleW);

	p = first;

	for(i=0;i<=count;i++)
	{
		r=p;
		p=p->next;
		free(r);
	}

	err_count = error_count;
}



