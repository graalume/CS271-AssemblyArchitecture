
; TITLE: Negative Input Calculator			FILE: (Project3-931810401.asm)

; AUTHOR: Elizabeth Graalum				EMAIL: graalume@oregonstate.edu
; COURSE / PROJECT ID: CS271 / Project 3	DATE: October 21st, 2018

; Description: this programme asks a user for their name. Then it asks for the
; user to input negative integers until a positive integer is entered. Once a
; positive integer is entered, the total number of integers inputted, the sum of
; those integers, and the average is outputted.
;	E.C.-1: Each of the lines of input are numbered
;	E.C.-2: Before the goodbye message a giant "O.K." symbol is displayed

;==================================================================================
INCLUDE Irvine32.inc
;==================================================================================
; CONSTANTS
; Constants------------------------------------------------------------------------

MIN = -100	; minimum of -100 defined as CONSTANT MIN

;==================================================================================
.data
;----------------------------------------------------------------------------------
; DATA
; Intros---------------------------------------------------------------------------

intro_1		BYTE		"Hello! My name is Libby, and this is Negative Input Calculator", 0
intro_2		BYTE		"It's nice to meet you ", 0	; greet user
intro_3		BYTE		".", 0
intro_4		BYTE		"This is a programme that will ask you, ", 0
intro_5		BYTE		", to enter negative whole numbers between -100 and -1.", 0
intro_6		BYTE		"Once you enter a positive number, it will calculate and display the average of your inputs. ", 0

; Prompts--------------------------------------------------------------------------

prompt_1		BYTE		"Before we continue, I'd like to know your name as well. What's your name? ", 0	; ask user's name
prompt_2		BYTE		"Enter a number: ", 0

validation	BYTE		"Please input a valid integer that is between -1 and -100. ", 0

period		BYTE		". ", 0

; Results-------------------------------------------------------------------------

leaveLoop		BYTE		"You entered a positive number so the loop was ended. ", 0
calculating	BYTE		"Calculating the average now. ", 0

noNumbers		BYTE		"I don't know if you know, but you didn't enter any negative numbers so there's nothing for me to calculate. ", 0
thanks		BYTE		"Thanks a lot... ", 0

results		BYTE		"Here are your results ", 0
colon		BYTE		": ",0

count_print	BYTE		"Numbers entered: ", 0
sum_print		BYTE		"Sum: ", 0
average_print	BYTE		"Average: ", 0

; Goodbyes-------------------------------------------------------------------------

goodbye_1		BYTE		"Great button-pushing and number-typing, ", 0
goodbye_2		BYTE		"! ", 0
goodbye_3		BYTE		"Tah-tah for now! ", 0

; O.K. Symbol- E.C.---------------------------------------------------------------

line_1		BYTE		"----------------------------------------", 0
line_2		BYTE		"----------------------------------------", 0
line_3		BYTE		"-----------OOOO--OOO--------------------", 0
line_4		BYTE		"----------OOOOO-OOOO--------------------", 0
line_5		BYTE		"--------OOO---OOO---OOOO--OOO-----------", 0
line_6		BYTE		"--------OOO---OOO---OOOOOOOOOO----------", 0
line_7		BYTE		"--------OOO-----OOO---OOOO--OO----------", 0
line_8		BYTE		"---------OOOO---OOOO---OOO--OO----------", 0
line_9		BYTE		"----------OOO-----OO----OO--OO----------", 0
line_10		BYTE		"------OOOOOOOOOO----OO--OO--OO----------", 0
line_11		BYTE		"-----OOOOOOOOOOOO---OO--OO--OO----------", 0
line_12		BYTE		"----OOO--------OOO--OO--OO--OO----------", 0
line_13		BYTE		"----OOO-OOOO---OOO--OO--OO--OO----------", 0
line_14		BYTE		"---OOOO-OOOOO---OO--OO--OO--OO----------", 0
line_15		BYTE		"---OOOOOO---OO------OO------OO----------", 0
line_16		BYTE		"-OOOOOOOO---OO------OO-----OOO----------", 0
line_17		BYTE		"-OO----OO---OO-------------OOO----------", 0
line_18		BYTE		"-OO-----OOO-OO-------------OOO----------", 0
line_19		BYTE		"-OOOO---OOOOOO-------------OOO----------", 0
line_20		BYTE		"---OO---OOOOO--------------OOO----------", 0
line_21		BYTE		"----OOO--OOO---------------OOO----------", 0
line_22		BYTE		"----OOO--------------------OOO----------", 0
line_23		BYTE		"----OOO-------------------OOO-----------", 0
line_24		BYTE		"-----OOOO----------------OOO------------", 0
line_25		BYTE		"------OOO----------------OOO------------", 0
line_26		BYTE		"--------OOO-------------OOO-------------", 0
line_27		BYTE		"--------OOOO------------OO--------------", 0
line_28		BYTE		"----------OOO-----------OO--------------", 0
line_29		BYTE		"----------OOOOOOOOOOOOOOOO--------------", 0
line_30		BYTE		"----------OOOOOOOOOOOOOOOO--------------", 0
line_31		BYTE		"----------------------------------------", 0
line_32		BYTE		"----------------------------------------", 0


; User Inputs---------------------------------------------------------------------

userName		BYTE		33 DUP(0)	; name inputted by user

; Number Values-------------------------------------------------------------------

lineNum		DWORD	1		; line number

inputNum		SDWORD	?		; number inputted by user
countNum		DWORD	0		; number of inputs
sumNum		SDWORD	0		; sum of inputs
averageNum	SDWORD	?		; average value of inputs

;=================================================================================
.code
main PROC
;---------------------------------------------------------------------------------
; MAIN
;---------------------------------------------------------------------------------
; Introduction
;---------------------------------------------------------------------------------
; Introduce programme and programmer----------------------------------------------
mov	edx, OFFSET	intro_1
call	WriteString
call CrLf

; Prompt user for user name-------------------------------------------------------
mov	edx, OFFSET	prompt_1
call WriteString
call CrLf

mov	edx, OFFSET	userName
mov	ecx, 32
call ReadString

; Greet user---------------------------------------------------------------------

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
call	CrLf

;---------------------------------------------------------------------------------
; Get User Input
;---------------------------------------------------------------------------------
; Ask user for negative integer---------------------------------------------------

mov	edx, OFFSET	prompt_2
call	WriteString
call	CrLf

; Input LOOP---------------------------------------------------------------------
LineNumber:
	mov	eax, lineNum	; display line number
	call	WriteDec

	mov	edx,	OFFSET	period
	call	WriteString

;---------------------------------------------------------------------------------
; Validate Input (is an int and less than zero)
;---------------------------------------------------------------------------------
; Is it an integer?---------------------------------------------------------------
InputStepA:		

	call	ReadInt			; read user input
	call	IsDigit			; check Zero Flag (ZF)
	add	eax, 0			
	jz	ValidationError	; ZF = 0 - invalid (not int)
	jmp	InputStepB		; ZF = 1 - is int and goes on to next step

; Is it less than zero? Check Sign Flag (SF)-------------------------------------
InputStepB:		

	add	eax, 0
	js	InputStepC		; SF = 1 - is negative int
	jns	CountCheck		; SF = 0 - is positive int

; Is it between -1 and -100?------------------------------------------------------
InputStepC:		

	mov	ebx, MIN			; move MIN to ebx register
	cmp	eax, ebx			; compare to MIN CONSTANT (-100)
	jl	ValidationError	; input is too low
	jmp	ValidInput		; input is valid


; Input is invalid (not int or too low)-------------------------------------------
ValidationError:	

	mov	edx,	OFFSET	validation	; tell user to input valid integer
	call	WriteString
	call	CrLf
	jmp	LineNumber				; Start Input Loop over

; Input is valid------------------------------------------------------------------
ValidInput:		

	mov	inputNum, eax		; move register value to number hold
	mov	eax, sumNum		; move sum value to register
	add	eax, inputNum		; add inputted value to sum
	mov	sumNum, eax		; move register value sum
	inc	countNum			; increase counter by 1
	inc	lineNum			; increase line number by 1
	jmp	LineNumber		; jump to start of loop

; Check to see if any negatives were inputted-------------------------------------
CountCheck:		

	cmp	countNum, 0				; compare counter to 0
	jg	EndLoop					; if counter is greater jump to EndLoop

	mov	edx,	OFFSET	noNumbers		; no number message
	call	WriteString
	call	CrLf

	mov	edx,	OFFSET	thanks		; sarcasm
	call	WriteString
	call	CrLf
	
	jmp Goodbye

; Poitive number entered----------------------------------------------------------
EndLoop:			

	mov	edx,	OFFSET	leaveLoop		; "positive int entered" message
	call	WriteString
	call	CrLf

;---------------------------------------------------------------------------------
; Calculations
;---------------------------------------------------------------------------------
; Calulate average----------------------------------------------------------------
mov	edx, -1			; clear dividend, negative
mov	eax, sumNum		; set dividend to sum
mov	ebx, countNum		; set divisor to counted numbers
idiv	ebx				; EAX = EAX / EBX or sumNum / countNum
mov	averageNum, eax	; set average equal to quotient

;---------------------------------------------------------------------------------
;Display results
;---------------------------------------------------------------------------------
; Display result intro------------------------------------------------------------
mov	edx,	OFFSET	results
call	WriteString
mov	edx,	OFFSET	userName
call	WriteString
mov	edx,	OFFSET	colon
call	WriteString
call	CrLf

; Display number of inputs--------------------------------------------------------
mov	edx,	OFFSET	count_print
call	WriteString

mov	eax,	countNum
call	WriteDec
call	CrLf

; Display sum of numbers----------------------------------------------------------
mov	edx,	OFFSET	sum_print
call	WriteString

mov	eax,	sumNum
call	WriteInt
call	CrLf

; Display average of numbers------------------------------------------------------
mov	edx,	OFFSET	average_print
call	WriteString

mov	eax,	averageNum
call	WriteInt
call	CrLf
call CrLf

;---------------------------------------------------------------------------------
; Departing message
;---------------------------------------------------------------------------------
; Print "O.K." symbol - E.C.
OKSymbol:
	mov	edx,	OFFSET	line_1
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_2
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_3
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_4
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_5
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_6
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_7
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_8
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_9
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_10
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_11
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_12
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_13
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_14
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_15
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_16
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_17
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_18
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_19
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_20
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_21
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_22
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_23
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_24
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_25
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_26
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_27
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_28
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_29
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_30
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_31
	call	WriteString
	call CrLf
	mov	edx,	OFFSET	line_32
	call	WriteString
	call CrLf

; Goodbye Message-----------------------------------------------------------------
Goodbye:
	mov	edx,	OFFSET	goodbye_1
	call	WriteString
	mov	edx,	OFFSET	userName
	call	WriteString
	mov	edx,	OFFSET	goodbye_2
	call	WriteString
	call	CrLf
	mov	edx,	OFFSET	goodbye_3
	call	WriteString
	call CrLf

;=================================================================================
	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main

