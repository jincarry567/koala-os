[SECTION .s16]
[BITS 16]
org 10000h

jmp Label_Start

%include	"fat12.inc"

BaseOfStack equ 0x7c00
BaseOfLoader equ 0x1000
OffsetOfLoader equ 0x00

RootDirSizeForLoop dw RootDirSectors
SectorNo dw SectorNumOfRootDirStart
RootIdx dw 0
NoKernerMessage : db "ERROR:NO Kerner FOUND"
LoaderFileName : db "LOADER  BIN",0
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
    jmp find_kernel_file
    jmp $

find_kernel_file:
    cmp word [RootDirSizeForLoop],0
    jz not_found_kernel
    dec word [RootDirSizeForLoop]
    mov ax,[SectorNo]
    ; 每次读2个扇区
    mov cl,2
    mov bx,0x8000
    add ax,SectorNumOfFAT1Start
    call Func_ReadOneSector
    mov word [RootIdx],0x8200
    jmp find_root_item

find_root_item:
    cmp word [RootIdx],0x8000
    jz find_kernel_file
    mov ax,[RootIdx]
    sub ax,20
    mov [RootIdx],ax
    push si
    push di
    
    mov cx,8
    mov si,ax
    mov di,LoaderFileName
    cld
    repe cmpsb
    pop di
    pop si
    mov [PrintMsgAddr],ax
    call print_msg
    jz finded_root_item
    jmp find_root_item

finded_root_item:
    mov ax,LoaderFileName
    mov [PrintMsgAddr],ax
    call print_msg
    jmp $

not_found_kernel:
    mov ax,NoKernerMessage
    mov [PrintMsgAddr],ax
    call print_msg
    jmp $

;=== mov ax,LoaderFileName
;=== mov [PrintMsgAddr],ax
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

; AX=待读取的磁盘起始扇区（0开始）
; CL=读入的扇区数量
; ES:BX 目标缓冲区地址
Func_ReadOneSector:
    push bp
    mov bp,sp
    sub esp,2
    mov byte [bp -2],cl
    push bx
    mov bl,[BPB_SecPerTrk]
    div bl
    inc ah
    mov cl,ah
    mov dh,al
    shr al,1
    mov ch,al
    and dh,1
    pop bx
    mov dl,[BS_DrvNum]
Label_Go_On_Reading:
    mov ah,2
    mov al,byte [bp -2]
    int 13h
    jc Label_Go_On_Reading
    add esp,2
    pop bp
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
