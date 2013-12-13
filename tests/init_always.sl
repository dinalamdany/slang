main() {
	int a = 7;
	init{
		#5 a = 2;
		#1 int b = 7;
	}
	init{
		#4 int c = 4;
	}
	always{
		#3 a = 1;
	}
}