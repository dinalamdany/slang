/* Tests comparison of objects */

main(){

	object myObject = object(string myProp1);
    object myDog = object(string myProp1);
   
    init{
        print(myObject == myDog);
        print(myDog == myDog);
	}
}
