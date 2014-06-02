; NES lib

; export to C functions
.export _ppu_vblankwait, _ppu_init, _ppu_ram2oam
.export _pal_seek, _pal_data, _pal_put
.export _vram_seek, _vram_data, _vram_put
.export _spr_getptr

.import popa, popax

; include zeropage
.include "zeropage.inc"

; the library code segment
.segment "CODE"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; PPU
; void ppu_vblankwait();
_ppu_vblankwait: ; void
    BIT $2002
    BPL _ppu_vblankwait
    RTS


; void __fastcall__ ppu_init(byte ctr, byte mask);
_ppu_init: ; X - ctr mask, A - screen mask
    STX $2000
    STA $2001
    RTS


; void ppu_ram2oam();
_ppu_ram2oam:
    LDA #$00  ; set the low byte (00) of the RAM address
    STA $2003
    LDA #$02  ; set the high byte (02) of the RAM address
    STA $4014 ; start sprites data transfer RAM to OAM
    RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; VRAM (NAMETABLES)
; void __fastcall__ vram_seek(uint offset);
_vram_seek: ; (uint offset)
    LDY $2002
    ;LDX #$3F ; hi
    STX $2006
    ;LDA #$00 ; low
    STA $2006
    RTS


; void __fastcall__ vram_data(const byte *data, byte size);
_vram_data:
    STA ptr1    ; size
    JSR popax
    STA ptr2
    STX ptr2+1  ; data
    ; STX ptr2+1
    ; data loop
    LDY #$00
@1:
    LDA (ptr2), Y
    STA $2007
    INY
    CPY #$04
    BNE @1
    RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; PALLETE
; void __fastcall__ pal_seek(byte offset);
_pal_seek: ; A - seek position
    LDX $2002 ; hi/low seek reset
    LDX #$3F  ; seek PPU address to $[3F]00 - hi-byte
    STX $2006
    ;LDA #$00 ; seek PPU address to $3F[00] - low-byte
    STA $2006 ; store function argument
    RTS


; void __fastcall__ pal_data(const byte *data);
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


; void __fastcall__ pal_put(byte color);
; void __fastcall__ vram_put(byte value);
_pal_put: ; A - byte color
_vram_put: ; A - value
    STA $2007
    RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; SPRITE
; Sprite* __fastcall__ spr_get(byte n);
_spr_getptr: ; A - sprite index
    ASL ; multiple A by 4
    ASL
    LDX #$02
    RTS
