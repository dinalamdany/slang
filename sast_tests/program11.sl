/*should not be accepted*/
func void test(int a){
  always{}
}

func void test2(int b){
  init{}
}

main() {
  init {}
  always{}
}
