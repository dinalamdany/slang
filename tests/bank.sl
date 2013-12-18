func int lineSize(int ourArray[], int arraySize)
{
	int place=0;
	while(place<arraySize)
	{
		if(ourArray[place]!=0)
			{place=place+1;}
	}
	return place;	
}

main()
{
	int person1=1;
	int person2=2;
	int person3=3;
	int person4=4;
	int person5=5;
	int person6=6;
	int person7=7;
	int person8=8;
	int person9=9;
	int person10=10;
	int people[]=[person1, person2, person3, person4, person5,person6,person7,person8,person9,person10];
	int peopleSize=10;
	int peopleindex=0;
	int lineindex=0;
	int seenindex=0;
	int boredindex=0;

	int line[]=[0,0,0,0,0,0,0,0,0,0,0];
	
	int seen[]=[0,0,0,0,0,0,0,0,0,0,0];
	
	int bored[]=[0,0,0,0,0,0,0,0,0,0];
	init
	{
		#99  
		int lineSize=lineSize(line,peopleSize);
		int seenSize=lineSize(seen,peopleSize);
		int boredSize=lineSize(bored,peopleSize);
		print(lineSize);
		print(seenSize);
		print(boredSize);
		#1 Terminate; 
	}
	always
	{
		#2
		if((lineindex<peopleSize)&(peopleindex<peopleSize))
		{ line[lineindex]=people[peopleindex]; peopleindex=peopleindex+1; lineindex=lineindex+1;}
	}
	always
	{
		#3
		if((seenindex<peopleSize)&(lineindex<peopleSize)&(lineindex!=0)&(line[lineindex]!=0))
			{seen[seenindex]=line[lineindex]; lineindex=lineindex+1; seenindex=seenindex+1;}
	}
	always
	{
		#4
		if((boredindex<peopleSize)&(lineindex<peopleSize)&(lineindex!=0)&(line[lineindex]!=0))
			{line[lineindex]=bored[boredindex];lineindex=lineindex+1; boredindex=boredindex+1;}
	}
}
