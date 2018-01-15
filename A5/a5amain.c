/*
Stefan Jovanovic
Assignment 5 part a
CPSC 355
*/

#include <stdio.h>
char ch;

int main(){
	find();
	do{
		expression();
		putchar('\n');
	}while (ch != '.');

	return 0;
}


