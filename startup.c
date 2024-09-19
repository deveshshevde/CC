
typedef unsigned int uint8_t;
typedef unsigned long uint32_t;

/*----------------------------------------------------------------------------
  Referenced from Linkers!!
 *----------------------------------------------------------------------------*/

extern void main();
extern uint32_t __StackTop;

extern uint32_t __Start_data;
extern uint32_t __End_data;
extern uint32_t __Data_Flash_ADDR;
extern uint32_t __bss_start;
extern uint32_t __bss_end;

/*----------------------------------------------------------------------------
  Exception / Interrupt Handler Function Prototype
 *----------------------------------------------------------------------------*/
typedef void( *pFunc )( void );

/*----------------------------------------------------------------------------
  Define stack and heap memory for microcontroller
 *----------------------------------------------------------------------------*/

#ifndef __Stack
    #define __Stack 0x00000200
#endif

static uint8_t stack[__Stack] __attribute__((aligned(8),used,section(".stack")));

#ifndef __Heap
    #define __Heap 0x00000200
#endif

static uint8_t stack[__Heap] __attribute__((aligned(8),used,section(".heap")));




    /*----------------------------------------------------------------------------
  Copied the data secti






/*----------------------------------------------------------------------------
  Internal References
 *----------------------------------------------------------------------------*/
void Default_Handler(void);                          /* Default empty handler */
void Reset_Handler(void);                            /* Reset Handler */
void NMI_Handler         (void) __attribute__ ((weak, alias("Default_Handler")));
void HardFault_Handler   (void) __attribute__ ((weak, alias("Default_Handler")));
void MemManage_Handler   (void) __attribute__ ((weak, alias("Default_Handler")));
void BusFault_Handler    (void) __attribute__ ((weak, alias("Default_Handler")));
void UsageFault_Handler  (void) __attribute__ ((weak, alias("Default_Handler")));
void SVC_Handler         (void) __attribute__ ((weak, alias("Default_Handler")));
void DebugMon_Handler    (void) __attribute__ ((weak, alias("Default_Handler")));
void PendSV_Handler      (void) __attribute__ ((weak, alias("Default_Handler")));
void SysTick_Handler     (void) __attribute__ ((weak, alias("Default_Handler")));



const pFunc __Vectors[] __attribute__ ((section(".vectors"))) = 
{
  /* Cortex-M4 Exceptions Handler */
  (pFunc)&__StackTop,                       /*      Initial Stack Pointer     */
  Reset_Handler,                            /*      Reset Handler             */
  NMI_Handler,                              /*      NMI Handler               */
  HardFault_Handler,                        /*      Hard Fault Handler        */
  MemManage_Handler,                        /*      MPU Fault Handler         */
  BusFault_Handler,                         /*      Bus Fault Handler         */
  UsageFault_Handler,                       /*      Usage Fault Handler       */
  0,                                        /*      Reserved                  */
  0,                                        /*      Reserved                  */
  0,                                        /*      Reserved                  */
  0,                                        /*      Reserved                  */
  SVC_Handler,                              /*      SVCall Handler            */
  DebugMon_Handler,                         /*      Debug Monitor Handler     */
  0,                                        /*      Reserved                  */
  PendSV_Handler,                           /*      PendSV Handler            */
  SysTick_Handler,                          /*      SysTick Handler           */
};


/*----------------------------------------------------------------------------
  Reset Handler called on controller reset
 *----------------------------------------------------------------------------*/
void Reset_Handler(void) {
    uint32_t *pSrc;
    uint32_t *pDes;

    uint32_t Size_to_Copy = __End_data - __Start_data;

    pSrc = &__Data_Flash_ADDR;

    /*----------------------------------------------------------------------------
  Copied the data section from FLASH to RAM
 *----------------------------------------------------------------------------*/

    for(;pDes = &__Start_data ; pDes < &__End_data){
        *(pDes++) = *(pSrc++);
    } 

    /*----------------------------------------------------------------------------
  Make BSS section 0
 *----------------------------------------------------------------------------*/
    pSrc = (uint32_t*)&__bss_start;
    pDes = &__bss_end;
    while(__bss_start<__bss_end)
    {
        *(pSrc++) = 0;
    }

    main();
}

void Default_Handler(void){
    while (1);
}