#include "neslib.h"

Sprite *spr = 0;

const byte bgAttr[] = {

};

void puts(byte nt, byte x, byte y, const byte *str)
{
    vram_seek(VRAM_NTCOORD(nt, x, y));

    while(*str != 0) {
        switch(*str) {
        case ' ':
            vram_put(0);
            break;

        case ',':
            vram_put(0x26);
            break;

        case '.':
            vram_put(0x25);
            break;

        case '\n':
            vram_seek(VRAM_NTCOORD(nt, x, ++y));
            break;

        default:
            if(*str >= 'A') {
                vram_put(*str - 'A' + 1);
            }
            else if(*str >= '0') {
                vram_put(*str - '0' + 0x1b);
            }
            break;
        }

        str++;
    }
}

void sync()
{
    if(scroll.x < 0xf0)
        scroll.x += 1;
    else {
        scroll.x = 0xff;
    }
    spr->x += 1;
}

void main()
{
    spr = (Sprite*)0x0200;
    spr->x = 0x80;
    spr->y = 0x80;
    spr->tile = 2;
    spr->attr = 0;
    puts(1, 5, 5, "HELLO 123.,\nTESTTEST");

    ppu_init(
             PPU_CTRL_VBLANK,
             PPU_MASK_SHOWBG|PPU_MASK_SHOWSPR|PPU_MASK_SPRNOCLIP|PPU_MASK_BGNOCLIP);

    while(1) {
    }
}
