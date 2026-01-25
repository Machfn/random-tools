
; This program opens a specified file and writes the given string to the end of file with a new line ; written for 32 bit linux (tested on: Fedora 43 WSL)
; usage:
;	writeTo $fileName $string
;	writeTo example.txt "hello world"


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
	tM db "Test"
	lenT equ $-tM
	succMsg db "Succesfully wrote to file"
	lenSucc equ $-succMsg
	errMsg db "Not enough arguments given", 0xA
	lenErr equ $-errMsg
	fileErr db "Error: File not found"
	lenFErr equ $-fileErr
	nL db 0xA
	lenN equ $-nL
	writeErr db "Error Writing To File"
	lenW equ $-writeErr

section .bss
	fdOut resb 32
	fileName resb 32
	fLen resb 32


section .text
	global _start


_start:
	cmp dword [esp], 3
	jl exit_err

	mov ecx, [esp + 8]
	push ecx
	mov edx, -1


getlen:
	; increase till we see null terminator
	inc edx
	cmp byte [ecx + edx], 0
	jne getlen
	pop ecx
	
	;mov eax, 4
	;mov ebx, 1
	; len already in edx, arg in ecx
	;int 0x80
	mov [fileName], ecx
	mov [fLen], edx
	
	; push both length and arg back onto stack
	;push edx
	;push ecx
	
	
	;pop ecx
	mov ecx, [esp + 12]
	push ecx
	mov edx, -1


openFile:
	; need to get len of string
	inc edx
	cmp byte [ecx + edx], 0
	jne openFile
	push edx ; now should have edx above ecx on stack
	
	; open file with only write permissions
	mov eax, 5
	mov ebx, [fileName]
	mov ecx, 1024|1
	int 0x80
	; check for errors
	cmp eax, 0
	jl exit_file_not_found

	; opening file puts descriptor in eax register, need to store to write later
	mov [fdOut], eax
	; set file to end of file input
	mov eax, 19
	mov ebx, [fdOut]
	mov ecx, 32
	mov edx, 2
	int 0x80

	pop edx
	pop ecx

	; write to file
	mov ebx, [fdOut]
	mov eax, 4
	int 0x80

	; write new line to file
	mov eax, 4
	mov ebx, [fdOut]
	mov ecx, nL
	mov edx, lenN
	int 0x80
	
	; check for errors
	cmp eax, 0
	jl exit_writing_file_err


	; close file
	mov eax, 6
	mov ebx, [fdOut]
	int 0x80

	writeString succMsg, lenSucc

	jmp exit_clean



exit_clean: ; exit with status code 0
	mov eax, 1
	mov ebx, 0
	int 0x80

exit_writing_file_err:
	writeString writeErr, lenW

	mov eax, 1
	mov ebx, 1
	int 0x80


exit_file_not_found:
	writeString fileErr, lenFErr

	mov eax, 1
	mov ebx, 1
	int 0x80

exit_err: ; tell the user not enough inputs and exit
	; display err message
	mov eax, 4
	mov ebx, 1
	mov ecx, errMsg
	mov edx, lenErr
	int 0x80
	
	; exit with status 1
	mov eax, 1
	mov ebx, 1
	int 0x80

