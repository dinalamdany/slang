/* Test double declaration of a variable 
local scoping
*/

main(){
	int a = 100;
    print(a);
	a = 5;
    print(a);
	init{
		int b;
		b = 200;
        print(b);
		int a = 10;
        print(a); /* variable already delcared, what should happen? */
	}
}
