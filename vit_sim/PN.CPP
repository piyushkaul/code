				//////////////////////////
				//        PN.cpp        //
				/////////////////////////

#include <decoder.h>


typedef struct
{
	unsigned long state; /* PN register state */
	unsigned long mask; /* the mask to get the next state */
	unsigned long deg; /*  is equal to 2 raised to power m-1 where m is the
				size of shift register for generating m-sequence */
} MseqState;

typedef struct
{
	MseqState *ps; /*pointer to a dynamically allocated MseqState var */
	char      used; /* 1 when ps is valid, 0 otherwise */
} MseqMaster;


static MseqMaster *mseq_table;
static char is_initialized = 0;


int find_ones(unsigned long num)
/*
	Calculates the no. of 1's appearing in the binary representation of
	the integer specified in the argument.
*/
{
	int sum=0;
	unsigned long  rem;

	while (num!=0)
	{
		rem = num%2;
		num = num/2;

		if(rem == 1)
			sum++;
	}

	return sum;
}


int mseq_init( void )
/*
	Initializes the mseq_table entries.
	mseq_init() should be called before any mseq- functions.
	0 is returned on successful initialization, -1 otherwise.
*/
{
	if ( !is_initialized )
	{
		int i;
		mseq_table = (MseqMaster*) malloc( sizeof(MseqMaster)*MAX_PN_ID );

		if ( mseq_table == (MseqMaster*)NULL )
		{
			fprintf(stderr, "mseq_init: ...cannot allocate memory!\n");
			return -1;
		}

		for ( i = 0; i < MAX_PN_ID; i++ )
		{
			mseq_table[i].ps   = (MseqState*) NULL;
			mseq_table[i].used = 0;
		}

		is_initialized = 1;
	}

	return 0;
}


void mseq_end( void )
/*
	It deallocates mseq_table and reset init flag.
*/
{
	if ( is_initialized )
	{
		free( mseq_table );
		is_initialized = 0;
	}
}

int mseq_create( unsigned deg, unsigned long poly, unsigned long seed )
  /* It create a M-sequence generator with the given connection
     polynomial and initializes the internal register state to the
     given seed. The M-sequence generator id is returned */
{
	unsigned id;

	if ( deg > 31 )
	{
		fprintf(stderr, "mseq_create: ..cannot handle deg > 31\n");
		return -1; /* too big degree of polynomial */
	}

	for ( id = 0; mseq_table[id].used && (id < MAX_PN_ID); id ++ );

	if ( id == MAX_PN_ID )
		return -1; /* Max M-Seq generators have been used */

	mseq_table[id].ps = (MseqState*) malloc( sizeof(MseqState) );

	if ( mseq_table[id].ps == (MseqState*) NULL )
	{
		fprintf(stderr, "mseq_create: ...cannot allocate memory!\n");
		return -1;
	}

	mseq_table[id].used = 1;
	mseq_table[id].ps->deg = (unsigned)powl(2,deg-1);
	mseq_table[id].ps->state = seed;
	mseq_table[id].ps->mask = poly;

	return id;
}

void mseq_free( int id )
/*
	mseq_free() deallocates the memory space for M-Sequence generator.
	The corresponding flags are set.
 */
{
	free( (void*) mseq_table[id].ps );
	mseq_table[id].used = 0;
}

int mseq( int id )
/*
	mseq() gives the next M-sequence bit of the M-Sequence generator.
*/
{
	int seq;
	int temp;

	seq = mseq_table[id].ps->state & 1;
	temp = find_ones(mseq_table[id].ps->state & mseq_table[id].ps->mask);
	mseq_table[id].ps->state >>= 1;

	if(temp%2)
		mseq_table[id].ps->state += mseq_table[id].ps->deg;

	return seq;
}

void pn_gen(int* mseq1, int* mseq2, int *gold)
/*
	This module uses mseq*() functions to generate various m-sequences.
*/
{
	int pn0, pn1;
	int i;
	i = mseq_init(); /* initialize mseq_table */
	if(i == -1)
	{
		fprintf(stderr, "Couldn't initialize msequence table.");
		exit(1);
	}

	pn0 = mseq_create(DEG,CONNECT1,INIT_STATE1); /*create two PN generators*/
	pn1 = mseq_create(DEG,CONNECT2,INIT_STATE2);
	if(pn0 == -1 || pn1 == -1)
	{
		fprintf(stderr, "Couldn't generate msequence.");
		exit(1);
	}

	for( i = 0; i < LEN; i++ )
	{
		mseq1[i] = mseq(pn0); /*create next bit in sequence and store*/
		mseq2[i] = mseq(pn1);

	}

	for (i=0; i < LEN;i++)
		gold[i] = mseq1[i]^mseq2[i];/* generate gold code  by ex-oring
							the two m-sequences */

	mseq_free(pn0);
	mseq_free(pn1);
	mseq_end();
}

unsigned char get_byte(int *seq, int num)
/*
	Used by pn_encode module
*/
{
	int i,temp[8];
	unsigned char a=0;
	for(i=0; i < 8; i++)
	{
		temp[i] = seq[i];
		a = a|temp[i];
		if (i!=7)
			a = a<<1;
	}
	for (i=0;i<LEN-8;i++)
		seq[i] = seq[i+8];

	for (i=0;i<8;i++)
		seq[LEN-8+i] = temp[i];

	if (num == 128)
		return a;
	else
		return (~a);
}

int find_ones(unsigned char num)
/*
	Finds and returns the number of ones in the binary representation of
	the number specified as argument. Used by PN_decode module.
*/
{
	int sum=0,rem;

	while (num!=0)
	{
		rem = num%2;
		num = num/2;

		if(rem == 1)
			sum++;
	}

	return sum;
}

void pn_encode(char file1[])
/*
	encodes the file specified as argument by multiplying with
	the gold code generated.
*/
{
	char file2[20];
	unsigned char load, store;
	int indx=0,temp,handleW,handleR;
	while (file1[indx] != '.' && file1[indx] != '\0')
	{
		file2[indx] = file1[indx];
		indx++;
	}

	file2[indx] = '\0';
	strcat(file2,".pni");

	int *gold, *mseq1, *mseq2;
	gold = new int[(int)pow(2, DEG) - 1];
	mseq1 = new int[(int)pow(2,DEG) - 1];
	mseq2 = new int[(int)pow(2,DEG) - 1];

	pn_gen(mseq1, mseq2, gold);

	handleW = open(file2,O_RDWR|O_BINARY|O_CREAT|O_TRUNC,S_IREAD|S_IWRITE);
	if (handleW == -1)
	{
		fprintf(stderr, "Couldn't open file %s.", file2);
		exit(1);
	}

	handleR = open(file1, O_RDWR|O_BINARY, S_IREAD|S_IWRITE);
	if(handleR == -1)
	{
		fprintf(stderr, "Couldn't open file ", file1);
		exit(1);
	}

	while (!eof(handleR))
	{
		read(handleR, &load, 1);
		for(indx = 0; indx < 8; indx++)
		{
			temp = load&128;
			load = load<<1;
			store = get_byte(gold, temp);
			write(handleW, &store, 1);
		}
	}
	close(handleR);
	close(handleW);
}

void pn_decode(char file1[])
{
	char file2[20];
	unsigned char load, store;
	int indx=0,temp,handleW,handleR;
	while (file1[indx] != '.' && file1[indx] != '\0')
	{
		file2[indx] = file1[indx];
		indx++;
	}

	file2[indx] = '\0';
	strcat(file2,".pno");

	int *gold, *mseq1, *mseq2;
	gold = new int[(int)pow(2, DEG) - 1];
	mseq1 = new int[(int)pow(2,DEG) - 1];
	mseq2 = new int[(int)pow(2,DEG) - 1];

	pn_gen(mseq1, mseq2, gold);

	handleW = open(file2,O_RDWR|O_BINARY|O_CREAT|O_TRUNC,S_IREAD|S_IWRITE);
	if (handleW == -1)
	{
		fprintf(stderr, "Couldn't open file %s.", file2);
		exit(1);
	}

	handleR = open(file1, O_RDWR|O_BINARY, S_IREAD|S_IWRITE);
	if(handleR == -1)
	{
		fprintf(stderr, "Couldn't open file ", file1);
		exit(1);
	}

	while (!eof(handleR))
	{
		store = 0;
		for(indx = 0; indx < 8; indx++)
		{
			read(handleR, &load, 1);
			temp = get_byte(gold, 128);
			load = load^temp;

			if(load == 0)
			{
				store |= 1;
				if (indx != 7)
					store <<= 1;
			}

			else if(load == 255)
			{
				store |= 0;
				if (indx != 7)
					store <<= 1;
			}

			else
			{
				temp = find_ones(load);
				if(temp <= 4)
				{
					store |= 1;
					if (indx != 7)
						store <<= 1;
				}
				else
				{
					store |= 0;
					if(indx != 7)
						store <<= 1;
				}
			}
		}

		write (handleW, &store, 1);
	}

	close(handleR);
	close(handleW);
}
