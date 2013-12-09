/* Test calling a function outside of timeblocks, SHOULD FAIL */

func void foo(){
	/* dosomething */
}

main(){

	/* try function calling */
	foo();

	init{

	}
}

