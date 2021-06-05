rm ../dist/*.*
nasm ../src/boot/boot.asm -o ../dist/boot.bin
nasm -i../src/boot/ ../src/boot/loader.asm -o ../dist/LOADER.BIN
dd if=../dist/boot.bin of=boot.img bs=512 count=1 conv=notrunc
sudo mount boot.img /koala-os-fs/ -t vfat -o loop
sudo cp ../dist/LOADER.BIN /koala-os-fs/
sudo cp ../dist/LOADER.BIN /koala-os-fs/KERNER.BIN
sync
sudo umount /koala-os-fs/
bochs -f bochsrc