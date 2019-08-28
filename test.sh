#!/bin/sh


fasm lb_fat12.asm
if [ $? -eq 0 ]; then
    truncate -s 1440k flop.img
    dd if=lb_fat12.bin of=./flop.img bs=512 count=1
    qemu-system-i386 -cpu 486 -drive if=floppy,format=raw,file=./flop.img
fi