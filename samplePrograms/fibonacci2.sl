main(){
	/* Setup variables */
	int prevPrev = 0;
	int prev = 1;
	int result = 0;
	
	init
	{
		#7 print(result); /* print result of fib */
		Terminate;
	}
	/* Loop to calculate numbers */
	always
	{
		#1
		result  = prev + prevPrev;
		prevPrev = prev;
		prev = result;
	}
}