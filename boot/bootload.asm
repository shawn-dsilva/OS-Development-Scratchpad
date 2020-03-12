[bits 16]
section .boot
global boot
    ; BIOS sets DL to boot drive before jumping to the bootloader

    ; Since we specified an ORG(offset) of 0x7c00 we should make sure that
    ; Data Segment (DS) is set accordingly. The DS:Offset that would work
    ; in this case is DS=0 . That would map to segment:offset 0x0000:0x7c00
    ; which is physical memory address (0x0000<<4)+0x7c00 . We can't rely on
    ; DS being set to what we expect upon jumping to our code so we set it
    ; explicitly
boot:
    mov si,hello ; point si register to hello label memory location
    mov ah,0x0e ; 0x0e means 'Write Character in TTY mode'
.loop:
    lodsb
    or al,al ; is al == 0 ?
    jz diskboot ; if (al == 0) jump to halt label
    int 0x10 ; runs BIOS interrupt 0x10 - Video Services
    jmp .loop

hello: db "In Bootloader Stage One, Loading Stage Two...",0


diskboot:
    mov ax,0x800    ; When we read the sector, we are going to read address 0x1000
    mov es,ax         ; Set ES with 0x1000

    xor bx,bx   ;Ensure that the buffer offset is 0!
    mov ah,0x2  ;2 = Read floppy
    mov al,0x1  ;Reading one sector
    mov ch,0x0  ;Track 1
    mov cl,0x2  ;Sector 2, track 1
    mov dh,0x0  ;Head 1
    int 0x13
    jmp 0x800:0 ;Jump to 0x1000, start of second program
