#include "neslib.h"

Sprite *spr = 0;

void sync()
{
    // ram to oam is automatic
}

void main()
{
    spr = spr_get(0);
    spr->x = 0x80;
    spr->y = 0x80;
    spr->tile = 0x76;
    spr->attr = 0x00;

    // seek nt addr and write data
    //vram_seek(0);
    //vram_data();

    while(1) {
    }
}
