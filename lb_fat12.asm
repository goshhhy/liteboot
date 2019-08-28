format binary
use16

org $7c00
jmp short init
nop

bpb:
bpb_oem:   rb 8
bpb_bps:   rb 2
bpb_spc:   rb 1
bpb_res:   rb 2
bpb_nfat:  rb 1
bpb_ndir:  rb 2
bpb_nsec:  rb 2
bpb_mtype: rb 1
bpb_spf:   rb 2
bpb_spt:   rb 2
bpb_nhead: rb 2
bpb_nhide: rb 4
bpb_lsec:  rb 4
ebr:
ebr_drv:   rb 1
ebr_flags: rb 1
ebr_sig:   rb 1
ebr_ser:   rb 4
ebr_label: rb 11
ebr_ident: rb 8
; API provided from boot sector to second stage
bapi:
bapi_loadfile: dw loadfile

init:
    push cs
    pop es
    call cls
    mov al,0
    mov ah,0x13
    mov dx,0
    mov bh,0
    mov bl,0x0f
    mov cx,8
    mov bp,pstring
    int 0x10

hloop:
    hlt
    jmp hloop

; library functions

loadfile:
    pusha
    popa
    ret

cls:
    pusha
    mov ax, 0x07
    mov bx, ax
    mov cx, ax
    mov dx, 0x1950
    int 0x10
    popa
    ret

; data

pstring: db "liteboot"
bsident: db "fat12   "

; end

display 13,10,"0x"
bits = 12
repeat bits/4
    d = '0' + (510-($-$$)) shr (bits-%*4) and 0Fh
    if d > '9'
        d = d + 'A'-'9'-1
    end if
    display d
end repeat
display " bytes of free space",13,10

padding: times 510-($-$$) db 0
bootsig: dw 0xaa55
