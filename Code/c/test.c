void DegenInit() __attribute__((section(".core_init")));
int main();

void DegenInit()
{
	//Do init crap
	main();
}

int main()
{

	int x = 2;
	int y = 3;

	int* asdf = (int*)1024;

	*asdf = x+y;
}
