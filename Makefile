
bochs: clean boot loader
	bochs -f env/bochsrc

clean:
	rm -f dist/boot.bin
	rm -f dist/LOADER.BIN

boot:
	nasm src/boot/boot.asm -o dist/boot.bin
	dd if=dist/boot.bin of=boot.img bs=512 count=1 conv=notrunc

loader:
	nasm -i./src/boot/ ./src/boot/loader.asm -o dist/LOADER.BIN
	sudo mount env/boot.img /koala-os-fs/ -t vfat -o loop
	sudo cp dist/LOADER.BIN /koala-os-fs/
	sudo cp dist/KERNEL.BIN /koala-os-fs/KERNEL.BIN
	sync
	sudo umount /koala-os-fs/