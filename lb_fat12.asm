format binary
use16

org $7c00
jmp short init
nop

bpb:
bpb_oem:   db "liteboot"
bpb_bps:   dw 512
bpb_spc:   db 1
bpb_res:   dw 1
bpb_nfat:  db 1
bpb_ndir:  dw 224
bpb_nsec:  dw 2880
bpb_mtype: db 0xf0
bpb_spf:   dw 9
bpb_spt:   dw 18
bpb_nhead: dw 2
bpb_nhide: dq 0
bpb_lsec:  dq 0
ebr:
ebr_drv:   db 0
ebr_flags: db 0
ebr_sig:   db 41
ebr_ser:   db "ltbt"
ebr_label: db "liteboot   "
ebr_ident: db "fat12   "
; API provided from boot sector to second stage
bapi:
bapi_loadfile: dw loadfile

init:
    xchg bx,bx
    push cs
    pop ax
    mov ds, ax
    mov es, ax
    call cls
    ; print string
    mov al,0
    mov ah,0x13
    mov dx,0
    mov bh,0
    mov bl,0x0f
    mov cx,8
    mov bp,pstring
    int 0x10
    ; copy fat into ram at 0x1000
    mov ah, 0x02
    mov al, [bpb_spf]
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, 0
    mov bx, 0x1000
    int 0x13


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

pstring: db "liteboat"

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
