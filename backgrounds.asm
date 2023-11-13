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
  ; write a palette
  LDX PPUSTATUS
  LDX #$3f
  STX PPUADDR
  LDX #$00
  STX PPUADDR
load_palettes:
  LDA palettes,X
  STA PPUDATA
  INX
  CPX #$20
  BNE load_palettes

  ; write sprite data
  LDX #$00
load_sprites:
  LDA sprites,X
  STA $0200,X
  INX
  CPX #$10
  BNE load_sprites

  	; render floor
	; floor block top left
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$80
	STA PPUADDR
	LDX #$2e
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$82
	STA PPUADDR
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$84
	STA PPUADDR
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$86
	STA PPUADDR
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$88
	STA PPUADDR
	STX PPUDATA


	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$8a
	STA PPUADDR
	LDX #$2e
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$8c
	STA PPUADDR
	LDA #$2e
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$8e
	STA PPUADDR
	LDA #$2e
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$90
	STA PPUADDR
	LDA #$2e
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$92
	STA PPUADDR
	LDA #$2e
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$94
	STA PPUADDR
	LDA #$2e
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$96
	STA PPUADDR
	LDA #$2e
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$98
	STA PPUADDR
	LDA #$2e
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$9a
	STA PPUADDR
	LDA #$2e
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$9c
	STA PPUADDR
	LDA #$2e
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$9e
	STA PPUADDR
	LDA #$2e
	STA PPUDATA

	; floor block top right
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$81
	STA PPUADDR
	LDX #$2f
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$83
	STA PPUADDR
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$85
	STA PPUADDR
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$87
	STA PPUADDR
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$89
	STA PPUADDR
	STX PPUDATA


	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$8b
	STA PPUADDR
	LDX #$2f
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$8d
	STA PPUADDR
	LDA #$2f
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$8f
	STA PPUADDR
	LDA #$2f
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$91
	STA PPUADDR
	LDA #$2f
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$93
	STA PPUADDR
	LDA #$2f
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$95
	STA PPUADDR
	LDA #$2f
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$97
	STA PPUADDR
	LDA #$2f
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$99
	STA PPUADDR
	LDA #$2f
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$9b
	STA PPUADDR
	LDA #$2f
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$9d
	STA PPUADDR
	LDA #$2f
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$9f
	STA PPUADDR
	LDA #$2f
	STA PPUDATA


	; floor block bottom left


	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$a0
	STA PPUADDR
	LDX #$3e
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$a2
	STA PPUADDR
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$a4
	STA PPUADDR
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$a6
	STA PPUADDR
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$a8
	STA PPUADDR
	STX PPUDATA


	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$a8
	STA PPUADDR
	LDX #$3e
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$aa
	STA PPUADDR
	LDA #$3e
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$ac
	STA PPUADDR
	LDA #$3e
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$ae
	STA PPUADDR
	LDA #$3e
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$b0
	STA PPUADDR
	LDA #$3e
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$b2
	STA PPUADDR
	LDA #$3e
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$b4
	STA PPUADDR
	LDA #$3e
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$b6
	STA PPUADDR
	LDA #$3e
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$b8
	STA PPUADDR
	LDA #$3e
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$ba
	STA PPUADDR
	LDA #$3e
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$bc
	STA PPUADDR
	LDA #$3e
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$be
	STA PPUADDR
	LDA #$3e
	STA PPUDATA

	; floor block bottom right

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$a1
	STA PPUADDR
	LDX #$3f
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$a3
	STA PPUADDR
	LDA #$3f
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$a5
	STA PPUADDR
	LDA #$3f
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$a7
	STA PPUADDR
	LDA #$3f
	STA PPUDATA
	;
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$a9
	STA PPUADDR
	LDX #$3f
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$ab
	STA PPUADDR
	LDA #$3f
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$ad
	STA PPUADDR
	LDA #$3f
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$af
	STA PPUADDR
	LDA #$3f
	STA PPUDATA

	;

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$b1
	STA PPUADDR
	LDX #$3f
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$b3
	STA PPUADDR
	LDA #$3f
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$b5
	STA PPUADDR
	LDA #$3f
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$b7
	STA PPUADDR
	LDA #$3f
	STA PPUDATA
	;
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$b9
	STA PPUADDR
	LDX #$3f
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$bb
	STA PPUADDR
	LDA #$3f
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$bd
	STA PPUADDR
	LDA #$3f
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$bf
	STA PPUADDR
	LDA #$3f
	STA PPUDATA
	;completed floor render

	;render left skull

	;render skull stick bottom left
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$60   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$50   
	STA PPUDATA
	
	;render skull stick bottom right
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$61   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$51   
	STA PPUDATA

	;render skull stick middle right
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$41   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$41   
	STA PPUDATA

	;render skull stick middle left
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$40   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$40   
	STA PPUDATA

	;render skull stick top left
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$20   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$30   
	STA PPUDATA

	;render skull stick top right
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$21   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$31   
	STA PPUDATA

	;completed left skull render

	;render right skull

	;render skull stick bottom left
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$7e   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$50   
	STA PPUDATA
	
	 ;render skull stick bottom right
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$7f   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$51   
	STA PPUDATA

	;render skull stick middle right
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$5f   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$41   
	STA PPUDATA

	;render skull stick middle left
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$5e   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$40   
	STA PPUDATA

	;render skull stick top left
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$3e   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$30   
	STA PPUDATA

	;render skull stick top right
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$3f   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$31   
	STA PPUDATA

	;completed right skull render
;render left RIP

	;render RIP bottom left
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$62   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$55   
	STA PPUDATA
	
	;render RIP bottom right
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$65   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$58   
	STA PPUDATA

	;render RIP bottom middle right
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$64   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$57   
	STA PPUDATA

	;render RIP bottom middle left
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$63   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$56   
	STA PPUDATA

	;render RIP middle left left
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$42   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$45   
	STA PPUDATA

	;render RIP middle  left
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$43   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$46   
	STA PPUDATA

	;render RIP middle  left
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$44   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$47   
	STA PPUDATA

	;render RIP top left
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$23   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$36   
	STA PPUDATA

	;render RIP top right
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$24   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$37   
	STA PPUDATA

	;completed left RIP render

	;render right RIP

	;render RIP bottom left
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$7a   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$55   
	STA PPUDATA
	
	;render RIP bottom right
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$7d   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$58   
	STA PPUDATA

	;render RIP bottom middle right
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$7c   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$57   
	STA PPUDATA

	;render RIP bottom middle left
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$7b   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$56   
	STA PPUDATA

	;render RIP middle left left
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$5a   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$45   
	STA PPUDATA

	;render RIP middle  left
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$5b   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$46   
	STA PPUDATA

	;render RIP middle  right
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$5c   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$47   
	STA PPUDATA

	;render RIP top left
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$3b   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$36   
	STA PPUDATA

	;render RIP top right
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$3c   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$37   
	STA PPUDATA

	;completed right RIP render

		;render platform

	;render beginning bones\
	;1
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$88   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$34   
	STA PPUDATA
	;2
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$8a   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$34   
	STA PPUDATA
	;3
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$8c  
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$34   
	STA PPUDATA
	;4
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$8e   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$34   
	STA PPUDATA
	;5
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$90   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$34   
	STA PPUDATA
	;6
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$92   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$34   
	STA PPUDATA
	;7
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$94   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$34   
	STA PPUDATA
	;8
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$96   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$34   
	STA PPUDATA
	;


	;render end bone

	;1
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$89   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$35   
	STA PPUDATA
	;2
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$8b   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$35   
	STA PPUDATA
	;3
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$8d  
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$35   
	STA PPUDATA
	;4
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$8f   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$35   
	STA PPUDATA
	;5
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$91   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$35   
	STA PPUDATA
	;6
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$93   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$35   
	STA PPUDATA
	;7
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$95   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$35   
	STA PPUDATA
	;8
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$97   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$35   
	STA PPUDATA
	; completed platform render

	;render bats

	;render bats left

	; 1 left
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$a1   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$29   
	STA PPUDATA
	;2 left
	LDA PPUSTATUS
	LDA #$21
	STA PPUADDR
	LDA #$c2   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$29   
	STA PPUDATA
	;3 left
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$64   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$29   
	STA PPUDATA
	;4 right panel
	LDA PPUSTATUS
	LDA #$21
	STA PPUADDR
	LDA #$dd   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$29   
	STA PPUDATA
	;5 right panel
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$5b   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$29   
	STA PPUDATA
	;6 left
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$bd   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$29   
	STA PPUDATA

	;render bats right

	; 1 left
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$a2   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$2a   
	STA PPUDATA
	;2 left
	LDA PPUSTATUS
	LDA #$21
	STA PPUADDR
	LDA #$c3   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$2a   
	STA PPUDATA
	;3 left
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$65   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$2a   
	STA PPUDATA
	;4 right panel
	LDA PPUSTATUS
	LDA #$21
	STA PPUADDR
	LDA #$de   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$2a   
	STA PPUDATA
	;5 right panel
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$5c   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$2a   
	STA PPUDATA
	;6 left
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$be   
	STA PPUADDR
	
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$2a   
	STA PPUDATA

	

	; finally, attribute table
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$c2
	STA PPUADDR
	LDA #%01000000
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$f7
	STA PPUADDR
	LDA #%01000000
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$ef
	STA PPUADDR
	LDA #%01000000
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$e6
	STA PPUADDR
	LDA #%01000000
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$e7
	STA PPUADDR
	LDA #%01000000
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$df
	STA PPUADDR
	LDA #%01000000
	STA PPUDATA


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

.segment "CHR"
.incbin "game.chr"
