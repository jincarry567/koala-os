nasm ../src/boot/boot.asm -o ../dist/boot.bin
nasm ../src/boot/loader.asm -o ../dist/LOADER.BIN
dd if=../dist/boot.bin of=boot.img bs=512 count=1 conv=notrunc
sudo mount boot.img /koala-os-fs/ -t vfat -o loop
sudo cp ../dist/loader.bin /koala-os-fs/
sync
sudo umount /koala-os-fs/
bochs -f bochsrc