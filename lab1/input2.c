#include<iostream>

int main()
{

	int a, b;
	a=1;
	b=2;
	float c= a*b;
	if(a<b)
		c += a;
	else
		c += b;
	printf("%d, %d, %f", a, b, c); 
}
		
