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
  MSG_LINES DB "Lines $"
  MSG_GAME_OVER DB '______________________________________________________________________________',0ah,0dh
   		   DB ' ||\_____\ |\______\ |\__\     /\__\|\________\                               |',0ah,0dh
           DB ' |||      |||   _   |||   \   //   |||   _____|_____                          |',0ah,0dh
           DB ' |||  ____|||  /|\  |||    \ //    |||  |_\ |\______\  ______  ______  _____  |',0ah,0dh
           DB ' ||| |\__\ || |__\| |||     \/  /| |||   __|||  ___  ||\__\__||\_____\|\____\ |',0ah,0dh
           DB ' ||| |\|_ |||  ___  |||  \     /|| |||  |___|| |   | |||  |  |||  ___|||  _  ||',0ah,0dh
           DB ' ||| |_\| |||   |   |||  |\___/ || |||  |___|| |   | |||  |  |||   _| || |_/ ||',0ah,0dh
           DB ' |||      |||   |   |||  |      || |||      || |___| |\|  |  |||  |_\ ||    < |',0ah,0dh
           DB ' |\|______|\|___|___|\|__|      \|_|\|______\|_______| \____/ \|_____|\|_|\__\|',0ah,0dh
           DB ' |____________________________________________________________________________|',0ah,0dh
           DB ' ',0ah,0dh
           DB ' ',0ah,0dh
           DB ' ',0ah,0dh
           DB 'Press ESC to return to menu...',0ah,0dh,'$'
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
  
  CALL INITIALIZATION
  
  JMP EXIT
;----------------------------------------------------------- 
;Procedures
;----------------------------------------------------------- 
PROCEDURE_DISPLAY_SCORE PROC NEAR
  MOV AX, [SCORE]
  MOV DL, 100
  DIV DL
  MOV CL, '0'
  ADD CL, AL
  MOV [MSG_SCORE_BUFFER], CL
  
  MOV AL, AH
  XOR AH, AH
  MOV DL, 10
  DIV DL
  MOV CL, '0'
  ADD CL, AL
  MOV [MSG_SCORE_BUFFER + 1], CL
  
  MOV CL, '0'
  ADD CL, AH
  MOV [MSG_SCORE_BUFFER + 2], CL
  
  MOV BX, MSG_SCORE_BUFFER
  MOV DH, 15
  MOV DL, 26
  CALL PROCEDURE_PRINT_AT
  
  RET
PROCEDURE_DISPLAY_SCORE ENDP

PROCEDURE_PRINT_AT PROC NEAR
  PUSH BX
  MOV AH, 2
  XOR BH, BH
  INT 10H
  
  MOV AH, 9
  POP DX
  INT 21H
  
  RET
PROCEDURE_PRINT_AT ENDP

PROCEDURE_RANDOM_NEXT_PIECE PROC FAR
  CALL PROCEDURE_DELAY
  
  MOV BL, 7
  CALL PROCEDURE_GENERATE_RANDOM_NUMBER
  MOV [NEXT_PIECE_COLOR_INDEX], AX
  
  MOV BL, 4
  CALL PROCEDURE_GENERATE_RANDOM_NUMBER
  
  MOV [NEXT_PIECE_ORIENTATION_INDEX], AX
  
  RET
PROCEDURE_RANDOM_NEXT_PIECE ENDP

PROCEDURE_ATTEMPT_LINE_REMOVAL PROC FAR
  PUSH CX
  
  MOV DI, 47815
  MOV CX, 104
  
  ATTEMPT_LINE_REMOVAL_LOOP:
    CALL PROCEDURE_IS_HORIZONTAL_LINE_FULL
	TEST AL, AL
	JZ ATTEMPT_LINE_REMOVAL_FULL_LINE_FOUND
	
	SUB DI, [SCREEN_WIDTH]
	LOOP ATTEMPT_LINE_REMOVAL_LOOP
	
	JMP ATTEMPT_LINE_REMOVAL_NO_LINE_FOUND
	
	ATTEMPT_LINE_REMOVAL_FULL_LINE_FOUND:
	
	  ATTEMPT_LINE_REMOVAL_SHIFT_LINES_DOWN_LOOP:
	    PUSH CX
		PUSH DI
		
		MOV SI, DI
		SUB SI, [SCREEN_WIDTH]
		
		MOV CX, 50
		
		PUSH DS
		PUSH ES
		MOV AX, 0A000H
		MOV DS, AX
		MOV ES, AX
		REP MOVSB
		POP ES
		POP DS
		
		POP DI
		POP CX
		
		SUB DI, [SCREEN_WIDTH]
		
		LOOP ATTEMPT_LINE_REMOVAL_SHIFT_LINES_DOWN_LOOP
		
		XOR DL, DL
		MOV CX, 50
		CALL PROCEDURE_DRAW_LINE
		
		MOV AL, 1
		JMP ATTEMPT_LINE_REMOVAL_DONE
		
	  ATTEMPT_LINE_REMOVAL_NO_LINE_FOUND:
	    XOR AL, AL
		
	ATTEMPT_LINE_REMOVAL_DONE:
	  POP CX
	  RET
PROCEDURE_ATTEMPT_LINE_REMOVAL ENDP

PROCEDURE_IS_HORIZONTAL_LINE_FULL PROC NEAR
  PUSH CX
  PUSH DI
  
  MOV CX, 50
  
  IS_HORIZONTAL_LINE_FULL_LOOP:
    CALL PROCEDURE_READ_PIXEL
	TEST DL, DL
	JZ IS_HORIZONTAL_LINE_FULL_FAILURE
	
	INC DI
	LOOP IS_HORIZONTAL_LINE_FULL_LOOP
	
	XOR AX, AX
	JMP IS_HORIZONTAL_LINE_FULL_LOOP_DONE
	
  IS_HORIZONTAL_LINE_FULL_FAILURE:
    MOV AL, 1
	
  IS_HORIZONTAL_LINE_FULL_LOOP_DONE:
    POP DI
	POP CX
	
  RET
PROCEDURE_IS_HORIZONTAL_LINE_FULL ENDP

PROCEDURE_GENERATE_RANDOM_NUMBER PROC NEAR
  MOV AL, [RANDOM_NUMBER]
  ADD AL, 31
  MOV [RANDOM_NUMBER], AL
  
  DIV BL
  MOV AL, AH
  XOR AH, AH
  
  RET
PROCEDURE_GENERATE_RANDOM_NUMBER ENDP

PROCEDURE_COPY_PIECE PROC NEAR
  PUSH DS
  PUSH ES
  
  MOV AX, CS
  MOV DS, AX
  MOV ES, AX
  
  MOV DI, PIECE_BLOCKS
  
  MOV AX, [PIECE_ORIENTATION_INDEX]
  
  MOV SI, [PIECE_DEFINITION]
  
  PUSH CX
  MOV CL, 3
  
  SHL AX, CL
  
  POP CX
  
  ADD SI, AX
  
  MOV CX, 4
  
  REP MOVSW
  
  POP ES
  POP DS
  
  RET
PROCEDURE_COPY_PIECE ENDP

PROCEDURE_APPLY_DELTA_AND_DRAW_PIECE PROC FAR
  MOV DL, 0
  CALL PROCEDURE_DRAW_PIECE
  
  MOV AX, [PIECE_POSITION]
  ADD AX, [PIECE_POSITION_DELTA]
  MOV [PIECE_POSITION], AX
  
  MOV BX, [CURRENT_PIECE_COLOR_INDEX]
  SHL BX, 1
  MOV DL, [COLOR_FALLING_PIECE + BX]
  CALL PROCEDURE_DRAW_PIECE
  
  RET
PROCEDURE_APPLY_DELTA_AND_DRAW_PIECE ENDP

PROCEDURE_DRAW_PIECE PROC NEAR
  DRAW_PIECE_LOOP:
    MOV DI, [PIECE_POSITION]
	
	MOV BX, CX
	SHL BX, 1
	SUB BX, 2
	ADD DI, [PIECE_BLOCKS + BX]
	
	MOV BX, [BLOCK_SIZE]
	CALL PROCEDURE_DRAW_SQUARE
	
	LOOP DRAW_PIECE_LOOP
	
  RET
PROCEDURE_DRAW_PIECE ENDP

PROCEDURE_CAN_PIECE_BE_PLACED PROC FAR
  MOV CX, [BLOCKS_PER_PIECE]
  
  CAN_PIECE_BE_PLACED_LOOP:
    MOV DI, [PIECE_POSITION]
	
	MOV BX, CX
	SHL BX, 1
	SUB BX, 2
	ADD DI, [PIECE_BLOCKS + BX]
	
	PUSH CX
	
	MOV BX, 1
	
	MOV CX, [BLOCK_SIZE]
	
  CAN_PIECE_BE_PLACED_LINE_BY_LINE_LOOP:
    CALL PROCEDURE_IS_LINE_AVAILABLE
	TEST AL, AL
	JNE CAN_PIECE_BE_PLACED_FAILURE
	
	ADD DI, [SCREEN_WIDTH]
	LOOP CAN_PIECE_BE_PLACED_LINE_BY_LINE_LOOP
	
	POP CX
	
	LOOP CAN_PIECE_BE_PLACED_LOOP
	
	XOR AX, AX
	JMP CAN_PIECE_BE_PLACED_SUCCESS
	
  CAN_PIECE_BE_PLACED_FAILURE:
    MOV AL, 1
	
	POP CX
	
  CAN_PIECE_BE_PLACED_SUCCESS:
    RET
PROCEDURE_CAN_PIECE_BE_PLACED ENDP

PROCEDURE_ADVANCE_ORIENTATION PROC FAR
  MOV AX, [PIECE_ORIENTATION_INDEX]
  INC AX
  AND AX, 3
  MOV [PIECE_ORIENTATION_INDEX], AX
  
  CALL PROCEDURE_COPY_PIECE
  
  RET
PROCEDURE_ADVANCE_ORIENTATION ENDP

PROCEDURE_READ_CHARACTER PROC NEAR
  MOV AH, 1
  INT 16H
  JNZ READ_CHARACTER_KEY_WAS_PRESSED
  
  RET
  
  READ_CHARACTER_KEY_WAS_PRESSED:
    MOV AH, 0
	INT 16H
	
	PUSH AX
	MOV AH, 6
	MOV DL, 0FFH
	INT 21H
	POP AX
	
	HANDLE_INPUT:
	  CMP AL, 's'
	  JE MOVE_RIGHT
	  
	  CMP AL, 'a'
	  JE MOVE_LEFT
	  
	  CMP AL, ' '
	  JE ROTATE
	  
	  CMP AL, 'q'
	  JE QUIT
	  
	  RET
	
	QUIT:
	  MOV [MUST_QUIT], 1
	  RET
	  
	ROTATE:
	  PUSH [PIECE_ORIENTATION_INDEX]
	  
	  CALL PROCEDURE_ADVANCE_ORIENTATION
	  
	  CALL PROCEDURE_CAN_PIECE_BE_PLACED
	  TEST AL, AL
	  JZ ROTATE_PERFORM
	  
	  POP [PIECE_ORIENTATION_INDEX]
	  CALL PROCEDURE_COPY_PIECE
	  
	  RET
	  
	ROTATE_PERFORM:
	  POP [PIECE_ORIENTATION_INDEX]
	  CALL PROCEDURE_COPY_PIECE
	  
	  XOR DL, DL
	  CALL PROCEDURE_DRAW_PIECE
	  
	  CALL PROCEDURE_ADVANCE_ORIENTATION
	  
	  MOV AL, [RANDOM_NUMBER]
	  ADD AL, 11
	  MOV [RANDOM_NUMBER], AL
	  
	  RET
	  
	MOVE_RIGHT:
	  MOV [PLAYER_INPUT_PRESSED], 1
	  
	  MOV CX, [BLOCKS_PER_PIECE]
	  MOVE_RIGHT_LOOP:
	    MOV DI, [PIECE_POSITION]
		
		MOV BX, CX
		SHL BX, 1
		SUB BX, 2
		ADD DI, [PIECE_BLOCKS + BX]
		
		ADD DI, [BLOCK_SIZE]
		
		MOV BX, [SCREEN_WIDTH]
		CALL PROCEDURE_IS_LINE_AVAILABLE
		
		TEST AL, AL
		JNZ MOVE_RIGHT_DONE
		
		LOOP MOVE_RIGHT_LOOP
		
		MOV AX, [PIECE_POSITION_DELTA]
		ADD AX, [BLOCK_SIZE]
		MOV [PIECE_POSITION_DELTA], AX
		
	  MOVE_RIGHT_DONE:
	    MOV AL, [RANDOM_NUMBER]
	    ADD AL, 3
	    MOV [RANDOM_NUMBER], AL
	  
	    RET
	MOVE_LEFT:
	  MOV [PLAYER_INPUT_PRESSED], 1
	  
	  MOV CX, [BLOCKS_PER_PIECE]
	  MOVE_LEFT_LOOP:
	    MOV DI, [PIECE_POSITION]
		
		MOV BX, CX
		SHL BX, 1
		SUB BX, 2
		ADD DI, [PIECE_BLOCKS + BX]
		
		DEC DI
		
		MOV BX, [SCREEN_WIDTH]
		CALL PROCEDURE_IS_LINE_AVAILABLE
		
		TEST AL, AL
		JNZ MOVE_LEFT_DONE
		
		LOOP MOVE_LEFT_LOOP
		
		MOV AX, [PIECE_POSITION_DELTA]
		SUB AX, [BLOCK_SIZE]
		MOV [PIECE_POSITION_DELTA], AX
		
	  MOVE_LEFT_DONE:
	    MOV AL, [RANDOM_NUMBER]
		ADD AL, 5
		MOV [RANDOM_NUMBER], AL
		
		RET
PROCEDURE_READ_CHARACTER ENDP

PROCEDURE_CAN_MOVE_DOWN PROC FAR
  PUSH CX
  PUSH DI
  
  MOV CX, [BLOCK_SIZE]
  
  CAN_MOVE_DOWN_FIND_DELTA:
    ADD DI, [SCREEN_WIDTH]
	LOOP CAN_MOVE_DOWN_FIND_DELTA
	
	MOV BX, 1
	CALL PROCEDURE_IS_LINE_AVAILABLE
	
	TEST AL, AL
	JNZ CAN_MOVE_DOWN_OBSTACLE_FOUND
	
	XOR AX, AX
	JMP CAN_MOVE_DOWN_DONE
	
  CAN_MOVE_DOWN_OBSTACLE_FOUND:
    MOV AX, 1

  CAN_MOVE_DOWN_DONE:
    POP DI
	POP CX
	
	RET
PROCEDURE_CAN_MOVE_DOWN ENDP
	
PROCEDURE_IS_LINE_AVAILABLE PROC NEAR
  PUSH BX
  PUSH CX
  PUSH DI
  
  MOV CX, [BLOCK_SIZE]
  
  IS_LINE_AVAILABLE_LOOP:
    CALL PROCEDURE_READ_PIXEL
	TEST DL, DL
	JNZ IS_LINE_AVAILABLE_OBSTACLE_FOUND
	
	IS_LINE_AVAILABLE_LOOP_NEXT_PIXEL:
	  ADD DI, BX
	  LOOP IS_LINE_AVAILABLE_LOOP
	  
	  XOR AX, AX
	  JMP IS_LINE_AVAILABLE_LOOP_DONE
	  
	IS_LINE_AVAILABLE_OBSTACLE_FOUND:
	  PUSH BX
	  MOV BX, [CURRENT_PIECE_COLOR_INDEX]
	  SHL BX, 1
	  MOV AL, [COLOR_FALLING_PIECE + BX]
	  CMP DL, AL
	  POP BX
	  JNE IS_LINE_AVAILABLE_FAILURE
	  
	  JMP IS_LINE_AVAILABLE_LOOP_NEXT_PIXEL
	  
	IS_LINE_AVAILABLE_FAILURE:
	  MOV AL, 1
	  
	IS_LINE_AVAILABLE_LOOP_DONE:
	  POP DI
	  POP CX
	  POP BX
	  
	  RET
PROCEDURE_IS_LINE_AVAILABLE ENDP

PROCEDURE_DELAY PROC NEAR
  PUSH BX
  PUSH CX
  PUSH DX
  PUSH AX
  
  XOR BL, BL
  MOV AH, 2CH
  INT 21H
  
  MOV AL, [RANDOM_NUMBER]
  ADD AL, DL
  MOV [RANDOM_NUMBER], AL
  
  MOV [DELAY_INITIAL], DH
  
  ADD DL, [DELAY_CENTISECONDS]
  CMP DL, 100
  JB DELAY_SECOND_ADJUSTMENTS_DONE
  
  SUB DL, 100
  MOV BL, 1
  
  DELAY_SECOND_ADJUSTMENTS_DONE:
    MOV [DELAY_STOPPING_POINT_CENTISECONDS], DL
	
  READ_TIME_AGAIN:
    INT 21H
	
	TEST BL, BL
	JE MUST_BE_WITHIN_SAME_SECOND
	
	CMP DH, [DELAY_INITIAL]
	JE READ_TIME_AGAIN
	
	PUSH DX
	SUB DH, [DELAY_INITIAL]
	CMP DH, 2
	POP DX
	JAE DONE_DELAY
	
	JMP CHECK_STOPPING_POINT_REACHED
	
	MUST_BE_WITHIN_SAME_SECOND:
	  CMP DH, [DELAY_INITIAL]
	  JNE DONE_DELAY
	  
	CHECK_STOPPING_POINT_REACHED:
	  CMP DL, [DELAY_STOPPING_POINT_CENTISECONDS]
	  JB READ_TIME_AGAIN
	  
	DONE_DELAY:
	  POP AX
	  POP DX
	  POP CX
	  POP BX
	  
	  RET
PROCEDURE_DELAY ENDP

PROCEDURE_DRAW_RECTANGLE PROC FAR
  PUSH DI
  PUSH DX
  PUSH CX
  
  MOV CX, AX
  
  DRAW_RECTANGLE_LOOP:
    PUSH CX
	PUSH DI
	MOV CX, BX
	CALL PROCEDURE_DRAW_LINE
	
	POP DI
	
	ADD DI, [SCREEN_WIDTH]
	
	POP CX
	
	LOOP DRAW_RECTANGLE_LOOP
	
	POP CX
	POP DX
	POP DI
	
	RET
PROCEDURE_DRAW_RECTANGLE ENDP

PROCEDURE_DRAW_SQUARE PROC
  MOV AX, BX
  CALL PROCEDURE_DRAW_RECTANGLE
  
  RET
PROCEDURE_DRAW_SQUARE ENDP

PROCEDURE_DRAW_LINE PROC NEAR
  CALL PROCEDURE_DRAW_PIXEL
  
  INC DI
  
  LOOP PROCEDURE_DRAW_LINE
  
  RET
PROCEDURE_DRAW_LINE ENDP

PROCEDURE_DRAW_LINE_VERTICAL PROC FAR
  CALL PROCEDURE_DRAW_PIXEL
  
  ADD DI, [SCREEN_WIDTH]
  
  LOOP PROCEDURE_DRAW_LINE_VERTICAL
  
  RET
PROCEDURE_DRAW_LINE_VERTICAL ENDP

PROCEDURE_DRAW_PIXEL PROC NEAR
  PUSH AX
  PUSH ES
  
  MOV AX, 0A000H
  MOV ES, AX
  MOV ES:[DI], DL
  
  POP ES
  POP AX
  
  RET
PROCEDURE_DRAW_PIXEL ENDP

PROCEDURE_READ_PIXEL PROC NEAR
  PUSH AX
  PUSH ES
  
  MOV AX, 0A000H
  MOV ES, AX
  MOV DL, ES:[DI]
  
  POP ES
  POP AX
  
  RET
PROCEDURE_READ_PIXEL ENDP

PROCEDURE_DRAW_BORDER PROC FAR
  MOV DL, 200
  
  MOV BX, 4
  MOV AX, 200
  
  XOR DI, DI
  CALL PROCEDURE_DRAW_RECTANGLE
  
  MOV BX, 317
  MOV AX, 4
  
  XOR DI, DI
  CALL PROCEDURE_DRAW_RECTANGLE
  
  MOV DI, 62720
  CALL PROCEDURE_DRAW_RECTANGLE
  
  RET
PROCEDURE_DRAW_BORDER ENDP
  
PROCEDURE_DRAW_SCREEN PROC FAR
  CALL PROCEDURE_DRAW_BORDER
  
  DRAW_SCREEN_PLAY_AREA:
    MOV DL, 27
	
	MOV CX, 52
	MOV DI, 14214
	CALL PROCEDURE_DRAW_LINE
	
	MOV CX, 52
	MOV DI, 48134
	CALL PROCEDURE_DRAW_LINE
	
	MOV CX, 105
	MOV DI, 14534
	CALL PROCEDURE_DRAW_LINE_VERTICAL
	
	MOV CX, 105
	MOV DI, 14585
	CALL PROCEDURE_DRAW_LINE_VERTICAL
	
  DRAW_SCREEN_NEXT_PIECE_AREA:
    MOV DI, 16199
	MOV CX, 31
	CALL PROCEDURE_DRAW_LINE
	
	MOV DI, 25799
	MOV CX, 31
	CALL PROCEDURE_DRAW_LINE
	
	MOV DI, 16199
	MOV CX, 31
	CALL PROCEDURE_DRAW_LINE_VERTICAL
	
	MOV DI, 16230
	MOV CX, 31
	CALL PROCEDURE_DRAW_LINE_VERTICAL
	
  DRAW_SCREEN_STRINGS:
    MOV DH, 21
	MOV DL, 4
	MOV BX, MSG_AUTHOR
	CALL PROCEDURE_PRINT_AT
	
	MOV DH, 11
	MOV DL, 25
	MOV BX, MSG_NEXT
	CALL PROCEDURE_PRINT_AT
	
	MOV DH, 8
	MOV DL, 4
	MOV BX, MSG_LEFT
	CALL PROCEDURE_PRINT_AT
	
	MOV DH, 10
	MOV DL, 4
	MOV BX, MSG_RIGHT
	CALL PROCEDURE_PRINT_AT
	
	MOV DH, 12
	MOV DL, 4
	MOV BX, MSG_ROTATE
	CALL PROCEDURE_PRINT_AT
	
	MOV DH, 14
	MOV DL, 4
	MOV BX, MSG_QUIT
	CALL PROCEDURE_PRINT_AT
	
	MOV BX, MSG_LINES
	MOV DH, 16
	MOV DL, 24
	CALL PROCEDURE_PRINT_AT
	
	MOV BX, MSG_TETRIS
	MOV DH, 3
	MOV DL, 16
	CALL PROCEDURE_PRINT_AT
	
	RET
PROCEDURE_DRAW_SCREEN ENDP  
  
PROCEDURE_DISPLAY_LOGO PROC NEAR
  MOV AX, [CURRENT_FRAME]
  AND AX, 3
  JZ DISPLAY_LOGO_BEGIN
  
  RET
  
  DISPLAY_LOGO_BEGIN: 
    MOV DI, 4905
	
	MOV CX, 20
	DISPLAY_LOGO_HORIZONTAL_LOOP:
	  MOV AX, [CURRENT_FRAME]
	  AND AX, 8
	  
	  PUSH CX
	  MOV CL, 3
	  
	  SHR AL, CL
	  
	  ADD AX, DI
	  AND AL, 1
	  
	  SHL AL, CL
	  
	  POP CX
	  
	  ADD AL, 192
	  MOV DL, AL
	  MOV BX, 5
	  CALL PROCEDURE_DRAW_SQUARE
	  
	  PUSH DI
	  ADD DI, 6400
	  
	  CALL PROCEDURE_DRAW_SQUARE
	  
	  POP DI
	  ADD DI, BX
	  LOOP DISPLAY_LOGO_HORIZONTAL_LOOP
	  
	  MOV DI, 4905
	  
	MOV CX, 5
	DISPLAY_LOGO_VERTICAL_LOOP:
      MOV AX, [CURRENT_FRAME]
      AND AX, 8
	  
	  PUSH CX
	  MOV CL, 3
	  
	  SHR AL, CL
	  PUSH AX
	  
	  MOV AX, DI
	  MOV BL, 160
	  DIV BL
	  
	  XOR AH, AH
	  SHR AX, 1
	  
	  AND AL, 1
	  
	  POP BX
	  ADD AL, BL
	  AND AL, 1
	  
	  SHL AL, CL
	  
	  POP CX
	  
	  ADD AL, 192
	  MOV DL, AL
	  MOV BX, 5
	  CALL PROCEDURE_DRAW_SQUARE
	  
	  PUSH DI
	  ADD DI, 100
	  
	  CALL PROCEDURE_DRAW_SQUARE
	  
	  POP DI
	  ADD DI, 1600
	  LOOP DISPLAY_LOGO_VERTICAL_LOOP
	  
	  RET
PROCEDURE_DISPLAY_LOGO ENDP

_SET_CURSOR PROC NEAR
  MOV AH, 02H
  MOV BH, 00H
  INT 10H
  RET
_SET_CURSOR ENDP

PROCEDURE_DISPLAY_GAME_OVER PROC FAR
  MOV AX, 3
  INT 10H
  
  MOV DL, 00
  MOV DH, 05
  CALL _SET_CURSOR
  
  LEA DX, MSG_GAME_OVER
  MOV AH, 09H
  INT 21H
  
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