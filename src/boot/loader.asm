[SECTION .s16]
[BITS 16]
org 10000h

jmp Label_Start

BaseOfStack equ 0x7c00
BaseOfLoader equ 0x1000
OffsetOfLoader equ 0x00

RootDirSectors equ 14
SectorNumOfRootDirStart equ 19
SectorNumOfFAT1Start equ 1
SectorBalance equ 17


RootDirSizeForLoop dw RootDirSectors
SectorNo dw 0
Odd db 0
NoKernerMessage : db "ERROR:NO Kerner FOUND"
LoaderFileName : db "KERNER  BIN",0
PrintMsgAddr : dw 0

StartLoaderMessage : db "Start Loader"
LABEL_GDT : dd 0,0   
LABEL_DESC_CODE32:	dd	0x0000FFFF,0x00CF9A00
LABEL_DESC_DATA32:	dd	0x0000FFFF,0x00CF9200

LOAD_GDT :  dw 17h 
            dd LABEL_GDT

Label_Start:

    mov ax,cs
    mov ds,ax
    mov es,ax
    mov ax,0x00
    mov ss,ax
    mov sp,0x7c00

    ;call Enable_Protected_Mode
    mov ax,LoaderFileName
    mov [PrintMsgAddr],ax
    call print_msg
    jmp $

find_kernel_file:
    cmp word [RootDirSizeForLoop],0
    jz not_found_kernel
    dec word [RootDirSizeForLoop]


not_found_kernel:
    mov ax,1301h
    mov bx,008ch
    mov dx,0100h
    mov cx,21
    push ax
    mov ax,ds
    mov es,ax
    pop ax
    mov bp,NoKernerMessage
    int 10h
    jmp $

print_msg:
   
    push ax
    push bx
    push cx
    push dx
    push ds
    push es
    push bp

    mov ax,0600h
    mov bx,0700h
    mov cx,0
    mov dx,0184fh
    int 10h
    mov ax,0200h
    mov bx,0000h
    mov dx,0000h
    int 10h

    mov ax,1301h
    mov bx,000fh
    mov dx,0200h
    mov cx,12
    push ax
    mov ax,ds
    mov es,ax
    mov ax,[PrintMsgAddr]
    mov bp,ax
    pop ax
    int 10h

    pop bp
    pop es
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax

    ret

Enable_Protected_Mode:

    push ax
    in al,92h
    or al,00000010b
    out 92h,al
    pop ax

    cli
    lgdt [LOAD_GDT]
    mov eax,cr0
    or eax,1
    mov cr0,eax
    mov ax,10h
    mov fs,ax
    mov eax,cr0
    and al,11111110b
    mov cr0,eax
    sti
    ret
