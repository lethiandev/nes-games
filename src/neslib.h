#ifndef NESLIB_H_INCLUDED
#define NESLIB_H_INCLUDED

typedef unsigned int  uint;
typedef unsigned char byte;

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
#define PPU_CTRL 0x
#define PPU_MASK

#define NT_PATTERN(pt)
#define NT_ADDR(nt)
#define NT_ATTR(nt)

typedef struct {
    byte y, tile, attr, x;
} Sprite;

// ppu
void ppu_vblankwait();
void __fastcall__ ppu_init(byte ctr, byte mask);
void ppu_ram2oam();

// vram nametables memory access
void vram_seek(uint offset);
void vram_data(const byte *data, uint size);

// pallete
void __fastcall__ pal_seek(byte offset);
void __fastcall__ pal_data(const byte *data);
void __fastcall__ pal_put(byte color);

// sprites
Sprite* __fastcall__ spr_get(byte n);

#endif // NESLIB_H_INCLUDED
