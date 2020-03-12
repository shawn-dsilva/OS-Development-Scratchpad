

void print(char* string,  int color) {
    volatile char *vga_buf = (volatile char*)0xB8000;
    while( *string != 0 )
    {
        *vga_buf++ = *string++;
        *vga_buf++ = color;
    }
}

extern void kmain()
{

    char hello[60] = "LOOK AT ME, IM IN 32 BITS  KERNEL C CODE NOW !!!";
    print(hello, 0x02);

}