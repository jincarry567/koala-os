nasm ../src/boot/boot.asm -o ../dist/boot.bin
dd if=../dist/boot.bin of=boot.img bs=512 count=1 conv=notrunc
bochs -f bochsrc