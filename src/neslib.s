; NES lib

; void __fastcall__ ppu_vblankwait();
; void __fastcall__ ppu_init(byte ctr, byte mask);
.export _ppu_vblankwait, _ppu_init, _ppu_ram2oam

; void __fastcall__ pal_seek(byte offset);
; void __fastcall__ pal_data(const byte *data, byte offset);
; void __fastcall__ pal_put(byte color);
.export _pal_seek, _pal_data, _pal_put

; Sprite* __fastcall__ spr_get(byte n);
.export _spr_get

.include "zeropage.inc"

; library code segment
.segment "CODE"


;;;;;;;;;; PPU
_ppu_vblankwait: ; void
    BIT $2002
    BPL _ppu_vblankwait
    RTS


_ppu_init: ; A - ctr mask, X - screen mask
    STA $2000
    STX $2001
    RTS


_ppu_ram2oam:
    LDA #$00  ; set the low byte (00) of the RAM address
    STA $2003
    LDA #$02  ; set the high byte (02) of the RAM address
    STA $4014 ; start sprites data transfer RAM to OAM
    RTS


;;;;;;;;;; PALLETE
_pal_seek: ; A - seek position
    LDX $2002 ; hi/low seek reset
    LDX #$3F  ; seek PPU address to $[3F]00 - hi-byte
    STX $2006
    ;LDA #$00 ; seek PPU address to $3F[00] - low-byte
    STA $2006 ; store function argument
    RTS


_pal_data: ; A - low-bytes pointer, X - hi-bytes pointer
    STA ptr1   ; store data address into zeropage - 2bytes
    STX ptr1+1
    LDA $2002 ; hi/low seek reset
    LDA #$3F  ; seek PPU address to $[3F]00 - hi-byte
    STA $2006
    LDA #$00  ; seek PPU address to $3F[00] - low-byte
    STA $2006
    LDY #$00  ; start indexing
@1:
    LDA (ptr1), Y ; read data
    STA $2007
    INY
    CPY #$20
    BNE @1 ; loop limit
    RTS


_pal_putat: ; A - byte color, X - byte offset
    LDY $2002 ; hi/low seek reset
    LDY #$3F  ; seek PPU address to $[3F]00 - hi-byte
    STY $2006
    ;LDX #$00 ; seek PPU address to $3F[00] - low-byte
    STX $2006 ; store function argument


_pal_put: ; A - byte color
    STA $2007
    RTS


_pal_fill: ; A - low-bytes pointer, X - hi-bytes pointer
    STA ptr1   ; store data address into zeropage - 2bytes
    STX ptr1+1
    LDA $2002 ; hi/low seek reset
    LDA #$3F  ; seek PPU address to $[3F]00 - hi-byte
    STA $2006
    LDA #$00  ; seek PPU address to $3F[00] - low-byte
    STA $2006
    LDY #$00  ; start indexing
@1:
    LDA (ptr1), Y ; read data
    STA $2007
    INY
    CPY #$20
    BNE @1 ; loop limit
    RTS

_spr_get: ; A - sprite index
    ASL ; multiple A by 4
    ASL
    LDX #$02
    RTS
