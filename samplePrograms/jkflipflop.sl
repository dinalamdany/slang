main()
{
	/* Reference to global time*/
	int abs_time = 0;
	/* Clock */
	bool clk = false;
	/* J/K Flip Flop Variables */
	bool j = false;
	bool k = false;
	bool q = true;

	/* Clock */
	always{
		#1
		clk = !clk;
		abs_time++;
	}
	/* J/K Flip Flop logic */
	always{
		#1
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
		print("AbsTime, Clock:");
		print(abs_time);
		print(clk);
		print("J,K");
		print(j);
		print(k);
		print("Q:");
		print(q);
	}
	/* Changes in input */
	init{
		#5 k = true;
		#10 j = true;
		#15 k = false;
		#20 j = false;
		#25 j = true; k = true;
		#30 Terminate;
	}
}