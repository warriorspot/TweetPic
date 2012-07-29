
#include <stdio.h>
#include <stdlib.h>

static char lookup_table[] = {'0','1','2','3','4','5','6','7','8','9'};

char * my_itoa(int input)
{
	char *result = NULL;
	int index = 0;

    // Calculate needed storage size first
	int temp = input;
	int size = 0;
	while(temp != 0)
	{
		size++;
		temp = temp / 10;
	}

	result = (char *) malloc(size * sizeof(char) + 1);	
	result[size] = '\0';

	while(input != 0)
	{
		int remainder = input % 10;

		result[size - 1] = lookup_table[remainder];

		input = input / 10;

		index++;
		size--;
	}

	return result;
}
