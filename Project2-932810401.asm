
TITLE: Fibonacci Sequence				FILE: (Project2-931810401.asm)

; AUTHOR: Elizabeth Graalum				EMAIL: graalume@oregonstate.edu
; COURSE / PROJECT ID: CS271 / Project 2	DATE: October 07th, 2018

; Description: this programme asks the users their name, greets the user,
;	introduces the programme, and then prompts the users for a whole number between 1-46.
;	The programme then displays the Fibonacci sequence up to the number inputted by the user.
;	The numbers are also displayed in rainbow colours as a cool trick for extra-credit

INCLUDE Irvine32.inc

.data
;---------------------------------------------------------------------------
; DATA
; Intros--------------------------------------------------------------------
;
intro_1		BYTE		"Hello! My name is Libby, and this is PROGRAMME ", 0
intro_2		BYTE		"It's nice to meet you ", 0	; greet user
intro_3		BYTE		".", 0
intro_4		BYTE		"This is a programme that will ask you, ", 0
intro_5		BYTE		", for a positive whole number between 1 and 46. ", 0
intro_6		BYTE		"It will then display the Fibonacci sequence with as many cycles as the number you entered. ", 0
intro_7		BYTE		"As Extra-Credit, the values will also be displayed in multiple colours!", 0

; Prompts-------------------------------------------------------------------

prompt_1		BYTE		"Before we continue, I'd like to know your name as well. What's your name? ", 0	; ask user's name
prompt_2		BYTE		"How many times would you like the Fibonacci sequence to run? ", 0

validation	BYTE		"Please input a valid integer. ", 0

space		BYTE		"     ", 0

; User Inputs---------------------------------------------------------------
userName		BYTE		33 DUP(0)

cycleNumber	DWORD	?	; number inputted by user
lastNumber	DWORD	?	; previous number
currentNumber	DWORD	?	; current number
newNumber		DWORD	?	; new number

; Counter Values------------------------------------------------------------
counter		DWORD	?
colourcounter	DWORD	?

; Results-------------------------------------------------------------------
result_1		BYTE		"Here's the Fibonacci Sequence for ", 0
result_2		BYTE		" rounds: ", 0

; Goodbyes------------------------------------------------------------------
goodbye_1		BYTE		"Tah-Tah for now, ", 0
goodbye_2		BYTE		"! ", 0

;---------------------------------------------------------------------------

.code
main PROC
;---------------------------------------------------------------------------
; MAIN
;---------------------------------------------------------------------------
; Introduction
;---------------------------------------------------------------------------

; Introduce programme and programmer----------------------------------------
mov	edx, OFFSET	intro_1
call	WriteString
call CrLf

; Prompt user for user name-------------------------------------------------
mov	edx, OFFSET	prompt_1
call WriteString
call CrLf

mov	edx, OFFSET	userName
mov	ecx, 32
call ReadString

; Greet user----------------------------------------------------------------

mov	edx, OFFSET	intro_2		
call WriteString

mov	edx, OFFSET	userName
call WriteString

mov	edx, OFFSET	intro_3
call WriteString
call CrLf

; Explain Programme---------------------------------------------------------

mov	edx, OFFSET	intro_4
call WriteString

mov	edx, OFFSET	userName
call WriteString

mov	edx, OFFSET	intro_5
call WriteString
call CrLf

mov	edx, OFFSET	intro_6
call	WriteString
call	CrLf

mov	edx, OFFSET	intro_7
call	WriteString
call	CrLf

;---------------------------------------------------------------------------
; Prompt user to input number for number of Fibonnaci cycles
;---------------------------------------------------------------------------

mov	edx, OFFSET	prompt_2
call WriteString
call CrLf

;---------------------------------------------------------------------------
; Validate Input (is an int and greater than zero)
;---------------------------------------------------------------------------

InputStepA:		
	; is it an integer?
	call	ReadInt
	call	IsDigit			; check Zero Flag (ZF)
	jz	ValidationError	; ZF = 0 - is int and goes on to next step
	jmp	InputStepB		; ZF = 1 - invalid (not int)

InputStepB:	
	; greater than zero?
	cmp	eax, 1			; compare input to 1
	jl	ValidationError	; invalid (is less than 1)
	jmp	InputStepC		; is greater than/equal to 1
	
InputStepC:	
	; less than/equal to 46?
	cmp	eax, 46			; compare input to 46
	jg	ValidationError	; invalid (greater than 46)
	jmp	ValidInput		; is less than/equal to 46

ValidationError:
	; invalid input
	mov	edx, OFFSET	validation
	call	WriteString		; tell user it's invalid - ask for new input
	call CrLf
	jmp	InputStepA		; restart validation at StepA

ValidInput:
	; valid input
	mov	cycleNumber, eax	; make cycle number input value
	call	CrLf

;---------------------------------------------------------------------------
; Calculate Fibonnaci sequence
;---------------------------------------------------------------------------

mov edx, OFFSET	result_1	; introduce Fibonacci Sequence
call WriteString

mov eax, cycleNumber		; sequence rounds
call WriteDec

mov edx, OFFSET	result_2
call WriteString
call CrLf

; Initalize Variables-------------------------------------------------------

mov	counter, 0		; counter set to 0 - to be incremented
mov	colourcounter, 5	; colour counter set to 5 - to be decremented
mov	lastNumber, 0		; last number set to 0
mov	currentNumber, 1	; current number set to 1
mov	newNumber, 1		; new number set to 1

; Fibonacci Post-test Loop--------------------------------------------------

FibLoop:
	; change text colour---------------------------------------------------
	; EC: display the outputs in multiple colours

	mov	eax,	colourcounter	; colour change based on counter
	call	settextcolor		
	dec	colourcounter		; decrement counter

	; Display new number---------------------------------------------------

	mov	eax, newNumber
	call WriteDec

	; Space with length of 5-----------------------------------------------
	mov	edx, OFFSET	space
	call WriteString
	
	; Calculate next number------------------------------------------------
	mov	eax, currentNumber
	add	eax, lastNumber	; add last number to current (in eax)
	mov	newNumber, eax		; set sum (in eax) to newNumber value

	; Make current number now last number----------------------------------
	mov	eax,	currentNumber
	mov	lastNumber, eax

	; Make new number now current number-----------------------------------
	mov	eax, newNumber
	mov	currentNumber, eax

	; Increment and check counter------------------------------------------
	inc	counter			; increment
	cmp	counter, 5		; compare to 5
	je	NewLine			; if equal go to NewLine Loop
	jmp	ContinueLoop		; otherwise go to ContinueLoop Loop

NewLine:
	call CrLf				; make new line
	mov	counter, 0		; reset counter to 0
	mov	colourcounter, 5	; reset colourcounter to 5
	jmp	ContinueLoop		; go to ContinueLoop Loop

ContinueLoop:
	dec	cycleNumber		; decrement cycle number
	cmp	cycleNumber, 0		; compare cycle number to 0
	jg	FibLoop			; if greater than 0 start FibLoop again
	jmp	EndLoop			; otherwise exit loop

;---------------------------------------------------------------------------
EndLoop:
;---------------------------------------------------------------------------
; Say "goodbye" to user-----------------------------------------------------

mov	eax, white + (black * 16)	; reset colour scheme
call	settextcolor

call	CrLf
call CrLf

mov	edx, OFFSET	goodbye_1		; goodbye message 1
call	WriteString

mov	edx, OFFSET	userName
call WriteString

mov	edx, OFFSET	goodbye_2		; goodbye message 2
call	WriteString

;---------------------------------------------------------------------------
	exit	; exit to operating system
main ENDP
;-----------------------------------------------------------------------------

END main
