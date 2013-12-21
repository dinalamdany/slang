main()
{
	/* Clock */
	bool clk = false;
	/* Clock up */
	bool clk_up = false;
	bool prev_clk = false;

	/* J/K Flip Flop Variables */
	bool j = false;
	bool k = false;
	bool q = true;

	/* Clock */
	always{
		#2
		clk = !clk; 
	}
	/* Section for generating clock up events */
	always{
		#1
		if (clk & !prev_clk)
			{clk_up = true;}
		else
			{clk_up = false;}

		prev_clk = clk;
	}
	/* J/K Flip Flop logic */
	always{
		#1
		abs_time++;
		if(clk){
			if(j & k){q = !q;}
			else{
				if(j){q = true;}
				if(k){q = false;}
			}
		}
	}
	/* Printing */
	always{
		#1 		
		print("AbsTime");
		print(print_time());
		print("Clock: Clk_up");
		print(clk);
		print(clk_up);
		print("J,K");
		print(j);
		print(k);
		print("Q:");
		print(q);
	}
	/* Changes in input */
	init{
		#7 k = true;
		#7 j = true;
		#7 k = false;
		#7 j = false;
		#7 j = true; k = true;
		#7 Terminate;
	}
}
