				///////////////////////
				//	Filecomp.cpp   //
				///////////////////////
#include"decoder.h"

/*
	Finds and returns the number of ones in the binary representation of
	the number specified as argument.
*/




 find_ones( unsigned char num)

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

float file_comp(char fil_nam1[], char fil_nam2[])
/*
	Compares the two files and returns the percentage of errors with
	respect to the "Larger" file as well as other data such as no. of
	bit errors and the sizes of the two files in bits.
*/
{
	int handle1,handle2;
	long size1, size2, err;
	handle1 = open(fil_nam1, O_RDWR|O_BINARY, S_IREAD|S_IWRITE);
	handle2 = open(fil_nam2, O_RDWR|O_BINARY, S_IREAD|S_IWRITE);

	if(handle1 == -1)
	{
		cerr << "\nCouldn't open file " << fil_nam1;
		exit(1);
	}

	if(handle2 == -1)
	{
		cerr << "\nCouldn't open file " << fil_nam2;
		exit(1);
	}

	unsigned char i1,i2,i3;
	unsigned long pos;
	err=0;
	size1=0;
	size2=0;
	float per_err;

	while (!eof(handle1) && !eof(handle2))
	{
		read(handle1, &i1, 1);
		read(handle2, &i2, 1);

		i3 = i1^i2;
		if(i3 != 0)
			err += find_ones(i3);

		size1++;
	}

	if(!eof(handle1))
	{
		pos = tell(handle1);
		lseek(handle1, 0, SEEK_END);
		err += 8*(tell(handle1)-pos);
		size2 = tell(handle1)-pos;
	}

	if(!eof(handle2))
	{
		pos = tell(handle2);
		lseek(handle2, 0, SEEK_END);
		err += 8*(tell(handle2)-pos);
		size2 = tell(handle2)-pos;
	}

	size2 += size1;
	per_err =  (float)(err*100)/(8*size2);


	close(handle1);
	close(handle2);

	return per_err;
}

