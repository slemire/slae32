#include <stdio.h>

char shellcode[]=
	"SHELLCODE";

int main()
{
	int (*ret)() = (int(*)())shellcode;
	printf("Size: %d bytes.\n", sizeof(shellcode)); 
	ret();
}
