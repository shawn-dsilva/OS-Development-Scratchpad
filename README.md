# OS Development Scratchpad

Repository for learning how to develop an Operating System from scratch, using various resources.

## Specs/Objectives
- x86 architecture
- GRUB as bootloader to start off
- QEMU or some other VM, not real hardware for now
- x86 assembly and C


## Troubleshooting
- press 'c' then enter to get `bochs` to start executing your code
- `nasm -f elf32  boot4.s -o boot4.o` to compile boot4.s into obj file
- `gcc -m32 kmain.cpp boot4.o -o kernel.bin -nostdlib -ffreestanding -std=c++11 -mno-red-zone -fno-exceptions -nostdlib -fno-rtti -Wall -Wextra -Werror -T linker.ld` to compile `kmain.cpp` with `boot4.o` into `kernel.bin`
- `qemu-system-x86_64 -fda kernel.bin` to run binary in qemu