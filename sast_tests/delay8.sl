/* Should fail; can't put delays in functions */
func int foo(int a){	
	#2 a=5;
	return a;
}

main(){
	init{
		#2 int a = foo(4);
	}
}