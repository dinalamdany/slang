/* Test double declaration of a variable 
local scoping
*/

main(){
	int a = 100;
    init{
	    a = 5;
        a;
		int b;
		b = 200;
        b;
		int a = 10;
        a; /* variable already delcared, what should happen? */
	}
}
