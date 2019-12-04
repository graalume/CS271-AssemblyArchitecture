; TITLE "Elementary, My Dear Function"    (project1.asm)

; Author: Elizabeth Graalum	Email: (graalume@oregonstate.edu)
; Course / Project ID: CS271-400 / project #1      Date: Sept. 30, 2018
; Description: this project will prompt the user to input two
; numbers and then it will display the sum, differencem product, 
; and quotient (with the remainder) of the numbers.

INCLUDE Irvine32.inc

.data

intro_1	BYTE	"Hello! My name is Libby, and this is Elementary, My Dear Function ", 0
intro_2	BYTE	"This is a program that will ask you, the user, for two positive numbers. It will then display the sum , difference, product, and quotient (with the remainder) of those two numbers in the order you gave them. ", 0

prompt_1	BYTE "What is the first number you'd like to enter? ", 0
prompt_2	BYTE "And what would you like the second number to be? ", 0

numberA	DWORD	?	; integer to be entered by user
numberB	DWORD	?	; integer to be entered by user

sum	DWORD	?	; sum of two inputs
diff	DWORD	?	; difference of inputs
pro	DWORD	?	; product of inputs
quot	DWORD	?	; quotient of inputs
remainder	DWORD	?	; remainder from quotient

result_1	BYTE	"Here are your results: ", 0
plus	BYTE	" + ", 0
minus	BYTE " - ", 0
multi	BYTE	" * ", 0
divide	BYTE	" ", 246, ' ', 0
equal	BYTE	" = ", 0
remainderString	BYTE	" R ", 0

goodBye	BYTE	"Tah-Tah for now! ", 0

.code
main PROC

; Introduce Programme and Programmer
	mov	edx, OFFSET	intro_1
	call WriteString
	call	CrLf

; Explain instrucitons to user
	mov	edx, OFFSET	intro_2
	call	WriteString
	call	CrLf

; Get Number A
	mov	edx,	OFFSET	prompt_1
	call	WriteString
	call ReadInt
	mov	numberA, eax
	call	CrLf

; Get Number B
	mov	edx,	OFFSET	prompt_2
	call	WriteString
	call ReadInt
	mov	numberB, eax
	call	CrLf

; Calculate sum, difference, product, and quotient
	; Calculate Sum
	mov	eax, numberA
	add	eax, numberB
	mov	sum, eax

	; Calculate Difference
	mov	eax, numberA
	sub	eax, numberB
	mov	diff, eax

	; Calculate Product
	mov	eax, numberA
	mov	ebx, numberB
	mul	ebx
	mov	pro, eax

	; Calculate Quotient
	mov	eax, numberA
	mov	ebx, numberB
	mov	edx, 0
	div	ebx
	mov	quot, eax
	mov	remainder, edx

; Display results
	mov	edx, OFFSET	result_1
	call	WriteString	; display "here are your results"
	call	CrLf

	; Display sum
	mov	eax, numberA
	call	WriteDec		; display first number

	mov edx, OFFSET	plus
	call WriteString	; display "+"

	mov	eax, numberB
	call	WriteDec		; display second number

	mov	edx, OFFSET	equal
	call	WriteString	; display "="

	mov	eax, sum
	call WriteDec		; display sum
	call CrLf

	; Display difference
	mov	eax, numberA
	call	WriteDec		; display first number

	mov edx, OFFSET	minus
	call WriteString	; display "-"

	mov	eax, numberB
	call	WriteDec		; display second number

	mov	edx, OFFSET	equal
	call	WriteString	; display "="

	mov	eax, diff
	call WriteDec		; display difference
	call CrLf

	; Display product
	mov	eax, numberA
	call	WriteDec		; display first number

	mov edx, OFFSET	multi
	call WriteString	; display "*"

	mov	eax, numberB
	call	WriteDec		; display second number

	mov	edx, OFFSET	equal
	call	WriteString	; display "="

	mov	eax, pro
	call WriteDec		; display product
	call CrLf

	; Display quotient
	mov	eax, numberA
	call	WriteDec		; display first number

	mov edx, OFFSET	divide
	call WriteString	; display quotient symbol

	mov	eax, numberB
	call	WriteDec		; display second number

	mov	edx, OFFSET	equal
	call	WriteString	; display "="

	mov	eax, quot
	call WriteDec		; display quotient
	
	mov	edx,	OFFSET	remainderString
	call	WriteString	; display remainder sign ("R")
	
	mov	eax, remainder
	call	WriteDec		; display remainder number
	call CrLf


; Say "goodbye"
	mov	edx, OFFSET	goodBye
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

END main
