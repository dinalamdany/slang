func int[] popLine(int line[])
{
	int newLine []=[0,0,0,0,0,0,0,0,0,0];
	int place=1;
	for(place=1;place<10;place++)
	{
		int newPlace=place-1;
		newLine[newPlace]=line[place];
	}
	return newLine;
}

func int[] pushLine(int line[],int newEntry)
{
	int newLine []=[0,0,0,0,0,0,0,0,0,0];
	int place=0;
	for(place=0;place<10;place++)
	{
		newLine[place]=line[place];
	}
    bool end=false;
    place=0;
    while((place<10)&(end==false))
    {
        if(line[place]==0)
            {end=true;}
        else {place=place+1;}
    }
    if(end==false)
        {print("No room at end of line");}
    if(end==true)
        {newLine[place]=newEntry;}
	return newLine;
}

func int lineSize(int ourArray[], int arraySize)
{
	int place=0;
    int count=0;
	while(place<arraySize)
	{
		if(ourArray[place]!=0)
			{count=count+1;}
        place=place+1;
	}
    
	return count;	
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
        print("People still in line:");
		print(lineSize);
        print("People seen:");
		print(seenSize);
        print("People bored in line:");
		print(boredSize); 
        
        #1 Terminate; 
	}
	always
	{
		#2
        line=pushLine(line,people[0]);
        people=popLine(people);
		
	}
	always
	{
		#3
        seen=pushLine(seen,line[0]);
        line=popLine(line);
		
	}
	always
	{
		#4
		bored=pushLine(bored,line[0]);
        line=popLine(line);
	}
}
