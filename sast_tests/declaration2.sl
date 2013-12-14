/* Test double declaration of a variable 
local scoping
*/

main(){
	int a = 100;
    init{
	    a;
        a = 6;
        int b = 10;
        b = 10;
        int a = 10;
	}
}
