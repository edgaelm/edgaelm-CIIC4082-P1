.include "constants.inc"
.include "header.inc"



.segment "ZEROPAGE"
player_x: .res 1
player_y: .res 1
player_face_left: .res 1
frame_counter: .res 1
controller1: .res 1 
jumping: .res 1    ; 0 = not jumping, 1 = jumping
ascending: .res 1  ; 0 = descending, 1 = ascending

.exportzp player_x, player_y, frame_counter

.segment "CODE"
.proc irq_handler
  RTI
.endproc

.proc nmi_handler
  LDA #$00
  STA OAMADDR
  LDA #$02
  STA OAMDMA

  ; Increment the frame counter
  INC frame_counter
  
  ; Check if it needs to be reset
  LDA frame_counter
  CMP #3  ; If we have 3 frames, compare with 3 (0, 1, 2)
  BNE no_reset
  LDA #0
  STA frame_counter
  
no_reset:
  ; Rest of NMI code...

  JSR update
  JSR draw

	LDA #$00
	STA $2005
	STA $2005
  RTI
.endproc

.proc read_controller1
  PHP
  PHA
  TXA
  PHA
  TYA
  PHA

  LDA #$01
  STA $4016     ; write 1 to $4016 to latch controller state
  LDA #$00
  STA $4016     ; write 0 to $4016 to begin reading button states

  ReadA: 
  LDA $4016       ; player 1 - A
  AND #%00000001  ; only look at bit 0
  BEQ ReadADone   ; branch to ReadADone if button is NOT pressed (0)
                  ; add instructions here to do something when button IS pressed (1)
  LDA player_y
  CMP #$d0      ; Check if player is on ground level or special Y index
  BEQ DoA
  BNE ReadADone ; Skip A button processing if not on allowed Y indices

  DoA:
  ; Check the direction the player is facing
  LDA player_face_left
  BEQ FacingRight       ; If facing right, use right-facing sprites

  ; If A is pressed and player is facing left
  ; player tile attributes for facing left
  LDA #$40
  STA $0202
  STA $0206
  STA $020a
  STA $020e

  ; left-facing sprite
  LDA #$0a
  STA $0201
  LDA #$09
  STA $0205
  LDA #$1a
  STA $0209
  LDA #$19


  LDA $00
  STA player_face_left
  INC player_face_left

  JMP SetJumping        ; Go to jump setting

FacingRight:
; player tile attributes
  ; palette 0
  LDA #$00
  STA $0202
  STA $0206
  STA $020a
  STA $020e

  LDA #$09
  STA $0201
  LDA #$0a
  STA $0205
  LDA #$19
  STA $0209
  LDA #$1a

  LDA $00
  STA player_face_left

SetJumping:
  LDA #$01
  STA jumping          ; Set jumping status to true
  LDA #$01
  STA ascending        ; Start ascending

  	LDA player_y
	STA $0203
	STA $020B
	TAX
	CLC
	ADC #$08
	STA $0207
	STA $020F
	DEX
	STX player_y
  	JMP ReadADone

  JSR check_boundaries

ReadADone:        ; handling this button is done
  
ReadB: 
  LDA $4016       ; player 1 - B
  AND #%00000001  ; only look at bit 0
  BEQ ReadBDone   ; branch to ReadBDone if button is NOT pressed (0)
                  ; add instructions here to do something when button IS pressed (1)
  LDA player_face_left      ; Load the direction the player is facing
  CMP #0              ; Compare it with zero
  BNE left_attack

   ; player tile attributes
  ; palette 0
  LDA #$00
  STA $0202
  STA $0206
  STA $020a
  STA $020e

  LDA #$0d
  STA $0201
  LDA #$0e
  STA $0205
  LDA #$1d
  STA $0209
  LDA #$1e
  STA $020d
  JMP ReadBDone


  left_attack:

  ; player tile attributes
  ; palette 0
  LDA #$40
  STA $0202
  STA $0206
  STA $020a
  STA $020e


  LDA #$0e
  STA $0201
  LDA #$0d
  STA $0205
  LDA #$1e
  STA $0209
  LDA #$1d
  STA $020d


ReadBDone:        ; handling this button is done

ReadSelect: 
  LDA $4016       ; player 1 - A
  AND #%00000001  ; only look at bit 0
  BEQ ReadSelectDone   ; branch to ReadADone if button is NOT pressed (0)

ReadSelectDone:

ReadStart: 
  LDA $4016       ; player 1 - A
  AND #%00000001  ; only look at bit 0
  BEQ ReadStartDone   ; branch to ReadADone if button is NOT pressed (0)

ReadStartDone:

ReadUp: 
  LDA $4016       ; player 1 - A
  AND #%00000001  ; only look at bit 0
  BEQ ReadUpDone   ; branch to ReadADone if button is NOT pressed (0)

ReadUpDone:

ReadDown: 
  LDA $4016       ; player 1 - A
  AND #%00000001  ; only look at bit 0
  BEQ ReadDownDone   ; branch to ReadADone if button is NOT pressed (0)

  DoDown:
  LDA player_face_left      ; Load the direction the player is facing
  CMP #0              ; Compare it with zero
  BNE left_down

   ; player tile attributes
  ; palette 0
  LDA #$01
  STA $0202
  STA $0206
  STA $020a
  STA $020e

  JMP ReadDownDone


  left_down:

  ; player tile attributes
  ; palette 0
  LDA #$41
  STA $0202
  STA $0206
  STA $020a
  STA $020e

ReadDownDone:

ReadLeft: 
  LDA $4016       ; player 1 - A
  AND #%00000001  ; only look at bit 0
  BNE DoLeft
  JMP ReadLeftDone   ; branch to ReadADone if button is NOT pressed (0)



;Move to the left
DoLeft:
  LDA player_x
  STA $0203
  STA $020B
  TAX
  CLC
  ADC #$08
  STA $0207
  STA $020F
  DEX
  STX player_x
  LDA $00
  STA player_face_left
  INC player_face_left
  JSR check_boundaries 

   ; player tile attributes
  ; palette 0
  LDA #$40
  STA $0202
  STA $0206
  STA $020a
  STA $020e
  ; Animation frame updates here
  INC frame_counter ; Increment the frame counter for animation
  LDA frame_counter
  AND #%00000011    ; Use bitwise AND to cycle through 4 frames (0-3)
  TAX               ; Transfer to X to use as an index for selecting frame

  ; Select the correct frame based on frame_counter
  ; Frame one (when frame_counter is 0)
  CPX #0
  BEQ load_leftframe_1
  CPX #1
  BEQ load_leftframe_2
  ; Frame three (when frame_counter is 2)
  CPX #2
  BEQ load_leftframe_3

  ; Continue with additional frames if you have more than 3

  ; If frame_counter is 3, fall through to load_frame_1
  ; to loop the animation
load_leftframe_1:
  ; Load tile numbers for frame 1
  LDA #$04
  STA $0201
  LDA #$03
  STA $0205
  LDA #$14
  STA $0209
  LDA #$13
  STA $020d
  JMP update_done

load_leftframe_2:
  ; Load tile numbers for frame 2
  LDA #$06
  STA $0201
  LDA #$05
  STA $0205
  LDA #$16
  STA $0209
  LDA #$15
  STA $020d
  JMP update_done

load_leftframe_3:
  ; Load tile numbers for frame 3
  LDA #$08
  STA $0201
  LDA #$07
  STA $0205
  LDA #$18
  STA $0209
  LDA #$17
  STA $020d
    

ReadLeftDone:

ReadRight: 
   LDA $4016       ; player 1 - A
  AND #%00000001  ; only look at bit 0
  BNE DoRight
  JMP ReadRightDone ; branch to ReadADone if button is NOT pressed (0)

 

DoRight:
  LDA player_x
  STA $0203
  STA $020B
  TAX
  CLC
  ADC #$08
  STA $0207
  STA $020F
  INX
  STX player_x
  JSR check_boundaries

  LDA $00
  STA player_face_left

  ; player tile attributes
  ; palette 0
  LDA #$00
  STA $0202
  STA $0206
  STA $020a
  STA $020e
  ; Animation frame updates here
  INC frame_counter ; Increment the frame counter for animation
  LDA frame_counter
  AND #%00000011    ; Use bitwise AND to cycle through 4 frames (0-3)
  TAX               ; Transfer to X to use as an index for selecting frame

  ; Select the correct frame based on frame_counter
  ; Frame one (when frame_counter is 0)
  CPX #0
  BEQ load_frame_1
  CPX #1
  BEQ load_frame_2
  ; Frame three (when frame_counter is 2)
  CPX #2
  BEQ load_frame_3

  ; Continue with additional frames if you have more than 3

  ; If frame_counter is 3, fall through to load_frame_1
  ; to loop the animation
load_frame_1:
  ; Load tile numbers for frame 1
  LDA #$03
  STA $0201
  LDA #$04
  STA $0205
  LDA #$13
  STA $0209
  LDA #$14
  STA $020d
  JMP update_done

load_frame_2:
  ; Load tile numbers for frame 2
  LDA #$05
  STA $0201
  LDA #$06
  STA $0205
  LDA #$15
  STA $0209
  LDA #$16
  STA $020d
  JMP update_done

load_frame_3:
  ; Load tile numbers for frame 3
  LDA #$07
  STA $0201
  LDA #$08
  STA $0205
  LDA #$17
  STA $0209
  LDA #$18
  STA $020d


ReadRightDone:

update_done:
  ; Restore registers and return
  PLA
  TAY
  PLA
  TAX
  PLA
  PLP
  RTS

  .endproc

.import reset_handler

.export main
.proc main

 ;palette

load_palettes:
  LDX PPUSTATUS ; load ppu status register
  LDX #$3f ; load high byte value into accumulator
  STX PPUADDR  
  LDX #$00	; set register value x to 0
  STX PPUADDR
  

load_palettes_loop:
  LDA palettes, X 	; load value from palette array with offset of x value
  STA PPUDATA		
  INX			; increments x register value to move to the next element
  CPX #$20		; compares value with32 palette value
  BNE load_palettes_loop 	; begin loop again if there are elements left

;sprites

; load_sprites:
; 	LDX #$00	; starts at zero
; load_sprites_loop:
; 	LDA sprites, x  ; loads sprite data and sets an offset of x value
; 	STA $0200, x	; stores in ram address with offset of x value
; 	INX				; increments x to go to the next element
; 	CPX #$d0		; compares with the sprite data amount
; 	BNE load_sprites_loop ; begin loop again if there are elements left

;background

load_backgrund:
LDX PPUSTATUS
LDX #$20
STX PPUADDR		
LDX #$00
STX PPUADDR		

;loads first 256 bytes
LDX #$00		;sets x to 0
load_background_loop1:
LDA map, x  ; loads map value at offset x
STA PPUDATA	
INX			; goes to next element
BNE load_background_loop1 ; stays in loop until reaches zero

;loads next 256 bytes
LDX #$00		;sets x to 0
load_background_loop2:
LDA map+256, x  ; loads map value at offset x
STA PPUDATA	
INX			; goes to next element
BNE load_background_loop2 ; stays in loop until reaches zero

;loads next 256 bytes
LDX #$00		;sets x to 0
load_background_loop3:
LDA map+512, x  ; loads map value at offset x
STA PPUDATA	
INX			; goes to next element
BNE load_background_loop3 ; stays in loop until reaches zero

;loads next 256 bytes
LDX #$00		;sets x to 0
load_background_loop4:
LDA map+768, x  ; loads map value at offset x
STA PPUDATA	
INX			; goes to next element
BNE load_background_loop4 ; stays in loop until reaches zero

vblankwait:       ; wait for another vblank before continuing
  BIT PPUSTATUS
  BPL vblankwait

  LDA #%10010000  ; turn on NMIs, sprites use first pattern table
  STA PPUCTRL
  LDA #%00011110  ; turn on screen
  STA PPUMASK

forever:
  JMP forever
.endproc

.proc draw
	; save registers
  PHP
  PHA
  TXA
  PHA
  TYA
  PHA

 


    ; top left tile:
  LDA player_y
  STA $0200
  LDA player_x
  STA $0203

  ; top right tile (x + 8):
  LDA player_y
  STA $0204
  LDA player_x
  CLC
  ADC #$08
  STA $0207

  ; bottom left tile (y + 8):
  LDA player_y
  CLC
  ADC #$08
  STA $0208
  LDA player_x
  STA $020b

  ; bottom right tile (x + 8, y + 8)
  LDA player_y
  CLC
  ADC #$08
  STA $020c
  LDA player_x
  CLC
  ADC #$08
  STA $020f


  ; restore registers and return
  PLA
  TAY
  PLA
  TAX
  PLA
  PLP
  RTS
.endproc




.proc update
  ; Save registers
  PHP
  PHA
  TXA
  PHA
  TYA
  PHA

  JSR check_boundaries

  JSR is_jumping

  JSR read_controller1 ; Read controller input

  LDA controller1

  



exit_subroutine:

  ; Restore registers and return
  PLA
  TAY
  PLA
  TAX
  PLA
  PLP
  RTS
.endproc

.proc check_boundaries
  ; Save registers
  PHP
  PHA
  TXA
  PHA
  TYA
  PHA
  
  ; Check if player is at the left boundary
  LDA player_x
  CMP #$00
  BEQ no_move_left  ; If at left boundary, do not move left

  ; Check if player is at the right boundary
  CMP #$F8
  BEQ no_move_right ; If at right boundary, do not move right

  ; No boundary hit, can move freely
  JMP exit

no_move_left:
  ; Prevent moving left by setting player's x position to the left boundary
  LDA #$04
  STA player_x
  JMP exit

no_move_right:
  ; Prevent moving right by setting player's x position to the right boundary
  LDA #$F4
  STA player_x
  JMP exit

  ; y boundary

   ; Check if player is at the up boundary
  LDA player_y
  CMP #$00
  BEQ no_move_up  ; If at up boundary, do not move up

  ; Check if player is at the right boundary
  CMP #$F8
  BEQ no_move_down ; If at right boundary, do not move right

  ; No boundary hit, can move freely
  JMP exit

no_move_up:
  ; Prevent moving up by setting player's y position to the up boundary
  LDA #$04
  STA player_y
  JMP exit

no_move_down:
  ; Prevent moving right by setting player's y position to the down boundary
  LDA #$d0
  STA player_y
  JMP exit

  

exit:
  ; Restore registers and return
  PLA
  TAY
  PLA
  TAX
  PLA
  PLP
  RTS
.endproc

.proc is_jumping
  ; Save registers
  PHP
  PHA
  TXA
  PHA
  TYA
  PHA

  ; Handle jumping logic
  LDA jumping
  BEQ NotJumping  ; If not jumping, skip

  LDA ascending
  BEQ Descending  ; If descending, handle descent

Ascent:
  ; Handle ascent
  LDA player_y
  CMP #$92       ; Check if we've reached the jump apex
  BEQ CheckXRange ; Check if within the specific X range
  DEC player_y    ; Move up
  CMP #$92        ; Ensure we don't go above the top boundary
  BNE SkipApexCheck
  JMP StartDescent

SkipApexCheck:
  JMP DoneJumping

CheckXRange:
  LDA player_x
  CMP #$40
  BCC StartDescent ; If less than #$40, start descent
  CMP #$B9
  BCS StartDescent ; If greater than or equal to #$B9, start descent
  ; Within range, can stand on #$8e
  JMP DoneJumping

StartDescent:
  LDA #$00
  STA ascending   ; Start descending

Descending:
  LDA player_y
  CMP #$d0        ; Check if we've reached ground level
  BEQ NotJumping  ; If at ground level, stop jumping
  INC player_y    ; Move down
  JMP DoneJumping

DoneJumping:
  ; Continue with the rest of the update code

NotJumping:
  PLA
  TAY
  PLA
  TAX
  PLA
  PLP
  RTS
.endproc

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "RODATA"
palettes:
.byte $0f, $02, $10, $20 
.byte $0f, $25, $21, $39
.byte $0f, $0c, $07, $13
.byte $0f, $19, $09, $29

.byte $0f, $15, $37, $2a
.byte $0f, $02, $10, $20
.byte $0f, $19, $09, $29
.byte $0f, $19, $09, $29

; sprites:

; 	;facing right

; ;sprite static

; 	;  y   tile att   x
; .byte $58, $01, $00, $58
; .byte $58, $02, $00, $60
; .byte $60, $11, $00, $58
; .byte $60, $12, $00, $60

	
; ;sprite run 1

; 	;  y   tile att   x
; .byte $58, $03, $00, $68
; .byte $58, $04, $00, $70
; .byte $60, $13, $00, $68
; .byte $60, $14, $00, $70

; ;sprite run 2

; 	;  y   tile att   x
; .byte $58, $05, $00, $78
; .byte $58, $06, $00, $80
; .byte $60, $15, $00, $78
; .byte $60, $16, $00, $80

; ;sprite run 3

; 	;  y   tile att   x
; .byte $58, $07, $00, $88
; .byte $58, $08, $00, $90
; .byte $60, $17, $00, $88
; .byte $60, $18, $00, $90

; ;sprite jump

; 	;  y   tile att   x
; .byte $68, $09, $00, $58
; .byte $68, $0a, $00, $60
; .byte $70, $19, $00, $58
; .byte $70, $1a, $00, $60

	
; ;sprite dead

; 	;  y   tile att   x
; .byte $70, $1b, $00, $70
; .byte $70, $1c, $00, $78

; ;sprite attack

; 	;  y   tile att   x
; .byte $68, $0d, $00, $88
; .byte $68, $0e, $00, $90
; .byte $70, $1d, $00, $88
; .byte $70, $1e, $00, $90

; ; ;facing left

; ;sprite static

; 	;  y   tile att   x
; .byte $78, $02, $40, $58
; .byte $78, $01, $40, $60
; .byte $80, $12, $40, $58
; .byte $80, $11, $40, $60

	
; ;sprite run 1

; 	;  y   tile att   x
; .byte $78, $04, $40, $68
; .byte $78, $03, $40, $70
; .byte $80, $14, $40, $68
; .byte $80, $13, $40, $70

; ;sprite run 2

; 	;  y   tile att   x
; .byte $78, $06, $40, $78
; .byte $78, $05, $40, $80
; .byte $80, $16, $40, $78
; .byte $80, $15, $40, $80

; ;sprite run 3

; 	;  y   tile att   x
; .byte $78, $08, $40, $88
; .byte $78, $07, $40, $90
; .byte $80, $18, $40, $88
; .byte $80, $17, $40, $90

; ;sprite jump

; 	;  y   tile att   x
; .byte $88, $0a, $40, $58
; .byte $88, $09, $40, $60
; .byte $90, $1a, $40, $58
; .byte $90, $19, $40, $60

	
; ;sprite dead

; 	;  y   tile att   x
; .byte $90, $1c, $40, $70
; .byte $90, $1b, $40, $78

; ;sprite attack

; 	;  y   tile att   x
; .byte $88, $0e, $40, $88
; .byte $88, $0d, $40, $90
; .byte $90, $1e, $40, $88
; .byte $90, $1d, $40, $90



map:
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$2c,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$2c,$00,$00,$00,$00,$00,$00,$00,$2b,$00
	.byte $00,$00,$00,$2c,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$2b,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$2c,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$2c,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2c,$00,$00,$00
	.byte $00,$00,$00,$2b,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2b,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$2b,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$2d,$00,$00,$00,$00,$00,$00,$00,$00,$2b,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$2c,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$2c,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$2c,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$29,$2a,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$29,$2a,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$29,$2a,$00,$00,$00
	.byte $00,$00,$00,$00,$29,$2a,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$34,$35,$34,$35,$34,$35,$34,$35
	.byte $34,$35,$34,$35,$34,$35,$34,$35,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$29,$2a,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$29,$2a,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $30,$31,$00,$36,$37,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$36,$37,$00,$30,$31
	.byte $40,$41,$45,$46,$47,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$45,$46,$47,$00,$40,$41
	.byte $50,$51,$55,$56,$57,$58,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$56,$57,$58,$50,$51
	.byte $2e,$2f,$2e,$2f,$2e,$2f,$2e,$2f,$2e,$2f,$2e,$2f,$2e,$2f,$2e,$2f
	.byte $2e,$2f,$2e,$2f,$2e,$2f,$2e,$2f,$2e,$2f,$2e,$2f,$2e,$2f,$2e,$2f
	.byte $3e,$3f,$3e,$3f,$3e,$3f,$3e,$3f,$3e,$3f,$3e,$3f,$3e,$3f,$3e,$3f
	.byte $3e,$3f,$3e,$3f,$3e,$3f,$3e,$3f,$3e,$3f,$3e,$3f,$3e,$3f,$3e,$3f
	.byte $00,$40,$00,$40,$40,$00,$20,$00,$00,$02,$00,$10,$40,$00,$01,$20
	.byte $40,$04,$04,$00,$00,$20,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$10,$00,$00,$00,$01,$40,$10,$0a,$00,$00,$00,$00,$00,$00,$0a
	.byte $00,$00,$00,$00,$00,$00,$44,$55,$00,$00,$00,$00,$00,$00,$00,$00



.segment "CHR"
.incbin "game.chr"
