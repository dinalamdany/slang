/* Tests that values are passed by value or reference */
/* TODO: print values and compare */

main(){
	init{
		int a = 5;
		foo(a);
		/* Assert a == 5 */

		int[] array = [1,2,3];
		foo2(array);
		/* Assert array = [3,2,1];
	}
}

func void foo(int value){
	value = value + 1;
}

func void foo2(int[] reference){
	reference = [3,2,1];	
}