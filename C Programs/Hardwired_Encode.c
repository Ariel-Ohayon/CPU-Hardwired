/* The code written by me (Ariel Ohayon).
 *
 * This code script load .txt file that include assembler code for the Hardwired CPU architecture.
 * The output of the program is a file called "outputfile.txt" that include the encoding for each
 * assembly code line to machine language that program into the CPU memory.
 *
 */

#include <stdio.h>
#include <string.h>

int mycmp(char x1[],char x2[]);

int main(int argc, char *argv[])
{
	int i = 0, flag = 0;
	
	char Dir[100];
	char read[100];
	char str[100];
	char op[10];

	char st;
	FILE *in;
	FILE *out;
	printf("Enter Directory:\n");
	scanf("%s",Dir);

	in = fopen(Dir,"r");
	if (in == NULL)
	{
		printf("File Not Found.\n");
		return 0;
	}
	printf("\n- - - - - - - - - - - - - - - - - - -\n");
	printf("Read file: %s:\n",Dir);
	while (fgets(read,100,in))
		printf("%s",read);
	printf("\n- - - - - - - - - - - - - - - - - - -\n\n");
	fclose(in);
	printf("End of file.\n");
	
	printf("Do you want to encode the program?[y/n]");
	st = getchar();
	st = getchar();
	if (st == 'n' || st != 'y')
	{
		return 0;	// Exit from the program.
	}
	printf("Do you want to make a output file for compilation?[y/n]");
	st = getchar();
	st = getchar();

	if (st == 'y')
	{
		out = fopen("outputfile.txt","w");
	}


	in = fopen(Dir,"r");
	while (fgets(read,100,in))
	{
		flag = 0;
		i = 0;
		while (read[i] != 0x3b)		// 0x3b = ";" (ASCII code)
		{
			i++;
		}
		read[i] = 0;			// 0x0 = NULL (ASCII code)
		i = 0;

		printf("%s",read);
		
		op[0] = '0';
		op[1] = 'x';

		// ---
		if (!mycmp(read,"AND"))
		{
			flag = 1;
			printf(" - 0x0xxx\n");
			op[2] = '0';

		}
		else if (!mycmp(read,"ADD"))
		{
			flag = 1;
			//printf(" - 0x1xxx\n");
			op[2] = '1';
		}
		else if(!mycmp(read,"LDA"))
		{
			flag = 1;
			//printf(" - 0x2xxx\n");
			op[2] = '2';
		}
		else if(!mycmp(read,"STA"))
		{
			flag = 1;
			//printf(" - 0x3xxx\n");
			op[2] = '3';
		}
		else if (!mycmp(read,"BUN"))
		{
			flag = 1;
			//printf(" - 0x4xxx\n");
			op[2] = '4';
		}
		else if(!mycmp(read,"BSA"))
		{
			flag = 1;
			//printf(" - 0x5xxx\n");
			op[2] = '5';
		}
		else if(!mycmp(read,"ISZ"))
		{
			flag = 1;
			//printf(" - 0x6xxx\n");
			op[2] = '6';
		}



		else if (!strcmp(read,"CLA"))	//CLA = 7800
		{
			printf(" - 0x7800\n");
			strcpy(str,"0x7800\n");
		}
		else if (!strcmp(read,"CLE"))	//CLE = 7400
		{
			printf(" - 0x7400\n");
			strcpy(str,"0x7400\n");
		}
		else if (!strcmp(read,"CMA"))	//CMA = 7200
		{
			printf(" - 0x7200\n");
			strcpy(str,"0x7200\n");
		}
		else if (!strcmp(read,"CME"))	//CME = 7100
		{
			printf(" - 0x7100\n");
			strcpy(str,"0x7100\n");
		}
		else if (!strcmp(read,"CIR"))	//CIR = 7080
		{
			printf(" - 0x7080\n");
			strcpy(str,"0x7080\n");
		}
		else if (!strcmp(read,"CIL"))	//CIL = 7040
		{
			printf(" - 0x7040\n");
			strcpy(str,"0x7040\n");
		}
		else if (!strcmp(read,"INC"))	//INC = 7020
		{
			printf(" - 0x7020\n");
			strcpy(str, "0x7020\n");
		}
		else if (!strcmp(read,"SPA"))	//SPA = 7010
		{
			printf(" - 0x7010\n");
			strcpy(str,"0x7010\n");
		}
		else if (!strcmp(read,"SNA"))	//SNA = 7008
		{
			printf(" - 0x7008\n");
			strcpy(str,"0x7008\n");
		}
		else if (!strcmp(read,"SZA"))	//SZA = 7004
		{
			printf(" - 0x7004\n");
			strcpy(str,"0x7004\n");
		}
		else if (!strcmp(read,"SZE"))	//SZE = 7002
		{
			printf(" - 0x7002\n");
			strcpy(str,"0x7002\n");
		}
		else if (!strcmp(read,"HLT"))	//HLT = 7001
		{
			printf(" - 0x7001\n");
			strcpy(str,"0x7001\n");
		}
		// ---
		if (st == 'y')
			fputs(str,out);

		if (flag == 1)
		{
			i = 0;
			while (read[i] != 'x')
			{
				i++;
			}
			i++;
			op[3] = read[i];
			op[4] = read[i+1];
			op[5] = read[i+2];
			op[6] = '\n';
			i = 0;
			
			printf(" - %s",op);
			if (st == 'y')
				fputs(op,out);
		}
	}
	if (st == 'y')
	{
		fclose(out);
	}

	fclose(in);
	return 0;
}

int mycmp(char x1[],char x2[])
{
	int i;
	for (i = 0; i < 3; i++)
	{
		if (x1[i] != x2[i])
		{
			return 1;	//Not Equal
		}
	}
	return 0;
}
