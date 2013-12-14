/* Should pass; multiple idential init blocks */

main(){
	init{
		int a =0;
		#2 a = 4;
		int b=4;
		#2 int c=3;
	}

	init{
		int a =0;
		#2 a = 4;
		int b=4;
		#3 int c=3;
	}

}