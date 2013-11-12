/* Test for if/ifelse */
/* TODO: must print values and check expected results */

main{
	init{
		
		/* Test if/else */
		if(true){
            print("yes");
		}
		else{
			/* Dosomething */
		}
		/* Standalone if */

		if(4<5){/* Dosomething */
            print(3);
		/* Nested if/else */
		    if(1<1){
                print(1);
		    }
		    else{
			    if (false){}
			    else{}
		    }
        }
	}
}
