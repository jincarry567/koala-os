[SECTION .s16]
[BITS 16]
org 10000h

mov ax,cs
mov ds,ax
mov es,ax
mov ax,0x00
mov ss,ax
mov sp,0x7c00

mov ax,1301h
mov bx,000fh
mov dx,0200h
mov cx,12
push ax
mov ax,ds
mov es,ax
pop ax
mov bp,StartLoaderMessage
int 10h

push ax
in al,92h
or al,00000010b
out 92h,al
pop ax

[BITS 32]
lgdt [0x7e00]
mov eax,cr0
or eax,1
mov cr0,eax
mov ax,0xffffffff
mov fs,ax
mov eax,cr0
and al,11111110b
mov cr0,eax
sti


jmp $



StartLoaderMessage : db "Start Loader"