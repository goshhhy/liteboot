#!/bin/sh


fasm lb_fat12.asm
if [ $? -eq 0 ]; then
    if [ ! -f flop.img ]; then
        truncate -s 1440k flop.img
    fi
    dd if=lb_fat12.bin of=./flop.img conv=notrunc
    qemu-system-i386 -cpu 486 -drive if=floppy,format=raw,file=./flop.img
fi