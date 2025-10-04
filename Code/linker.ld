/* linker.ld — minimal bare-metal RISC-V (RV32I, no OS) */

ENTRY(_start)

MEMORY
{
    RAM (rwx) : ORIGIN = 0x00000000, LENGTH = 64K
}

SECTIONS
{
    /* Code and read-only data */
    .text :
    {
        KEEP(*(.init))        /* startup code */
        *(.text*)             /* program code */
        *(.rodata*)           /* const data */
    } > RAM

    /* Initialized data */
    .data :
    {
        *(.data*)
    } > RAM

    /* Uninitialized data */
    .bss (NOLOAD) :
    {
        *(.bss*)
        *(COMMON)
    } > RAM

    /* Stack near the top of RAM */
    _stack_top = ORIGIN(RAM) + LENGTH(RAM);
}