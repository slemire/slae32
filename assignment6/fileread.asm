section .text

global _start

_start:

xor eax, eax
xor ebx, ebx
xor ecx, ecx
xor edx, edx
jmp two

one:

pop ebx
mov al, 0x5
xor ecx, ecx
int 0x80
mov esi, eax
jmp read

exit:

mov al, 0x1
xor ebx, ebx
int 0x80

read:

mov ebx, esi
mov al, 0x3
sub esp, 0x1
lea ecx, [esp]
mov dl, 0x1
int 0x80

xor ebx, ebx
cmp ebx, eax
je exit

mov al, 0x4
mov bl, 0x1
mov dl, 0x1
int 0x80

add esp, 0x1
jmp short read

two:

call one
db '/etc/passwd'
