
ENTRY(Reset_Handler)

/* Memory regions */
MEMORY
{
    RAM (xrw)      : ORIGIN = 0x20000000, LENGTH = 128K
    FLASH (rx)     : ORIGIN = 0x08000000, LENGTH = 1024K
}

/* Sections */
SECTIONS
{
    /* .text section: contains code and read-only data */
    .text :
    {
        __Vectors = .;
        KEEP(*(.vectors));           /* Keep vector table */
        __Vectors_End = .;
        __end = .;
        *(.text)                     /* Code section */
        *(.rodata)                   /* Read-only data */
    } > FLASH

    /* .data section: contains initialized data to be copied from FLASH to RAM */
    .data : 
    {
        __Data_Flash_ADDR = LOADADDR(.data); /* Flash address for data */
        __Start_data = .;
        *(.data)                     /* Data section */
        . = ALIGN(4);
        __End_data = .;
    } > RAM AT > FLASH

    /* .bss section: contains uninitialized data */
    .bss :
    {
        . = ALIGN(4);
        __bss_start = .;
        *(.bss*)                    /* Uninitialized data section */
        . = ALIGN(4);
        __bss_end = .;
    } > RAM

    /* .heap section: used for dynamic memory allocation */
    .heap (COPY) :
    {
        __HeapBase = .;
        KEEP(*(.heap*));            /* Keep heap section */
        __HeapLimit = .;
    } > RAM

    /* .stack_dummy section: used to calculate stack size */
    .stack_dummy (COPY) :
    {
        KEEP(*(.stack*));           /* Keep stack section */
    } > RAM

    /* Define stack limits */
    __StackTop = ORIGIN(RAM) + LENGTH(RAM);  /* Stack top is at the end of RAM */
    __StackLimit = __StackTop - SIZEOF(.stack_dummy);  /* Stack limit calculated */
    PROVIDE(__stack = __StackTop);            /* Provide stack top symbol */
}
