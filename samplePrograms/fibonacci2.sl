main(){
	/* Setup variables */
	int prevPrev = 0;
	int prev = 1;
	int result = 0;
	
	init
	{
		#0 print(0);print(1); /* Print initial values */
		#10 Terminate; /* Calculate fib(10 + 2) (10 + initial values) */
	}
	/* Loop to calculate numbers */
	always
	{
		#1
		result  = prev + prevPrev;
		prevPrev = prev;
		prev = result;

		print(result);
	}
}