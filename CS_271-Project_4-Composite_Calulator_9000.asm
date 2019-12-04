; TITLE: Composite Calulator 9000			FILE: (Project4-931810401.asm)

; AUTHOR: Elizabeth Graalum				EMAIL: graalume@oregonstate.edu
; COURSE / PROJECT ID: CS271 / Project 4	DATE: October 28th, 2018

; Description: this programme will introduce itself and the programmer. Then it
; will ask the user for a positive integer between 1 and 400 and validate the
; user's input. It will then caluclate and display the composite numbers up to the
; inputted place. Finally it will display a goodbye message.

;	E.C.: Output columns are aligned

;=====================================================================================
INCLUDE Irvine32.inc
;=====================================================================================
; CONSTANTS
; Constants---------------------------------------------------------------------------

MAX EQU <400>	; max output limit

;=====================================================================================
.data
;-------------------------------------------------------------------------------------
; DATA
;-------------------------------------------------------------------------------------
; Intros------------------------------------------------------------------------------
intro_1		BYTE		"Hello! My name is Libby, and this is the Composite Number Calculator 9000! ",	0
intro_2		BYTE		"This programme will ask you to imput a positive integer between 1 and 400. ",	0
intro_3		BYTE		"It will then display all of the composite numbers up to the inputted place. ",	0

; Prompts-----------------------------------------------------------------------------
prompt_1		BYTE		"Please enter an integer between 1 and 400: ",	0

invalid		BYTE		"That's out of range, I told you the range -like- 10 times. Try again. ",	0

; Spacing Results---------------------------------------------------------------------
space_6		BYTE		"      ",		0
space_7		BYTE		"       ",	0
space_8		BYTE		"        ",	0

; Goodbyes----------------------------------------------------------------------------
goodbye_1		BYTE		"Trust my math, I'm a coder ;) ",	0
goodbye_2		BYTE		"Tah-tah for now! ",	0
goodbye_3		BYTE		"-Libby ",	0


; User Inputs------------------------------------------------------------------------

input		DWORD	?	; user input


; Variables---------------------------------------------------------------------------

number		DWORD	?	; number to be printed	
factor		DWORD	?	; factor used for calculations
count		DWORD	?	; loop counter
lineCount		DWORD	?	; loop counter for line breaks

;=====================================================================================
.code
;-------------------------------------------------------------------------------------
; MAIN
;-------------------------------------------------------------------------------------

main	PROC
	call	introduction

	call	getUserData

	call	showComposites

	call	farewell

	exit

main ENDP

;=====================================================================================
;-------------------------------------------------------------------------------------
; INTRODUCTION
;-------------------------------------------------------------------------------------
;Procedure to introduce the programme
;receives:		none
;returns:			none
;preconditions:	none
;registers changed: edx
;-------------------------------------------------------------------------------------

introduction	PROC

	; Introduce programme and programmer---------------------------------------------
	mov	edx,	OFFSET	intro_1
	call	WriteString
	call	CrLf

	; Explain programme--------------------------------------------------------------
	mov	edx,	OFFSET	intro_2
	call	WriteString
	call	CrLf

	mov	edx,	OFFSET	intro_3
	call	WriteString
	call	CrLf
	call	CrLf

	ret

introduction	ENDP

;=====================================================================================
;-------------------------------------------------------------------------------------
; GET USER DATA
;-------------------------------------------------------------------------------------
; Procedure to get user data for composite calculation
; receives:			none
; returns:			validated user input for global variable input
; preconditions:		none
; registers changed:	eax, ebx, edx
;-------------------------------------------------------------------------------------

getUserData	PROC
; Ask user for positive integer-------------------------------------------------------

mov	edx, OFFSET	prompt_1
call	WriteString

	;--------------------------------------------------------------------------------
	; Validate Input (is an int and greater than zero)
	;--------------------------------------------------------------------------------
	;Procedure to get user data for composite calculation
	; receives:			input is a global variable
	; returns:			validated user input for global variable input
	; preconditions:		MAX is CONSTANT det to 400
	; registers changed:	eax, ebx, edx
	;--------------------------------------------------------------------------------

	validate	PROC
	
		; Is it an integer?---------------------------------------------------------
		InputStepA:		

			call	ReadInt			; read user input
			call	IsDigit			; check Zero Flag (ZF)
			add	eax, 0			
			jz	ValidationError	; ZF = 0 - invalid (not int)
			jmp	InputStepB		; ZF = 1 - is int and goes on to next step

		; Is it between 1 and 400?--------------------------------------------------
		InputStepB:		

			mov	ebx, MAX 			; move MIN to ebx register
			cmp	eax, ebx			; compare to MIN CONSTANT (-100)
			jg	ValidationError	; input is too high
			cmp	eax,	0
			jle	ValidationError
			jmp	ValidInput		; input is valid

		; Input is invalid (not int or too low)-------------------------------------
		ValidationError:	

			mov	edx,	OFFSET	invalid	; tell user to input valid integer
			call	WriteString
			call	CrLf
			mov	edx,	OFFSET	prompt_1
			call	WriteString
			jmp	InputStepA			; Start Input Loop over
		
		; Input is valid------------------------------------------------------------
		ValidInput:		

			mov	input, eax		; move register value to number hold
		;---------------------------------------------------------------------------
		ret
	validate	ENDP
	;--------------------------------------------------------------------------------

	ret
getUserData	ENDP

;=====================================================================================
;-------------------------------------------------------------------------------------
; SHOW COMPOSITES
;-------------------------------------------------------------------------------------
; Procedure to validate and display composite numbers
; receives:			input is a global variable
; returns:			none
; preconditions:		input has been validated (0 < input <= 400)
; registers changed:	eax, ebx, ecx, edx
;-------------------------------------------------------------------------------------

showComposites	PROC
; Intialize variables-----------------------------------------------------------------

call CrLf				; line break

mov	ecx,	input		; set ECX register to validated input to track loop

mov	number,		3	; number to start loop (we know 1, 2, 3 are prime)
mov	factor,		1	; factor to start loop (can't divide by zero or 1)

	;----------------------------------------------------------------------
	;| NOTE:	both number and factor are to be incremented at the		|
	;|		very start of the caculation loop so the calculations 		|
	;|		to find composities will actually begin with				|
	;|		number = 4 and factor = 2							|
	;----------------------------------------------------------------------

mov	count,		0	; start overall counter at 0
mov	lineCount,	0	; start counter used for line breaks at 0
;-------------------------------------------------------------------------------------

; LOOP for composites verification----------------------------------------------------
CompositeLoop:
	call	isComposite		; procedure for verifying composite numbers
	inc	count			; increment loop counter
	inc	lineCount			; increment counter for line breaks
	call	printComposite		; procedure for printing composites
	
	loop CompositeLoop		; loop until ECX = 0

	;================================================================================
	;--------------------------------------------------------------------------------
	; IS COMPOSITE?
	;--------------------------------------------------------------------------------
	; Sub-Procedure to find composite numbers
	; receives:			input, number, and factor are global variables
	; returns:			validated composite
	; preconditions:		input has been validated
	; registers changed:	eax, ebx, edx
	;--------------------------------------------------------------------------------
	
	isComposite	PROC
	; Check is composite?------------------------------------------------------------
		IncrementNum:
			inc	number		; increment number being checked
			mov	factor,	1	; reset factor to 1
		IncrementFact:
			inc	factor		; increment factor

			mov	eax,	number	; move number value to EAX
			mov	ebx,	factor	; move factor value to EBX

			cmp	ebx,	eax		; compare factor to number
			jge	IncrementNum	; if factor greater than number move on 
							; to next number

			mov	edx,	0		; set EDX to 0
			div	ebx			; divide the number by the factor (EAX/EBX)
			cmp	edx, 0		; compare remainder in EDX to 0
			jne	IncrementFact	; if not equal jump to top to try next factor

			; if the remainder is equal to 0 that means the factor is an actual
			; factor f the number so the number is not prime, a.k.a. composite

		ret
	isComposite	ENDP

	;================================================================================ 
	;--------------------------------------------------------------------------------
	; PRINT COMPOSITE
	;--------------------------------------------------------------------------------
	; Sub-Procedure to print composite numbers
	; receives:			input, number, and factor are global variables
	; returns:			validated composite
	; preconditions:		input has been validated
	; registers changed:	eax, ebx, edx
	;--------------------------------------------------------------------------------
	;| NOTE:	In this section the extra cedit requirements for aligning all of the	|
	;|		outputted columns.											|
	;--------------------------------------------------------------------------------
	
	printComposite	PROC
	; Print composite value----------------------------------------------------------
		mov	eax, number
		call	WriteDec

	; Make new line?-----------------------------------------------------------------
		cmp	lineCount, 10
		je	newLine
		jmp	numSpace

	; Adjust spacing based on value position in line-up------------------------------
		numSpace:
		cmp	number,	9	; if composite < 9
		jle	giantSpace	; use giantSpace (space of 8)
		
		cmp	number,	99	; if composite < 99
		jle	bigSpace		; use bigSpace (space of 7)
		
		jmp	regSpace		; if composite => 99 use regSpace (space of 6)
						
	; Spacing Sizes------------------------------------------------------------------
		giantSpace:
		mov	edx,	OFFSET	space_8
		call	WriteString
		jmp spacingEnd

		bigSpace:
		mov	edx,	OFFSET	space_7
		call	WriteString
		jmp spacingEnd

		regSpace:
		mov	edx,	OFFSET	space_6
		call	WriteString
		jmp spacingEnd

	; Continue on new line-----------------------------------------------------------	
		newLine:
		call CrLf
		mov	lineCount,	0

	; End of spacing-----------------------------------------------------------------
		spacingEnd:

		ret
	printComposite	ENDP
	;================================================================================


	ret
showComposites	ENDP

;=====================================================================================
;-------------------------------------------------------------------------------------
; FAREWELL
;-------------------------------------------------------------------------------------
; Procedure to print departing message
; receives:			none
; returns:			none
; preconditions:		none
; registers changed:	edx
;-------------------------------------------------------------------------------------

farewell	PROC
; Goodbye Message---------------------------------------------------------------------
	call	CrLf
	call	CrLf

	mov	edx,	OFFSET	goodbye_1
	call	WriteString
	call	CrLf
	mov	edx,	OFFSET	goodbye_2
	call	WriteString
	call	CrLf
	call CrLF
	mov	edx,	OFFSET	goodbye_3
	call	WriteString
	call CrLf

	ret

farewell	ENDP

;=====================================================================================

END main
