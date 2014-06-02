#include "neslib.h"

Sprite *spr = 0;

const byte bg[] = {
    0x6b, 0x6c, 0x6d, 0x6f
};

void puts(byte x, byte y, const byte *str)
{
    vram_seek(VRAM_NTCOORD(0, x, y));

    while(*str != 0) {
        if(*str >= 'A') {
            vram_put(*str - 'A' + 10);
        }
        else
        if(*str >= '0') {
            vram_put(*str - '0');
        }

        str++;
    }
}

void sync()
{
    scroll.y += 1;
}

void main()
{
    puts(1, 1, "HELLO");

    spr = spr_getptr(0);
    spr->x = 0x80;
    spr->y = 0x80;
    spr->tile = 0x76;
    spr->attr = 0x00;

    // seek nt addr and write data
    vram_seek(VRAM_NTCOORD(0, 5, 2));
    vram_data(bg, 4);
    //vram_put(0xc5);
    //vram_seek(0);
    //vram_data();

    ppu_init(PPU_CTRL,PPU_MASK);
    while(1) {
    }
}
