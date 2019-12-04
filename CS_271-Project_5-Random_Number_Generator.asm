; TITLE: Random Number Generator			FILE: (Project5-931810401.asm)

; AUTHOR: Elizabeth Graalum				EMAIL: graalume@oregonstate.edu
; COURSE / PROJECT ID: CS271 / Project 5	DATE: November 13, 2018

; Description: This is project asks the user for an integer between 10 and 200.
; Once validated, their input become the length of an empty array. This array is
; then filled with random values between 100 and 999. This unsorted array is
; displayed. Next the array is sorted into descending order (highest value first).
; The median of the newly sorted array is then displayed, followed by the sorted
; array itself.

;==================================================================================
INCLUDE Irvine32.inc
;==================================================================================
; CONSTANTS
; Constants------------------------------------------------------------------------

MIN	EQU	<10>		; user input minimum
MAX	EQU	<200>	; user input maximum

LO	EQU	<100>	; random number minimum
HI	EQU	<999>	; random number maximum

;==================================================================================
.data
;----------------------------------------------------------------------------------
; DATA
; Intros---------------------------------------------------------------------------
	intro_1	BYTE	"Hello Stranger! My name is Libby. ",	0
	intro_2	BYTE	"Welcome to the Random Number Generator! ",	0
	intro_3	BYTE	"To play, you will be asked to input an integer between 10 and 200. ",	0
	intro_4	BYTE	"This magical programme will then output that many random numbers, order the numbers from high to low, and then display the median of the reordered list. ",	0

; Prompts--------------------------------------------------------------------------
	prompt_1	BYTE	"Please input an integer between 10 and 200. ", 0

; Validation-----------------------------------------------------------------------
	invalid	BYTE	"That's out of range. Please, just a number between 10 and 200, it's not that hard. ", 0

; Title----------------------------------------------------------------------------
	title_unsorted		BYTE	"Unsorted List: ",	0
	title_median		BYTE	"Here is the median of your results: ",	0
	title_sorted		BYTE	"Sorted List: ",	0

	space			BYTE	"     ",	0

; Goodbyes-------------------------------------------------------------------------
	goodbye_1	BYTE	"Tah-tah for now! ",	0

; User Inputs----------------------------------------------------------------------
	input_Length	DWORD	?

; Variables------------------------------------------------------------------------
	list_Array	dd		200 dup (?)

	median		DWORD	?
	
	line_Counter	DWORD	?

;==================================================================================
.code

;----------------------------------------------------------------------------------
; MAIN
;----------------------------------------------------------------------------------
main PROC

	call	Randomize				; Random number from Irvine Library

	call	introduction			; introduce programme

	; getData
	push	OFFSET	input_Length	; pass input_Length by reference
	call			getData		; get value for input_Length

	; fillArray
	push			input_Length	; pass input_Length value
	push	OFFSET	list_Array	; pass list_Array by reference
	call			fillArray		; fills array with random value
	
	; displayList - unsorted
	push	OFFSET	list_Array	; pass listArray by reference
	push			input_Length	; pass input_length value
	push OFFSET	title_unsorted	; pass "unsorted" title by reference
	call			displayList	; display unsorted listArray

	; sortList
	push	OFFSET	list_Array	; pass listArray by reference
	push			input_Length	; pass input_length value
	call			sortList		; sort list into decending order

	; displayMedian
	push	OFFSET	list_Array	; pass listArray by reference
	push			input_Length	; pass input_length value
	push	OFFSET	title_median	; pass "median" title by reference
	call			displayMedian	; display median

	; displayList - sorted
	push	OFFSET	list_Array	; pass listArray by reference
	push			input_Length	; pass input_Length value
	push OFFSET	title_sorted	; pass "sorted" title by reference
	call			displayList	; display sorted list

	exit

main ENDP
;==================================================================================
;----------------------------------------------------------------------------------
; INTRODUCTION
;----------------------------------------------------------------------------------
;Procedure to introduce the programme
;receives:		none
;returns:			none
;preconditions:	none
;registers changed: edx
;----------------------------------------------------------------------------------

introduction	PROC

	; Introduce programme and programmer---------------------------------------------
	mov	edx,	OFFSET	intro_1
	call	WriteString
	call	CrLf

	mov	edx,	OFFSET	intro_2
	call	WriteString
	call	CrLf

	; Explain programme--------------------------------------------------------------
	mov	edx,	OFFSET	intro_3
	call	WriteString
	call	CrLf
	call	CrLf

	mov	edx,	OFFSET	intro_4
	call	WriteString
	call	CrLf
	call	CrLf

	ret

introduction	ENDP
;==================================================================================
;----------------------------------------------------------------------------------
; GET DATA
;----------------------------------------------------------------------------------
;Procedure to get the user request (i.e. the length of the array)
;receives:		the address of request
;returns:			validated user input for request value
;preconditions:	MIN and MAX are global CONSTANTS
;registers changed: eax, ebx, edx, ebp 
;----------------------------------------------------------------------------------

getData	PROC
	push	ebp					; push base pointer
	mov	ebp,	esp				; move stack pointer to base pointer	

	mov	ebx,	[ebp+8]			; move address for user request into ebx

	mov	edx,	OFFSET	prompt_1	
	call	WriteString			; print request statement		
	call	CrLf

	;--------------------------------------------------------------------------------
	; Validate Input (is an int and greater 10 and less than 200)
	;--------------------------------------------------------------------------------
	; Sequence within getData procedure to validate input
	; receives:			user input
	; returns:			validated user input
	; preconditions:		MIN and MAX are global CONSTANTS
	; registers changed:	eax, ebx, edx
	;--------------------------------------------------------------------------------

		; Is it an integer?---------------------------------------------------------
		InputStepA:		

			call	ReadInt			; read user input
			call	IsDigit			; check Zero Flag (ZF)
			add	eax, 0			
			jz	ValidationError	; ZF = 0 - invalid (not int)
			jmp	InputStepB		; ZF = 1 - is int and goes on to next step

		; Is it greater than 10 and less than 200?--------------------------------------------------
		InputStepB:		

			cmp	eax, MIN			; compare to MIN CONSTANT (10)
			jl	ValidationError	; input is too low
			cmp	eax,	MAX			; compare to MAX CONSTANT (200)
			jg	ValidationError	; input is too high
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

			mov	[ebx], eax		; move register value to number hold

		;---------------------------------------------------------------------------

	pop	ebp		; remove base pointer
	ret	4		; clear/reset stack

getData	ENDP
;==================================================================================
;----------------------------------------------------------------------------------
; FILL ARRAY
;----------------------------------------------------------------------------------
;Procedure to fill the array of requested size with random values
;between 100 and 999
;receives:		value of request and address of array
;returns:			randomized array values
;preconditions:	HI and LO are global CONSTANTS, and input_length is the length
;					of the array
;registers changed: eax, ecx, esi, ebp
;----------------------------------------------------------------------------------

fillArray	PROC
	push	ebp					; push base pointer
	mov	ebp,	esp				; move stack pointer to base pointer

	mov	ecx,	[ebp+12]			; set ecx equal to length
	mov	esi,	[ebp+8]			; move array into esi

	FillLoop:
		mov	eax,	HI			; eax is random generator range
		sub	eax,	LO			; range-1 = HI - LO (i.e. 999 - 100 = 899)
		inc	eax				; range = (HI - LO) + 1 (i.e. 900)
	
		call	RandomRange		; call Irvine library procedure to produce random
							;	value in eax between 0 and eax
							;	(i.e 0 and 899)
		add	eax,	LO			; add min to value
							;	(makes range of 0 - 899 to 100 - 999)
		mov	[esi], eax		; move random value into array
		add	esi,	4			; move on to next space in array

		loop	FillLoop			; loop until array is full
	
	pop	ebp	; remove base pointer
	ret	8	; clear/reset stack

fillArray	ENDP
;==================================================================================
;----------------------------------------------------------------------------------
; SORT LIST
;----------------------------------------------------------------------------------
;Procedure to sort the array into descending order (i.e. largest first, lowest last)
;receives:		value of request and address of array
;returns:			sorted list_Array (descending order)
;preconditions:	list_Array is filled with randomized values and input_length is
;				the length of list_array
;registers changed: eax, ebx, ecx, edx, esi, ebp
;----------------------------------------------------------------------------------
sortList	PROC

	push	ebp					; push base pointer
	mov	ebp,	esp				; move stack pointer to base pointer

	mov	esi,	[ebp+12]			; move array (at ebp+12) into esi register
	mov	ecx,	0				; set ecx (k) equal to 0

	OutterLoop:
		mov	eax,	ecx			; set eax (i) equal to ecx (k)
		mov	ebx,	ecx			; set ebx (j) equal to ecx (k)

		InnerLoop:
			inc	ebx			; increment ebx (j++)
			mov	esi, [ebp+12]	; reset esi to original array
			add	esi,	eax		; (1) add eax value (i) to esi
			add	esi,	eax		; (2)
			add	esi,	eax		; (3)
			add	esi,	eax		; (4) add four times for size of array element
			mov	edx,	[esi]	; mov esi (array[eax]/array[i]) into edx

			mov	esi,	[ebp+12]	; reset esi to original array

			add	esi,	ebx		; (1) add ebx value (j) to esi
			add	esi,	ebx		; (2)
			add	esi,	ebx		; (3)
			add	esi,	ebx		; (4) add four times for size of array element
							; esi is now array[ebx]/array[j]

 			cmp	edx,	[esi]	; compare array[eax]/array[i]
							;	and array[ebx]/array[j]
			jge	skip			; if array[eax] is greater or equal to array[ebx]
							; jump to 'skip'
			
			mov	eax,	ebx		; move ebx value to eax register (i = j)
			
			skip:			; 'skip'
			mov	edx,	[ebp+8]	; move array length (at ebp+8) into edx
			dec	edx			; decrement edx
			cmp	ebx,	edx		; compare ebx (j) to edx (length-1)
			jl	InnerLoop		; jump if less than to top of loop (continue loop)
		
			mov	esi,	[ebp+12]	; reset esi to original array

			add	esi,	eax		; (1)
			add	esi,	eax		; (2)
			add	esi,	eax		; (3)
			add	esi,	eax		; (4) - esi is now array[eax]/array[i]

			push esi			; push esi (array[eax]/array[i]) onto stack

			mov	esi,	[ebp+12]	; reset esi to original array

			add	esi,	ecx		; (1)	
			add	esi,	ecx		; (2)
			add	esi,	ecx		; (3)
			add	esi,	ecx		; (4) - esi is now array[ecx]/array[k]
			
			push esi			; push esi (array[ecx]/array[k]) onto stack


			call	exchangeElement	; exchange the vlaues of array[i] and 
								;	array[k]

		inc	ecx				; increment ecx (k++)
		mov	eax,	[ebp+8]		; move array length (at ebp+8) into eax (i)
		dec	eax				; decrement eax
		cmp	ecx,	eax			; compare ecx (k) to eax (length-1)
		jne	OutterLoop		; jump if not equal to top of OutterLoop

	pop	ebp	; remove base pointer
	ret	8	; clear/reset stack

	;-----------------------------------------------------------------------------
	; EXCAHNGE ELEMENT
	;-----------------------------------------------------------------------------
	;Procedure to exchange the values of two positions in the array
	;receives:		array[i] and array[k] by reference (addresses of)
	;returns:			switch array values
	;preconditions:	array[i] is greater than array[k]
	;registers changed: eax, ecx, edx, ebp
	;-----------------------------------------------------------------------------
	exchangeElement	PROC
		
		push	ebp					; push base pointer
		mov	ebp,	esp				; move stack pointer to base pointer
		push	ecx					; push ecx

		mov	eax,	[ebp+8]			; move array[i] address into eax
		mov	eax,	[eax]			; dereference to value

		mov	edx,	[ebp+12]			; move array[j] address into edx
		mov	edx,	[edx]			; dereference to vlaue

		mov ecx, [ebp+12]			; move array[j] address into ecx
		mov [ecx], eax				; move eax (value of array[i]) into the
								;	address of ecx (array[j])

		mov ecx, [ebp+8]			; move array[i] address into ecx
		mov [ecx], edx				; move edx (value of array[j]) into the
								;	address of ecx (array[i])

		pop	ecx	; restore ecx register
		pop	ebp	; remove base pointer
		ret	8	; clear/reset stack

	exchangeElement	ENDP

sortList	ENDP
;==================================================================================
;----------------------------------------------------------------------------------
; DISPLAY ELEMENT
;----------------------------------------------------------------------------------
;Procedure to display the median of the reordered array
;receives:		address of array, value of request, and address of title
;returns:			median of array
;preconditions:	the array is filled and the request is the length of the array
;registers changed: eax, ebx, ecx, edx, esi, ebp
;----------------------------------------------------------------------------------
displayMedian	PROC
	
	push	ebp					; push base pointer
	mov	ebp,	esp				; move stack pointer to base pointer

	mov	esi,	[ebp+16]			; move array into esi

	call	CrLf
	mov	edx,	[ebp+8]			; move title into edx
	call	WriteString			; print title

	mov	edx,	0				; set edx equal to 0
	mov	eax,	[ebp+12]			; set eax equal to length
	mov	ecx,	2				; set ecx equal to 2
	div	ecx					; divide eax by ecx (length/2)

	cmp	edx,	0				; compare remainder (in edx) to 0
	jne	OddLength				; if not equal, jump to 'OddLength'

	EvenLength:				; Sequence for even lengths
		mov	esi,	[ebp+16]		; move original array into esi
		add	esi,	eax			; (1)
		add	esi,	eax			; (2)
		add	esi,	eax			; (3)
	 	add	esi,	eax			; (4) - esi is equal to array[eax]
		mov	edx,	[esi]		; set edx equal to esi/array[eax]
		
		mov	esi,	[ebp+16]		; move original array into esi
		dec	eax				; decrement eax
		add	esi,	eax			; (1)
		add	esi,	eax			; (2)
		add	esi,	eax			; (3)
		add	esi,	eax			; (4) - esi i equal to array[eax-1]
		
		add	edx, [esi]		; add array values of array[eax] and array[eax-1]

		mov	eax,	edx			; set eax equal to sum of array values
		mov	ebx,	2			; set ebx equal to 2
		mov	edx,	0			; reset edx to 0
		inc	eax				; increment eax (for rounding purposes)
		div	ebx				; divide eax by ebx (sum/2)
							; eax is equal to average of centre values

		jmp	Display			; jump to 'Display'

	OddLength:				; Sequence for odd lengths
		add	esi,	eax			; (1)
		add	esi,	eax			; (2)
		add	esi,	eax			; (3)
		add	esi,	eax			; (4) - esi is equal to array[eax]
		mov	eax,	[esi]		; set eax equal to value in esi (at array[eax])
		jmp	Display			; jump to 'Display'

	Display:					; Display median
		call	WriteDec			; write median


   	pop	ebp	; remove base pointer
	ret	12	; clear/reset stack

displayMedian	ENDP
;==================================================================================
;----------------------------------------------------------------------------------
; DISPLAY LIST
;----------------------------------------------------------------------------------
;Procedure to display the values in the array - with 10 elements per line
;receives:		address of array, value of request, and address of title
;returns:			displays array
;preconditions:	array is filled and request is the length of the array
;registers changed: eax, ebx, ecx, edx, esi, ebp
;----------------------------------------------------------------------------------
displayList	PROC
	push	ebp					; push base pointer
	mov	ebp,	esp				; move stack pointer to base pointer

	call	CrLf					; new line
	call	CrLf					; new line

	mov	edx,	[ebp+8]			; move title into edx
	call	WriteString			; print title
	call	CrLf

	mov	ecx,	[ebp+12]			; set ecx equal to length
	mov	esi,	[ebp+16]			; move array into esi

	mov	ebx,	0				; set ebx (counter) equal to 0

	DisplayLoop:				; Display sequence
		mov	eax,	[esi]		; set eax equal to esi (array[x])
		call	WriteDec			; ouput value
	
		mov	edx,	OFFSET	space
		call	WriteString		; space between numbers

		add	esi,	4			; go to next element in array
							;(add 4 for element size)

		inc	ebx				; increment ebx (counter)	
		cmp	ebx,	10			; compare counter to 10
		jl	SameLine			; if less than skip to 'SameLine' 
							; (i.e. don't make new line)

		call	CrLf				; new line (if counter = 10)
		mov	ebx, 0			; reset counter

		SameLine:
		loop	DisplayLoop		; loop

	pop	ebp	; remove base pointer
	ret	12	; clear/reset stack

displayList	ENDP
;==================================================================================

END main
