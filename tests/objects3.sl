/* Test inline delaration and initialization of an object */

main(){

	object myObject = object(string myProp1, int myProp2, string myProp3);
    myObject.myProp1 = "dog";
	init{
        print(myObject.myprop1);
	}
	
}
