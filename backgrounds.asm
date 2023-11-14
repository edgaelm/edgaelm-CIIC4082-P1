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
  STX PPUADDR ; store high byte of ppu address 
  LDX #$00	; set register value x to 0
  STX PPUADDR

load_palettes_loop:
  LDA palettes, X 	; load value from palette array with offset of x value
  STA PPUDATA		; stores accumulator value into ppu memory into address specifies
  INX			; increments x register value to move to the next element
  CPX #$20		; compares value with32 palette value
  BNE load_palettes_loop 	; begin loop again if there are elements left

; ;sprites

; load_sprites:
; 	LDX #$00	; starts at zero
; load_sprites_loop:
; 	LDA sprites, x  ; loads sprite data and sets an offset of x value
; 	STA $0200, x	; stores in ram address with offset of x value
; 	INX				; increments x to go to the next element
; 	CPX #$2d		; compares with the sprite data amount
; 	BNE load_sprites_loop ; begin loop again if there are elements left

;background

load_backgrund:
LDX PPUSTATUS		; ppu status
LDX #$20
STX PPUADDR		; writes high byte
LDX #$00
STX PPUADDR		; writes low byte

;loads first 256 bytes
LDX #$00		;sets x to 0
load_background_loop1:
LDA map, x  ; loads map value at offset x
STA PPUDATA	; writes in ppu
INX			; goes to next element
BNE load_background_loop1 ; stays in loop until reaches zero

;loads next 256 bytes
LDX #$00		;sets x to 0
load_background_loop2:
LDA map+256, x  ; loads map value at offset x
STA PPUDATA	; writes in ppu
INX			; goes to next element
BNE load_background_loop2 ; stays in loop until reaches zero

;loads next 256 bytes
LDX #$00		;sets x to 0
load_background_loop3:
LDA map+512, x  ; loads map value at offset x
STA PPUDATA	; writes in ppu
INX			; goes to next element
BNE load_background_loop3 ; stays in loop until reaches zero

;loads next 256 bytes
LDX #$00		;sets x to 0
load_background_loop4:
LDA map+768, x  ; loads map value at offset x
STA PPUDATA	; writes in ppu
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
.byte $0f, $01, $21, $39
.byte $0f, $0c, $07, $13
.byte $0f, $19, $09, $29

.byte $0f, $2d, $10, $15
.byte $0f, $19, $09, $29
.byte $0f, $19, $09, $29
.byte $0f, $19, $09, $29

sprites:
.byte $70, $05, $00, $80
.byte $70, $06, $00, $88
.byte $78, $07, $00, $80
.byte $78, $08, $00, $88

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
