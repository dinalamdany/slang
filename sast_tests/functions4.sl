/* Test function delcaration and scope */
func int foo(){
    int x = 5;
    return x;
}

main(){
	init{
        int x = foo();
	}
}

