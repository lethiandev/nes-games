; NES Library loader
; general crt exports
.export _exit
.export __STARTUP__ : absolute = 1 ; mark as startup
.export RESET, NMI, IRQ

.export _scroll

.import initlib, donelib, callmain
.import _main, _sync, zerobss, copydata

; CC65 linker generated symbols
.import __RAM_START__, __RAM_SIZE__
.import __SRAM_START__, __SRAM_SIZE__
.import __ROM0_START__, __ROM0_SIZE__
.import __STARTUP_LOAD__, __STARTUP_RUN__, __STARTUP_SIZE__
.import __CODE_LOAD__, __CODE_RUN__, __CODE_SIZE__
.import __RODATA_LOAD__, __RODATA_RUN__, __RODATA_SIZE__

.include "zeropage.inc"


; 16bits header segment
.segment "HEADER"
    .byte $4e,$45,$53,$1a ; "NES"<EOF>
    .byte 2               ; PRG banks
    .byte 1               ; CHR banks
    .byte %00000011       ; flag 6 - NNNN FTBM - enable banks mirroring
    .byte %00000000       ; flag 7 - NNNN xxPV - mapper disabled
    .word 0,0,0,0         ; fill 8bytes by zeroes - unused

; program startup segment
.segment "STARTUP"
RESET:
    SEI ; disable IRQ
    CLD ; clear decimal mode

    LDX #$40
    STX $4017 ; disable APU frame IRQ

    LDX #$ff
    TXS ; set-up stack

    INX ; X = $ff + $01 = $00
    STX $2000 ; disable NMI
    STX $2001 ; disable rendering
    STX $4010 ; disable DMC IRQs

vblankwait1: ; wait for PPU re-charge
    BIT $2002
@1:
    BIT $2002
    BPL @1
@2:
    BIT $2002
    BPL @2

clearVRAM: ; fill VRAM (nametables) by zeroes
    LDA $2002 ; reset PPU status
    LDA #$20  ; seek PPU address to $2000 - nametables
    STA $2006
    STX $2006 ; X = 0
    TXA       ; A = X = 0
    LDY #$20
@1:
    STA $2007
    INX
    BNE @1 ; loop
    DEY
    BNE @1 ; loop

clearRAM: ; fill RAM memory by zeroes
    LDA #$00
    STA $0100, x
    ;STA $0200, X - sprites memory addr
    STA $0300, x
    STA $0400, x
    STA $0500, x
    STA $0600, x
    STA $0700, x

    LDA #$FF
    STA $0200, x ; - no - sprites

    INX
    BNE clearRAM

    JSR zerobss
    JSR copydata

    ; setup stack pointer
    LDA #<(__SRAM_START__ + __SRAM_SIZE__)
    STA sp
    LDA #>(__SRAM_START__ + __SRAM_SIZE__)
    STA sp+1 ; set argument stack ptr

vblankwait2: ; wait for PPU re-charge
    BIT $2002
@1:
    BIT $2002
    BPL @1
@2:
    BIT $2002
    BPL @2

    ; fill pallete by default one
    LDA $2002
    LDA #$3F ; hi
    STA $2006
    LDA #$00 ; low
    STA $2006

loadPallete:
    LDX #$00
@1:
    LDA defaultPalette, x
    STA $2007
    INX
    CPX #$20
    BNE @1

    ; PPU default controller and mask
    ; disabled at startup
    ;LDA #%10010000 ; enable NMI - the rendering
    ;STA $2000
    ;LDA #%00011110 ; enable sprites, enable background, no clipping on left side
    ;STA $2001

    ; calc C function
    JSR _main

_exit: ; restart game on exit
    JMP RESET

NMI:
    ; transfer RAM memory to OAM
    LDA #$00  ; set the low byte (00) of the RAM address
    STA $2003
    LDA #$02  ; set the high byte (02) of the RAM address
    STA $4014 ; start sprites data transfer RAM to OAM

    ; calc C function
    JSR _sync

    LDA _scroll  ; background scrolling
    STA $2005
    LDA _scroll+1
    STA $2005

    ; cleanup PPU process
    LDA #%10010000 ; enable NMI - the rendering
    STA $2000
    LDA #%00011110 ; enable sprites, enable background, no clipping on left side
    STA $2001
    RTI

IRQ:
    RTI

; read-write memory block
.segment "DATA"
_scroll:
    .byte 0, 0

; read-only memory block
.segment "RODATA"
defaultPalette:
    .byte $22,$29,$1A,$0F,  $22,$36,$17,$0F,  $22,$30,$21,$0F,  $22,$27,$17,$0F   ;;background palette
    .byte $22,$1C,$15,$14,  $22,$02,$38,$3C,  $22,$1C,$15,$14,  $22,$02,$38,$3C   ;;sprite palette

; hardware vectors segment
.segment "VECTORS"
    ;.word 0,0,0
    .word NMI
    .word RESET
    .word IRQ

; binary files
.segment "CHARS"
    ;.incbin "tileset.chr"
    .incbin "sprites.chr"
