/* Fails with delay inside for loop */
main(){
	int a=1;
	init{
		int i=0;
		for(i=0; i<10; i++){
			#2 a++;
		}
	}
}