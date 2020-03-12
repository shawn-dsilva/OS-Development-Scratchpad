ENTRY(boot)
OUTPUT_FORMAT("binary")

SECTIONS {
  . = 0x7c00;
  .boot :
  {
    *(.boot)
  }

  . = 0x7dfe;
  .sig : {
     SHORT(0xaa55);
  }

  . = 0x8000;
  .kernel : AT(0x7e00)  /* place immediately after the boot sector */
  {
    *(.kernel)
    *(.text)
    *(.rodata)
    *(.data)
    *(.bss)
    *(COMMON)
  }

}