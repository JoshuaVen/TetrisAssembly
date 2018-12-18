TITLE TETRIS (GAME EXE)
;-----------------------------------------------------------
STACKSEG SEGMENT PARA 'Stack'
  DW 32 DUP ('R7')
STACKSEG ENDS
;-----------------------------------------------------------
DATASEG SEGMENT PARA 'Data'
  MSG_AUTHOR DB "BY JOSHUA VEN AND NISHA ALEXIS, 2018 $"
  MSG_NEXT DB "NEXT $"
  MSG_LEFT DB "A - Left $"
  MSG_RIGHT DB "S - Right $"
  MSG_ROTATE DB "SPC - Rotate $"
  MSG_QUIT DB "Q - Quit $"
  MSG_LINES DB "Score $"
  MSG_GAME_OVER DB "GAME OVER $"
  LOAD_STR	DB		'Loading...$'
  OPTION1	DB 	'START$'
  OPTION2	DB 	'INSTRUCTIONS$'
  OPTION3	DB 	'HIGHEST SCORE$'
  OPTION4	DB 	'QUIT$'
  PRESSESC  DB 'Press ESC to return to menu... ',0ah,0dh,'$'

  
  TITLECURSORCOL DB 02	
  TITLECURSORROW DB 10H
  BIRDPOSCOL DB 0AH	
  BIRDPOSROW DB 0AH		
  
  TEMP		DB		?
  TEMP2		DB 		1
  CHECKER 	DB 		0
  BUTTON_PRESSED		DB 		?
  BUTTON_PRESSED2		DB 		?
  
   MESSAGE1 DB '_________________________________________________',0ah,0dh
   		   DB ' | ####### ####### ####### ######    ###    ##### |',0ah,0dh
           DB ' |    #    #          #    #     #    #    #     #|',0ah,0dh
           DB ' |    #    #          #    #     #    #    #      |',0ah,0dh
           DB ' |    #    #####      #    ######     #     ##### |',0ah,0dh
           DB ' |    #    #          #    #   #      #          #|',0ah,0dh
           DB ' |    #    #          #    #    #     #    #     #|',0ah,0dh
           DB ' |    #    #######    #    #     #   ###    ##### |',0ah,0dh
           DB ' |                                                |',0ah,0dh
           DB ' |________________________________________________|',0ah,0dh,'$'
  
  MESSAGE2	DB '------------------------------------------------------------------------------',0ah,0dh,'$'
  MESSAGE3	DB '------------------------------------------------------------------------------',0ah,0dh,'$'

   FLAG	DB 	0
  FLAG2	DB 	0
  DELAY DB 0
   SCORE1 DB 0
  SCORE2 DB 0
  STRLEN DW 3
  PIPEROW DB 0
  PIPECOL DB 4FH
  PIPECOL2 DB 0
  PIPECOL3 DB 0
  PIPECOL4 DB 0
  RECORD_STR    DB 4H DUP('$')  ;length = original length of record + 1 (for $)
  READED_STR    DB 4H DUP('$')  ;length = original length of record + 1 (for $)
  RECORD_STR1   DB '000'
  PATHFILENAME  DB 'Hscore.txt', 00H
  FILEHANDLE    DW ?
  HIGHSCORE_TEXT DB 'HIGHSCORE: $'
   HOLE DB 4
  HOLE2 DB 4
  HOLE3 DB 4
  HOLE4 DB 4
  MSG_TETRIS DB "TETRIS $"
  
  ;MAKE GAME OVER DB
  ;MAKE START GAME DB
  
  DELAY_CENTISECONDS DB 5 ;delay between frames in hundredths of a second
  SCREEN_WIDTH DW 320
  
  BLOCK_SIZE DW 5 ;block size in pixels
  BLOCKS_PER_PIECE DW 4 ;number of blocks in a piece
  
  ; the reason why pieces change colour is to facilitate collision detection
  ; since when rotating, each piece is allowed to collide with pixels of the
  ; same colour as itself, but is not allowed to collide with versions of 
  ; itself which have already cemented
  COLOR_CEMENTED_PIECE DW 40, 48, 54, 14, 42, 36, 34 ;colors for pieces w/c have cemented
  COLOR_FALLING_PIECE DW 39, 47, 55, 44, 6, 37, 33 ;colors for pieces w/c are falling
  
  ;piece definitions begin here
  ;
  ; - piece_definition variable moves between piece_t, piece_j, etc.
  ; - piece_orientation_index variable moves between 0 and 3, offsetting
  ;                     within a piece's four possible orientations
  PIECES_ORIGIN LABEL WORD
  PIECE_T DW 1605, 1610, 1615, 3210 ;point DOWN
          DW 10, 1610, 1615, 3210   ;point RIGHT
		  DW 10, 1605, 1610, 1615   ;point UP
		  DW 10, 1605, 1610, 3210   ;point LEFT
  
  PIECE_J DW 1605, 1610, 1615, 3215 ;point DOWN
          DW 10, 15, 1610, 3210     ;point RIGHT
		  DW 5, 1605, 1610, 1615    ;point UP
		  DW 10, 1610, 3205, 3210   ;point LEFT
  
  PIECE_L DW 1605, 1610, 1615, 3205 ;point DOWN
          DW 10, 1610, 3210, 3215   ;point RIGHT
		  DW 15, 1605, 1610, 1615   ;point UP
		  DW 5, 10, 1610, 3210      ;point LEFT
  
  PIECE_Z DW 1605, 1610, 3210, 3215 ;point DOWN
          DW 15, 1610, 1615, 3210   ;point RIGHT
		  DW 1605, 1610, 3210, 3215 ;point UP
		  DW 15, 1610, 1615, 3210   ;point LEFT
  
  PIECE_S DW 1610, 1615, 3205, 3210 ;point DOWN
          DW 10, 1610, 1615, 3215   ;point RIGHT
		  DW 1610, 1615, 3205, 3210 ;point UP
		  DW 10, 1610, 1615, 3215   ;point LEFT
  
  PIECE_SQUARE DW 1605, 1610, 3205, 3210 ;point DOWN
               DW 1605, 1610, 3205, 3210 ;point RIGHT
			   DW 1605, 1610, 3205, 3210 ;point UP
			   DW 1605, 1610, 3205, 3210 ;point LEFT
  
  PIECE_LINE DW 1600, 1605, 1610, 1615 ;point DOWN
             DW 10, 1610, 3210, 4810   ;point RIGHT
			 DW 1600, 1605, 1610, 1615 ;point UP
			 DW 10, 1610, 3210, 4810   ;point LEFT
			 
  MSG_SCORE_BUFFER DB "000$" ;string representation of score
  SCORE DW 0 ;keeps score (total number of cleared lines)
  
  CURRENT_FRAME DW 0 ;global frame counter
  
  INSTRUCT  DB 'INSTRUCTIONS',0ah,0dh
  			DB '------------------------------------------------------------------------------',0ah,0dh
  			DB 'Press the SPACEBAR Button to hard drop a block. use left and right arrow keys to',0ah,0dh
  			DB 'move the block. Each line that fills clears and scores by one. ',0ah,0dh
  			DB 'Reach the highest point by beating the previous high score!,',0ah,0dh
  			DB ' ',0ah,0dh
  			DB ' ',0ah,0dh
  			DB ' ',0ah,0dh
  			DB 'Press ESC to return to menu... ',0ah,0dh,'$'

  STAR    DB '-------------------------------------------------------------------------------',0ah,0dh
        DB '                               |      /\      |                                ',0ah,0dh
        DB '                               |  ___/  \___  |                                ',0ah,0dh
        DB '                               |  \  _()_  /  |                                ',0ah,0dh
        DB '                               |   \/    \/   |                                ',0ah,0dh
        DB '                               |   /  /\  \   |                                ',0ah,0dh
        DB '                               |  /__/  \__\  |                                ',0ah,0dh
        DB '-------------------------------------------------------------------------------',0ah,0dh,'$'

		
  DELAY_STOPPING_POINT_CENTISECONDS DB 0 ;convenience variable used by the
                                         ;delay subroutine
  DELAY_INITIAL DB 0 ;another convenience variable used by the 
                     ;delay subroutine
  
  RANDOM_NUMBER DB 0 ;incremented by various events 
                     ;such as input, clock polling, etc.
  
  MUST_QUIT DB 0 ;flag indicating that the player is quitting the game
  
  CEMENT_COUNTER DB 0 ;number of frames during which a piece which
                      ;can no longer fall is allowed to still be
                      ;controlled by the player
  
  PLAYER_INPUT_PRESSED DB 0 ;flag indicating the presence of input
  
  CURRENT_PIECE_COLOR_INDEX DW 0 ;index of current color
  NEXT_PIECE_COLOR_INDEX DW 0 ;used to display next piece
  NEXT_PIECE_ORIENTATION_INDEX DW 0 ;used to display next piece
  
  PIECE_DEFINITION DW 0 ;pointer to first of the group 
                        ;of four piece orientations for this piece
  PIECE_ORIENTATION_INDEX DW 0 ;0 through 3, index of current orientation
                               ;among all of the piece's orientations
  
  PIECE_BLOCKS DW 0, 0, 0, 0 ;stores positions of blocks of current piece
  PIECE_POSITION DW 0 ;position of the top left corner of the falling 4 by 4 piece
  PIECE_POSITION_DELTA DW 0 ;frame-by-frame change in current piece position
DATASEG ENDS  
;----------------------------------------------------------- 
CODESEG SEGMENT PARA 'Code' 
  ASSUME SS:STACKSEG, DS:DATASEG, CS:CODESEG
START:
  MOV AX, DATASEG
  MOV DS, AX
  
  MENU:
  		MOV FLAG, 0
  		CALL _TITLE
  		MOV HOLE, 4
  		MOV HOLE2, 4
  		MOV HOLE3, 4
  		MOV HOLE4, 4
  		MOV PIPECOL, 0
  		MOV PIPECOL2, 0
  		MOV PIPECOL3, 0
  		MOV PIPECOL4, 0
      MOV SCORE1, 0
      MOV SCORE2, 0
      MOV SCORE, 0

_LOOP_TITLE:
    CALL _GET_KEY

	MOV		DL, TITLECURSORCOL ;col
	MOV		DH, TITLECURSORROW ;row
	CALL	_SET_CURSOR

	MOV		AL, '*'
	MOV		AH, 02H
	MOV		DL, AL
	INT		21H

	CALL	_DELAY  		

	CMP BUTTON_PRESSED2, 0DH ;enter key is pressed
  	JNE NEXTU
    JMP CHECK_OPTION
	
	NEXTU:
	CMP BUTTON_PRESSED, 4BH ;cursor moves left when left key is pressed
  	JE _LEFT
  	CMP BUTTON_PRESSED, 4DH ;cursor moves right when right key is pressed
  	JE _RIGHT
	
	JMP _LOOP_TITLE
	
	JMP EXIT
	
_RIGHT:;when right button is pressed(from right to left)
		CMP TEMP2, 4
		JE	ENDR
  		INC TEMP2
		CMP TEMP2, 1
		JE FIRSTR
		CMP TEMP2, 2
		JE FRIGHT
		CMP TEMP2, 3
		JE SRIGHT
		CMP TEMP2, 4
		JE TRIGHT

		FIRSTR:;moves cursor to the first option at the menu
		MOV TITLECURSORCOL, 02
		CALL _TITLE
		JMP ENDR

		FRIGHT:;moves cursor to the second option at the menu
		ADD TITLECURSORCOL, 0AH
		CALL _TITLE
		JMP ENDR

		SRIGHT:;moves cursor to the third option at the menu
		ADD TITLECURSORCOL, 11H
		CALL _TITLE
		JMP ENDR

		TRIGHT:;moves cursor to the last option at the menu
		ADD TITLECURSORCOL, 12H
		CALL _TITLE
		JMP ENDR

		ENDR:
		JMP _LOOP_TITLE
		
_LEFT:;when left button is pressed(from left to right)
		CMP TEMP2, 1
		JE	ENDL
		DEC TEMP2
		CMP TEMP2, 1
		JE FIRSTL
		CMP TEMP2, 2
		JE FLEFT
		CMP TEMP2, 3
		JE SLEFT
		CMP TEMP2, 4
		JE TLEFT

		FIRSTL:;moves cursor to the first option at the menu
		MOV TITLECURSORCOL, 02
		CALL _TITLE
		JMP ENDL

		FLEFT:;moves cursor to the second option at the menu
		SUB TITLECURSORCOL, 11H
		CALL _TITLE
		JMP ENDL

		SLEFT:;moves cursor to the third option at the menu
		SUB TITLECURSORCOL, 12H
		CALL _TITLE
		JMP ENDL

		TLEFT:;moves cursor to the last option at the menu
		SUB TITLECURSORCOL, 0AH
		CALL _TITLE
		JMP ENDL

		ENDL:
		JMP _LOOP_TITLE
	
	CHECK_OPTION:
		CMP TEMP2, 1
		JNE CHECKT2
        CALL INITIALIZATION

    CHECKT2:
		CMP TEMP2, 2
		JE INSTRUCTIONS
		CMP TEMP2, 3
		JE HIGHSCOREPAGE1
		JMP EXIT
		
HIGHSCOREPAGE1:
  MOV FLAG, 04
  CALL _CLEAR_SCREEN_LOAD

  MOV DL, 0
  MOV DH, 0
  CALL _SET_CURSOR
  
  CALL _PRINT_TEXT

  MOV DL, 1FH
  MOV DH, 08H
  CALL _SET_CURSOR

  LEA DX, HIGHSCORE_TEXT
  MOV AH, 09H
  INT 21H

  CALL FILEREAD
  LEA DX, READED_STR
  MOV AH, 09H
  INT 21H

  MOV DL, 0
  MOV DH, 14H
  CALL _SET_CURSOR

  LEA DX, PRESSESC
  MOV AH, 09H
  INT 21H

  LOOPER1:
  CALL _GET_KEY
  JMP LOOPER1

		
		JMP EXIT

		INSTRUCTIONS:
		MOV FLAG, 2
		CALL _CLEAR_SCREEN_LOAD
		MOV DL, 00
		MOV DH, 00
		CALL _SET_CURSOR
		LEA DX, INSTRUCT
		CALL _PRINT_TEXT

		INSTRUCTION_LOOP:
				CALL _GET_KEY
			JMP INSTRUCTION_LOOP


  JMP _LOOP_TITLE
  
  ;CALL INITIALIZATION
  
  JMP EXIT
;----------------------------------------------------------- 
;Procedures
;----------------------------------------------------------- 
HIGHSCOREPAGE PROC NEAR
  MOV FLAG, 04
  CALL _CLEAR_SCREEN_LOAD

  MOV DL, 0
  MOV DH, 0
  CALL _SET_CURSOR
  
  LEA DX, STAR
  MOV AH, 09H
  INT 21H

  MOV DL, 1FH
  MOV DH, 08H
  CALL _SET_CURSOR

  LEA DX, HIGHSCORE_TEXT
  MOV AH, 09H
  INT 21H

  CALL FILEREAD
  CALL _PRINT_TEXT

  MOV DL, 0
  MOV DH, 14H
  CALL _SET_CURSOR

  LEA DX, PRESSESC
  MOV AH, 09H
  INT 21H

  LOOPER:
  CALL _GET_KEY
  JMP LOOPER

HIGHSCOREPAGE ENDP

_PRINT_TEXT PROC NEAR
	MOV AH, 09H
	INT 21H
	RET
_PRINT_TEXT ENDP

_CLEAR_SCREEN_TITLE PROC NEAR
			MOV AX, 0600H
			MOV BH, 07H
			MOV CX, 0000H
			MOV DX, 184FH
			INT 10H
			MOV AX, 0600H
			MOV BH, 57H
			MOV CX, 0301H
			MOV DX, 0D4EH
			INT 10H
			MOV AX, 0600H
			MOV BH, 57H
			MOV CX, 0F01H
			MOV DX, 114EH
			INT 10H
			RET
_CLEAR_SCREEN_TITLE ENDP

FILEREAD PROC NEAR
  ;open file
  MOV AH, 3DH           ;requst open file
  MOV AL, 00            ;read only; 01 (write only); 10 (read/write)
  LEA DX, PATHFILENAME
  INT 21H
  ;JC DISPLAY_ERROR1
  MOV FILEHANDLE, AX

  ;read file
  MOV AH, 3FH           ;request read record
  MOV BX, FILEHANDLE    ;file handle
  MOV CX, STRLEN            ;record length
  LEA DX, READED_STR    ;address of input area
  INT 21H
  ;JC DISPLAY_ERROR2
  ;CMP AX, 00            ;zero bytes read?
  ;JE DISPLAY_ERROR3


  ;close file handle
  MOV AH, 3EH           ;request close file
  MOV BX, FILEHANDLE    ;file handle
  INT 21H

RET
FILEREAD ENDP


_GET_KEY	PROC	NEAR
			MOV		AH, 01H		;check for input
			INT		16H

			JZ		__LEAVETHIS

			MOV		AH, 00H		;get input	MOV AH, 10H; INT 16H
			INT		16H
			CMP AL, 1BH			;compares AL to 'esc'
 			;JE CHECK_2				;exits when 'esc' is pressed
 			JNE __LEAVETHIS
 			
 			CHECK_2:
 			CMP FLAG, 1
 			JLE __LEAVETHIS
 			JMP MENU

	__LEAVETHIS:
			MOV 	BUTTON_PRESSED2, AL
			MOV		BUTTON_PRESSED, AH
			RET
_GET_KEY 	ENDP

_TITLE PROC NEAR
  CALL _CLEAR_SCREEN_TITLE
 ;title
  MOV DL, 01
  MOV DH, 03H
  CALL _SET_CURSOR
  LEA DX, MESSAGE1
  CALL _PRINT_TEXT


 ;selection 
  MOV DL, 01
  MOV DH, 0FH
  CALL _SET_CURSOR
  LEA DX, MESSAGE2
  CALL _PRINT_TEXT 
  MOV DL, 03
  MOV DH, 10H
  CALL _SET_CURSOR
  LEA DX, OPTION1
  CALL _PRINT_TEXT
  MOV DL, 0DH
  MOV DH, 10H
  CALL _SET_CURSOR
  LEA DX, OPTION2
  CALL _PRINT_TEXT  
  MOV DL, 1EH
  MOV DH, 10H
  CALL _SET_CURSOR
  LEA DX, OPTION3
  CALL _PRINT_TEXT
  MOV DL, 30H
  MOV DH, 10H
  CALL _SET_CURSOR
  LEA DX, OPTION4
  CALL _PRINT_TEXT
  MOV DL, 01
  MOV DH, 11H
  CALL _SET_CURSOR
  LEA DX, MESSAGE3
  CALL _PRINT_TEXT


  RET
_TITLE ENDP

_DELAY PROC	NEAR
			MOV BP, 2 ;lower value faster
			MOV SI, 2 ;lower value faster
		DELAY2:
			DEC BP
			NOP
			JNZ DELAY2
			DEC SI
			CMP SI, 0
			JNZ DELAY2
			RET
_DELAY ENDP

_CLEAR_SCREEN_LOAD PROC NEAR
			MOV AX, 0600H
			MOV BH, 07H
			MOV CX, 0000H
			MOV DX, 184FH
			INT 10H
			RET
_CLEAR_SCREEN_LOAD ENDP

_SET_CURSOR	PROC NEAR
			;MOV DL,	;column
			;MOV DH,	;row
			MOV AH, 02H
			MOV BH, 00H
			INT 10H
			RET
_SET_CURSOR ENDP


; Convert current score to a string, and display it
PROCEDURE_DISPLAY_SCORE PROC NEAR
  ; divide by 100 and convert to the character '0', '1', '2', ... , '9',
  ; storing it in the first position of our 3-digit string buffer
  MOV AX, [SCORE]
  MOV DL, 100
  DIV DL      ; hundreds in al, remainder in ah 
  MOV CL, '0'
  ADD CL, AL
  MOV [MSG_SCORE_BUFFER], CL  ; set hundreds digit
  
  ; divide by 10 and convert to the character '0', '1', '2', ... , '9',
  ; storing it in the second position of our 3-digit string buffer
  MOV AL, AH ; divide remainder again
  XOR AH, AH
  MOV DL, 10
  DIV DL     ; tens in al, remainder in ah
  MOV CL, '0'
  ADD CL, AL
  MOV [MSG_SCORE_BUFFER + 1], CL  ; set tens digit
  
  ; convert remainder to the character '0', '1', '2', ... , '9',
  ; storing it in the third position of our 3-digit string buffer
  MOV CL, '0'
  ADD CL, AH
  MOV [MSG_SCORE_BUFFER + 2], CL ; set units digit
  
  ; display string representation of score
  MOV BX, MSG_SCORE_BUFFER
  MOV DH, 15
  MOV DL, 26
  CALL PROCEDURE_PRINT_AT
  
  RET
PROCEDURE_DISPLAY_SCORE ENDP

; Print a string at the specified location
;
; Input:
;         dh = row
;         dl = column
;         bx = address of string
PROCEDURE_PRINT_AT PROC NEAR
  ; position cursor
  PUSH BX
  MOV AH, 2
  XOR BH, BH
  INT 10H
  
  ; output string
  MOV AH, 9
  POP DX
  INT 21H
  
  RET
PROCEDURE_PRINT_AT ENDP

; Create next piece
PROCEDURE_RANDOM_NEXT_PIECE PROC FAR
  CALL PROCEDURE_DELAY ; advance random number (or seed for the initial call)
  
  ; piece index will be randomly chosen from [0, 6] inclusive
  MOV BL, 7
  CALL PROCEDURE_GENERATE_RANDOM_NUMBER ; choose a piece (in ax)
  MOV [NEXT_PIECE_COLOR_INDEX], AX ; save colour index
  
  ; orientation will be randomly chosen from [0, 3] inclusive
  MOV BL, 4
  CALL PROCEDURE_GENERATE_RANDOM_NUMBER ; choose one of four piece orientations (in ax)
  
  MOV [NEXT_PIECE_ORIENTATION_INDEX], AX
  
  RET
PROCEDURE_RANDOM_NEXT_PIECE ENDP

; Attempt to find and remove one line by scanning upwards from the bottom of 
; the play area. As soon as the first full line is found, all lines above it 
; are shifted one line down.
; Finally, the top line in the play area is cleared.
;
; Note: "line" here means a one-pixel tall horizontal line, and NOT a line
;        which is as tall as a block
;
; Output:
;        al - number of lines cleared
PROCEDURE_ATTEMPT_LINE_REMOVAL PROC FAR
  PUSH CX
  
  ; start at bottom left position of play area
  MOV DI, 47815
  MOV CX, 104 ; we'll check at most all but one lines of the play area
                ; there are 20 block lines, and each block line is 5 pixels 
                ; tall with an additional top line to accomodate pieces with 
                ; an empty top block line in some of their orientations
  
  ; for each line moving upwards
  ATTEMPT_LINE_REMOVAL_LOOP:
    ; if this line is full (no black pixels), we will shift all lines above it
    ; down by one line each
    CALL PROCEDURE_IS_HORIZONTAL_LINE_FULL
	TEST AL, AL
	JZ ATTEMPT_LINE_REMOVAL_FULL_LINE_FOUND
	
	; this line isn't full (it has gaps), so continue with next line above
	SUB DI, [SCREEN_WIDTH]
	LOOP ATTEMPT_LINE_REMOVAL_LOOP
	
	; no completely full lines has been found
	JMP ATTEMPT_LINE_REMOVAL_NO_LINE_FOUND
	
	ATTEMPT_LINE_REMOVAL_FULL_LINE_FOUND:
	; di now points to the left most pixel of the full line we're removing
    ; and cx takes our next loop to the second line from the top (inclusive)
	
	  ATTEMPT_LINE_REMOVAL_SHIFT_LINES_DOWN_LOOP:
	    ; save outer loop (for each line, going upwards)
	    PUSH CX
		PUSH DI
		
		; set source pointer for the memory copy operation to be one line above
        ; our current line
		MOV SI, DI
		SUB SI, [SCREEN_WIDTH] ; line above (source)
		; destination pointer for the memory copy operation is in di, and is 
        ; set to the current line, as it should be
		
		; memory copy operation will execute 50 times, going pixel-by-pixel to the
        ; right, copying the line above current line into current line
		MOV CX, 50
		
		; execute memory copy operation within the video memory segment, restoring
        ; data segments after
		PUSH DS
		PUSH ES
		MOV AX, 0A000H ; we'll be reading and writing within the video segment
		MOV DS, AX ; so source segment will be this segment as well
		MOV ES, AX ; and so will the destination segment
		REP MOVSB
		POP ES
		POP DS
		
		; restore outer loop (for each line, going upwards)
		POP DI
		POP CX
		
		; next line (upwards)
		SUB DI, [SCREEN_WIDTH] ; move one line up
		
		LOOP ATTEMPT_LINE_REMOVAL_SHIFT_LINES_DOWN_LOOP
		
		; after the last iteration of our shift-lines-down-by-one loop, 
        ; di is at the beginning of the top most line; this is exactly where we 
        ; need it in order to empty (set all pixels to black) the top-most line
		XOR DL, DL
		MOV CX, 50
		CALL PROCEDURE_DRAW_LINE ; empty the top most line
		
		; return the fact that we did clear one line
		MOV AL, 1
		JMP ATTEMPT_LINE_REMOVAL_DONE
		
	  ATTEMPT_LINE_REMOVAL_NO_LINE_FOUND:
	    ; return the fact that no lines were cleared
	    XOR AL, AL
		
	ATTEMPT_LINE_REMOVAL_DONE:
	  POP CX
	  RET
PROCEDURE_ATTEMPT_LINE_REMOVAL ENDP

; Check a line to see whether it is full (meaning it contains no black pixels)
;
; Input:
;        di - position
; Output:
;        al - 0 if line is full
PROCEDURE_IS_HORIZONTAL_LINE_FULL PROC NEAR
  PUSH CX
  PUSH DI
  
  ; for each pixel, going to the right, starting at di
  MOV CX, 50 ; width of play area is 10 blocks
  
  IS_HORIZONTAL_LINE_FULL_LOOP:
    ; if current pixel is black, then this line cannot be full
    CALL PROCEDURE_READ_PIXEL
	TEST DL, DL ; is colour at current location black?
	JZ IS_HORIZONTAL_LINE_FULL_FAILURE
	
	; next pixel
	INC DI ; next pixel of this line
	LOOP IS_HORIZONTAL_LINE_FULL_LOOP
	
	; if we got here, it means we haven't found any black pixels, so the line 
    ; is full; ax is set accordingly to return the fact that the line is full
	XOR AX, AX
	JMP IS_HORIZONTAL_LINE_FULL_LOOP_DONE
	
  IS_HORIZONTAL_LINE_FULL_FAILURE:
    ; return the fact that the line isn't full
    MOV AL, 1
	
  IS_HORIZONTAL_LINE_FULL_LOOP_DONE:
    POP DI
	POP CX
	
  RET
PROCEDURE_IS_HORIZONTAL_LINE_FULL ENDP

; Generate a random number between 0 and N-1 inclusive
;
; Input:
;        bl - N
; Output:
;        ax - random number
PROCEDURE_GENERATE_RANDOM_NUMBER PROC NEAR
  ; advance random number
  MOV AL, [RANDOM_NUMBER]
  ADD AL, 31
  MOV [RANDOM_NUMBER], AL
  
  ; divide by N and return remainder
  DIV BL ; divide by N
  MOV AL, AH ; save remainder in al
  XOR AH, AH
  
  RET
PROCEDURE_GENERATE_RANDOM_NUMBER ENDP

; Change current piece orientation to the 
; orientation specified in [piece_orientation_index]
PROCEDURE_COPY_PIECE PROC NEAR
  PUSH DS
  PUSH ES
  
  ; both source and destination segments will be the same as the code segment
  MOV AX, CS ; all code is within this segment
  MOV DS, AX ; so source segment will be this segment as well
  MOV ES, AX ; and so will the destination segment
  
  ; destination of memory copy operation is the current piece blocks array
  MOV DI, PIECE_BLOCKS ; pointer to current orientation (destination)
  
  ; source of memory copy operation is the current piece origin, offset by
  ; the orientation specified in [piece_orientation_index]
  MOV AX, [PIECE_ORIENTATION_INDEX] ; choose k-th orientation of this piece ( 0 through 3 )
  
  MOV SI, [PIECE_DEFINITION] ; piece_definition is a pointer to first orientation of current piece (source)
  
  PUSH CX
  MOV CL, 3
  SHL AX, CL
  POP CX
  
  ADD SI, AX
  
  ; copy each of the four blocks
  MOV CX, 4
  
  REP MOVSW ; perform copy
  
  POP ES
  POP DS
  
  RET
PROCEDURE_COPY_PIECE ENDP

; Applies a movement delta (causing either vertical or horizontal movement of
; the current piece
PROCEDURE_APPLY_DELTA_AND_DRAW_PIECE PROC FAR
  ; erase old piece
  MOV DL, 0
  CALL PROCEDURE_DRAW_PIECE
  
  ; apply delta
  MOV AX, [PIECE_POSITION]
  ADD AX, [PIECE_POSITION_DELTA]
  MOV [PIECE_POSITION], AX
  
  ; draw new piece
  MOV BX, [CURRENT_PIECE_COLOR_INDEX]
  SHL BX, 1 ;two bytes per color
  MOV DL, [COLOR_FALLING_PIECE + BX]
  CALL PROCEDURE_DRAW_PIECE
  
  RET
PROCEDURE_APPLY_DELTA_AND_DRAW_PIECE ENDP

; Draw the blocks within the current piece at current position
;
; Input:
;        dl - color
PROCEDURE_DRAW_PIECE PROC NEAR
  ; for each of the piece's four blocks
  MOV CX, [BLOCKS_PER_PIECE]
  
  DRAW_PIECE_LOOP:
    ; set di to the origin (top left corner) of this piece
    MOV DI, [PIECE_POSITION]
	
	; and then offset it to the origin (top left corner) of the current block
	MOV BX, CX
	SHL BX, 1
	SUB BX, 2
	ADD DI, [PIECE_BLOCKS + BX] ; shift position in the piece to the position of current block
	
	; di now points to the origin of the current block, so we can draw it
	MOV BX, [BLOCK_SIZE]
	CALL PROCEDURE_DRAW_SQUARE
	
	; next block of this piece
	LOOP DRAW_PIECE_LOOP
	
  RET
PROCEDURE_DRAW_PIECE ENDP

; Checks if current piece can be placed in its current position
; This can be used to check if we can still spawn pieces (whether the
; game has ended), or if we can rotate a certain piece (since existing
; "cemented" blocks could be in the way, or we could be too close to the
; edge or bottom)
;
; Output
;        al - 0 if piece can be placed at current location
PROCEDURE_CAN_PIECE_BE_PLACED PROC FAR
  ; for each of the piece's four blocks
  MOV CX, [BLOCKS_PER_PIECE] ; each piece has 4 blocks
  
  CAN_PIECE_BE_PLACED_LOOP:
    ; set di to the origin (top left corner) of this piece
    MOV DI, [PIECE_POSITION]
	
	; and then offset it to the origin (top left corner) of the current block
	MOV BX, CX
	SHL BX, 1
	SUB BX, 2
	ADD DI, [PIECE_BLOCKS + BX] ; shift position in the piece to the position of current block
	
	; preserve outer loop (for each block of current piece)
	PUSH CX ; don't mess up the outer loop
	
	; inner loop will check horizontal lines, so the pixel increment is 1
	MOV BX, 1 ; horizontal lines
	
	; di now points to the first horizontal line of this block
	
	; for each of this block's horizontal lines
	MOV CX, [BLOCK_SIZE]
	
  CAN_PIECE_BE_PLACED_LINE_BY_LINE_LOOP:
    ; if current line is not available, we cannot place this piece
    CALL PROCEDURE_IS_LINE_AVAILABLE
	TEST AL, AL ; a non-zero indicates an obstacle
	JNE CAN_PIECE_BE_PLACED_FAILURE
	
	; next horizontal line of this block
	ADD DI, [SCREEN_WIDTH]
	LOOP CAN_PIECE_BE_PLACED_LINE_BY_LINE_LOOP
	
	; restore outer loop (for each block of current piece)
	POP CX
	
	; next block of this piece
	LOOP CAN_PIECE_BE_PLACED_LOOP
	
	; we've checked all blocks of this piece, and they can all be placed, so
    ; then the piece itself can be placed
    ; set ax to return the fact that this piece can be placed here
	XOR AX, AX
	JMP CAN_PIECE_BE_PLACED_SUCCESS
	
  CAN_PIECE_BE_PLACED_FAILURE:
    ; return the fact that this piece cannot be placed here
    MOV AL, 1
	
	; we broke out of the inner loop, so didn't pop cx for the outer loop
    ; and we must not corrupt stack
	POP CX
	
  CAN_PIECE_BE_PLACED_SUCCESS:
    RET
PROCEDURE_CAN_PIECE_BE_PLACED ENDP

; Advances orientation index, and copies the new orientation to 
; make it current, as needed by a rotation
PROCEDURE_ADVANCE_ORIENTATION PROC FAR
   ; advance index within [0, 3], cycling back to 0 from 3
  MOV AX, [PIECE_ORIENTATION_INDEX]
  INC AX
  AND AX, 3
  MOV [PIECE_ORIENTATION_INDEX], AX
  
  ; copy new orientation in the current piece
  CALL PROCEDURE_COPY_PIECE
  
  RET
PROCEDURE_ADVANCE_ORIENTATION ENDP

; Read keyboard input and act accordingly
PROCEDURE_READ_CHARACTER PROC NEAR
  ; check if any key is pressed
  MOV AH, 1
  INT 16H ; any keys pressed?
  JNZ READ_CHARACTER_KEY_WAS_PRESSED ; yes
  
  ; no keys pressed
  RET
  
  READ_CHARACTER_KEY_WAS_PRESSED:
    ; ALTERNATIVELY, read via 60h
    ; in al, 60h
    ; and change SCAN CODES matching

	; read key from buffer
    MOV AH, 0
	INT 16H
	
	; clear keyboard buffer
	PUSH AX
	MOV AH, 6 ; direct console I/O
	MOV DL, 0FFH ; input mode
	INT 21H
	POP AX
	
	HANDLE_INPUT:
	  ; check whether right was pressed
	  CMP AL, 's'
	  JE MOVE_RIGHT
	  ; check whether left was pressed
	  CMP AL, 'a'
	  JE MOVE_LEFT
	  ; check whether rotate was pressed
	  CMP AL, ' '
	  JE ROTATE
	  ; check whether quit was pressed
	  CMP AL, 'q'
	  JE QUIT
	  
	  ; an unknown key was pressed
	  RET
	
	QUIT:
	  ; indicate that the main loop should end, and we should exit the game
	  MOV [MUST_QUIT], 1
	  RET
	  
	ROTATE:
	  ; save old orientation, in case we cannot rotate
	  PUSH [PIECE_ORIENTATION_INDEX]
	  
	  ; change to next orientation 
	  CALL PROCEDURE_ADVANCE_ORIENTATION
	  
	  ; see if new orientation can be placed
	  CALL PROCEDURE_CAN_PIECE_BE_PLACED
	  TEST AL, AL ; did we get a 0, meaning ok
	  JZ ROTATE_PERFORM ; yes
	  
	  ; new orientation cannot be placed, so restore old orientation
	  POP [PIECE_ORIENTATION_INDEX]
	  CALL PROCEDURE_COPY_PIECE
	  
	  RET
	  
	ROTATE_PERFORM:
	  ; new orientation can be placed
	  
	  ; restore old orientation, so we can clear it
	  POP [PIECE_ORIENTATION_INDEX]
	  CALL PROCEDURE_COPY_PIECE
	  
	  ; draw old orientation in black to clear it
	  XOR DL, DL ;BLACK COLOR
	  CALL PROCEDURE_DRAW_PIECE
	  ; change to next orientation 
	  CALL PROCEDURE_ADVANCE_ORIENTATION
	  ; advance random number
	  MOV AL, [RANDOM_NUMBER]
	  ADD AL, 11
	  MOV [RANDOM_NUMBER], AL
	  
	  RET
	  
	MOVE_RIGHT:
	  ; set player input flag
	  MOV [PLAYER_INPUT_PRESSED], 1
	  
	  ; determine if we can move right
	  
	  ; for each of the piece's four blocks
	  MOV CX, [BLOCKS_PER_PIECE]
	  MOVE_RIGHT_LOOP:
	    ; set di to the origin (top left corner) of this piece
	    MOV DI, [PIECE_POSITION]
		
		; and then offset it to the origin (top left corner) of the current block
		MOV BX, CX
		SHL BX, 1
		SUB BX, 2
		ADD DI, [PIECE_BLOCKS + BX] ; shift position in the piece to the position of current block
		
		; position di immediately to the right of the end of the block's first line
		ADD DI, [BLOCK_SIZE]
		
		; set pixel increment to screen width, meaning a vertical line, and check
        ; whether the vertical line immediately to the right of block is available
		MOV BX, [SCREEN_WIDTH]
		CALL PROCEDURE_IS_LINE_AVAILABLE
		
		; if line is not available, we cannot move
		TEST AL, AL ; did we get a 0, meaning success ?
		JNZ MOVE_RIGHT_DONE ; no
		
		; next block of this piece
		LOOP MOVE_RIGHT_LOOP
		
		; we are moving right, so set piece position delta adequately
		MOV AX, [PIECE_POSITION_DELTA]
		ADD AX, [BLOCK_SIZE]
		MOV [PIECE_POSITION_DELTA], AX
		
	  MOVE_RIGHT_DONE:
	    ; advance random number
	    MOV AL, [RANDOM_NUMBER]
	    ADD AL, 3
	    MOV [RANDOM_NUMBER], AL
	  
	    RET
	MOVE_LEFT:
	; set player input flag
	  MOV [PLAYER_INPUT_PRESSED], 1
	  
	  ; determine if we can move left
	  
	  ; for each of the piece's four blocks
	  MOV CX, [BLOCKS_PER_PIECE]
	  MOVE_LEFT_LOOP:
	    ; set di to the origin (top left corner) of this piece
	    MOV DI, [PIECE_POSITION]
		
		; and then offset it to the origin (top left corner) of the current block
		MOV BX, CX
		SHL BX, 1
		SUB BX, 2
		ADD DI, [PIECE_BLOCKS + BX] ; shift position in the piece to the position of current block
		
		; position di immediately to the left of the block's origin (top left)
		DEC DI
		
		; set pixel increment to screen width, meaning a vertical line, and check
        ; whether the vertical line immediately to the left of block is available
		MOV BX, [SCREEN_WIDTH]
		CALL PROCEDURE_IS_LINE_AVAILABLE
		
		; if line is not available, we cannot move
		TEST AL, AL ; did we get a 0, meaning success ?
		JNZ MOVE_LEFT_DONE ; no 
		
		; next block of this piece
		LOOP MOVE_LEFT_LOOP
		
		; we are moving left, so set piece position delta adequately
		MOV AX, [PIECE_POSITION_DELTA]
		SUB AX, [BLOCK_SIZE]
		MOV [PIECE_POSITION_DELTA], AX
		
	  MOVE_LEFT_DONE:
	    ; advance random number
	    MOV AL, [RANDOM_NUMBER]
		ADD AL, 5
		MOV [RANDOM_NUMBER], AL
		
		RET
PROCEDURE_READ_CHARACTER ENDP

; Given a position, check if a block with the origin at that position
; can move downward one pixel
;
; Input:
;        di - position
; Output:
;        al - 0 if can move
PROCEDURE_CAN_MOVE_DOWN PROC FAR
  PUSH CX
  PUSH DI
  
  ; position di right underneath block's left most bottom pixel
  MOV CX, [BLOCK_SIZE]
  
  CAN_MOVE_DOWN_FIND_DELTA:
    ADD DI, [SCREEN_WIDTH]
	LOOP CAN_MOVE_DOWN_FIND_DELTA
	
	; set pixel increment to one, meaning a horizontal line, and check
    ; whether the horizontal line immediately below the block is available
	MOV BX, 1
	CALL PROCEDURE_IS_LINE_AVAILABLE
	
	; if line is not available, this block cannot move down
	TEST AL, AL ; did we get a 0, meaning success ?
	JNZ CAN_MOVE_DOWN_OBSTACLE_FOUND ;NO
	
	; this block can move down, so return this fact
	XOR AX, AX
	JMP CAN_MOVE_DOWN_DONE
	
  CAN_MOVE_DOWN_OBSTACLE_FOUND:
    ; return the fact that this block cannot move down
    MOV AX, 1

  CAN_MOVE_DOWN_DONE:
    POP DI
	POP CX
	
	RET
PROCEDURE_CAN_MOVE_DOWN ENDP

; Check if a line of length [block_size] is available. 
; An available line can only contain either:
;    - black pixels, or
;    - pixels of the same colour as the falling block
;
; Input:
;        di - position (beginning of line to check)
;        bx - pixel increment (can be used to change between horizontal
;                 and vertical lines
; Output:
;        al - 0 if line is available, 1 otherwise	
PROCEDURE_IS_LINE_AVAILABLE PROC NEAR
  PUSH BX
  PUSH CX
  PUSH DI
  
  ; for each pixel of this line
  MOV CX, [BLOCK_SIZE]
  
  IS_LINE_AVAILABLE_LOOP:
    ; if current pixel is not black, we found an obstacle
    CALL PROCEDURE_READ_PIXEL
	TEST DL, DL ; is colour at current location black?
	JNZ IS_LINE_AVAILABLE_OBSTACLE_FOUND
	
	; current pixel is black, so continue with next pixel of this line
	IS_LINE_AVAILABLE_LOOP_NEXT_PIXEL:
	  ADD DI, BX ; move to next pixel of this line
	  LOOP IS_LINE_AVAILABLE_LOOP
	  
	   ; if we got here, it means that all pixels are either black or of the same
       ; colour as the current piece, so we return success
	  XOR AX, AX
	  JMP IS_LINE_AVAILABLE_LOOP_DONE
	  
	  ; one of the pixels of this line was not black
	IS_LINE_AVAILABLE_OBSTACLE_FOUND:
	  ; if this pixel is not the same colour as the falling piece, this line is
    ; not available
	  PUSH BX
	  MOV BX, [CURRENT_PIECE_COLOR_INDEX]
	  SHL BX, 1 ; two bytes per colour
	  MOV AL, [COLOR_FALLING_PIECE + BX]
	  CMP DL, AL ; if obstacle is a falling block, treat it as a non-obstacle
	  POP BX
	  JNE IS_LINE_AVAILABLE_FAILURE
	  
	  ; this pixel isn't black, but is of the same colour as the falling piece
    ; so we don't fail because of it, and we resume loop
	  JMP IS_LINE_AVAILABLE_LOOP_NEXT_PIXEL
	  
	IS_LINE_AVAILABLE_FAILURE:
	  ; return the fact that this line is not available
	  MOV AL, 1
	  
	IS_LINE_AVAILABLE_LOOP_DONE:
	  POP DI
	  POP CX
	  POP BX
	  
	  RET
PROCEDURE_IS_LINE_AVAILABLE ENDP

; Creates a delay lasting a specified number of centiseconds
PROCEDURE_DELAY PROC NEAR
  PUSH BX
  PUSH CX
  PUSH DX
  PUSH AX
  
  ; read current system time
  XOR BL, BL
  MOV AH, 2CH
  INT 21H
  
   ; advance random number
  MOV AL, [RANDOM_NUMBER]
  ADD AL, DL
  MOV [RANDOM_NUMBER], AL
  
  ; store second
  MOV [DELAY_INITIAL], DH
  
  ; calculate stopping point, and do not adjust if the stopping point is in
  ; the next second
  ADD DL, [DELAY_CENTISECONDS]
  CMP DL, 100
  JB DELAY_SECOND_ADJUSTMENTS_DONE
  
  ; stopping point will cross into next second, so adjust
  SUB DL, 100
  MOV BL, 1
  
  DELAY_SECOND_ADJUSTMENTS_DONE:
    ; save stopping point in centiseconds
    MOV [DELAY_STOPPING_POINT_CENTISECONDS], DL
	
  READ_TIME_AGAIN:
    ; read system time again
    INT 21H
	
	 ; if we have to stop within the same second, ensure we're still within the
    ; same second
	TEST BL, BL ; will we stop within the same second?
	JE MUST_BE_WITHIN_SAME_SECOND
	
	; second will change, so we keep polling if we're still within
    ; the same second as when we started
	CMP DH, [DELAY_INITIAL]
	JE READ_TIME_AGAIN
	
	; if we're more than one second later than the second read when we entered
    ; the delay procedure, we have to stop
	PUSH DX
	SUB DH, [DELAY_INITIAL]
	CMP DH, 2
	POP DX
	JAE DONE_DELAY
	
	; we're exactly one second after the initial second (when we entered the 
    ; delay procedure, which is where we expect the stopping point; therefore,
    ; we need to check if we've reached the stopping point
	JMP CHECK_STOPPING_POINT_REACHED
	
	MUST_BE_WITHIN_SAME_SECOND:
	  ; since we expect to stop within the same second, if current second is not
      ; what we already saved in delay_initial, then we're done
	  CMP DH, [DELAY_INITIAL]
	  JNE DONE_DELAY
	  
	CHECK_STOPPING_POINT_REACHED:
	  ; keep reading system time if the current centisecond is below our stopping
    ; point in centiseconds
	  CMP DL, [DELAY_STOPPING_POINT_CENTISECONDS]
	  JB READ_TIME_AGAIN
	  
	DONE_DELAY:
	  POP AX
	  POP DX
	  POP CX
	  POP BX
	  
	  RET
PROCEDURE_DELAY ENDP

; Draw a rectangle at the specified location and using the specified colour
;
; Input:
;        ax - height
;        bx - width
;        di - position
;        dl - colour
PROCEDURE_DRAW_RECTANGLE PROC FAR
  PUSH DI
  PUSH DX
  PUSH CX
  
  ; for each horizontal line (there are [height] of them)
  MOV CX, AX
  
  DRAW_RECTANGLE_LOOP:
    ; draw a bx wide horizontal line
    PUSH CX
	PUSH DI
	MOV CX, BX
	CALL PROCEDURE_DRAW_LINE
	
	; restore di to the beginning of this line
	POP DI
	; move di down one line, to the beginning of the next line
	ADD DI, [SCREEN_WIDTH]
	; restore loop counter
	POP CX
	 ; next horizontal line
	LOOP DRAW_RECTANGLE_LOOP
	
	POP CX
	POP DX
	POP DI
	
	RET
PROCEDURE_DRAW_RECTANGLE ENDP

; Draw a square at the specified location and using the specified colour
;
; Input:
;        bx - size of square
;        di - position
;        dl - colour
PROCEDURE_DRAW_SQUARE PROC
  ; draw a rectangle whose height equals its width
  MOV AX, BX
  CALL PROCEDURE_DRAW_RECTANGLE
  
  RET
PROCEDURE_DRAW_SQUARE ENDP

; Draw a horizontal line
;
; Input: 
;        cx - line length
;        di - position
;        dl - colour
PROCEDURE_DRAW_LINE PROC NEAR
  CALL PROCEDURE_DRAW_PIXEL
  ; move di one pixel to the right
  INC DI
  ; next pixel
  LOOP PROCEDURE_DRAW_LINE
  
  RET
PROCEDURE_DRAW_LINE ENDP

; Draw a vertical line
;
; Input: 
;        cx - line length
;        di - position
;        dl - colour
PROCEDURE_DRAW_LINE_VERTICAL PROC FAR
  CALL PROCEDURE_DRAW_PIXEL
  ; move di one pixel down
  ADD DI, [SCREEN_WIDTH]
  ; next pixel
  LOOP PROCEDURE_DRAW_LINE_VERTICAL
  
  RET
PROCEDURE_DRAW_LINE_VERTICAL ENDP

; Draw a pixel
;
; Input: 
;        di - position
;        dl - colour
PROCEDURE_DRAW_PIXEL PROC NEAR
  PUSH AX
  PUSH ES
  
  ; set A000:di to the specified colour
  MOV AX, 0A000H
  MOV ES, AX
  MOV ES:[DI], DL
  
  POP ES
  POP AX
  
  RET
PROCEDURE_DRAW_PIXEL ENDP

; Read a pixel's colour
;
; Input:
;        di - position
; Output:
;        dl - colour
PROCEDURE_READ_PIXEL PROC NEAR
  PUSH AX
  PUSH ES
  ; read byte at A000:di
  MOV AX, 0A000H
  MOV ES, AX
  MOV DL, ES:[DI]
  
  POP ES
  POP AX
  
  RET
PROCEDURE_READ_PIXEL ENDP

; Draw a border around the entire screen
PROCEDURE_DRAW_BORDER PROC FAR
  MOV DL, 200 ;COLOR
  
  MOV BX, 4
  MOV AX, 200
  ; top left to bottom left
  XOR DI, DI
  CALL PROCEDURE_DRAW_RECTANGLE
  
  ; top right to bottom right
  MOV DI, 316
  CALL PROCEDURE_DRAW_RECTANGLE
  
  MOV BX, 317
  MOV AX, 4
  ; top left to top right
  XOR DI, DI
  CALL PROCEDURE_DRAW_RECTANGLE
  ; bottom left to bottom right
  MOV DI, 62720
  CALL PROCEDURE_DRAW_RECTANGLE
  
  RET
PROCEDURE_DRAW_BORDER ENDP

; Decorate the screen with the play area, border, controls, author, etc.  
PROCEDURE_DRAW_SCREEN PROC FAR
  CALL PROCEDURE_DRAW_BORDER
  
  DRAW_SCREEN_PLAY_AREA:
    ; draw the box within which pieces fall and the game is played
    MOV DL, 27 ;COLOR
	
	; top left to top right
	MOV CX, 52
	MOV DI, 14214
	CALL PROCEDURE_DRAW_LINE
	
	; bottom left to bottom right
	MOV CX, 52
	MOV DI, 48134
	CALL PROCEDURE_DRAW_LINE
	
	; top left to bottom left
	MOV CX, 105
	MOV DI, 14534
	CALL PROCEDURE_DRAW_LINE_VERTICAL
	
	; top right to bottom right
	MOV CX, 105
	MOV DI, 14585
	CALL PROCEDURE_DRAW_LINE_VERTICAL
	
  DRAW_SCREEN_NEXT_PIECE_AREA:
  ; draw the box within which the next piece is displayed
  
    ; top left to top right
    MOV DI, 16199
	MOV CX, 31
	CALL PROCEDURE_DRAW_LINE
	; bottom left to bottom right
	MOV DI, 25799
	MOV CX, 31
	CALL PROCEDURE_DRAW_LINE
	; top left to bottom left
	MOV DI, 16199
	MOV CX, 31
	CALL PROCEDURE_DRAW_LINE_VERTICAL
	; top right to bottom right
	MOV DI, 16230
	MOV CX, 31
	CALL PROCEDURE_DRAW_LINE_VERTICAL
	
  DRAW_SCREEN_STRINGS:
    ; display author string
    MOV DH, 21
	MOV DL, 4
	MOV BX, MSG_AUTHOR
	CALL PROCEDURE_PRINT_AT
	; display "Next" string
	MOV DH, 11
	MOV DL, 25
	MOV BX, MSG_NEXT
	CALL PROCEDURE_PRINT_AT
	; display "left" string
	MOV DH, 8
	MOV DL, 4
	MOV BX, MSG_LEFT
	CALL PROCEDURE_PRINT_AT
	; display "right" string
	MOV DH, 10
	MOV DL, 4
	MOV BX, MSG_RIGHT
	CALL PROCEDURE_PRINT_AT
	; display "rotate" string
	MOV DH, 12
	MOV DL, 4
	MOV BX, MSG_ROTATE
	CALL PROCEDURE_PRINT_AT
	; display "quit" string
	MOV DH, 14
	MOV DL, 4
	MOV BX, MSG_QUIT
	CALL PROCEDURE_PRINT_AT
	; display "Lines" string
	MOV BX, MSG_LINES
	MOV DH, 16
	MOV DL, 24
	CALL PROCEDURE_PRINT_AT
	; display game name string
	MOV BX, MSG_TETRIS
	MOV DH, 3
	MOV DL, 16
	CALL PROCEDURE_PRINT_AT
	
	RET
PROCEDURE_DRAW_SCREEN ENDP  
 
; Display the game's animated logo 
PROCEDURE_DISPLAY_LOGO PROC NEAR
  ; redraw animated logo only once every four frames
  MOV AX, [CURRENT_FRAME]
  AND AX, 3
  JZ DISPLAY_LOGO_BEGIN
  
  RET
  
  DISPLAY_LOGO_BEGIN: 
  ; start at the top left corner of where the logo will be rendered
    MOV DI, 4905
	; for each of the 20 coloured squares on the horizontal
	MOV CX, 20
	DISPLAY_LOGO_HORIZONTAL_LOOP:
	 ; oscillate ax between 0 and 1 every 8 frames
	  MOV AX, [CURRENT_FRAME]
	  AND AX, 8
	  
	  PUSH CX
	  MOV CL, 3
	  
	  SHR AL, CL
	  
	  ; also use use whether di is even or odd to alternate; this works because
    ; since we start with an odd value of di, and the size of each square is
    ; also odd, then each alternating square will have alternating odd and even
    ; values of di
	  ADD AX, DI
	  AND AL, 1
	  
	  ; we'll alternate between two colours in the palette which are eight slots
    ; apart
	  SHL AL, CL
	  
	  POP CX
	  
	  ; convert to colour (we'll use colours 192 and 200 alternating), then draw
	  ADD AL, 192
	  MOV DL, AL
	  MOV BX, 5
	  CALL PROCEDURE_DRAW_SQUARE
	  
	  ; save di, and then move to the square directly below, 
    ; on the lower horizontal
	  PUSH DI
	  ADD DI, 6400
	  
	  ; draw a square with parameters other than position like on top horizontal
	  CALL PROCEDURE_DRAW_SQUARE
	  
	  ; restore di, advance to the next square to the right, and 
    ; loop to process next square
	  POP DI
	  ADD DI, BX
	  LOOP DISPLAY_LOGO_HORIZONTAL_LOOP
	  
	  ; move back to the top left corner of where the logo will be rendered
	  MOV DI, 4905
	  
	  ; for each of the 5 coloured squares on the vertical
	MOV CX, 5
	DISPLAY_LOGO_VERTICAL_LOOP:
	; oscillate ax between 0 and 1 every 8 frames, and save the binary value
      MOV AX, [CURRENT_FRAME]
      AND AX, 8
	  
	  PUSH CX
	  MOV CL, 3
	  
	  SHR AL, CL
	  PUSH AX
	  
	  ; since each vertical square is on a different 320 pixel wide horizontal
    ; line, we can alternate colours based on the quotient of di/320
	
	  ; divide di by 160
	  MOV AX, DI
	  MOV BL, 160
	  DIV BL
	  ; divide again by 2
	  XOR AH, AH
	  SHR AX, 1
	  ; quotient oscillates between odd and even; save that as 0 or 1 in al
	  AND AL, 1
	  
	  ; combine with the oscillating 0/1 value we calculated from current frame
	  POP BX
	  ADD AL, BL
	  AND AL, 1
	  
	  ; we'll alternate between two colours in the palette which are eight slots apart
	  SHL AL, CL
	  
	  POP CX
	  
	  ; convert to colour (we'll use colours 192 and 200 alternating), then draw
	  ADD AL, 192
	  MOV DL, AL
	  MOV BX, 5
	  CALL PROCEDURE_DRAW_SQUARE
	  
	  ; save di, and then move to the square directly to the right, 
    ; on the right hand side vertical
	  PUSH DI
	  ADD DI, 100
	  
	  ; draw a square with parameters other than position like on 
    ; the left hand side vertical
	  CALL PROCEDURE_DRAW_SQUARE
	  
	  ; restore di, advance to the next square below, and 
    ; loop to process next square
	  POP DI
	  ADD DI, 1600
	  LOOP DISPLAY_LOGO_VERTICAL_LOOP
	  
	  RET
PROCEDURE_DISPLAY_LOGO ENDP

; _SET_CURSOR PROC NEAR
  ; MOV AH, 02H
  ; MOV BH, 00H
  ; INT 10H
  ; RET
; _SET_CURSOR ENDP

; Hide controls used during game play, and draw "game over" panel overlay
PROCEDURE_DISPLAY_GAME_OVER PROC FAR
  ; MOV AX, 3
  ; INT 10H
  
  ; MOV DL, 00
  ; MOV DH, 05
  ; CALL _SET_CURSOR
  
  ; hide left/right/rotate controls by drawing a black rectangle on top
  xor dl, dl
    mov ax, 45
    mov bx, 100
    mov di, 19550
    call procedure_draw_rectangle
	
	; draw "game over" panel
    mov dl, 40
    mov ax, 16
    mov bx, 88
    mov di, 29560
    call procedure_draw_rectangle
	
	; draw "game over" message
  mov dh, 12
    mov dl, 16
    mov bx, msg_game_over
    call procedure_print_at	
  ; LEA DX, MSG_GAME_OVER
  ; MOV AH, 09H
  ; INT 21H
  
  RET
PROCEDURE_DISPLAY_GAME_OVER ENDP
  
INITIALIZATION PROC NEAR
    ; enter graphics mode 13h, 320x200 pixels 8bit colour
    MOV AX, 13H
    INT 10H
    ; set keyboard parameters to be most responsive
    MOV AX, 0305H
    XOR BX, BX
    INT 16H
	
    ; generate initial piece
    CALL PROCEDURE_RANDOM_NEXT_PIECE
    ; display controls, play area, borders, etc.
    CALL PROCEDURE_DRAW_SCREEN
;Generate a new piece and refresh next piece 
  NEW_PIECE:
    ; since we're generating a new block, a piece has just cemented, which
    ; means that there may be updates to the score due to lines potentially 
    ; being cleared by that last piece
    CALL PROCEDURE_DISPLAY_SCORE
	
	; start falling from the middle of the top of the play area
	MOV [PIECE_POSITION], 14550
	
	; next piece colour index becomes current
	MOV AX, [NEXT_PIECE_COLOR_INDEX]
	MOV [CURRENT_PIECE_COLOR_INDEX], AX
	
	;setting CL to 5 to be used for shift left
	PUSH CX
	MOV CL, 5
	; colours array and pieces array have corresponding entries, so use colours
    ; index to set the piece index as well, but it has to be offset by as many
    ; bytes as each piece occupies
	SHL AX, CL
	ADD AX, OFFSET PIECES_ORIGIN ; offset from first piece
	MOV [PIECE_DEFINITION], AX ; piece_definition now points to the first of 
                               ; four piece orientations of a specific piece
	
	; next piece becomes current
	MOV AX, [NEXT_PIECE_ORIENTATION_INDEX] 
	MOV [PIECE_ORIENTATION_INDEX], AX ;choose one of the four orientations
	
	CALL PROCEDURE_COPY_PIECE
	; can this piece even spawn?
	CALL PROCEDURE_CAN_PIECE_BE_PLACED
	TEST AL, AL ; did we get a 0, meaning "can move"?
	JZ NOT_GAME_OVER ; yes, proceed to not_game_over
	
	GAME_OVER1:
	  CALL PROCEDURE_DISPLAY_GAME_OVER
	  
	  GAME_OVER_LOOP2:
	  CALL PROCEDURE_DISPLAY_LOGO
	  
	  CALL PROCEDURE_DELAY
	  
	  MOV AX, [CURRENT_FRAME]
	  INC AX
	  MOV [CURRENT_FRAME], AX
	  
	  MOV AH, 1
	  INT 16H
	  JZ GAME_OVER_LOOP2
	  
	  XOR AH, AH
	  INT 16H
	  CMP AL, 'q'
	  JNE GAME_OVER_LOOP2
	  
	DONE2:
	  MOV AX, 3
	  INT 10H
	  RET
	 
	; since we've just made next piece current, we need to generate a new one
	NOT_GAME_OVER:
	CALL PROCEDURE_RANDOM_NEXT_PIECE
	
; Temporarily make next piece current so that it can be displayed in the
; "Next" piece area	
  DISPLAY_NEXT_PIECE:
    ; erase old next piece by drawing a black 4x4 block piece on top
    MOV DI, 17805
	MOV BX, 20
	MOV DL, 0
	CALL PROCEDURE_DRAW_SQUARE
	
	; save current piece
	PUSH [CURRENT_PIECE_COLOR_INDEX]
	PUSH [PIECE_DEFINITION]
	PUSH [PIECE_ORIENTATION_INDEX]
	PUSH [PIECE_POSITION]
	; make next piece current - color index
	MOV AX, [NEXT_PIECE_COLOR_INDEX]
	MOV [CURRENT_PIECE_COLOR_INDEX], AX ;save color index
	
	; make next piece current - piece definition
	MOV CL, 5
	SHL AX, CL
	POP CX
	ADD AX, OFFSET PIECES_ORIGIN ;offset from first piece
	MOV [PIECE_DEFINITION], AX ; piece_definition now points to the first of 
                               ; four piece orientations of a specific piece 
	
	; make next piece current -  piece orientation index
	MOV AX, [NEXT_PIECE_ORIENTATION_INDEX]
	MOV [PIECE_ORIENTATION_INDEX], AX ;choose one of the four orientations
	
	CALL PROCEDURE_COPY_PIECE
	
	; temporarily move current piece to the Next display area
	MOV [PIECE_POSITION], 17805 ; move piece to where next 
                                ; piece is displayed
	
	; set colour in dl
	MOV BX, [CURRENT_PIECE_COLOR_INDEX]
	SHL BX, 1
	MOV DL, [COLOR_FALLING_PIECE + BX]
	CALL PROCEDURE_DRAW_PIECE
	
	; revert current piece to what is truly the current piece
	POP [PIECE_POSITION]
	POP [PIECE_ORIENTATION_INDEX]
	POP [PIECE_DEFINITION]
	POP [CURRENT_PIECE_COLOR_INDEX]
	CALL PROCEDURE_COPY_PIECE
	
	; Repeat from here on down as the current piece is falling
	MAIN_LOOP:
	  ; advance frame
	  MOV AX, [CURRENT_FRAME]
	  INC AX
	  MOV [CURRENT_FRAME], AX
	  
	  CALL PROCEDURE_DELAY
	  
	  ; reset position delta and input state
	  MOV [PIECE_POSITION_DELTA], 0
	  MOV [PLAYER_INPUT_PRESSED], 0
	  
	  ; animate logo
	  CALL PROCEDURE_DISPLAY_LOGO
	  
	READ_INPUT:
	  ; read input, exiting game if the player chose to
	  CALL PROCEDURE_READ_CHARACTER
	  CMP [MUST_QUIT], 0
	  JE HANDLE_HORIZONTAL_MOVE
	  ; [piece_position_delta] now contains modification from input
	  
	DONE1:
	  MOV AX, 3
	  INT 10H
	  RET
	
    ; if the player didn't press left or right, skip directly to where we 
    ; handle vertical movement	
	HANDLE_HORIZONTAL_MOVE:
	  MOV AX, [PIECE_POSITION_DELTA]
	  TEST AX, AX
	  JZ HANDLE_VERTICAL_MOVE ;didn't press left or right
	  
	  ; either left or right was pressed, so shift piece horizontally
      ; according to how delta was set
	  CALL PROCEDURE_APPLY_DELTA_AND_DRAW_PIECE
	  
	HANDLE_VERTICAL_MOVE:
	  ; for each of the blocks in the current piece
	  MOV CX, [BLOCKS_PER_PIECE] ;each piece has 4 blocks
	HANDLE_VERTICAL_MOVE_LOOP:
	  ; position di to the origin of current block
	  MOV DI, [PIECE_POSITION] ; start from the origin of the piece
	  MOV BX, CX
	  SHL BX, 1
	  SUB BX, 2
	  ADD DI, [PIECE_BLOCKS + BX] ; shift position in the piece 
                                  ; to the position of current block
	  
	  ; if current block cannot move down, then the whole piece cannot move down
	  CALL PROCEDURE_CAN_MOVE_DOWN
	  TEST AL, AL ;non-zero indicates an obstacle below
	  JNZ HANDLE_VERTICAL_MOVE_LOOP_FAILURE
	  ; check next block
	  LOOP HANDLE_VERTICAL_MOVE_LOOP
	  ; all blocks can move down means that the piece can move down
	  JMP HANDLE_VERTICAL_MOVE_MOVE_DOWN_SUCCESS
	  
	HANDLE_VERTICAL_MOVE_LOOP_FAILURE:
	  ; we get here when the piece can no longer fall
	  MOV AL, [PLAYER_INPUT_PRESSED]
	  TEST AL, AL
	  
	  ; if no player input is present during this last frame, then cement right 
      ; away, because the player isn't trying to slide or rotate the piece at the
      ; last moment, as it is landing ( shortly after ); this would ultimately
      ; introduced an unnecessary delay when the piece lands, when the player
      ; is already expecting the next piece
	  JZ HANDLE_V_MOVE_CEMENT_IMMEDIATELY
	  
	  ; decrement and check the cement counter to see if it reached zero
      ; if it did, then the piece landed a long enough time ago to be cemented
      ; in place
	  MOV AL, [CEMENT_COUNTER]
	  DEC AL
	  MOV [CEMENT_COUNTER], AL
	  TEST AL, AL ; if we reached zero now, it means the piece can finally cement
	  JNZ MAIN_LOOP ; we haven't reached zero yet, so render next frame
	  ; cement counter is now zero, which means we have to cement the piece
	
; Current piece can now be "cemented" on whatever it landed	
	HANDLE_V_MOVE_CEMENT_IMMEDIATELY:
	  ; since the cement counter isn't guaranteed to be zero, we should zero it
	  MOV [CEMENT_COUNTER], 0
	  
	  ; it cannot move down, so "cement it in place" by changing its colour
      ; by indexing in the cemented piece colours array
	  MOV BX, [CURRENT_PIECE_COLOR_INDEX]
	  SHL BX, 1
	  MOV DL, [COLOR_CEMENTED_PIECE + BX]
	  CALL PROCEDURE_DRAW_PIECE
	  
	  ; remove possibly full lines
	  XOR DX, DX ; we'll accumulate number of lines cleared in dx
	  MOV CX, 20 ; we're clearing at most 4 lines, each having a height of 5 pixels
	  
	HANDLE_V_MOVE_CEMENT_IMMEDIATE_ATTEMPT_CLEAR_LINES_LOOP:
	  PUSH DX
	  CALL PROCEDURE_ATTEMPT_LINE_REMOVAL
	  POP DX
	  
	  ; accumulate number of cleared lines in dx and continue to loop
	  ADD DL, AL
	  LOOP HANDLE_V_MOVE_CEMENT_IMMEDIATE_ATTEMPT_CLEAR_LINES_LOOP
	  
	UPDATE_SCORE:
	  ; dx now contains number of lines (not block lines!) cleared, so we must
      ; divide in order to convert to block lines (or actual "tetris" lines)
	  MOV AX, DX
	  MOV DL, [BLOCK_SIZE]
	  DIV DL ; al now contains number of block lines
	  XOR AH, AH
	  ; add number of cleared lines to the score
	  MOV DX, [SCORE]
	  ADD AX, DX
	  
	  ; if score reached 1000, it rolls back to 0
	  CMP AX, 1000 ; our scoring goes to 999, so restart at 0 if it goes over
	  JL SCORE_IS_NOT_OVER_1000
	  SUB AX, 1000
	  
	SCORE_IS_NOT_OVER_1000:
	  MOV [SCORE], AX
	  ; spawn new piece
	  JMP NEW_PIECE
	 
    ; Current piece will now move down one pixel	 
	HANDLE_VERTICAL_MOVE_MOVE_DOWN_SUCCESS:
	  ; re-start cement counter, in case the piece landed on something, but the
      ; player slid it off during the cementing period, causing it to start 
      ; falling again, in which case we want to allow sliding again when it 
      ; lands on something again
	  MOV [CEMENT_COUNTER], 10
	  
	  ; it can move down, and our delta will be one pixel lower
	  MOV AX, [SCREEN_WIDTH]
	  MOV [PIECE_POSITION_DELTA], AX
	  ; delta is now one row lower
	  
	  ; move piece down and display it
	  CALL PROCEDURE_APPLY_DELTA_AND_DRAW_PIECE
	  
	  ; render next frame
	  JMP MAIN_LOOP
	  
	  ; Game has ended because the screen has filled up (next piece can no longer spawn)
	GAME_OVER:
	  ; draw game over overlay panel, and hide left/right/rotate controls
	  CALL PROCEDURE_DISPLAY_GAME_OVER
	  
	GAME_OVER_LOOP:
	  ; still display logo
	  CALL PROCEDURE_DISPLAY_LOGO
	  
	  CALL PROCEDURE_DELAY
	  
	  ; advance frame, since we're still animating the logo
	  MOV AX, [CURRENT_FRAME]
	  INC AX
	  MOV [CURRENT_FRAME], AX
	  
	  ; check whether any key is pressed
	  MOV AH, 1
	  INT 16H ; any key pressed ?
	  JZ GAME_OVER_LOOP ; no key pressed
	  
	  ; read key
	  XOR AH, AH
	  INT 16H
	  CMP AL, 'q'
	  JNE GAME_OVER_LOOP ; wait for Q to be pressed to exit the program
	
	; Exit to the operating system
	DONE:
	  ; change video mode to 80x25 text mode
	  MOV AX, 3
	  INT 10H ; restore text mode
	
  RET	
INITIALIZATION ENDP

EXIT:	
  MOV AH, 4CH
  INT 21H
CODESEG ENDS	
END START