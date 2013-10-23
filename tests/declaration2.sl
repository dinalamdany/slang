/* Test double declaration of a variable 
   -- Should fail
*/

main(){
	int a = 100;
	a = 5;
	init{
		int b;
		b = 200;
		int a; /* variable already delcared, what should happen? */
	}
	int a; /* again here */
}