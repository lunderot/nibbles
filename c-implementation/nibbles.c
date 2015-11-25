#include "helpers.h"

typedef struct
{
	int x, y;
} Node;



void start_game(int len, int n_apples)
{
	nib_init();
	
	/*Constants*/
	const int screenSizeX = 50;
	const int screenSizeY = 50;
	const int maxLen = 50;
	const int maxApples = 100;
	
	int currentLength = len;
	int direction = 0;
	
	Node body[maxLen];
	Node apples[maxApples];
	
	/*Init snake body*/
	int i;
	for (i = 0; i < len; i++)
	{
		body[i].x = screenSizeX/2 - i;
		body[i].y = screenSizeY/2;
	}
	
	/*Init apples*/
	for (i = 0; i < n_apples; i++)
	{
		apples[i].x = rand() % screenSizeX;
		apples[i].y = rand() % screenSizeY;
	}
	
	
	
	
	
	while(1)
	{
		/*Get input*/
		int input = nib_poll_kbd();
		if (input != -1)
		{
			if (input == 261)
			{
				direction = 0;
			}
			else if (input == 259)
			{
				direction = 1;
			}
			else if (input == 260)
			{
				direction = 2;
			}
			else if (input == 258)
			{
				direction = 3;
			}
		}
		
		/*Update*/
		Node pos = body[0];
		if (direction == 0)
		{
			body[0].x++;
		}
		else if (direction == 1)
		{
			body[0].y--;
		}
		else if (direction == 2)
		{
			body[0].x--;
		}
		else if (direction == 3)
		{
			body[0].y++;
		}
		
		
		for (i = 1; i < currentLength; i++)
		{
			//xor swapping
			Node temp;
			temp = body[i];
			body[i] = pos;
			pos = temp;
		}
		
		
		/*Collision detection*/
		
		
		
		/*Draw snake*/
		for (i = 0; i < currentLength; i++)
		{
			nib_put_scr(body[i].x, body[i].y, 'o');
		}
		
		/*Draw apples*/
		for (i = 0; i < maxApples; i++)
		{
			nib_put_scr(apples[i].x, apples[i].y, '*');
		}
		
		/*Sleep*/
		usleep(500000/2);
		/*TODO: Get input while sleeping*/
		clear();
	}
	
	nib_end();
}

