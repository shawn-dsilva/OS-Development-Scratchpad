nasm -f bin bootload.asm -o bootload.bin
nasm -f bin Stage2.asm -o stage2.bin
dd if=/dev/zero of=disk.img bs=1024 count=720
dd if=bootload.bin of=disk.img conv=notrunc
dd if=stage2.bin of=disk.img bs=512 seek=1 conv=notrunc
qemu-system-i386 -fda disk.img