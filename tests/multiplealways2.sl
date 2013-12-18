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

	always{
		#1
		counter++;
		print("currently time:");
		print(counter);
	}
}