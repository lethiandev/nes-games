#ifndef NESLIB_H_INCLUDED
#define NESLIB_H_INCLUDED

#define BINARY(a,b,c,d,e,f,g,h) \
    (((a)<<0)|((b)<<1)|((c)<<2)|((d)<<3)|((e)<<4)|((f)<<5)|((g)<<6)|((h)<<7))

#define SPRITE_TILE(bank, ind) ((((byte)ind))|(((byte)bank)<<7))
#define SPRITE_ATTR(pal, back, flipx, flipy)

/**************************************************
    PPU_CTRL ($2000) bit mask:
        7654 3210
        |||| ||||
        |||| ||++- Base nametable address
        |||| ||    (0 = $2000; 1 = $2400; 2 = $2800; 3 = $2C00)
        |||| |+--- VRAM address increment per CPU read/write of PPUDATA
        |||| |     (0: add 1, going across; 1: add 32, going down)
        |||| +---- Sprite pattern table address for 8x8 sprites
        ||||       (0: $0000; 1: $1000; ignored in 8x16 mode)
        |||+------ Background pattern table address (0: $0000; 1: $1000)
        ||+------- Sprite size (0: 8x8; 1: 8x16)
        |+-------- PPU master/slave select
        |          (0: read backdrop from EXT pins; 1: output color on EXT pins)
        +--------- Generate an NMI at the start of the
                   vertical blanking interval (0: off; 1: on)

    PPU_MASK ($2001) bit mask:
        7654 3210
        |||| ||||
        |||| |||+- Grayscale (0: normal color; 1: produce a monochrome display)
        |||| ||+-- 1: Show background in leftmost 8 pixels of screen; 0: Hide
        |||| |+--- 1: Show sprites in leftmost 8 pixels of screen; 0: Hide
        |||| +---- 1: Show background
        |||+------ 1: Show sprites
        ||+------- Intensify reds (and darken other colors)
        |+-------- Intensify greens (and darken other colors)
        +--------- Intensify blues (and darken other colors)
 **************************************************/
#define PPU_CTRL 0x09
#define PPU_MASK 0x78

#define VRAM_NTWIDTH  32
#define VRAM_NTHEIGHT 30
#define VRAM_NTSIZE   0x03C0
#define VRAM_NTSIZEA  0x0400

//#define VRAM_PATTERN(pt) ((pt)*0x1000) // unused
#define VRAM_PALETTE(of) (0x3F00  + (of))
#define VRAM_NTADDR(nt)  (0x2000 + ((nt)*VRAM_NTSIZEA))
#define VRAM_NTATTR(nt)  (VRAM_NTADDR(nt) + VRAM_NTSIZE)

#define VRAM_NTCOORD(nt, x, y) (VRAM_NTADDR(nt) + (y)*VRAM_NTWIDTH + (x))

typedef unsigned int  uint;
typedef unsigned char byte;

/**
    NES sprite structure in given order.
    x    - horizontal sprite position
    attr - sprite attribute
    tile - CHR source tile
    y    - vertical sprite position
*/
typedef struct {
    byte y, tile, attr, x;
} Sprite;

typedef struct {
    byte x, y;
} Scroll;

extern Scroll scroll;

// ppu
void ppu_vblankwait();
void __fastcall__ ppu_init(byte ctr, byte mask);
void ppu_ram2oam();

// vram memory access
void __fastcall__ vram_seek(uint offset);
void __fastcall__ vram_data(const byte *data, byte size);
void __fastcall__ vram_put(byte value);

// pallete
void __fastcall__ pal_seek(byte offset);
void __fastcall__ pal_data(const byte *data);
void __fastcall__ pal_put(byte color);

// sprites
Sprite* __fastcall__ spr_getptr(byte n);

#endif // NESLIB_H_INCLUDED
