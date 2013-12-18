main()
{
	int counter = 0;
	init{
			#13
			print("TERMINATE!");
			print(counter);
			Terminate;
	}

	always {
		#3
		print("--every 3");
	}

	/*
	always{
			#3 
			print("always1 at ");
			print(counter);
			}
	always{
			#4 
			print("always2 at ");
			print(counter);
	}*/
	always{
		#1
		counter++;
		print("currently time:");
		print(counter);
	}
}