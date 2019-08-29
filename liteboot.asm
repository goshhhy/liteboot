format binary
use16

org $1000
    ; print string
    mov al,0
    mov ah,0x13
    mov dx,0
    mov bh,0
    mov bl,0x0f
    mov cx,25
    mov bp,pstring
    int 0x10

haltloop:
    cli
    hlt
    jmp haltloop

pstring: db "liteboot has been loaded!"