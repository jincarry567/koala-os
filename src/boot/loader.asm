[SECTION .s16]
[BITS 16]
org 10000h

mov ax,cs
mov ds,ax
mov es,ax
mov ax,0x00
mov ss,ax
mov sp,0x7c00

push ax
in al,92h
or al,00000010b
out 92h,al
pop ax

lgdt [LOAD_GDT]
mov eax,cr0
or eax,1
mov cr0,eax
mov ax,10h
mov fs,ax
mov eax,cr0

jmp $



StartLoaderMessage : db "Start Loader"
LABEL_GDT : dd 0,0   
LABEL_DESC_CODE32:	dd	0x0000FFFF,0x00CF9A00
LABEL_DESC_DATA32:	dd	0x0000FFFF,0x00CF9200

LOAD_GDT :  dw 17h 
            dd LABEL_GDT


;=== LoaderGDT : dd 0h dd 0h  dd 7c00ffffh dd 00000000110011111001101000000000b