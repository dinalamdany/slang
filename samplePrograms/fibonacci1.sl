func int fib(int n){
	/* Base Case */
	if (n == 0){return 0;}
	if (n == 1){return 1;}

	/* Setup varaibles */
	int prevPrev = 0;
	int prev = 1;
	int result = 0;
	int i = 2;

	/* Calculate results */
	for (i = 2; i <= n; i++)
	{
		result  = prev + prevPrev;
		prevPrev = prev;
		prev = result;
	}

	return result;
}

main(){
	init{
		#1
		int fib = fib(7);
		print(fib);
	}
}
