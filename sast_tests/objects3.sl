/* Test inline delaration and initialization of an object */

main(){

	object myObject = object(string myProp1, int myProp2, string myProp3);
	init{
        myObject.myProp1 = "dog";
        print(myObject.myprop1);
	}
	
}
