
// Clock base addr and configs for the bus which we have to enable

.equ RCC_ADDR_BASE       ,    0x40023800
.equ RCC_AHB1ENR_OFF     ,    0x30


.equ RCC_AHB1ENR         ,    (RCC_ADDR_BASE+RCC_AHB1ENR_OFF)

.equ GPIOD_EN            ,    (1 << 3)




.equ GPIOD_ADDR_BASE     ,    0x40020C00
.equ GPIOD_MODER_OFFSET  ,    0x00000000
.equ GPIOD_MODER         ,    (GPIOD_ADDR_BASE+GPIOD_MODER_OFFSET)
.equ GPIOD_ODR_OFFSET    ,    0x14

.equ LEDS              ,    (GPIOD_ADDR_BASE+GPIOD_ODR_OFFSET)

.equ LED1_ON 		     ,    (1<<12)
.equ LED2_ON 		     ,    (1<<13)
.equ LED3_ON 		     ,    (1<<14)
.equ LED4_ON 		     ,    (1<<15)
.equ LED_OFF             ,    (0<<12)
.equ GPIOD_12            ,    (1<<24)
.equ GPIOD_13            ,    (1<<26)
.equ GPIOD_14            ,    (1<<28)
.equ GPIOD_15            ,    (1<<30)





.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb

	.section .text


	.globl main


main:

	//Lets use some arm register (real significance of aasm lol )


	/* Enable the clock acc for GPIOD*/
	ldr r1,=RCC_AHB1ENR

	ldr r0,[r1]

	orr r0,#GPIOD_EN

	/* Now arm is load store arch :)
	we have to store the modification also
	*/
	str r0,[r1]


	/*
	Lets give my led pin order to act as output :)
	*/

	ldr r1 ,=GPIOD_MODER
	ldr r0,[r1]
	orr r0,GPIOD_12;
	orr r0,GPIOD_13;
	orr r0,GPIOD_14;
	orr r0,GPIOD_15;
	str r0,[r1]


	/*
		Now check whether it is glowing or not !
	*/
	;ldr r0,=(LED1_ON | LED2_ON | LED3_ON | LED4_ON)

while:
	ldr r1 ,=LEDS
	eor r0,r0
	ldr r0,=(LED1_ON | LED2_ON | LED3_ON | LED4_ON)
	str r0,[r1]
	bl delay
	ldr r0,=0
	str r0,[r1]
	bl delay
	b while


/* Delay subroutine */
delay:
	ldr r6,=#4128768
delay_loop:
	subs r6, r6, #1
	bne delay_loop
	bx lr

	.align
	.end
