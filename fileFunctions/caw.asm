; createAndWrite takes in two arguements and creates file of arg1 with arg2 written to
; compatibility is not absolute, written in x86 Assembly for 32 bit linux (tested on: Fedora 43 WSL)
; usage:
; prototype:	caw $fileName $string
; example: 	caw temp.txt "Hello World!"
; Written by Ben W (Benon)


	%macro writeString 2
		mov eax, 4
		mov ebx, 1
		mov ecx, %1
		mov edx, %2
		int 0x80

		mov eax, 4
		mov ebx, 1
		mov ecx, nL
		mov edx, lenN
		int 0x80
	%endmacro

section .data
	nL db 0xA
	lenN equ $-nL
	open_error db "Error opening file!"
	lenOE equ $-open_error
	write_error db "Error writing to file!"
	lenWE equ $-write_error
	arg_error db "Error, not enough arguements!"
	lenAE equ $-arg_error

section .bss
	fdOut resb 2
	fileName resb 32
	fLen resb 8
	strIn resb 128
	sLen resb 32

section .text
	global _start


_start:
	cmp dword [esp], 3
	jl arg_err

	mov ecx, [esp + 8]
	push ecx
	mov edx, -1

get_len_filename:
	inc edx
	cmp byte [ecx + edx], 0
	jne get_len_filename ; repeat until we get length of fileName

	pop ecx
	
	mov [fileName], ecx
	mov [fLen], edx

	mov ecx, [esp + 12]
	push ecx
	mov edx, -1

get_len_str:
	inc edx
	cmp byte [ecx, edx], 0
	jne get_len_str ; repeat until we get length of input string

	pop ecx
	
	mov [strIn], ecx
	mov [sLen], edx


open_create_file:
	; open file with correct permissions
	mov eax, 8
	mov ebx, [fileName]
	mov ecx, 0777
	int 0x80

	cmp eax, 0 ; error checking
	jl opening_error
	
	mov [fdOut], eax ; save file descriptor

	; write to file
	mov eax, 4
	mov ebx, [fdOut]
	mov ecx, [strIn]
	mov edx, [sLen]
	int 0x80

	cmp eax, 0 ; error checking
	jl writing_error

	;close file
	mov eax, 6
	mov ebx, [fdOut]
	int 0x80

	jmp exit_clean 

arg_err:
	writeString arg_error, lenAE

	; exit with error
	mov eax, 1
	mov ebx, 1
	int 0x80

opening_error:
	writeString open_error, lenOE

	; exit with error
	mov eax, 1
	mov ebx, 1
	int 0x80

writing_error:
	writeString write_error, lenWE

	; exit with error
mov eax, 1
	mov ebx, 1
	int 0x80


exit_clean:
	mov eax, 1
	mov ebx, 0
	int 0x80
