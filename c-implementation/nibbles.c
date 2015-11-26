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
	int hit = 0;
	int done = 0;
	int input = -1;
	
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
	
	while(!done)
	{
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
		
		/*Collision detection with apples*/
		hit = 0;
		for (i = 0; i < maxApples; i++)
		{
			if (apples[i].x == body[0].x &&
				apples[i].y == body[0].y )
			{
				hit = 1;
				apples[i].x = rand() % screenSizeX;
				apples[i].y = rand() % screenSizeY;
				break;
			}
		}
		if (hit)
		{
			body[currentLength] = body[currentLength-1];
		}
		for (i = 1; i < currentLength; i++)
		{
			//xor swapping
			Node temp;
			temp = body[i];
			body[i] = pos;
			pos = temp;
		}
		if (hit)
		{
			currentLength++;
		}
		
		/*Collision detection with self*/
		for (i = 1; i < currentLength; i++)
		{
			if (body[i].x == body[0].x &&
				body[i].y == body[0].y )
			{
				done = 1;
				break;
			}
		}
		/*Collision detection with walls*/
		for (i = 0; i < screenSizeX; i++)
		{
			if (body[0].x == i &&
				(body[0].y == 0 || body[0].y == screenSizeY)
				)
			{
				done = 1;
				break;
			}
		}
		for (i = 0; i < screenSizeY; i++)
		{
			if (body[0].y == i &&
				(body[0].x == 0 || body[0].x == screenSizeX)
				)
			{
				done = 1;
				break;
			}
		}
		
		/*Draw snake*/
		for (i = 0; i < currentLength; i++)
		{
			nib_put_scr(body[i].x, body[i].y, 'O');
		}
		
		/*Draw apples*/
		for (i = 0; i < maxApples; i++)
		{
			nib_put_scr(apples[i].x, apples[i].y, '*');
		}
		/*Draw game borders*/
		for (i = 0; i < screenSizeX; i++)
		{
			nib_put_scr(i, 0, '-');
			nib_put_scr(i, screenSizeY, '-');
		}
		for (i = 0; i < screenSizeY; i++)
		{
			nib_put_scr(0, i, '|');
			nib_put_scr(screenSizeX, i, '|');
		}
		
		/*TODO: Get input while sleeping*/
		for (i = 0; i < 10; i++)
		{
			/*Get input*/
			input = nib_poll_kbd();
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
				break;
			}
			/*Sleep*/
			usleep(100000/10);
		}
		
		usleep(100000/10*(10-i));
		
		clear();
	}
	
	nib_end();
}
