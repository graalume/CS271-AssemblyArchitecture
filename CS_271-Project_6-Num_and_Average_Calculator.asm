; TITLE: Num and Average Calculator			FILE: (Project6a-931810401.asm)

; AUTHOR: Elizabeth Graalum				EMAIL:	graalume@oregonstate.edu
; COURSE / PROJECT ID: CS271 / Project 6a	DATE:	December 2nd, 2018

; Description: this programme asks a user for their to input 10 unsigned integers.
; This programme recieves these numbers as strings and converts them to integers.
; It then places the inputted values into an array. After getting the user input,
; the list of numbers is displayed back to the user, followed by the sum of the
; values and then the average of the values. This programme employs the use of
; ReadVal and WriteVal procedures. The ReadVal procedure gets user input using a
; getString macro and then converts the strings to integers and places them in the
; array. The WriteVal procedure converts the strings to integers and outputs each
; given value using a displayString macro.

;====================================================================================
INCLUDE Irvine32.inc
;====================================================================================
; CONSTANTS
; Constants--------------------------------------------------------------------------

INPUTLENGTH	EQU	<33>		; max user input length 
ARRAYLENGTH	EQU	<10>		; int array size

;====================================================================================
; MACROS
; Macros-----------------------------------------------------------------------------

; getString MACRO--------------------------------------------------------------------
;	prompts the user for input and recieves a string as input
;	***all registers saved 
;	***no registers changed
;	***all registers restored

getString	MACRO prompt, user_input, input_size
	
	pushad		; pop all registers
	
	mov	edx, prompt	
	call	WriteString	; write given prompt

	mov	edx,	user_input	; set edx equal to user_input (user's inputed string)
	mov	ecx, INPUTLENGTH	; set ecx equal to CONSTANT INPUTLENGTH (33 in this case)
	dec	ecx				; decrement ecx
	call	ReadString		; get user input
	mov	input_size, eax	; set input_size (size of user's input) equal to eax
						; (which was set to the input length after 
						;						ReadString was called)
	call	CrLf				; new line

	popad		; restore all registers

ENDM
;------------------------------------------------------------------------------------
; powerConverter MACRO---------------------------------------------------------------
;	converts the value in ebx to the "nth" power of 10 (e.g. nth = 4 -> ebx = 10^4)
;	***eax, ecx, edx registers saved
;	***ebx register changed
;	***eax, ecx, edx registers restored

powerConverter MACRO	nth
	
	push eax
	push	ecx
	push	edx		; push eax, ecx, edx

	mov	eax, 1	; set eax, equal to 1
	mov	ebx,	10	; set ebx equal to 10
	mov	ecx,	nth	; set ecx equal to inputted nth
	cmp	ecx,	0	; compare nth to 0
	jz	exitPower	; skip power loop if nth equal to 0

	powerLoop:
		mul	ebx		; multiply eax by 10
		loop	powerLoop	; loop nth times
	
	exitPower:
	mov	ebx,	eax		; set ebx equal to eax(10^nth)

	pop	edx		
	pop	ecx
	pop	eax		; restore edx, ecx, eax
				; ebx chnaged

ENDM
;------------------------------------------------------------------------------------
; displayString MACRO----------------------------------------------------------------
;	displays "written_num" string using WriteString
;	***edx registers saved
;	***no registers changed
;	***edx register restored

displayString	MACRO	written_num
	
	push	edx				; push edx
	mov	edx,	written_num	; set edx equal to written_num string (inputted string)
	call	WriteString		; display written_num
	pop	edx				; restore edx

ENDM
;------------------------------------------------------------------------------------
;====================================================================================
.data
;------------------------------------------------------------------------------------
; DATA
; Intros-----------------------------------------------------------------------------
	intro_1		BYTE	"Hello Stranger! My name is Libby. ",	0
	intro_2		BYTE	"Welcome to the Sum and Average Calculator! ",	0
	intro_3		BYTE	"To play, you will be asked to input 10 integers. ",	0
	intro_4		BYTE	"This magical programme will then output all of your inputs, ", 0
	intro_5		BYTE	"and then the sum followed by the average of those numbers. ",	0

; Prompts-------------------------------------------------------------------------
	prompt_1		BYTE	"Please enter a positive integer: ",	0

; Error----------------------------------------------------------------------------
	error		BYTE	"That input is invalid, try again. ",	0

; Results--------------------------------------------------------------------------
	list_title	BYTE	"You enter the following numbers: ",	0
	sum_title		BYTE	"This is the sum: ",	0
	average_title	BYTE	"This is the average: ",	0

	space		BYTE	",  ",	0

; Goodbyes----------------------------------------------------------------------
	goodbye_2		BYTE	"Nice work! I/O-p you enjoyed the Sum & Average calculator!"
	goodbye_1		BYTE	"Tah-tah for now! ",	0

; Variables---------------------------------------------------------------------

 	input_string	BYTE		33 DUP(?)
	output_string	BYTE		33 DUP(?)
	string_size	DWORD	?

	num_sum		DWORD	?
	average		DWORD	?

	list_array	dd		40 DUP(?)
	array_place	DWORD	?

	list_length	DWORD	10
;=================================================================================

.code

main PROC
;-------------------------------------------------------------------------------------
; MAIN
;-------------------------------------------------------------------------------------

 	push	OFFSET	intro_5
	push	OFFSET	intro_4
	push	OFFSET	intro_3
	push	OFFSET	intro_2
	push	OFFSET	intro_1
	call			Introduction	; read all intros (could've just been done with
							;			displayString MACRO, but wasn't)

	push	OFFSET	error		; push address of error message
	push	OFFSET	array_place	; push address of array placement tracker
	push	OFFSET	string_size	; push address of string size
	push	OFFSET	list_array	; push address of array for inputs
	push	OFFSET	prompt_1		; push address of prompt message
	push	OFFSET	input_string	; push address of string inputted by user
	call	ReadVal				; call ReadVal Procedure

	call	CrLf							; new line
	displayString	OFFSET	list_title	; display "You have entered..."
	call	CrLf							; new line

		push	OFFSET	output_string		; push address of string to be outputted
		push	list_array[0]				; push address of 1st value
		call	WriteVal					; call WriteVal procedure
		displayString	OFFSET	space	; display ",  "
									; the following repeats lines 172 through 221
									; working it's way through each of the 10 inputs
		push	OFFSET	output_string	
		push	list_array[4]				; 2nd value
		call	WriteVal
		displayString	OFFSET	space

		push	OFFSET	output_string	
		push	list_array[8]				; 3rd value
		call	WriteVal
		displayString	OFFSET	space

		push	OFFSET	output_string	
		push	list_array[12]				; 4th value
		call	WriteVal
		displayString	OFFSET	space

		push	OFFSET	output_string	
		push	list_array[16]				; 5th value
		call	WriteVal
		displayString	OFFSET	space

		push	OFFSET	output_string	
		push	list_array[20]				; 6th value
		call	WriteVal
		displayString	OFFSET	space

		push	OFFSET	output_string	
		push	list_array[24]				; 7th value
		call	WriteVal
		displayString	OFFSET	space

		push	OFFSET	output_string	
		push	list_array[28]				; 8th value
		call	WriteVal
		displayString	OFFSET	space

		push	OFFSET	output_string	
		push	list_array[32]				; 9th value
		call	WriteVal
		displayString	OFFSET	space

		push	OFFSET	output_string	
		push	list_array[36]				; 10th value
		call	WriteVal
		call	CrLf

	push	OFFSET	list_array	; push address of integer array
	push	OFFSET	num_sum		; push address of sum of integers (to be filled)
	push	list_length			; push length of list by value
	call	CalculateSum			; call CalculateSum procedure

	displayString	OFFSET	sum_title	; display "This is the sum: "
	push	OFFSET	output_string		; push address of string to be outputted
	push	num_sum					; push sum value
	call	WriteVal					; call WriteVal procedure
	call	CrLF						; new line

	push	OFFSET	average		; push address of average
	push	num_sum				; push sum value
	call	CalculateAvg			; call CalculateAvg procedure

	displayString	OFFSET	average_title	; display "This is the average: "
	push	OFFSET	output_string			; push address of string to be outputted
	push	average						; push average by value
	call	WriteVal						; call WriteVal procedure
	call	CrLf							; new line

	displayString	OFFSET	goodbye_1		; display goodbye 1
	call	CrLf							; new line
	displayString	OFFSET	goodbye_2		; display goodbye 2
	call	CrLf							; new line
	call	CrLf							; new line

 	exit

main	ENDP
;==================================================================================
;----------------------------------------------------------------------------------
; INTRODUCTION
;----------------------------------------------------------------------------------
;Procedure to introduce the programme
;receives:		intro strings 1-5 passed onto stack
;returns:			none
;preconditions:	the existence of the displayString MACRO
;registers changed: edx
;----------------------------------------------------------------------------------

introduction	PROC

	push	ebp					; push base pointer
	mov	ebp,	esp				; move stack pointer to base pointer

	; Introduce programme and programmer------------------------------------------
	displayString	[ebp+8]
	call	CrLf

	displayString	[ebp+12]
	call	CrLf

	; Explain programme-----------------------------------------------------------
	displayString	[ebp+16]
	call	CrLf

	displayString	[ebp+20]
	call	CrLf
	
	displayString	[ebp+24]
	call	CrLf

	pop	ebp	; remove base pointer
	ret	20	; clear/reset stack

introduction	ENDP
;==================================================================================
;----------------------------------------------------------------------------------
; ReadVal
;----------------------------------------------------------------------------------
;Procedure to get string user input and convert it to integers and place in array
;receives:		@inputted string (ebp+8), @prompt for user input (ebp+12),
;				@the array (ebp+16), @lenght of input (ebp+20), @place in array
;				(ebp+24) and @error message (ebp+28)
;returns:			array of integer values converted from inputted strings
;preconditions:	existence of getString MACRO
;registers changed: eax, ebx, ecx, edx, esi
;----------------------------------------------------------------------------------

ReadVal	PROC
	
	push	ebp			; push base pointer
	mov	ebp,	esp		; move stack pointer to base pointer

	push	eax			; push eax
	push	ebx			; push ebx

	mov	eax,	[ebp+24]	; set eax to address of array placeholder
	mov	ebx,	1		; set ebx equal to 1
	mov	[eax], ebx	; set array placeholder (eax) equal to 1 (ebx)
	
	pop	ebx
	pop	eax

	; loop to read and validate and save input------------------------------------
	ReadLoop:

		; loop to get input from user--------------------------------------------
		getLoop:
			getString	[ebp+12], [ebp+8], [ebp+20]	
				; pass user input prompt, inputted string, and length of string

			mov	esi,	[ebp+8]		; input_string
			cld					; iterate forward

			mov	ecx, [ebp+20]		; set ecx equal to length of string
			mov	edx,	0			; hold input sum

			; validation loop---------------------------------------------------	
			ValidateLoop:
				mov	eax,	0		; set eax equal to 0
				lodsb			; load top char ASCII value into ax register
				cmp	ax,	30h		; less than '0' ASCII value?
				jl	errorMessage	; not Int - reprompt
				cmp	ax,	39h		; more than '9' ASCII value?
				jg	errorMessage	; not Int - reprompt
				loop	ValidateLoop	; loop length of string (ecx)

			mov	esi,	[ebp+8]		; set esi equal to inputted string
			cld					; iterate forward
			mov	ecx, [ebp+20]		; set ecx equal to length
			jmp	ConvertLoop		; jump to converter loop
			
			JmpBreak:
				jmp	ReadLoop		; halfway point

		; loop to convert string input to integer--------------------------------
		ConvertLoop:
			dec	ecx			; decrement length counter
			mov	eax,	0		; set eax equal to 0
			lodsb			; load byte at ds:si to ax		
			sub	ax,	30h		; subtract 48 (30 in hex) to get int value
			powerConverter	ecx	; get 10^nth (ecx) in ebx
			jc	errorMessage	; go to error if carry flag set
			jo	errorMessage	; go to error if overflow flag set
			push	edx			; push edx
			mul	ebx			; multiply int (eax) val by 10^nth (ebx)
			pop	edx			; restore edx
			add	edx,	eax		; add int*10^nth to edx
			jc	errorMessage	; go to error if carry flag set
			jo	errorMessage	; go to error if overflow flag set
			cmp	ecx,	0		; is length counter at 0?
			jnz	ConvertLoop	; if not 0 run ConvertLoop again
			cmp	edx,	0		
			jz	errorMessage	; error if input is 0?
			jmp	fillArray
	
			errorMessage:
				displayString	[ebp+28]	; display error message
				call	CrLf
				jmp	getLoop			; go back to getLoop

			; loop to fill array of integer with users input--------------------
			fillArray:
				mov	esi,	[ebp+16]		; set esi equal to array address
				mov	ecx,	[ebp+24]		; set ecx equal to array placeholder
				mov	ecx,	[ecx]		; set ecx equal to address of ecx 
				sub	esi,	4			; subtract esi by 4

				moveArrayPlace:
					add	esi,	4		; add 4 to esi
					loop	moveArrayPlace	; loop to add (based on ecx val)
					mov	[esi],	edx	; set esi to edx value
			
			mov	eax,	[ebp+24]		; set eax equal to array placeholder
			mov	ebx,	1			; set ebx equal to 1
			add	[eax], ebx		; add 1 to array placeholder
			mov	eax,	[eax]		; set eax equal to value of placeholder
			cmp	eax,	10			; is placeholder less than or equal to 10?
			jle	JmpBreak			; if yes jump to JmpBrek to start ReadLoop again

	pop	ebp	; remove base pointer
	ret	24	; clear/reset stack

ReadVal	ENDP
;==================================================================================
;----------------------------------------------------------------------------------
; WriteVal
;----------------------------------------------------------------------------------
;Procedure to 
;receives:		@inputted string (ebp+8), @outputted string (ebp+12)
;returns:			converted int to string
;preconditions:	existence of displayString MACRO and, CONSTANT INPUTLENGTH
;registers changed: eax, ebx, ecx, edx, esi, edi
;----------------------------------------------------------------------------------

WriteVal	PROC

  	push	ebp					; push base pointer
	mov	ebp,	esp				; move stack pointer to base pointer

	mov	ecx,	10			; set ecx equal to 10
	mov	edx,	0			; set edx equal to 0
	mov	eax,	[ebp+8]		; set eax equal to int value to be converted to string and outputted
	push	ecx				; push ecx
	mov	ecx,	0			; set ecx equal to 0

	; loop to divide integer by 10 to convert to string---------------------------
		Int2String_div:
			cdq				; extend eax into edx
			mov	ebx,	10		; set ebx equal to 10
			div	ebx			; divide input (eax) by 10 (ebx)
			push	edx			; push remainder (edx)
			inc	ecx			; increment ecx
			cmp	eax,	10		; if divided input is greater than or equal to 10
			jge	Int2String_div	; loop again

			push	eax				; push eax
			inc	ecx				; increment ecx
			mov	edi,	[ebp+12]		; set edi equal to address of string to be outputted
			push	ecx				; push ecx
			mov	ecx,	INPUTLENGTH	; set ecx to CONSTANT INPUTLENGTH (33)
			
			; loop to empty ouput string----------------------------------------
			EmptyLoop:
				mov	eax,	0		; set eax equal to 0 
				mov	[edi], eax	; set value at edi equal to 0
				inc	edi			; increment edi
				loop	EmptyLoop		; loop

  			pop	ecx				; pop ecx
			mov	edi,	[ebp+12]		; set edi equal to address of string to be outputted

			; loop to add 48 (30h) from integer to convert to string------------
			Int2String_sub:
				cld				; iterate forward
				pop	eax			; restore eax (original int at place n/10)
				add	eax,	30h		; add 48 (30 in hex) to get string value
   				stosb			; store eax at es:edi (string to be outputted)
				loop	Int2String_sub	; loop

			mov	eax,	0			; set eax equal to 0

			displayString	[ebp+12]	; display string

			pop	ecx				; restore ecx
		
		
		pop	ebp	; remove base pointer
		ret	8	; clear/reset stack

WriteVal	ENDP
;==================================================================================
;----------------------------------------------------------------------------------
; CalculateSum
;----------------------------------------------------------------------------------
;Procedure to calculat the sum of the inputted integers
;receives:		length of array (ebp+8), @num_sum (ebp+12), @array of integers 
;				(ebp+16)
;returns:			value in num_sum
;preconditions:	existence of CONSTANT ARRAYLENGTH 
;registers changed: eax, ebx, ecx, esi
;----------------------------------------------------------------------------------

CalculateSum	PROC

	push	ebp				; push base pointer
	mov	ebp,	esp			; move stack pointer to base pointer

	mov	esi,	[ebp+16]		; move array to esi
	mov	ecx,	ARRAYLENGTH	; set ecx equal to CONSTANT ARRAYLENGTH (10)
	mov	ebx,	0			; set ebx equal to 0

	sumLoop:
		mov	eax,	[esi]	; set eax equal to array address
		add	ebx,	eax		; add value from esi to ebx
		add	esi,	4		; add 4 to esi
		loop	sumLoop		; loop

	mov	ecx,	0			; set ecx equal to 0
	mov	ecx,	ebx			; set ecx equal to ebx
 	mov	ebx,	[ebp+12]		; move address of Sum value to ebx
	mov	[ebx], ecx		; set address at ebx equal to value in ecx	

	pop	ebp	; remove base pointer
	ret	12	; clear/reset stack

CalculateSum	ENDP
;==================================================================================
;----------------------------------------------------------------------------------
; CalculateAvg
;----------------------------------------------------------------------------------
;Procedure to calculate the average of inputted values
;receives:		num_sum (ebp+8), @average (ebp+12)
;returns:			none
;preconditions:	none
;registers changed: none
;----------------------------------------------------------------------------------

CalculateAvg	PROC
	
	push	ebp					; push base pointer
	mov	ebp,	esp				; move stack pointer to base pointer

	mov	edx,	0				; set edx equal to 0
	mov	eax,	[ebp+8]			; set eax equal to value of sum
	mov	ebx,	10				; set ebx equal to 10
	div	ebx					; divide sum (eax) by 10 (ebx) to get average

	mov	ecx,	[ebp+12]			; set ecx equal to address of average
	mov	[ecx], eax			; set average equal to value in eax

	pop	ebp	; remove base pointer
	ret	8	; clear/reset stack

CalculateAvg	ENDP
;==================================================================================
END main
