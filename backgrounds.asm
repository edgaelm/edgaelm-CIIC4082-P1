.include "constants.inc"
.include "header.inc"

.segment "CODE"
.proc irq_handler
  RTI
.endproc

.proc nmi_handler
  LDA #$00
  STA OAMADDR
  LDA #$02
  STA OAMDMA
	LDA #$00
	STA $2005
	STA $2005
  RTI
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

load_sprites:
	LDX #$00	; starts at zero
load_sprites_loop:
	LDA sprites, x  ; loads sprite data and sets an offset of x value
	STA $0200, x	; stores in ram address with offset of x value
	INX				; increments x to go to the next element
	CPX #$d0		; compares with the sprite data amount
	BNE load_sprites_loop ; begin loop again if there are elements left

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

sprites:

	;facing right

;sprite static

	;  y   tile att   x
.byte $58, $01, $00, $58
.byte $58, $02, $00, $60
.byte $60, $11, $00, $58
.byte $60, $12, $00, $60

	
;sprite run 1

	;  y   tile att   x
.byte $58, $03, $00, $68
.byte $58, $04, $00, $70
.byte $60, $13, $00, $68
.byte $60, $14, $00, $70

;sprite run 2

	;  y   tile att   x
.byte $58, $05, $00, $78
.byte $58, $06, $00, $80
.byte $60, $15, $00, $78
.byte $60, $16, $00, $80

;sprite run 3

	;  y   tile att   x
.byte $58, $07, $00, $88
.byte $58, $08, $00, $90
.byte $60, $17, $00, $88
.byte $60, $18, $00, $90

;sprite jump

	;  y   tile att   x
.byte $68, $09, $00, $58
.byte $68, $0a, $00, $60
.byte $70, $19, $00, $58
.byte $70, $1a, $00, $60

	
;sprite dead

	;  y   tile att   x
.byte $70, $1b, $00, $70
.byte $70, $1c, $00, $78

;sprite attack

	;  y   tile att   x
.byte $68, $0d, $00, $88
.byte $68, $0e, $00, $90
.byte $70, $1d, $00, $88
.byte $70, $1e, $00, $90

; ;facing left

;sprite static

	;  y   tile att   x
.byte $78, $02, $40, $58
.byte $78, $01, $40, $60
.byte $80, $12, $40, $58
.byte $80, $11, $40, $60

	
;sprite run 1

	;  y   tile att   x
.byte $78, $04, $40, $68
.byte $78, $03, $40, $70
.byte $80, $14, $40, $68
.byte $80, $13, $40, $70

;sprite run 2

	;  y   tile att   x
.byte $78, $06, $40, $78
.byte $78, $05, $40, $80
.byte $80, $16, $40, $78
.byte $80, $15, $40, $80

;sprite run 3

	;  y   tile att   x
.byte $78, $08, $40, $88
.byte $78, $07, $40, $90
.byte $80, $18, $40, $88
.byte $80, $17, $40, $90

;sprite jump

	;  y   tile att   x
.byte $88, $0a, $40, $58
.byte $88, $09, $40, $60
.byte $90, $1a, $40, $58
.byte $90, $19, $40, $60

	
;sprite dead

	;  y   tile att   x
.byte $90, $1c, $40, $70
.byte $90, $1b, $40, $78

;sprite attack

	;  y   tile att   x
.byte $88, $0e, $40, $88
.byte $88, $0d, $40, $90
.byte $90, $1e, $40, $88
.byte $90, $1d, $40, $90



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
