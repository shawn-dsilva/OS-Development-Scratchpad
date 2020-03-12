# nasm -f bin bootload.asm -o bootload.bin
# nasm -f bin Stage2.asm -o stage2.bin
# dd if=/dev/zero of=disk.img bs=1024 count=720
# dd if=bootload.bin of=disk.img conv=notrunc
# dd if=stage2.bin of=disk.img bs=512 seek=1 conv=notrunc
# qemu-system-i386 -fda disk.img
nasm -f elf bootload.asm -o bootload.o
nasm -f elf Stage2.asm -o stage2.o
# gcc -m32  kmain.cpp -o kmain.o -nostdlib -ffreestanding -std=c++11 -mno-red-zone -fno-exceptions -nostdlib -fno-rtti -Wall -Wextra -T clinker.ld
# gcc -m32 bootload.o stage2.o  kmain.o -o kernel.bin -nostdlib -ffreestanding -std=c++11 -mno-red-zone -fno-exceptions -nostdlib -fno-rtti -Wall -Wextra  -T linker.ld
gcc -m32  stage2.o bootload.o kmain.c -o kernel.bin -nostdlib -ffreestanding -mno-red-zone -fno-exceptions -nostdlib  -Wall -Wextra  -T linker.ld


qemu-system-i386 -fda kernel.bin