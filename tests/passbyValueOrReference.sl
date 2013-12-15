/* Tests that values are passed by value or reference */

func void foo(int value){
	value = value + 1;
}

func void foo2(int reference[]){
	reference = [3,2,1];	
}
main(){
	init{
		int a = 5;
		foo(a);
        	print(a);
		int array[] = [1,2,3];
		foo2(array);
	    	print(array[0]);
		print(array[1]);
		print(array[2]);
    }
}


