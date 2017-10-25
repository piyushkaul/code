					///////////////////
					//  decoder.cpp  //
					///////////////////

# include "decoder.h"

extern double mettab[2][256];



enum node {a,b,c,d,e,f,g,h};//the eight states of a 4 constraint length coder


//initialize  node  weight
int handleR,handleW; //input file & output file
long double node_wt_s[8]={1000,0,0,0,0,0,0,0};
long double temp_node_wt_s[8]={0,0,0,0,0,0,0,0};
long int node_wt_h[8]={1000,0,0,0,0,0,0,0,};
long int temp_node_wt_h[8]={0,0,0,0,0,0,0,0};

//record of the node path
unsigned long int  node_path[8]={0,0,0,0,0,0,0,0};
unsigned long int  temp_node_path[8]={0,0,0,0,0,0,0,0};
static int count=0;
boolean flag[8]={F,F,F,F,F,F,F,F};

//output bits for state transition x to y
unsigned int parity1[8][8] = {
						{0,1},
						{2,2,1,0},
						{2,2,2,2,1,0},
						{2,2,2,2,2,2,0,1},
						{1,0},
						{2,2,0,1},
						{2,2,2,2,0,1},
						{2,2,2,2,2,2,1,0}
					};

unsigned int parity2[8][8] = {
						{0,1},
						{2,2,1,0},
						{2,2,2,2,0,1},
						{2,2,2,2,2,2,1,0},
						{1,0},
						{2,2,0,1},
						{2,2,2,2,1,0},
						{2,2,2,2,2,2,0,1}
					};

unsigned char input_bit[8][8] = {
						{0,1},
						{2,2,0,1},
						{2,2,2,2,0,1},
						{2,2,2,2,2,2,0,1},
						{0,1},
						{2,2,0,1},
						{2,2,2,2,0,1},
						{2,2,2,2,2,2,0,1}
					 };

int max_node(void);
void shift_path(void);
void acs(node ,node ,node ,unsigned char ,unsigned char );
void write_path(node ,node  ,unsigned char  ,unsigned char );
int weight_comp(node ,node ,node ,int ,int );
int weight_h(node ,node ,unsigned char ,unsigned char);
long double weight_s(node ,node ,unsigned char,unsigned char);
char get_data();
unsigned  char get_databits(unsigned char* data);
void reset_flags(void);


void  vit_decode(char infile[],HS  HardSoft,boolean  cdm )
/*
	Performs Viterbi decoding.
*/
{

	char outfile[20];
	int indx=0;

	while (infile[indx] != '.' && infile[indx] != '\0')
	{
		outfile[indx] = infile[indx];
		indx++;
	}

	outfile[indx] = '\0';
	strcat(outfile,".out");

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

	unsigned char data;
	unsigned char bit1,bit2,byte1,byte2;
	int n;
	unsigned int Output_char=0;
	char* ptr_data;

	char str[10];
	unsigned char bits;
	if(HardSoft==soft)
	{
		  metric_gen();
	}

	if(cdm==F)
	{
		if(HardSoft==hard)
		{
			while (!eof(handleR))
			{
				byte1=get_data();
				byte2=get_data();
				if(byte1<127)
					bit1 = 0;
				else
					bit1=1;
				if(byte2<127)
					bit2 = 0;
				else
					bit2=1;
				acs(a,e,a,bit1,bit2);
				acs(a,e,b,bit1,bit2);
				acs(b,f,c,bit1,bit2);
				acs(b,f,d,bit1,bit2);
				acs(c,g,e,bit1,bit2);
				acs(c,g,f,bit1,bit2);
				acs(d,h,g,bit1,bit2);
				acs(d,h,h,bit1,bit2);
				count++;
				reset_flags();
				if((count>=32)&&((count%8)==0))
				{
					n=max_node();
					Output_char=(char)(node_path[n]>>24);
					//printf("\t%c\n",Output_char);
					write(handleW,&Output_char,1);
				}
			}
		}
		else
		{
			while (!eof(handleR))
			{
				byte1=get_data();
				byte2=get_data();
				acs(a,e,a,byte1,byte2);
				acs(a,e,b,byte1,byte2);
				acs(b,f,c,byte1,byte2);
				acs(b,f,d,byte1,byte2);
				acs(c,g,e,byte1,byte2);
				acs(c,g,f,byte1,byte2);
				acs(d,h,g,byte1,byte2);
				acs(d,h,h,byte1,byte2);
				count++;
				reset_flags();
				if((count>=32)&&((count%8)==0))
				{
					n=max_node();
					Output_char=(char)(node_path[n]>>24);
 //					printf("\t%c\n",Output_char);
					write(handleW,&Output_char,1);
				}
			}
		}
//*************************************************************************
// code to output the rest of the bits in the shift register to the outfile
//			printf("\t%c\n",Output_char);
	}
	else    //for cdm==T
	{

		while (!eof(handleR))
		{
			data=get_data();
	// the databits char returned is cast to int and fills the higher bits with zeroes
			ptr_data= (char *)&data;
			for(int j=0;j<=3;j++)
			{
				bits = get_databits((unsigned char*)ptr_data);
				bit1 =(unsigned int)(bits&0x80);
				bit2 =(unsigned int)(bits&0x40);
				acs(a,e,a,bit1,bit2);
				acs(a,e,b,bit1,bit2);
				acs(b,f,c,bit1,bit2);
				acs(b,f,d,bit1,bit2);
				acs(c,g,e,bit1,bit2);
				acs(c,g,f,bit1,bit2);
				acs(d,h,g,bit1,bit2);
				acs(d,h,h,bit1,bit2);
				count++;
				reset_flags();
			} //end for loop of 4
			if((count>=32)&&((count%8)==0))
			{
				n=max_node();
				Output_char=(char)(node_path[n]>>24);
//	 			printf("\t%c\n",Output_char);
				write(handleW,&Output_char,1);
			}
		}
	}
		for(int i=16;i>=0;i-=8)
		{

			Output_char=(char)((node_path[n])>>i)  ;
//			printf("\t%c\n",Output_char);
			write(handleW,&Output_char,1);
		}



	close(handleR);
	close(handleW);
}

   //finds the node with maximum weight

void acs(node x,node y,node z,unsigned char bitbyt1,unsigned char bitbyt2)
{
	if (HardSoft==hard)
	{
		if (weight_comp(x,y,z,bitbyt1,bitbyt2))
			write_path(x,z,bitbyt1,bitbyt2);

		else
			write_path(y,z,bitbyt1,bitbyt2);
	 }

	else
	{
		if (weight_comp(x,y,z,bitbyt1,bitbyt2))
			write_path(x,z,bitbyt1,bitbyt2);

		else
		    write_path(y,z,bitbyt1,bitbyt2);

	}

}


int weight_comp(node x,node y,node z,int bitbyt1,int bitbyt2)
{
	if (HardSoft==hard)
	{
		long wt_x,wt_y;

		if(flag[x]==T)
			wt_x=temp_node_wt_h[x];
		else
			wt_x=node_wt_h[x];


		if(flag[y]==T)
			wt_y=temp_node_wt_h[y];
		else
			wt_y=node_wt_h[y];


		if ((wt_x + weight_h(x,z,bitbyt1,bitbyt2)) > (wt_y+ weight_h(y,z,bitbyt1,bitbyt2)))
			return 1;
		else
			return 0;
	}

	else
	{
		long double wt_x,wt_y;
		if(flag[x]==T)
			wt_x=temp_node_wt_s[x];
		else
			wt_x=node_wt_s[x];


		if(flag[y]==T)
			wt_y=temp_node_wt_s[y];
		else
			wt_y=node_wt_s[y];


		if ((wt_x + weight_s(x,z,bitbyt1,bitbyt2))>(wt_y+ weight_s(y,z,bitbyt1,bitbyt2)))
			return 1;
		else
			return 0;
	}
}


int max_node(void)
{
	int max=0;
	if (HardSoft==hard)
	{
		for(int i=0;i<8;i++)
			if(node_wt_h[i]>node_wt_h[max])
				max=i;
	}

	else
	{
		for(int i=0;i<8;i++)
		{
			if(node_wt_s[i]>node_wt_s[max])
				max=i;
		}
	}
     return max;
   }

void write_path(node x,node y ,unsigned char bitbyt1 ,unsigned char bitbyt2)
{
	// oldest bit is MSB
	if (!flag[y])  //if path of y has not been altered   then
	{
		temp_node_path[y]=node_path[y];

		if(HardSoft==hard)
			temp_node_wt_h[y]=node_wt_h[y];
		else
			temp_node_wt_s[y]=node_wt_s[y];

		flag[y]=T;
	}

	if (flag[x])
	{
		node_path[y]=temp_node_path[x]<<1;
		node_path[y]=(input_bit[x][y])|(node_path[y]);

		if (HardSoft==hard)
			node_wt_h[y]=temp_node_wt_h[x]+weight_h(x,y,bitbyt1,bitbyt2);
		else
			node_wt_s[y]=temp_node_wt_s[x]+weight_s(x,y,bitbyt1,bitbyt2);

	}

	else
	{
		node_path[y]=node_path[x]<<1;
		node_path[y]=(input_bit[x][y])|(node_path[y]);

		if (HardSoft==hard)
			node_wt_h[y]=node_wt_h[x]+weight_h(x,y,bitbyt1,bitbyt2);
		else
			node_wt_s[y]=node_wt_s[x]+weight_s(x,y,bitbyt1,bitbyt2);

	}

}


char get_data()
{
	unsigned char data;
	read(handleR,&data,sizeof(data));
	return data;
}


unsigned  char get_databits(unsigned char* data)
{
	unsigned char databits;
	databits=((*data)&0xC0);
	*data=*data<<2;
	 return databits;
}


int weight_h(node x,node y,unsigned char bit1,unsigned char bit2)
{
	int recv_wt1,recv_wt2;

	if (bit1==0)
		recv_wt1=1;
	else
		recv_wt1=-1;

	if(bit2==0)
		recv_wt2=1;
	else
		recv_wt2=-1;

	int wt;
	wt= (((1- 2*parity1[x][y])  * ( recv_wt1)) + ((1- 2*parity2[x][y])  *  (recv_wt2)));
	return wt;
}


long double weight_s(node x,node y,unsigned char byte1,unsigned char byte2)
{
	double wt;
	wt = mettab[parity1[x][y]][(int)byte1]+mettab[parity2[x][y]][(int)byte2];
	return wt;
}





void   reset_flags(void)
{
	for(int i=0;i<=7;i++)
		flag[i]=F;
}



