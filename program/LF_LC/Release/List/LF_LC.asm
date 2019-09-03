
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R4
	.DEF _rx_counter=R7
	.DEF _tx_wr_index=R6
	.DEF _tx_rd_index=R9
	.DEF _tx_counter=R8
	.DEF _kP=R10
	.DEF _kP_msb=R11
	.DEF _kI=R12
	.DEF _kI_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_c:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x1F
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x1F,0x1F
	.DB  0x0,0x0,0x0,0x0,0x0,0x1F,0x1F,0x1F
	.DB  0x0,0x0,0x0,0x0,0x1F,0x1F,0x1F,0x1F
	.DB  0x0,0x0,0x0,0x1F,0x1F,0x1F,0x1F,0x1F
	.DB  0x0,0x0,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F
	.DB  0x0,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x14:
	.DB  0x0,0x0,0x10,0x0,0x8,0x0,0x4,0x0
	.DB  0x2,0x0,0x1
_0x15:
	.DB  0x0,0x0,0x0,0x2,0x0,0x4,0x0,0x8
	.DB  0x0,0x10,0x0,0x20
_0x0:
	.DB  0x20,0x20,0x20,0x20,0x4D,0x61,0x73,0x75
	.DB  0x6B,0x6B,0x61,0x6E,0x20,0x20,0x20,0x20
	.DB  0x0,0x50,0x61,0x73,0x73,0x77,0x6F,0x72
	.DB  0x64,0x3A,0x2E,0x2E,0x2E,0x2E,0x2E,0x2E
	.DB  0x2E,0x0,0x2A,0x0,0x20,0x4D,0x61,0x61
	.DB  0x66,0x20,0x50,0x61,0x73,0x73,0x77,0x6F
	.DB  0x72,0x64,0x20,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x53,0x61,0x6C,0x61,0x68,0x20,0x21
	.DB  0x21,0x20,0x20,0x20,0x20,0x0,0x4E,0x0
	.DB  0x43,0x0,0x43,0x50,0x3A,0x25,0x64,0x20
	.DB  0x0,0x61,0x0,0x62,0x0,0x63,0x0,0x20
	.DB  0x20,0x20,0x41,0x6E,0x64,0x61,0x20,0x54
	.DB  0x65,0x6C,0x61,0x68,0x20,0x20,0x20,0x0
	.DB  0x20,0x41,0x6B,0x74,0x69,0x66,0x61,0x73
	.DB  0x69,0x20,0x52,0x65,0x73,0x65,0x74,0x20
	.DB  0x0,0x20,0x53,0x69,0x6C,0x61,0x68,0x6B
	.DB  0x61,0x6E,0x20,0x55,0x6E,0x74,0x75,0x6B
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x52,0x65
	.DB  0x73,0x74,0x61,0x72,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x52,0x65,0x73,0x65,0x74
	.DB  0x20,0x53,0x65,0x74,0x74,0x69,0x6E,0x67
	.DB  0x20,0x3F,0x20,0x0,0x2B,0x20,0x59,0x61
	.DB  0x20,0x0,0x2D,0x20,0x54,0x69,0x64,0x61
	.DB  0x6B,0x20,0x20,0x20,0x20,0x0,0x53,0x69
	.DB  0x6C,0x61,0x68,0x6B,0x61,0x6E,0x20,0x52
	.DB  0x65,0x73,0x74,0x61,0x72,0x74,0x0,0x20
	.DB  0x20,0x55,0x6E,0x74,0x75,0x6B,0x20,0x52
	.DB  0x65,0x73,0x65,0x74,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x20,0x4B,0x6F,0x6D,0x75,0x6E
	.DB  0x69,0x6B,0x61,0x73,0x69,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x53,0x65,0x72,0x69,0x61
	.DB  0x6C,0x20,0x41,0x6B,0x74,0x69,0x66,0x20
	.DB  0x20,0x0,0x53,0x65,0x72,0x69,0x61,0x6C
	.DB  0x20,0x4E,0x6F,0x6E,0x2D,0x41,0x6B,0x74
	.DB  0x69,0x66,0x0,0x25,0x30,0x2E,0x32,0x66
	.DB  0x56,0x20,0x20,0x3E,0x3E,0x0,0x2B,0x20
	.DB  0x41,0x74,0x75,0x72,0x20,0x50,0x49,0x44
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x2D
	.DB  0x20,0x41,0x74,0x75,0x72,0x20,0x4B,0x65
	.DB  0x6C,0x61,0x6A,0x75,0x61,0x6E,0x20,0x0
	.DB  0x2B,0x20,0x54,0x65,0x73,0x20,0x4D,0x6F
	.DB  0x74,0x6F,0x72,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x2D,0x20,0x4B,0x61,0x6C,0x69,0x62
	.DB  0x72,0x61,0x73,0x69,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x2B,0x20,0x53,0x74,0x61,0x62
	.DB  0x69,0x6C,0x69,0x73,0x61,0x74,0x6F,0x72
	.DB  0x20,0x20,0x0,0x2D,0x20,0x44,0x65,0x6C
	.DB  0x61,0x79,0x20,0x41,0x77,0x61,0x6C,0x20
	.DB  0x20,0x20,0x20,0x0,0x2B,0x20,0x41,0x74
	.DB  0x75,0x72,0x20,0x43,0x6F,0x75,0x6E,0x74
	.DB  0x65,0x72,0x20,0x20,0x0,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x54,0x49,0x4D,0x20,0x4C,0x43
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x0,0x6B,0x50
	.DB  0x20,0x20,0x20,0x6B,0x49,0x20,0x20,0x20
	.DB  0x6B,0x44,0x20,0x20,0x20,0x20,0x0,0x63
	.DB  0xD,0x0,0x25,0x64,0xA,0x0,0x64,0xD
	.DB  0x0,0x65,0xD,0x0,0x64,0x0,0x65,0x0
	.DB  0x4D,0x61,0x6B,0x73,0x20,0x4D,0x69,0x6E
	.DB  0x20,0x20,0x20,0x4C,0x61,0x6A,0x75,0x20
	.DB  0x0,0x25,0x64,0x0,0x2D,0x25,0x64,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x43,0x65,0x6B
	.DB  0x20,0x4D,0x6F,0x74,0x6F,0x72,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x20,0x4C
	.DB  0x75,0x72,0x75,0x73,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x20,0x20,0x42,0x65,0x6C
	.DB  0x6F,0x6B,0x20,0x4B,0x61,0x6E,0x61,0x6E
	.DB  0x20,0x20,0x20,0x0,0x20,0x20,0x20,0x42
	.DB  0x65,0x6C,0x6F,0x6B,0x20,0x4B,0x69,0x72
	.DB  0x69,0x20,0x20,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x4D,0x75,0x6E,0x64,0x75,0x72
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x42,0x65,0x72,0x68,0x65,0x6E
	.DB  0x74,0x69,0x20,0x20,0x20,0x20,0x0,0x54
	.DB  0x6F,0x74,0x61,0x6C,0x20,0x57,0x61,0x6B
	.DB  0x74,0x75,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x25,0x64,0x73,0x3A,0x25,0x64,0x6D,0x73
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x4B,0x61
	.DB  0x6C,0x69,0x62,0x72,0x61,0x73,0x69,0x2E
	.DB  0x2E,0x2E,0x20,0x20,0x20,0x20,0x0,0x53
	.DB  0x74,0x61,0x62,0x69,0x6C,0x69,0x73,0x61
	.DB  0x74,0x6F,0x72,0x20,0x20,0x20,0x20,0x0
	.DB  0x25,0x64,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x44,0x65,0x6C,0x61,0x79,0x20,0x41
	.DB  0x77,0x61,0x6C,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x25,0x64,0x20,0x20,0x0,0x49
	.DB  0x3A,0x25,0x64,0x20,0x0,0x44,0x3A,0x25
	.DB  0x64,0x20,0x0,0x54,0x3A,0x25,0x64,0x20
	.DB  0x0,0x41,0x3A,0x4C,0x75,0x0,0x41,0x3A
	.DB  0x4B,0x61,0x0,0x41,0x3A,0x4B,0x69,0x0
	.DB  0x41,0x3A,0x53,0x74,0x0,0x4B,0x69,0x3A
	.DB  0x25,0x64,0x20,0x0,0x4B,0x61,0x3A,0x25
	.DB  0x64,0x0,0x53,0x3A,0x0,0x2D,0x2D,0x0
	.DB  0x43,0x50,0x0,0x4E,0x6F,0x49,0x6E,0x76
	.DB  0x0,0x49,0x6E,0x76,0x72,0x74,0x0,0x4C
	.DB  0x4B,0x69,0x3A,0x25,0x64,0x20,0x20,0x0
	.DB  0x4C,0x4B,0x61,0x3A,0x25,0x64,0x20,0x20
	.DB  0x0,0x4C,0x3A,0x25,0x64,0x20,0x20,0x0
	.DB  0x53,0x69,0x6D,0x70,0x61,0x6E,0x2E,0x2E
	.DB  0x2E,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x54,0x69
	.DB  0x6D,0x20,0x4C,0x43,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x32,0x30,0x31,0x37,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2020003:
	.DB  0x80,0xC0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x06
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0B
	.DW  _sensor_ka
	.DW  _0x14*2

	.DW  0x0C
	.DW  _sensor_ki
	.DW  _0x15*2

	.DW  0x02
	.DW  _0xBC
	.DW  _0x0*2+81

	.DW  0x02
	.DW  _0xBC+2
	.DW  _0x0*2+83

	.DW  0x02
	.DW  _0xBC+4
	.DW  _0x0*2+85

	.DW  0x03
	.DW  _0xBC+6
	.DW  _0x0*2+439

	.DW  0x03
	.DW  _0xBC+9
	.DW  _0x0*2+446

	.DW  0x03
	.DW  _0xBC+12
	.DW  _0x0*2+449

	.DW  0x02
	.DW  _0xBC+15
	.DW  _0x0*2+81

	.DW  0x02
	.DW  _0xBC+17
	.DW  _0x0*2+83

	.DW  0x02
	.DW  _0xBC+19
	.DW  _0x0*2+85

	.DW  0x02
	.DW  _0xBC+21
	.DW  _0x0*2+452

	.DW  0x02
	.DW  _0xBC+23
	.DW  _0x0*2+454

	.DW  0x03
	.DW  _0xBC+25
	.DW  _0x0*2+439

	.DW  0x03
	.DW  _0xBC+28
	.DW  _0x0*2+446

	.DW  0x03
	.DW  _0xBC+31
	.DW  _0x0*2+449

	.DW  0x03
	.DW  _0xBC+34
	.DW  _0x0*2+439

	.DW  0x03
	.DW  _0xBC+37
	.DW  _0x0*2+446

	.DW  0x03
	.DW  _0xBC+40
	.DW  _0x0*2+449

	.DW  0x03
	.DW  _0xBC+43
	.DW  _0x0*2+439

	.DW  0x03
	.DW  _0xBC+46
	.DW  _0x0*2+446

	.DW  0x03
	.DW  _0xBC+49
	.DW  _0x0*2+449

	.DW  0x02
	.DW  _0xBC+52
	.DW  _0x0*2+81

	.DW  0x02
	.DW  _0xBC+54
	.DW  _0x0*2+83

	.DW  0x02
	.DW  _0xBC+56
	.DW  _0x0*2+85

	.DW  0x02
	.DW  _0xBC+58
	.DW  _0x0*2+452

	.DW  0x02
	.DW  _0xBC+60
	.DW  _0x0*2+454

	.DW  0x03
	.DW  _0xBC+62
	.DW  _0x0*2+449

	.DW  0x03
	.DW  _0xBC+65
	.DW  _0x0*2+439

	.DW  0x03
	.DW  _0xBC+68
	.DW  _0x0*2+446

	.DW  0x03
	.DW  _0xBC+71
	.DW  _0x0*2+449

	.DW  0x03
	.DW  _0xBC+74
	.DW  _0x0*2+439

	.DW  0x03
	.DW  _0xBC+77
	.DW  _0x0*2+446

	.DW  0x03
	.DW  _0xBC+80
	.DW  _0x0*2+449

	.DW  0x02
	.DW  _0xBC+83
	.DW  _0x0*2+81

	.DW  0x02
	.DW  _0xBC+85
	.DW  _0x0*2+83

	.DW  0x02
	.DW  _0xBC+87
	.DW  _0x0*2+81

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*
; * LF_LC.c
; *
; * Created: 6/9/2017 5:33:09 AM Pembaharuan dari LF _NEWBIE 11/23/2016 11:37:15 AM -> LF Newbie buat INTERNAL TC2016
; * Author: Lintang
; */
;
;#include <stdio.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <mega32.h>
;#include <alcd.h>
;#include <delay.h>
;#include <stdlib.h>
;#include <string.h>
;
;#define motor_kiri PORTD.3
;#define motor_kanan PORTD.6
;#define OK PINC.0
;#define BATAL PINC.1
;#define MENU_ATAS PINC.2
;#define MENU_BAWAH PINC.3
;#define TAMBAH_NILAI PINC.4
;#define KURANG_NILAI PINC.5
;#define TR_1 PORTC.6
;#define TR_2 PORTC.7
;#define LCD PORTB.3
;
;#define sensor_mati TR_1 = 0;TR_2 = 0
;#define klap_klip TR_1 = 1;TR_2 = 0;LCD = 0;delay_ms(100);TR_1 = 0;TR_2 = 1;LCD = 1;delay_ms(100)
;
;#define NORMAL 0
;#define COUNTER 1
;
;#define JML_INDEKS 90
;
;#define lurus 0
;#define kanan 1
;#define kiri 2
;#define stop 3
;
;//urutan password
;#define kunci_1 OK
;#define kunci_2 TAMBAH_NILAI
;#define kunci_3 TAMBAH_NILAI
;#define kunci_4 BATAL
;#define kunci_5 OK
;#define kunci_6 KURANG_NILAI
;#define kunci_7 TAMBAH_NILAI
;
;#define ADC_VREF_TYPE 0x20 //saya pake referensi AREF
;
;#define USART_BAUDRATE 9600
;#define BAUD_PRESCALE ((((16000000/16) + (USART_BAUDRATE / 2)) / (USART_BAUDRATE)) - 1)//103.6666667
;//=====================================================================================
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index=0,rx_rd_index=0;
;#else
;unsigned int rx_wr_index=0,rx_rd_index=0;
;#endif
;
;#if RX_BUFFER_SIZE < 256
;unsigned char rx_counter=0;
;#else
;unsigned int rx_counter=0;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void){
; 0000 0050 interrupt [14] void usart_rx_isr(void){

	.CSEG
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0051     char status,data;
; 0000 0052     status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0053     data=UDR;
	IN   R16,12
; 0000 0054     if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0){
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BREQ PC+3
	JMP _0x3
; 0000 0055         rx_buffer[rx_wr_index++]=data;
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0056 #if RX_BUFFER_SIZE == 256
; 0000 0057         // special case for receiver buffer size=256
; 0000 0058         if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 0059 #else
; 0000 005A         if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R5
	BREQ PC+3
	JMP _0x4
	CLR  R5
; 0000 005B         if (++rx_counter == RX_BUFFER_SIZE){
_0x4:
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BREQ PC+3
	JMP _0x5
; 0000 005C             rx_counter=0;
	CLR  R7
; 0000 005D             rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 005E         }
; 0000 005F #endif
; 0000 0060     }
_0x5:
; 0000 0061 }
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void){
; 0000 0067 char getchar(void){
_getchar:
; .FSTART _getchar
; 0000 0068     char data;
; 0000 0069     while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x6:
	TST  R7
	BREQ PC+3
	JMP _0x8
	RJMP _0x6
_0x8:
; 0000 006A     data=rx_buffer[rx_rd_index++];
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0000 006B #if RX_BUFFER_SIZE != 256
; 0000 006C     if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDI  R30,LOW(8)
	CP   R30,R4
	BREQ PC+3
	JMP _0x9
	CLR  R4
; 0000 006D #endif
; 0000 006E #asm("cli")
_0x9:
	cli
; 0000 006F     --rx_counter;
	DEC  R7
; 0000 0070 #asm("sei")
	sei
; 0000 0071     return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0072 }
; .FEND
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 8
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE <= 256
;unsigned char tx_wr_index=0,tx_rd_index=0;
;#else
;unsigned int tx_wr_index=0,tx_rd_index=0;
;#endif
;
;#if TX_BUFFER_SIZE < 256
;unsigned char tx_counter=0;
;#else
;unsigned int tx_counter=0;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void){
; 0000 0087 interrupt [16] void usart_tx_isr(void){
_usart_tx_isr:
; .FSTART _usart_tx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0088     if (tx_counter){
	TST  R8
	BRNE PC+3
	JMP _0xA
; 0000 0089         --tx_counter;
	DEC  R8
; 0000 008A         UDR=tx_buffer[tx_rd_index++];
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 008B #if TX_BUFFER_SIZE != 256
; 0000 008C         if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDI  R30,LOW(8)
	CP   R30,R9
	BREQ PC+3
	JMP _0xB
	CLR  R9
; 0000 008D #endif
; 0000 008E     }
_0xB:
; 0000 008F }
_0xA:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c){
; 0000 0095 void putchar(char c){
_putchar:
; .FSTART _putchar
; 0000 0096     while (tx_counter == TX_BUFFER_SIZE);
	ST   -Y,R26
;	c -> Y+0
_0xC:
	LDI  R30,LOW(8)
	CP   R30,R8
	BREQ PC+3
	JMP _0xE
	RJMP _0xC
_0xE:
; 0000 0097 #asm("cli")
	cli
; 0000 0098     if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0)){
	TST  R8
	BREQ PC+3
	JMP _0x10
	SBIS 0xB,5
	RJMP _0x10
	RJMP _0xF
_0x10:
; 0000 0099         tx_buffer[tx_wr_index++]=c;
	MOV  R30,R6
	INC  R6
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
; 0000 009A #if TX_BUFFER_SIZE != 256
; 0000 009B         if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R6
	BREQ PC+3
	JMP _0x12
	CLR  R6
; 0000 009C #endif
; 0000 009D         ++tx_counter;
_0x12:
	INC  R8
; 0000 009E     }else
	RJMP _0x13
_0xF:
; 0000 009F         UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00A0 #asm("sei")
_0x13:
	sei
; 0000 00A1 }
	ADIW R28,1
	RET
; .FEND
;#pragma used-
;#endif
;//=====================================================================================
;//===Var. untuk tuning PID=====
;eeprom unsigned char e_kP;
;eeprom unsigned char e_kI;
;eeprom unsigned char e_kD;
;//=======Settingan LF==========
;eeprom unsigned char e_maks_PWM;
;eeprom unsigned char e_min_PWM;
;eeprom unsigned char e_kelajuan;
;eeprom unsigned char e_n_tengah[14];
;eeprom unsigned char e_ambang_atas[14],e_ambang_bawah[14];
;eeprom int e_k_stabilisator;
;eeprom unsigned char e_delay_awal;
;eeprom unsigned char e_reset_setting=1;
;//===========Variabel counter=============
;eeprom unsigned char e_c_delay[JML_INDEKS];
;eeprom unsigned char e_c_timer[JML_INDEKS];
;eeprom unsigned char e_c_aksi[JML_INDEKS];
;eeprom unsigned char e_c_sensor_ka[JML_INDEKS];
;eeprom unsigned char e_c_sensor_ki[JML_INDEKS];
;eeprom unsigned char e_c_cp[JML_INDEKS];
;eeprom unsigned char e_c_invert[JML_INDEKS];
;eeprom unsigned char e_c_laju[JML_INDEKS];
;eeprom unsigned char e_c_laju_ki[JML_INDEKS];
;eeprom unsigned char e_c_laju_ka[JML_INDEKS];
;//=====================================================================================
;int kP;
;int kI;
;int kD;
;int maks_PWM;
;int min_PWM;
;int kelajuan;
;int k_stabilisator;
;unsigned char delay_awal;
;unsigned char nilai_adc[14];
;unsigned char ambang_atas[14], ambang_bawah[14];
;unsigned char n_tengah[14];
;unsigned char c_delay[JML_INDEKS];
;unsigned char c_timer[JML_INDEKS];
;unsigned char c_aksi[JML_INDEKS];
;unsigned char c_sensor_ka[JML_INDEKS];
;unsigned char c_sensor_ki[JML_INDEKS];
;unsigned char c_cp[JML_INDEKS];
;unsigned char c_invert[JML_INDEKS];
;unsigned char c_laju[JML_INDEKS];
;unsigned char c_laju_ki[JML_INDEKS];
;unsigned char c_laju_ka[JML_INDEKS];
;
;char tampil[16];
;char buffer[18];
;unsigned int cacah=0;
;unsigned int detik=0;
;unsigned int target_timer=0;
;
;//Deteksi kombinasi sensor
;int sensor_ka[6] = {
;0b00000000000000,
;0b00000000010000,
;0b00000000001000,
;0b00000000000100,
;0b00000000000010,
;0b00000000000001};

	.DSEG
;int sensor_ki[6] = {
;0b00000000000000,
;0b00001000000000,
;0b00010000000000,
;0b00100000000000,
;0b01000000000000,
;0b10000000000000};
;
;//varibel buat kendali PID
;int /*SP = 0*/ /*PV = 0*/ PID, P, /*I = 0,*/ D, error=0, error_terakhir=0, pesat_error;
;int pwm_kiri, pwm_kanan;
;
;unsigned char c_i=0;
;unsigned char kelajuan_normal;
;unsigned char mode = 0;
;unsigned char aktifasi_serial=0;
;
;int sensor;
;bit timer_aktif=0;
;bit flag_berhenti=0;
;bit flag_invert=0;
;int sen_dep;
;int sen_ki;
;int sen_ka;
;//Buat grafik batang kepekaan sensor
;flash unsigned char c[7][8] = {{0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x1F},
;{0x00,0x00,0x00,0x00,0x00,0x00,0x1F,0x1F},
;{0x00,0x00,0x00,0x00,0x00,0x1F,0x1F,0x1F},
;{0x00,0x00,0x00,0x00,0x1F,0x1F,0x1F,0x1F},
;{0x00,0x00,0x00,0x1F,0x1F,0x1F,0x1F,0x1F},
;{0x00,0x00,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F},
;{0x00,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F}};
;//=====================================================================================
;interrupt [TIM0_OVF] void timer0_ovf_isr(void){
; 0000 0103 interrupt [12] void timer0_ovf_isr(void){

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0104     TCNT0 = 0xF0;
	LDI  R30,LOW(240)
	OUT  0x32,R30
; 0000 0105     cacah++;
	LDI  R26,LOW(_cacah)
	LDI  R27,HIGH(_cacah)
	CALL SUBOPT_0x0
; 0000 0106     if(cacah>=1000){
	CALL SUBOPT_0x1
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x16
; 0000 0107         cacah=0;
	CALL SUBOPT_0x2
; 0000 0108         detik++;
	LDI  R26,LOW(_detik)
	LDI  R27,HIGH(_detik)
	CALL SUBOPT_0x0
; 0000 0109     }
; 0000 010A }
_0x16:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;//=====================================================================================
;unsigned char read_adc(unsigned char adc_input){
; 0000 010C unsigned char read_adc(unsigned char adc_input){
_read_adc:
; .FSTART _read_adc
; 0000 010D     ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x20
	OUT  0x7,R30
; 0000 010E     // Delay needed for the stabilization of the ADC input voltage
; 0000 010F     delay_us(10);
	__DELAY_USB 53
; 0000 0110     // Start the AD conversion
; 0000 0111     ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0112     // Wait for the AD conversion to complete
; 0000 0113     while (!(ADCSRA & (1<<ADIF)));
_0x17:
	SBIC 0x6,4
	RJMP _0x19
	RJMP _0x17
_0x19:
; 0000 0114     ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 0115     return ADCH;
	IN   R30,0x5
	ADIW R28,1
	RET
; 0000 0116 }
; .FEND
;//=====================================================================================
;void define_char(flash unsigned char *pc, unsigned char code){
; 0000 0118 void define_char(flash unsigned char *pc, unsigned char code){
_define_char:
; .FSTART _define_char
; 0000 0119     unsigned char i,a;
; 0000 011A     a = (code << 3) | 0x40;
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*pc -> Y+3
;	code -> Y+2
;	i -> R17
;	a -> R16
	LDD  R30,Y+2
	LSL  R30
	LSL  R30
	LSL  R30
	ORI  R30,0x40
	MOV  R16,R30
; 0000 011B     for(i = 0;i < 8;i++)lcd_write_byte(a++, *pc++);
	LDI  R17,LOW(0)
_0x1B:
	CPI  R17,8
	BRLO PC+3
	JMP _0x1C
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	SBIW R30,1
	LPM  R26,Z
	CALL _lcd_write_byte
_0x1A:
	SUBI R17,-1
	RJMP _0x1B
_0x1C:
; 0000 011C }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
;//===========UART=============
;/*void kirim_data(char data){
;    //Gak optimal karena ketika data telah dikirim masih ada delay siap atau tidaknya pengiriman data selanjutnya
;    //sebagai gantinya pake UDRE karena siap atau tidaknya sebelum data dikirim
;    //UDR = data;
;    //while((UCSRA & (1 << TXC))==0);
;    while(!(UCSRA & (1 << UDRE)));
;    UDR = data;
;}
;unsigned char ambil_data(){
;    while(!(UCSRA & (1 << RXC)));
;    return UDR;
;}*/
;void kirim_string(char *s){
; 0000 012A void kirim_string(char *s){
_kirim_string:
; .FSTART _kirim_string
; 0000 012B     while(*s!=0x00){
	ST   -Y,R27
	ST   -Y,R26
;	*s -> Y+0
_0x1D:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BRNE PC+3
	JMP _0x1F
; 0000 012C         putchar(*s);
	LD   R26,X
	CALL _putchar
; 0000 012D         s++;
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
; 0000 012E     }
	RJMP _0x1D
_0x1F:
; 0000 012F }
	ADIW R28,2
	RET
; .FEND
;void ambil_string(char *s){
; 0000 0130 void ambil_string(char *s){
_ambil_string:
; .FSTART _ambil_string
; 0000 0131     char ch;
; 0000 0132     do{
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*s -> Y+1
;	ch -> R17
_0x21:
; 0000 0133         ch=getchar();
	CALL _getchar
	MOV  R17,R30
; 0000 0134         if(ch!='\n')
	CPI  R17,10
	BRNE PC+3
	JMP _0x23
; 0000 0135             *s++ = ch;
	CALL SUBOPT_0x3
	ST   Z,R17
; 0000 0136     }while(ch!='\n');
_0x23:
_0x20:
	CPI  R17,10
	BRNE PC+3
	JMP _0x22
	RJMP _0x21
_0x22:
; 0000 0137     *s=0;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 0138 }
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
;//=====================================================================================
;void baca_eeprom(){
; 0000 013A void baca_eeprom(){
_baca_eeprom:
; .FSTART _baca_eeprom
; 0000 013B     unsigned char i;
; 0000 013C     kP = e_kP; kI = e_kI; kD = e_kD; maks_PWM = e_maks_PWM; min_PWM = e_min_PWM;
	ST   -Y,R17
;	i -> R17
	LDI  R26,LOW(_e_kP)
	LDI  R27,HIGH(_e_kP)
	CALL __EEPROMRDB
	MOV  R10,R30
	CLR  R11
	LDI  R26,LOW(_e_kI)
	LDI  R27,HIGH(_e_kI)
	CALL __EEPROMRDB
	MOV  R12,R30
	CLR  R13
	LDI  R26,LOW(_e_kD)
	LDI  R27,HIGH(_e_kD)
	CALL __EEPROMRDB
	LDI  R31,0
	STS  _kD,R30
	STS  _kD+1,R31
	LDI  R26,LOW(_e_maks_PWM)
	LDI  R27,HIGH(_e_maks_PWM)
	CALL __EEPROMRDB
	LDI  R31,0
	CALL SUBOPT_0x4
	LDI  R26,LOW(_e_min_PWM)
	LDI  R27,HIGH(_e_min_PWM)
	CALL __EEPROMRDB
	LDI  R31,0
	CALL SUBOPT_0x5
; 0000 013D     kelajuan = e_kelajuan;k_stabilisator = e_k_stabilisator;delay_awal = e_delay_awal;
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
	LDI  R26,LOW(_e_k_stabilisator)
	LDI  R27,HIGH(_e_k_stabilisator)
	CALL __EEPROMRDW
	CALL SUBOPT_0x8
	LDI  R26,LOW(_e_delay_awal)
	LDI  R27,HIGH(_e_delay_awal)
	CALL __EEPROMRDB
	STS  _delay_awal,R30
; 0000 013E     for(i = 0;i < JML_INDEKS;i++){
	LDI  R17,LOW(0)
_0x25:
	CPI  R17,90
	BRLO PC+3
	JMP _0x26
; 0000 013F         c_delay[i] = e_c_delay[i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_c_delay)
	SBCI R31,HIGH(-_c_delay)
	MOVW R0,R30
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_e_c_delay)
	SBCI R27,HIGH(-_e_c_delay)
	CALL SUBOPT_0x9
; 0000 0140         c_timer[i] = e_c_timer[i];
	SUBI R30,LOW(-_c_timer)
	SBCI R31,HIGH(-_c_timer)
	MOVW R0,R30
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_e_c_timer)
	SBCI R27,HIGH(-_e_c_timer)
	CALL SUBOPT_0x9
; 0000 0141         c_aksi[i] = e_c_aksi[i];
	SUBI R30,LOW(-_c_aksi)
	SBCI R31,HIGH(-_c_aksi)
	MOVW R0,R30
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_e_c_aksi)
	SBCI R27,HIGH(-_e_c_aksi)
	CALL SUBOPT_0x9
; 0000 0142         c_sensor_ka[i] = e_c_sensor_ka[i];
	SUBI R30,LOW(-_c_sensor_ka)
	SBCI R31,HIGH(-_c_sensor_ka)
	MOVW R0,R30
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_e_c_sensor_ka)
	SBCI R27,HIGH(-_e_c_sensor_ka)
	CALL SUBOPT_0x9
; 0000 0143         c_sensor_ki[i] = e_c_sensor_ki[i];
	SUBI R30,LOW(-_c_sensor_ki)
	SBCI R31,HIGH(-_c_sensor_ki)
	MOVW R0,R30
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_e_c_sensor_ki)
	SBCI R27,HIGH(-_e_c_sensor_ki)
	CALL SUBOPT_0x9
; 0000 0144         c_cp[i] = e_c_cp[i];
	SUBI R30,LOW(-_c_cp)
	SBCI R31,HIGH(-_c_cp)
	MOVW R0,R30
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_e_c_cp)
	SBCI R27,HIGH(-_e_c_cp)
	CALL SUBOPT_0x9
; 0000 0145         c_invert[i] = e_c_invert[i];
	SUBI R30,LOW(-_c_invert)
	SBCI R31,HIGH(-_c_invert)
	MOVW R0,R30
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_e_c_invert)
	SBCI R27,HIGH(-_e_c_invert)
	CALL SUBOPT_0x9
; 0000 0146         c_laju[i] = e_c_laju[i];
	SUBI R30,LOW(-_c_laju)
	SBCI R31,HIGH(-_c_laju)
	MOVW R0,R30
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_e_c_laju)
	SBCI R27,HIGH(-_e_c_laju)
	CALL SUBOPT_0x9
; 0000 0147         c_laju_ki[i] = e_c_laju_ki[i];
	SUBI R30,LOW(-_c_laju_ki)
	SBCI R31,HIGH(-_c_laju_ki)
	MOVW R0,R30
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_e_c_laju_ki)
	SBCI R27,HIGH(-_e_c_laju_ki)
	CALL SUBOPT_0x9
; 0000 0148         c_laju_ka[i] = e_c_laju_ka[i];
	SUBI R30,LOW(-_c_laju_ka)
	SBCI R31,HIGH(-_c_laju_ka)
	MOVW R0,R30
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_e_c_laju_ka)
	SBCI R27,HIGH(-_e_c_laju_ka)
	CALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
; 0000 0149     }
_0x24:
	SUBI R17,-1
	RJMP _0x25
_0x26:
; 0000 014A     for(i = 0;i < 14;i++){
	LDI  R17,LOW(0)
_0x28:
	CPI  R17,14
	BRLO PC+3
	JMP _0x29
; 0000 014B         n_tengah[i] = e_n_tengah[i];
	CALL SUBOPT_0xA
	MOVW R0,R30
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_e_n_tengah)
	SBCI R27,HIGH(-_e_n_tengah)
	CALL SUBOPT_0x9
; 0000 014C         ambang_atas[i] = e_ambang_atas[i];
	SUBI R30,LOW(-_ambang_atas)
	SBCI R31,HIGH(-_ambang_atas)
	MOVW R0,R30
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_e_ambang_atas)
	SBCI R27,HIGH(-_e_ambang_atas)
	CALL SUBOPT_0x9
; 0000 014D         ambang_bawah[i] = e_ambang_bawah[i];
	SUBI R30,LOW(-_ambang_bawah)
	SBCI R31,HIGH(-_ambang_bawah)
	MOVW R0,R30
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_e_ambang_bawah)
	SBCI R27,HIGH(-_e_ambang_bawah)
	CALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
; 0000 014E     }
_0x27:
	SUBI R17,-1
	RJMP _0x28
_0x29:
; 0000 014F }
	LD   R17,Y+
	RET
; .FEND
;//=====================================================================================
;void atur_pwm(int pwm_ki, int pwm_ka){
; 0000 0151 void atur_pwm(int pwm_ki, int pwm_ka){
_atur_pwm:
; .FSTART _atur_pwm
; 0000 0152     if(pwm_ki > maks_PWM){OCR1B = maks_PWM; motor_kiri = 0;}
	ST   -Y,R27
	ST   -Y,R26
;	pwm_ki -> Y+2
;	pwm_ka -> Y+0
	CALL SUBOPT_0xB
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CP   R30,R26
	CPC  R31,R27
	BRLT PC+3
	JMP _0x2A
	CALL SUBOPT_0xB
	OUT  0x28+1,R31
	OUT  0x28,R30
	CBI  0x12,3
; 0000 0153     else if(pwm_ki < -(min_PWM)){OCR1B = 255 - min_PWM; motor_kiri = 1;}
	RJMP _0x2D
_0x2A:
	CALL SUBOPT_0xC
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CP   R26,R30
	CPC  R27,R31
	BRLT PC+3
	JMP _0x2E
	CALL SUBOPT_0xD
	OUT  0x28+1,R31
	OUT  0x28,R30
	SBI  0x12,3
; 0000 0154     else if(pwm_ki >= 0){OCR1B = pwm_ki; motor_kiri = 0;}
	RJMP _0x31
_0x2E:
	LDD  R26,Y+3
	TST  R26
	BRPL PC+3
	JMP _0x32
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	OUT  0x28+1,R31
	OUT  0x28,R30
	CBI  0x12,3
; 0000 0155     else if(pwm_ki < 0){OCR1B = 255 + pwm_ki; motor_kiri = 1;}
	RJMP _0x35
_0x32:
	LDD  R26,Y+3
	TST  R26
	BRMI PC+3
	JMP _0x36
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	OUT  0x28+1,R31
	OUT  0x28,R30
	SBI  0x12,3
; 0000 0156 
; 0000 0157     if(pwm_ka > maks_PWM){OCR1A = maks_PWM; motor_kanan = 0;}
_0x36:
_0x35:
_0x31:
_0x2D:
	CALL SUBOPT_0xB
	LD   R26,Y
	LDD  R27,Y+1
	CP   R30,R26
	CPC  R31,R27
	BRLT PC+3
	JMP _0x39
	CALL SUBOPT_0xB
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	CBI  0x12,6
; 0000 0158     else if(pwm_ka < -(min_PWM)){OCR1A = 255 - min_PWM; motor_kanan = 1;}
	RJMP _0x3C
_0x39:
	CALL SUBOPT_0xC
	LD   R26,Y
	LDD  R27,Y+1
	CP   R26,R30
	CPC  R27,R31
	BRLT PC+3
	JMP _0x3D
	CALL SUBOPT_0xD
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	SBI  0x12,6
; 0000 0159     else if(pwm_ka >= 0){OCR1A = pwm_ka; motor_kanan = 0;}
	RJMP _0x40
_0x3D:
	LDD  R26,Y+1
	TST  R26
	BRPL PC+3
	JMP _0x41
	LD   R30,Y
	LDD  R31,Y+1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	CBI  0x12,6
; 0000 015A     else if(pwm_ka < 0){OCR1A = 255 + pwm_ka; motor_kanan = 1;}
	RJMP _0x44
_0x41:
	LDD  R26,Y+1
	TST  R26
	BRMI PC+3
	JMP _0x45
	LD   R30,Y
	LDD  R31,Y+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	SBI  0x12,6
; 0000 015B }
_0x45:
_0x44:
_0x40:
_0x3C:
	ADIW R28,4
	RET
; .FEND
;//=====================================================================================
;void grafik(){
; 0000 015D void grafik(){
_grafik:
; .FSTART _grafik
; 0000 015E     unsigned char i;
; 0000 015F     unsigned char j;
; 0000 0160     TR_1 = 1; TR_2 = 0;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R17
;	j -> R16
	CALL SUBOPT_0xE
; 0000 0161     delay_us(150);
; 0000 0162     for(i = 0;i < 7;i++){
_0x4D:
	CPI  R17,7
	BRLO PC+3
	JMP _0x4E
; 0000 0163         nilai_adc[i] = read_adc(7-i);
	CALL SUBOPT_0xF
	PUSH R31
	PUSH R30
	LDI  R30,LOW(7)
	SUB  R30,R17
	MOV  R26,R30
	CALL _read_adc
	POP  R26
	POP  R27
	CALL SUBOPT_0x10
; 0000 0164         lcd_gotoxy(14-i,0);
; 0000 0165         for(j = 0;j < 7;j++){
_0x50:
	CPI  R16,7
	BRLO PC+3
	JMP _0x51
; 0000 0166             if(nilai_adc[i] >= ambang_atas[i]-((ambang_atas[i]-n_tengah[i])/8)*(j+1) &&
; 0000 0167                 nilai_adc[i] < ambang_atas[i]-((ambang_atas[i]-n_tengah[i])/8)*j || nilai_adc[i] > ambang_atas[i]){
	CALL SUBOPT_0xF
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
	BRGE PC+3
	JMP _0x53
	CALL SUBOPT_0xF
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	CALL SUBOPT_0x14
	BRLT PC+3
	JMP _0x53
	RJMP _0x55
_0x53:
	CALL SUBOPT_0xF
	CALL SUBOPT_0x15
	BRSH PC+3
	JMP _0x55
	RJMP _0x52
_0x55:
; 0000 0168                 lcd_putchar((j)?7-j:0xFF);break;
	CPI  R16,0
	BRNE PC+3
	JMP _0x57
	CALL SUBOPT_0x16
	RJMP _0x58
_0x57:
	LDI  R30,LOW(255)
_0x58:
_0x59:
	MOV  R26,R30
	CALL _lcd_putchar
	RJMP _0x51
; 0000 0169             }else if(nilai_adc[i] < n_tengah[i]){
	RJMP _0x5A
_0x52:
	CALL SUBOPT_0xF
	LD   R26,Z
	CALL SUBOPT_0xA
	LD   R30,Z
	CP   R26,R30
	BRLO PC+3
	JMP _0x5B
; 0000 016A                 lcd_putchar(32);break;
	LDI  R26,LOW(32)
	CALL _lcd_putchar
	RJMP _0x51
; 0000 016B             }
; 0000 016C         }
_0x5B:
_0x5A:
_0x4F:
	SUBI R16,-1
	RJMP _0x50
_0x51:
; 0000 016D     }
_0x4C:
	SUBI R17,-1
	RJMP _0x4D
_0x4E:
; 0000 016E 
; 0000 016F     TR_1 = 0; TR_2 = 1;
	CALL SUBOPT_0x17
; 0000 0170     delay_us(150);
; 0000 0171     for(i = 7;i < 14;i++){
_0x61:
	CPI  R17,14
	BRLO PC+3
	JMP _0x62
; 0000 0172         nilai_adc[i] = read_adc(i-6);
	CALL SUBOPT_0xF
	PUSH R31
	PUSH R30
	MOV  R26,R17
	SUBI R26,LOW(6)
	CALL _read_adc
	POP  R26
	POP  R27
	CALL SUBOPT_0x10
; 0000 0173         lcd_gotoxy(14-i,0);
; 0000 0174         for(j = 0;j < 7;j++){
_0x64:
	CPI  R16,7
	BRLO PC+3
	JMP _0x65
; 0000 0175             if(nilai_adc[i] >= ambang_atas[i]-((ambang_atas[i]-n_tengah[i])/8)*(j+1) &&
; 0000 0176                 nilai_adc[i] < ambang_atas[i]-((ambang_atas[i]-n_tengah[i])/8)*j || nilai_adc[i] > ambang_atas[i]){
	CALL SUBOPT_0xF
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
	BRGE PC+3
	JMP _0x67
	CALL SUBOPT_0xF
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	CALL SUBOPT_0x14
	BRLT PC+3
	JMP _0x67
	RJMP _0x69
_0x67:
	CALL SUBOPT_0xF
	CALL SUBOPT_0x15
	BRSH PC+3
	JMP _0x69
	RJMP _0x66
_0x69:
; 0000 0177                 lcd_putchar((j)?7-j:0xFF);break;
	CPI  R16,0
	BRNE PC+3
	JMP _0x6B
	CALL SUBOPT_0x16
	RJMP _0x6C
_0x6B:
	LDI  R30,LOW(255)
_0x6C:
_0x6D:
	MOV  R26,R30
	CALL _lcd_putchar
	RJMP _0x65
; 0000 0178             }else if(nilai_adc[i] < n_tengah[i]){
	RJMP _0x6E
_0x66:
	CALL SUBOPT_0xF
	LD   R26,Z
	CALL SUBOPT_0xA
	LD   R30,Z
	CP   R26,R30
	BRLO PC+3
	JMP _0x6F
; 0000 0179                 lcd_putchar(32);break;
	LDI  R26,LOW(32)
	CALL _lcd_putchar
	RJMP _0x65
; 0000 017A             }
; 0000 017B         }
_0x6F:
_0x6E:
_0x63:
	SUBI R16,-1
	RJMP _0x64
_0x65:
; 0000 017C     }
_0x60:
	SUBI R17,-1
	RJMP _0x61
_0x62:
; 0000 017D     //sensor_mati;
; 0000 017E     //delay_us(10);
; 0000 017F }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;//=====================================================================================
;//cacahan tombol yang ditekan sama tombol yg sesuai ditekan
;unsigned char hitung_tekan;
;unsigned char hitung_password;
;
;void logika_password(){
; 0000 0185 void logika_password(){
_logika_password:
; .FSTART _logika_password
; 0000 0186     hitung_tekan=0;
	LDI  R30,LOW(0)
	STS  _hitung_tekan,R30
; 0000 0187     hitung_password=0;
	STS  _hitung_password,R30
; 0000 0188     lcd_gotoxy(0,0);
	CALL SUBOPT_0x18
; 0000 0189     lcd_putsf("    Masukkan    ");
	__POINTW2FN _0x0,0
	CALL SUBOPT_0x19
; 0000 018A     lcd_gotoxy(0,1);
; 0000 018B     lcd_putsf("Password:.......");
	__POINTW2FN _0x0,17
	CALL _lcd_putsf
; 0000 018C     lcd_gotoxy(9,1);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x1A
; 0000 018D     while(1){
_0x70:
; 0000 018E         if(!OK||!BATAL||!MENU_ATAS||!MENU_BAWAH||!TAMBAH_NILAI||!KURANG_NILAI){
	SBIS 0x13,0
	RJMP _0x74
	SBIS 0x13,1
	RJMP _0x74
	SBIS 0x13,2
	RJMP _0x74
	SBIS 0x13,3
	RJMP _0x74
	SBIS 0x13,4
	RJMP _0x74
	SBIS 0x13,5
	RJMP _0x74
	RJMP _0x73
_0x74:
; 0000 018F             lcd_putsf("*");
	__POINTW2FN _0x0,34
	CALL _lcd_putsf
; 0000 0190             while(!OK||!BATAL||!MENU_ATAS||!MENU_BAWAH||!TAMBAH_NILAI||!KURANG_NILAI){
_0x76:
	SBIS 0x13,0
	RJMP _0x79
	SBIS 0x13,1
	RJMP _0x79
	SBIS 0x13,2
	RJMP _0x79
	SBIS 0x13,3
	RJMP _0x79
	SBIS 0x13,4
	RJMP _0x79
	SBIS 0x13,5
	RJMP _0x79
	RJMP _0x78
_0x79:
; 0000 0191                 if(!kunci_1&&(hitung_password==0)){
	SBIC 0x13,0
	RJMP _0x7C
	LDS  R26,_hitung_password
	CPI  R26,LOW(0x0)
	BREQ PC+3
	JMP _0x7C
	RJMP _0x7D
_0x7C:
	RJMP _0x7B
_0x7D:
; 0000 0192                     hitung_password++;;
	CALL SUBOPT_0x1B
; 0000 0193                     while(!kunci_1)delay_ms(20);
_0x7E:
	SBIC 0x13,0
	RJMP _0x80
	CALL SUBOPT_0x1C
	RJMP _0x7E
_0x80:
; 0000 0194 }
; 0000 0195                 if(!kunci_2&&(hitung_password==1)){
_0x7B:
	SBIC 0x13,4
	RJMP _0x82
	LDS  R26,_hitung_password
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x82
	RJMP _0x83
_0x82:
	RJMP _0x81
_0x83:
; 0000 0196                     hitung_password++;
	CALL SUBOPT_0x1B
; 0000 0197                     while(!kunci_2)delay_ms(20);
_0x84:
	SBIC 0x13,4
	RJMP _0x86
	CALL SUBOPT_0x1C
	RJMP _0x84
_0x86:
; 0000 0198 }
; 0000 0199                 if(!kunci_3&&(hitung_password==2)){
_0x81:
	SBIC 0x13,4
	RJMP _0x88
	LDS  R26,_hitung_password
	CPI  R26,LOW(0x2)
	BREQ PC+3
	JMP _0x88
	RJMP _0x89
_0x88:
	RJMP _0x87
_0x89:
; 0000 019A                     hitung_password++;
	CALL SUBOPT_0x1B
; 0000 019B                     while(!kunci_3)delay_ms(20);
_0x8A:
	SBIC 0x13,4
	RJMP _0x8C
	CALL SUBOPT_0x1C
	RJMP _0x8A
_0x8C:
; 0000 019C }
; 0000 019D                 if(!kunci_4&&(hitung_password==3)){
_0x87:
	SBIC 0x13,1
	RJMP _0x8E
	LDS  R26,_hitung_password
	CPI  R26,LOW(0x3)
	BREQ PC+3
	JMP _0x8E
	RJMP _0x8F
_0x8E:
	RJMP _0x8D
_0x8F:
; 0000 019E                     hitung_password++;
	CALL SUBOPT_0x1B
; 0000 019F                     while(!kunci_4)delay_ms(20);
_0x90:
	SBIC 0x13,1
	RJMP _0x92
	CALL SUBOPT_0x1C
	RJMP _0x90
_0x92:
; 0000 01A0 }
; 0000 01A1                 if(!kunci_5&&(hitung_password==4)){
_0x8D:
	SBIC 0x13,0
	RJMP _0x94
	LDS  R26,_hitung_password
	CPI  R26,LOW(0x4)
	BREQ PC+3
	JMP _0x94
	RJMP _0x95
_0x94:
	RJMP _0x93
_0x95:
; 0000 01A2                     hitung_password++;
	CALL SUBOPT_0x1B
; 0000 01A3                     while(!kunci_5)delay_ms(20);
_0x96:
	SBIC 0x13,0
	RJMP _0x98
	CALL SUBOPT_0x1C
	RJMP _0x96
_0x98:
; 0000 01A4 }
; 0000 01A5                 if(!kunci_6&&(hitung_password==5)){
_0x93:
	SBIC 0x13,5
	RJMP _0x9A
	LDS  R26,_hitung_password
	CPI  R26,LOW(0x5)
	BREQ PC+3
	JMP _0x9A
	RJMP _0x9B
_0x9A:
	RJMP _0x99
_0x9B:
; 0000 01A6                     hitung_password++;
	CALL SUBOPT_0x1B
; 0000 01A7                     while(!kunci_6)delay_ms(20);
_0x9C:
	SBIC 0x13,5
	RJMP _0x9E
	CALL SUBOPT_0x1C
	RJMP _0x9C
_0x9E:
; 0000 01A8 }
; 0000 01A9                 if(!kunci_7&&(hitung_password==6)){
_0x99:
	SBIC 0x13,4
	RJMP _0xA0
	LDS  R26,_hitung_password
	CPI  R26,LOW(0x6)
	BREQ PC+3
	JMP _0xA0
	RJMP _0xA1
_0xA0:
	RJMP _0x9F
_0xA1:
; 0000 01AA                     hitung_password++;
	CALL SUBOPT_0x1B
; 0000 01AB                     while(!kunci_7)delay_ms(20);
_0xA2:
	SBIC 0x13,4
	RJMP _0xA4
	CALL SUBOPT_0x1C
	RJMP _0xA2
_0xA4:
; 0000 01AC }
; 0000 01AD                 delay_ms(20);
_0x9F:
	CALL SUBOPT_0x1C
; 0000 01AE             }
	RJMP _0x76
_0x78:
; 0000 01AF             hitung_tekan++;
	LDS  R30,_hitung_tekan
	SUBI R30,-LOW(1)
	STS  _hitung_tekan,R30
; 0000 01B0         }
; 0000 01B1         if(hitung_password==7){
_0x73:
	LDS  R26,_hitung_password
	CPI  R26,LOW(0x7)
	BREQ PC+3
	JMP _0xA5
; 0000 01B2             break;
	RJMP _0x72
; 0000 01B3         }
; 0000 01B4         if(hitung_tekan==7){
_0xA5:
	LDS  R26,_hitung_tekan
	CPI  R26,LOW(0x7)
	BREQ PC+3
	JMP _0xA6
; 0000 01B5             lcd_gotoxy(0,0);
	CALL SUBOPT_0x18
; 0000 01B6             lcd_putsf(" Maaf Password  ");
	__POINTW2FN _0x0,36
	CALL SUBOPT_0x19
; 0000 01B7             lcd_gotoxy(0,1);
; 0000 01B8             lcd_putsf("    Salah !!    ");
	__POINTW2FN _0x0,53
	CALL _lcd_putsf
; 0000 01B9             delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 01BA             break;
	RJMP _0x72
; 0000 01BB         }
; 0000 01BC         delay_ms(100);
_0xA6:
	CALL SUBOPT_0x1D
; 0000 01BD     }
	RJMP _0x70
_0x72:
; 0000 01BE }
	RET
; .FEND
;
;//=====================================================================================
;void menu(){
; 0000 01C1 void menu(){
_menu:
; .FSTART _menu
; 0000 01C2     unsigned char jumlah_cp;
; 0000 01C3     unsigned char i;
; 0000 01C4     unsigned char j;
; 0000 01C5     unsigned char indeks;
; 0000 01C6     int indeks_cp;
; 0000 01C7     float tegangan = 0;
; 0000 01C8     siaga:
	CALL SUBOPT_0x1E
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+3,R30
	CALL __SAVELOCR6
;	jumlah_cp -> R17
;	i -> R16
;	j -> R19
;	indeks -> R18
;	indeks_cp -> R20,R21
;	tegangan -> Y+6
_0xA7:
; 0000 01C9     lcd_clear();
	CALL SUBOPT_0x1F
; 0000 01CA     lcd_gotoxy(0,0);
; 0000 01CB     switch(mode){
	LDS  R30,_mode
	LDI  R31,0
; 0000 01CC         case NORMAL : lcd_putsf("N");break;
	SBIW R30,0
	BREQ PC+3
	JMP _0xAB
	__POINTW2FN _0x0,70
	CALL _lcd_putsf
	RJMP _0xAA
; 0000 01CD         case COUNTER : lcd_putsf("C");break;
_0xAB:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0xAA
	__POINTW2FN _0x0,72
	CALL _lcd_putsf
; 0000 01CE     }
_0xAA:
; 0000 01CF     indeks=mode;
	LDS  R18,_mode
; 0000 01D0     jumlah_cp=0;
	LDI  R17,LOW(0)
; 0000 01D1     for(i=0;i<JML_INDEKS;i++){
	LDI  R16,LOW(0)
_0xAE:
	CPI  R16,90
	BRLO PC+3
	JMP _0xAF
; 0000 01D2         if(c_cp[i])jumlah_cp++;
	CALL SUBOPT_0x20
	BRNE PC+3
	JMP _0xB0
	SUBI R17,-1
; 0000 01D3     }
_0xB0:
_0xAD:
	SUBI R16,-1
	RJMP _0xAE
_0xAF:
; 0000 01D4     indeks_cp=-1;
	__GETWRN 20,21,-1
; 0000 01D5     if(c_i)c_i--;
	LDS  R30,_c_i
	CPI  R30,0
	BRNE PC+3
	JMP _0xB1
	SUBI R30,LOW(1)
	STS  _c_i,R30
; 0000 01D6     for(i=0;i<=c_i;i++){
_0xB1:
	LDI  R16,LOW(0)
_0xB3:
	LDS  R30,_c_i
	CP   R30,R16
	BRSH PC+3
	JMP _0xB4
; 0000 01D7         if(c_cp[i])indeks_cp++;
	CALL SUBOPT_0x20
	BRNE PC+3
	JMP _0xB5
	__ADDWRN 20,21,1
; 0000 01D8     }
_0xB5:
_0xB2:
	SUBI R16,-1
	RJMP _0xB3
_0xB4:
; 0000 01D9     //if(indeks_cp==-1)indeks_cp=0;
; 0000 01DA     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1A
; 0000 01DB     sprintf(tampil,"CP:%d ",indeks_cp+1);
	CALL SUBOPT_0x21
; 0000 01DC     lcd_puts(tampil);
; 0000 01DD     while(1){
_0xB6:
; 0000 01DE         if(aktifasi_serial){
	LDS  R30,_aktifasi_serial
	CPI  R30,0
	BRNE PC+3
	JMP _0xB9
; 0000 01DF             if(rx_counter){
	TST  R7
	BRNE PC+3
	JMP _0xBA
; 0000 01E0                 ambil_string(buffer);
	CALL SUBOPT_0x22
; 0000 01E1                 if(!strcmp(buffer,"a")){
	CALL SUBOPT_0x23
	__POINTW2MN _0xBC,0
	CALL _strcmp
	CPI  R30,0
	BREQ PC+3
	JMP _0xBB
; 0000 01E2                     sensor_mati;
	CBI  0x15,6
	CBI  0x15,7
; 0000 01E3                     baca_eeprom();
	CALL _baca_eeprom
; 0000 01E4                     goto atur_PID;
	RJMP _0xC1
; 0000 01E5                 }else if(!strcmp(buffer,"b")){
_0xBB:
	CALL SUBOPT_0x23
	__POINTW2MN _0xBC,2
	CALL _strcmp
	CPI  R30,0
	BREQ PC+3
	JMP _0xC3
; 0000 01E6                     sensor_mati;
	CBI  0x15,6
	CBI  0x15,7
; 0000 01E7                     baca_eeprom();
	CALL _baca_eeprom
; 0000 01E8                     goto atur_kelajuan;
	RJMP _0xC8
; 0000 01E9                 }else if(!strcmp(buffer,"c")){
_0xC3:
	CALL SUBOPT_0x23
	__POINTW2MN _0xBC,4
	CALL _strcmp
	CPI  R30,0
	BREQ PC+3
	JMP _0xCA
; 0000 01EA                     sensor_mati;
	CBI  0x15,6
	CBI  0x15,7
; 0000 01EB                     //baca_eeprom();
; 0000 01EC                     goto cek_motor;
	RJMP _0xCF
; 0000 01ED                 }
; 0000 01EE             }
_0xCA:
_0xC9:
_0xC2:
; 0000 01EF         }
_0xBA:
; 0000 01F0         if(!OK){
_0xB9:
	SBIC 0x13,0
	RJMP _0xD0
; 0000 01F1             sensor_mati;
	CBI  0x15,6
	CBI  0x15,7
; 0000 01F2             while(!OK){
_0xD5:
	SBIC 0x13,0
	RJMP _0xD7
; 0000 01F3                 if(!BATAL){
	SBIC 0x13,1
	RJMP _0xD8
; 0000 01F4 					pertama:
_0xD9:
; 0000 01F5                     if(e_reset_setting){
	LDI  R26,LOW(_e_reset_setting)
	LDI  R27,HIGH(_e_reset_setting)
	CALL __EEPROMRDB
	CPI  R30,0
	BRNE PC+3
	JMP _0xDA
; 0000 01F6                         lcd_gotoxy(0,0);
	CALL SUBOPT_0x18
; 0000 01F7                         lcd_putsf("   Anda Telah   ");
	__POINTW2FN _0x0,87
	CALL SUBOPT_0x19
; 0000 01F8                         lcd_gotoxy(0,1);
; 0000 01F9                         lcd_putsf(" Aktifasi Reset ");
	__POINTW2FN _0x0,104
	CALL SUBOPT_0x24
; 0000 01FA                         delay_ms(1500);
; 0000 01FB                         lcd_gotoxy(0,0);
	CALL SUBOPT_0x18
; 0000 01FC                         lcd_putsf(" Silahkan Untuk ");
	__POINTW2FN _0x0,121
	CALL SUBOPT_0x19
; 0000 01FD                         lcd_gotoxy(0,1);
; 0000 01FE                         lcd_putsf("    Restart     ");
	__POINTW2FN _0x0,138
	CALL SUBOPT_0x24
; 0000 01FF                         delay_ms(1500);
; 0000 0200                         while(!OK||!BATAL)delay_ms(20);
_0xDB:
	SBIS 0x13,0
	RJMP _0xDE
	SBIS 0x13,1
	RJMP _0xDE
	RJMP _0xDD
_0xDE:
	CALL SUBOPT_0x1C
	RJMP _0xDB
_0xDD:
; 0000 0201 goto siaga;
	RJMP _0xA7
; 0000 0202                     }else{
_0xDA:
; 0000 0203                         lcd_gotoxy(0,0);
	CALL SUBOPT_0x18
; 0000 0204                         lcd_putsf("Reset Setting ? ");
	__POINTW2FN _0x0,155
	CALL SUBOPT_0x19
; 0000 0205                         lcd_gotoxy(0,1);
; 0000 0206                         lcd_putsf("+ Ya ");
	__POINTW2FN _0x0,172
	CALL _lcd_putsf
; 0000 0207                         lcd_gotoxy(5,1);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x1A
; 0000 0208                         lcd_putsf("- Tidak    ");
	__POINTW2FN _0x0,178
	CALL _lcd_putsf
; 0000 0209                         while(!OK||!BATAL)delay_ms(20);
_0xE1:
	SBIS 0x13,0
	RJMP _0xE4
	SBIS 0x13,1
	RJMP _0xE4
	RJMP _0xE3
_0xE4:
	CALL SUBOPT_0x1C
	RJMP _0xE1
_0xE3:
; 0000 020A }
_0xE0:
; 0000 020B                     while(1){
_0xE6:
; 0000 020C                         if(!TAMBAH_NILAI){
	SBIC 0x13,4
	RJMP _0xE9
; 0000 020D                             while(!TAMBAH_NILAI)delay_ms(20);
_0xEA:
	SBIC 0x13,4
	RJMP _0xEC
	CALL SUBOPT_0x1C
	RJMP _0xEA
_0xEC:
; 0000 020E logika_password();
	CALL _logika_password
; 0000 020F                             if(hitung_password<7)goto pertama;
	LDS  R26,_hitung_password
	CPI  R26,LOW(0x7)
	BRLO PC+3
	JMP _0xED
	RJMP _0xD9
; 0000 0210                             lcd_gotoxy(0,0);
_0xED:
	CALL SUBOPT_0x18
; 0000 0211                             lcd_putsf("Silahkan Restart");
	__POINTW2FN _0x0,190
	CALL SUBOPT_0x19
; 0000 0212                             lcd_gotoxy(0,1);
; 0000 0213                             lcd_putsf("  Untuk Reset   ");
	__POINTW2FN _0x0,207
	CALL _lcd_putsf
; 0000 0214                             goto siaga;
	RJMP _0xA7
; 0000 0215                         }
; 0000 0216                         if(!KURANG_NILAI){
_0xE9:
	SBIC 0x13,5
	RJMP _0xEE
; 0000 0217                             while(!KURANG_NILAI)delay_ms(20);
_0xEF:
	SBIC 0x13,5
	RJMP _0xF1
	CALL SUBOPT_0x1C
	RJMP _0xEF
_0xF1:
; 0000 0218 goto siaga;
	RJMP _0xA7
; 0000 0219                         }
; 0000 021A                     }
_0xEE:
	RJMP _0xE6
_0xE8:
; 0000 021B                 }
; 0000 021C                 else if(!MENU_ATAS){
	RJMP _0xF2
_0xD8:
	SBIC 0x13,2
	RJMP _0xF3
; 0000 021D                     if(!aktifasi_serial){
	LDS  R30,_aktifasi_serial
	CPI  R30,0
	BREQ PC+3
	JMP _0xF4
; 0000 021E                         while(rx_counter){ambil_string(buffer);}
_0xF5:
	TST  R7
	BRNE PC+3
	JMP _0xF7
	CALL SUBOPT_0x22
	RJMP _0xF5
_0xF7:
; 0000 021F                         //kirim_string("A\n");
; 0000 0220                         aktifasi_serial=1;
	LDI  R30,LOW(1)
	STS  _aktifasi_serial,R30
; 0000 0221                         lcd_gotoxy(0,0);
	CALL SUBOPT_0x18
; 0000 0222                         lcd_putsf("   Komunikasi   ");
	__POINTW2FN _0x0,224
	CALL SUBOPT_0x19
; 0000 0223                         lcd_gotoxy(0,1);
; 0000 0224                         lcd_putsf("  Serial Aktif  ");
	__POINTW2FN _0x0,241
	CALL SUBOPT_0x24
; 0000 0225                         delay_ms(1500);
; 0000 0226                         goto siaga;
	RJMP _0xA7
; 0000 0227                     }else{
_0xF4:
; 0000 0228                         while(rx_counter){ambil_string(buffer);}
_0xF9:
	TST  R7
	BRNE PC+3
	JMP _0xFB
	CALL SUBOPT_0x22
	RJMP _0xF9
_0xFB:
; 0000 0229                         //kirim_string("A\n");
; 0000 022A                         aktifasi_serial=0;
	LDI  R30,LOW(0)
	STS  _aktifasi_serial,R30
; 0000 022B                         lcd_gotoxy(0,0);
	CALL SUBOPT_0x18
; 0000 022C                         lcd_putsf("   Komunikasi   ");
	__POINTW2FN _0x0,224
	CALL SUBOPT_0x19
; 0000 022D                         lcd_gotoxy(0,1);
; 0000 022E                         lcd_putsf("Serial Non-Aktif");
	__POINTW2FN _0x0,258
	CALL SUBOPT_0x24
; 0000 022F                         delay_ms(1500);
; 0000 0230                         goto siaga;
	RJMP _0xA7
; 0000 0231                     }
_0xF8:
; 0000 0232 
; 0000 0233                 }
; 0000 0234                 delay_ms(20);
_0xF3:
_0xF2:
	CALL SUBOPT_0x1C
; 0000 0235             }
	RJMP _0xD5
_0xD7:
; 0000 0236             indeks=0;
	LDI  R18,LOW(0)
; 0000 0237             goto menu;
	RJMP _0xFC
; 0000 0238         }
; 0000 0239         if(!KURANG_NILAI){//&&(tegangan>=11.10)){
_0xD0:
	SBIC 0x13,5
	RJMP _0xFD
; 0000 023A             sensor_mati;
	CBI  0x15,6
	CBI  0x15,7
; 0000 023B             while(!KURANG_NILAI)delay_ms(20);
_0x102:
	SBIC 0x13,5
	RJMP _0x104
	CALL SUBOPT_0x1C
	RJMP _0x102
_0x104:
; 0000 023C goto keluar;
	JMP  _0x105
; 0000 023D         }
; 0000 023E         if(!MENU_ATAS){
_0xFD:
	SBIC 0x13,2
	RJMP _0x106
; 0000 023F             sensor_mati;
	CBI  0x15,6
	CBI  0x15,7
; 0000 0240             lcd_gotoxy(0,0);
	CALL SUBOPT_0x18
; 0000 0241             while(!MENU_ATAS)delay_ms(20);
_0x10B:
	SBIC 0x13,2
	RJMP _0x10D
	CALL SUBOPT_0x1C
	RJMP _0x10B
_0x10D:
; 0000 0242 mode = (mode)?0:1;
	LDS  R30,_mode
	CPI  R30,0
	BRNE PC+3
	JMP _0x10E
	LDI  R30,LOW(0)
	RJMP _0x10F
_0x10E:
	LDI  R30,LOW(1)
_0x10F:
_0x110:
	STS  _mode,R30
; 0000 0243             switch(mode){
	LDI  R31,0
; 0000 0244                 case 0:lcd_putsf("N");break;
	SBIW R30,0
	BREQ PC+3
	JMP _0x114
	__POINTW2FN _0x0,70
	CALL _lcd_putsf
	RJMP _0x113
; 0000 0245                 case 1:lcd_putsf("C");break;
_0x114:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x113
	__POINTW2FN _0x0,72
	CALL _lcd_putsf
; 0000 0246             }
_0x113:
; 0000 0247         }
; 0000 0248         if(!MENU_BAWAH){
_0x106:
	SBIC 0x13,3
	RJMP _0x116
; 0000 0249             sensor_mati;
	CBI  0x15,6
	CBI  0x15,7
; 0000 024A             delay_ms(100);
	CALL SUBOPT_0x1D
; 0000 024B             indeks_cp++;
	__ADDWRN 20,21,1
; 0000 024C             if(indeks_cp>(jumlah_cp-1))indeks_cp=0;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,1
	CP   R30,R20
	CPC  R31,R21
	BRLT PC+3
	JMP _0x11B
	__GETWRN 20,21,0
; 0000 024D             lcd_gotoxy(0,1);
_0x11B:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1A
; 0000 024E             sprintf(tampil,"CP:%d ",indeks_cp+1);
	CALL SUBOPT_0x21
; 0000 024F             lcd_puts(tampil);
; 0000 0250 
; 0000 0251         }
; 0000 0252         if(!TAMBAH_NILAI){
_0x116:
	SBIC 0x13,4
	RJMP _0x11C
; 0000 0253             sensor_mati;
	CBI  0x15,6
	CBI  0x15,7
; 0000 0254             delay_ms(100);
	CALL SUBOPT_0x1D
; 0000 0255             indeks_cp--;
	__SUBWRN 20,21,1
; 0000 0256             if(indeks_cp==-1)indeks_cp=(jumlah_cp-1);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R20
	CPC  R31,R21
	BREQ PC+3
	JMP _0x121
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,1
	MOVW R20,R30
; 0000 0257             lcd_gotoxy(0,1);
_0x121:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1A
; 0000 0258             sprintf(tampil,"CP:%d ",indeks_cp+1);
	CALL SUBOPT_0x21
; 0000 0259             lcd_puts(tampil);
; 0000 025A         }
; 0000 025B         tegangan = (float) read_adc(0)*5.3*5.0/255.0;
_0x11C:
	LDI  R26,LOW(0)
	CALL _read_adc
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2N 0x40A9999A
	CALL __MULF12
	__GETD2N 0x40A00000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x437F0000
	CALL __DIVF21
	__PUTD1S 6
; 0000 025C         lcd_gotoxy(6,1);
	LDI  R30,LOW(6)
	CALL SUBOPT_0x1A
; 0000 025D         sprintf(tampil, "%0.2fV  >>", tegangan);
	CALL SUBOPT_0x25
	__POINTW1FN _0x0,275
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
; 0000 025E         lcd_puts(tampil);
	CALL SUBOPT_0x28
; 0000 025F         /*if(tegangan<11.10){//Tegangan kerja minimal batre lipo yang 3sel
; 0000 0260             lcd_gotoxy(1,0);
; 0000 0261             lcd_putsf("Baterai Lemah!");
; 0000 0262             TR_1=0;
; 0000 0263             TR_2=0;
; 0000 0264             LCD=0;
; 0000 0265             delay_ms(500);
; 0000 0266             LCD=1;
; 0000 0267             delay_ms(500);*/
; 0000 0268         //}else{
; 0000 0269             grafik();
	CALL _grafik
; 0000 026A         //}
; 0000 026B     }
	RJMP _0xB6
_0xB8:
; 0000 026C 
; 0000 026D     menu:
_0xFC:
; 0000 026E     //indeks=0;
; 0000 026F     //Ambil data dari EEPROM buat ditampilin di menu
; 0000 0270     baca_eeprom();
	CALL _baca_eeprom
; 0000 0271     while(1){
_0x122:
; 0000 0272         if(!MENU_ATAS){while(!MENU_ATAS)delay_ms(20);indeks++;}
	SBIC 0x13,2
	RJMP _0x125
_0x126:
	SBIC 0x13,2
	RJMP _0x128
	CALL SUBOPT_0x1C
	RJMP _0x126
_0x128:
	SUBI R18,-1
; 0000 0273         if(!MENU_BAWAH){while(!MENU_BAWAH)delay_ms(20);indeks--;}
_0x125:
	SBIC 0x13,3
	RJMP _0x129
_0x12A:
	SBIC 0x13,3
	RJMP _0x12C
	CALL SUBOPT_0x1C
	RJMP _0x12A
_0x12C:
	SUBI R18,1
; 0000 0274         if(!OK){while(!OK)delay_ms(20); goto siaga;}
_0x129:
	SBIC 0x13,0
	RJMP _0x12D
_0x12E:
	SBIC 0x13,0
	RJMP _0x130
	CALL SUBOPT_0x1C
	RJMP _0x12E
_0x130:
	RJMP _0xA7
; 0000 0275         if(!BATAL){while(!BATAL)delay_ms(20); goto siaga;}
_0x12D:
	SBIC 0x13,1
	RJMP _0x131
_0x132:
	SBIC 0x13,1
	RJMP _0x134
	CALL SUBOPT_0x1C
	RJMP _0x132
_0x134:
	RJMP _0xA7
; 0000 0276         if(!TAMBAH_NILAI){
_0x131:
	SBIC 0x13,4
	RJMP _0x135
; 0000 0277             while(!TAMBAH_NILAI)delay_ms(20);
_0x136:
	SBIC 0x13,4
	RJMP _0x138
	CALL SUBOPT_0x1C
	RJMP _0x136
_0x138:
; 0000 0278 switch(indeks){
	MOV  R30,R18
	LDI  R31,0
; 0000 0279                 case 0 : goto atur_PID;
	SBIW R30,0
	BREQ PC+3
	JMP _0x13C
	RJMP _0xC1
; 0000 027A                 case 1 : goto cek_motor;
	RJMP _0x13D
_0x13C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x13E
_0x13D:
	RJMP _0xCF
; 0000 027B                 case 2 : goto stabilisator;
	RJMP _0x13F
_0x13E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x140
_0x13F:
	RJMP _0x141
; 0000 027C                 case 3 : goto counter_1;
	RJMP _0x142
_0x140:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x13B
_0x142:
	RJMP _0x144
; 0000 027D             }
_0x13B:
; 0000 027E         }
; 0000 027F         if(!KURANG_NILAI){
_0x135:
	SBIC 0x13,5
	RJMP _0x145
; 0000 0280             while(!KURANG_NILAI)delay_ms(20);
_0x146:
	SBIC 0x13,5
	RJMP _0x148
	CALL SUBOPT_0x1C
	RJMP _0x146
_0x148:
; 0000 0281 switch(indeks){
	MOV  R30,R18
	LDI  R31,0
; 0000 0282                 case 0 : goto atur_kelajuan;
	SBIW R30,0
	BREQ PC+3
	JMP _0x14C
	RJMP _0xC8
; 0000 0283                 case 1 : goto kalibrasi;
	RJMP _0x14D
_0x14C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x14E
_0x14D:
	RJMP _0x14F
; 0000 0284                 case 2 : goto delay_mulai;
	RJMP _0x150
_0x14E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x153
_0x150:
	RJMP _0x152
; 0000 0285                 //case 3 : goto counter_2;
; 0000 0286                 default:break;
_0x153:
; 0000 0287             }
_0x14B:
; 0000 0288         }
; 0000 0289         switch(indeks){
_0x145:
	MOV  R30,R18
	LDI  R31,0
; 0000 028A             case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x157
; 0000 028B                 lcd_gotoxy(0,0);
	CALL SUBOPT_0x18
; 0000 028C                 lcd_putsf("+ Atur PID      ");
	__POINTW2FN _0x0,286
	CALL SUBOPT_0x19
; 0000 028D                 lcd_gotoxy(0,1);
; 0000 028E                 lcd_putsf("- Atur Kelajuan ");break;
	__POINTW2FN _0x0,303
	CALL _lcd_putsf
	RJMP _0x156
; 0000 028F             case 1:
_0x157:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x158
; 0000 0290                 lcd_gotoxy(0,0);
	CALL SUBOPT_0x18
; 0000 0291                 lcd_putsf("+ Tes Motor     ");
	__POINTW2FN _0x0,320
	CALL SUBOPT_0x19
; 0000 0292                 lcd_gotoxy(0,1);
; 0000 0293                 lcd_putsf("- Kalibrasi     ");break;
	__POINTW2FN _0x0,337
	CALL _lcd_putsf
	RJMP _0x156
; 0000 0294             case 2:
_0x158:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x159
; 0000 0295                 lcd_gotoxy(0,0);
	CALL SUBOPT_0x18
; 0000 0296                 lcd_putsf("+ Stabilisator  ");
	__POINTW2FN _0x0,354
	CALL SUBOPT_0x19
; 0000 0297                 lcd_gotoxy(0,1);
; 0000 0298                 lcd_putsf("- Delay Awal    ");break;
	__POINTW2FN _0x0,371
	CALL _lcd_putsf
	RJMP _0x156
; 0000 0299              case 3:
_0x159:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x15B
; 0000 029A                 lcd_gotoxy(0,0);
	CALL SUBOPT_0x18
; 0000 029B                 lcd_putsf("+ Atur Counter  ");
	__POINTW2FN _0x0,388
	CALL SUBOPT_0x19
; 0000 029C                 lcd_gotoxy(0,1);
; 0000 029D                 lcd_putsf("=====TIM LC=====");break;
	__POINTW2FN _0x0,405
	CALL _lcd_putsf
	RJMP _0x156
; 0000 029E             default :
_0x15B:
; 0000 029F             if(indeks == 4){indeks = 0;}
	CPI  R18,4
	BREQ PC+3
	JMP _0x15C
	LDI  R18,LOW(0)
; 0000 02A0             else {indeks = 3;}
	RJMP _0x15D
_0x15C:
	LDI  R18,LOW(3)
_0x15D:
; 0000 02A1         }
_0x156:
; 0000 02A2         delay_ms(150);
	LDI  R26,LOW(150)
	LDI  R27,0
	CALL _delay_ms
; 0000 02A3     }
	RJMP _0x122
_0x124:
; 0000 02A4 
; 0000 02A5     atur_PID:
_0xC1:
; 0000 02A6     indeks = 0;
	LDI  R18,LOW(0)
; 0000 02A7     lcd_clear();
	CALL SUBOPT_0x1F
; 0000 02A8     lcd_gotoxy(0,0);
; 0000 02A9     sprintf(tampil, "kP   kI   kD    ");
	CALL SUBOPT_0x25
	__POINTW1FN _0x0,422
	CALL SUBOPT_0x29
; 0000 02AA     lcd_puts(tampil);
; 0000 02AB     if(aktifasi_serial){
	LDS  R30,_aktifasi_serial
	CPI  R30,0
	BRNE PC+3
	JMP _0x15E
; 0000 02AC         kirim_string("c\r");
	__POINTW2MN _0xBC,6
	CALL SUBOPT_0x2A
; 0000 02AD         sprintf(buffer,"%d\n",kP);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 02AE         kirim_string(buffer);
	CALL SUBOPT_0x2D
; 0000 02AF         kirim_string("d\r");
	__POINTW2MN _0xBC,9
	CALL SUBOPT_0x2A
; 0000 02B0         sprintf(buffer,"%d\n",kI);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2E
; 0000 02B1         kirim_string(buffer);
	CALL SUBOPT_0x2D
; 0000 02B2         kirim_string("e\r");
	__POINTW2MN _0xBC,12
	CALL SUBOPT_0x2A
; 0000 02B3         sprintf(buffer,"%d\n",kD);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2F
; 0000 02B4         kirim_string(buffer);
	CALL SUBOPT_0x2D
; 0000 02B5     }
; 0000 02B6     while(1){
_0x15E:
_0x15F:
; 0000 02B7         if(aktifasi_serial){
	LDS  R30,_aktifasi_serial
	CPI  R30,0
	BRNE PC+3
	JMP _0x162
; 0000 02B8             if(rx_counter){
	TST  R7
	BRNE PC+3
	JMP _0x163
; 0000 02B9                 ambil_string(buffer);
	CALL SUBOPT_0x22
; 0000 02BA                 if(!strcmp(buffer,"a")){
	CALL SUBOPT_0x23
	__POINTW2MN _0xBC,15
	CALL _strcmp
	CPI  R30,0
	BREQ PC+3
	JMP _0x164
; 0000 02BB                     e_kP = kP; e_kI = kI; e_kD = kD;
	CALL SUBOPT_0x30
; 0000 02BC                     goto simpan;
	JMP  _0x165
; 0000 02BD                 }else if(!strcmp(buffer,"b")){
_0x164:
	CALL SUBOPT_0x23
	__POINTW2MN _0xBC,17
	CALL _strcmp
	CPI  R30,0
	BREQ PC+3
	JMP _0x167
; 0000 02BE                     goto siaga;
	RJMP _0xA7
; 0000 02BF                 }else if(!strcmp(buffer,"c")){
_0x167:
	CALL SUBOPT_0x23
	__POINTW2MN _0xBC,19
	CALL _strcmp
	CPI  R30,0
	BREQ PC+3
	JMP _0x169
; 0000 02C0                     if(rx_counter){
	TST  R7
	BRNE PC+3
	JMP _0x16A
; 0000 02C1                         indeks=0;
	LDI  R18,LOW(0)
; 0000 02C2                         ambil_string(buffer);
	CALL SUBOPT_0x22
; 0000 02C3                         kP = atoi(buffer);
	CALL SUBOPT_0x31
	MOVW R10,R30
; 0000 02C4                     }
; 0000 02C5                 }else if(!strcmp(buffer,"d")){
_0x16A:
	RJMP _0x16B
_0x169:
	CALL SUBOPT_0x23
	__POINTW2MN _0xBC,21
	CALL _strcmp
	CPI  R30,0
	BREQ PC+3
	JMP _0x16C
; 0000 02C6                     if(rx_counter){
	TST  R7
	BRNE PC+3
	JMP _0x16D
; 0000 02C7                         indeks=1;
	LDI  R18,LOW(1)
; 0000 02C8                         ambil_string(buffer);
	CALL SUBOPT_0x22
; 0000 02C9                         kI = atoi(buffer);
	CALL SUBOPT_0x31
	MOVW R12,R30
; 0000 02CA                     }
; 0000 02CB                 }else if(!strcmp(buffer,"e")){
_0x16D:
	RJMP _0x16E
_0x16C:
	CALL SUBOPT_0x23
	__POINTW2MN _0xBC,23
	CALL _strcmp
	CPI  R30,0
	BREQ PC+3
	JMP _0x16F
; 0000 02CC                     if(rx_counter){
	TST  R7
	BRNE PC+3
	JMP _0x170
; 0000 02CD                         indeks=2;
	LDI  R18,LOW(2)
; 0000 02CE                         ambil_string(buffer);
	CALL SUBOPT_0x22
; 0000 02CF                         kD = atoi(buffer);
	CALL SUBOPT_0x31
	STS  _kD,R30
	STS  _kD+1,R31
; 0000 02D0                     }
; 0000 02D1                 }
_0x170:
; 0000 02D2             }
_0x16F:
_0x16E:
_0x16B:
_0x168:
_0x166:
; 0000 02D3         }
_0x163:
; 0000 02D4         if(!MENU_ATAS){indeks++;if(indeks==3)indeks=0;delay_ms(70);}
_0x162:
	SBIC 0x13,2
	RJMP _0x171
	SUBI R18,-1
	CPI  R18,3
	BREQ PC+3
	JMP _0x172
	LDI  R18,LOW(0)
_0x172:
	CALL SUBOPT_0x32
; 0000 02D5         if(!MENU_BAWAH){indeks--;if(indeks==255)indeks=2;delay_ms(70);}
_0x171:
	SBIC 0x13,3
	RJMP _0x173
	SUBI R18,1
	CPI  R18,255
	BREQ PC+3
	JMP _0x174
	LDI  R18,LOW(2)
_0x174:
	CALL SUBOPT_0x32
; 0000 02D6         if(!TAMBAH_NILAI){
_0x173:
	SBIC 0x13,4
	RJMP _0x175
; 0000 02D7             switch(indeks){
	MOV  R30,R18
	LDI  R31,0
; 0000 02D8                 case 0 : kP++;break;
	SBIW R30,0
	BREQ PC+3
	JMP _0x179
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0x178
; 0000 02D9                 case 1 : kI++;break;
_0x179:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x17A
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	RJMP _0x178
; 0000 02DA                 case 2 : kD++;break;
_0x17A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x178
	LDI  R26,LOW(_kD)
	LDI  R27,HIGH(_kD)
	CALL SUBOPT_0x0
; 0000 02DB             }
_0x178:
; 0000 02DC             if(aktifasi_serial){
	LDS  R30,_aktifasi_serial
	CPI  R30,0
	BRNE PC+3
	JMP _0x17C
; 0000 02DD                 if(indeks==0){
	CPI  R18,0
	BREQ PC+3
	JMP _0x17D
; 0000 02DE                     kirim_string("c\r");
	__POINTW2MN _0xBC,25
	CALL SUBOPT_0x2A
; 0000 02DF                     sprintf(buffer,"%d\n",kP);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 02E0                     kirim_string(buffer);
	CALL SUBOPT_0x2D
; 0000 02E1                 }else if(indeks==1){
	RJMP _0x17E
_0x17D:
	CPI  R18,1
	BREQ PC+3
	JMP _0x17F
; 0000 02E2                     kirim_string("d\r");
	__POINTW2MN _0xBC,28
	CALL SUBOPT_0x2A
; 0000 02E3                     sprintf(buffer,"%d\n",kI);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2E
; 0000 02E4                     kirim_string(buffer);
	CALL SUBOPT_0x2D
; 0000 02E5                 }else if(indeks==2){
	RJMP _0x180
_0x17F:
	CPI  R18,2
	BREQ PC+3
	JMP _0x181
; 0000 02E6                     kirim_string("e\r");
	__POINTW2MN _0xBC,31
	CALL SUBOPT_0x2A
; 0000 02E7                     sprintf(buffer,"%d\n",kD);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2F
; 0000 02E8                     kirim_string(buffer);
	CALL SUBOPT_0x2D
; 0000 02E9                 }
; 0000 02EA             }
_0x181:
_0x180:
_0x17E:
; 0000 02EB             delay_ms(70);
_0x17C:
	CALL SUBOPT_0x32
; 0000 02EC         }
; 0000 02ED         if(!KURANG_NILAI){
_0x175:
	SBIC 0x13,5
	RJMP _0x182
; 0000 02EE             switch(indeks){
	MOV  R30,R18
	LDI  R31,0
; 0000 02EF                 case 0 : kP--;break;
	SBIW R30,0
	BREQ PC+3
	JMP _0x186
	MOVW R30,R10
	SBIW R30,1
	MOVW R10,R30
	RJMP _0x185
; 0000 02F0                 case 1 : kI--;break;
_0x186:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x187
	MOVW R30,R12
	SBIW R30,1
	MOVW R12,R30
	RJMP _0x185
; 0000 02F1                 case 2 : kD--;break;
_0x187:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x185
	LDI  R26,LOW(_kD)
	LDI  R27,HIGH(_kD)
	CALL SUBOPT_0x33
; 0000 02F2             }
_0x185:
; 0000 02F3             if(aktifasi_serial){
	LDS  R30,_aktifasi_serial
	CPI  R30,0
	BRNE PC+3
	JMP _0x189
; 0000 02F4                 if(indeks==0){
	CPI  R18,0
	BREQ PC+3
	JMP _0x18A
; 0000 02F5                     kirim_string("c\r");
	__POINTW2MN _0xBC,34
	CALL SUBOPT_0x2A
; 0000 02F6                     sprintf(buffer,"%d\n",kP);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 02F7                     kirim_string(buffer);
	CALL SUBOPT_0x2D
; 0000 02F8                 }else if(indeks==1){
	RJMP _0x18B
_0x18A:
	CPI  R18,1
	BREQ PC+3
	JMP _0x18C
; 0000 02F9                     kirim_string("d\r");
	__POINTW2MN _0xBC,37
	CALL SUBOPT_0x2A
; 0000 02FA                     sprintf(buffer,"%d\n",kI);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2E
; 0000 02FB                     kirim_string(buffer);
	CALL SUBOPT_0x2D
; 0000 02FC                 }else if(indeks==2){
	RJMP _0x18D
_0x18C:
	CPI  R18,2
	BREQ PC+3
	JMP _0x18E
; 0000 02FD                     kirim_string("e\r");
	__POINTW2MN _0xBC,40
	CALL SUBOPT_0x2A
; 0000 02FE                     sprintf(buffer,"%d\n",kD);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2F
; 0000 02FF                     kirim_string(buffer);
	CALL SUBOPT_0x2D
; 0000 0300                 }
; 0000 0301             }
_0x18E:
_0x18D:
_0x18B:
; 0000 0302             delay_ms(70);
_0x189:
	CALL SUBOPT_0x32
; 0000 0303         }
; 0000 0304         lcd_gotoxy(1,1);
_0x182:
	LDI  R30,LOW(1)
	CALL SUBOPT_0x1A
; 0000 0305         sprintf(tampil, "%d ", kP);
	CALL SUBOPT_0x25
	CALL SUBOPT_0x34
	CALL SUBOPT_0x2C
; 0000 0306         lcd_puts(tampil);
	CALL SUBOPT_0x28
; 0000 0307         lcd_gotoxy(6,1);
	LDI  R30,LOW(6)
	CALL SUBOPT_0x1A
; 0000 0308         sprintf(tampil, "%d ", kI);
	CALL SUBOPT_0x25
	CALL SUBOPT_0x34
	CALL SUBOPT_0x2E
; 0000 0309         lcd_puts(tampil);
	CALL SUBOPT_0x28
; 0000 030A         lcd_gotoxy(11,1);
	LDI  R30,LOW(11)
	CALL SUBOPT_0x1A
; 0000 030B         sprintf(tampil, "%d ", kD);
	CALL SUBOPT_0x25
	CALL SUBOPT_0x34
	CALL SUBOPT_0x2F
; 0000 030C         lcd_puts(tampil);
	CALL SUBOPT_0x28
; 0000 030D         lcd_gotoxy(0,1);lcd_putchar((indeks==0)?0x7E:32);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1A
	CPI  R18,0
	BREQ PC+3
	JMP _0x18F
	LDI  R30,LOW(126)
	RJMP _0x190
_0x18F:
	LDI  R30,LOW(32)
_0x190:
_0x191:
	CALL SUBOPT_0x35
; 0000 030E         lcd_gotoxy(5,1);lcd_putchar((indeks==1)?0x7E:32);
	CPI  R18,1
	BREQ PC+3
	JMP _0x192
	LDI  R30,LOW(126)
	RJMP _0x193
_0x192:
	LDI  R30,LOW(32)
_0x193:
_0x194:
	MOV  R26,R30
	CALL _lcd_putchar
; 0000 030F         lcd_gotoxy(10,1);lcd_putchar((indeks==2)?0x7E:32);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x1A
	CPI  R18,2
	BREQ PC+3
	JMP _0x195
	LDI  R30,LOW(126)
	RJMP _0x196
_0x195:
	LDI  R30,LOW(32)
_0x196:
_0x197:
	MOV  R26,R30
	CALL _lcd_putchar
; 0000 0310         if(!OK){while(!OK)delay_ms(10);e_kP = kP; e_kI = kI; e_kD = kD; indeks = 0; goto simpan;}
	SBIC 0x13,0
	RJMP _0x198
_0x199:
	SBIC 0x13,0
	RJMP _0x19B
	CALL SUBOPT_0x36
	RJMP _0x199
_0x19B:
	CALL SUBOPT_0x30
	LDI  R18,LOW(0)
	JMP  _0x165
; 0000 0311         if(!BATAL){;while(!BATAL)delay_ms(10);indeks = 0; goto menu;}
_0x198:
	SBIC 0x13,1
	RJMP _0x19C
_0x19D:
	SBIC 0x13,1
	RJMP _0x19F
	CALL SUBOPT_0x36
	RJMP _0x19D
_0x19F:
	LDI  R18,LOW(0)
	RJMP _0xFC
; 0000 0312         delay_ms(10);
_0x19C:
	CALL SUBOPT_0x36
; 0000 0313     }
	RJMP _0x15F
_0x161:
; 0000 0314 
; 0000 0315     atur_kelajuan:
_0xC8:
; 0000 0316     indeks = 0;
	LDI  R18,LOW(0)
; 0000 0317     lcd_clear();
	CALL SUBOPT_0x1F
; 0000 0318     lcd_gotoxy(0,0);
; 0000 0319     sprintf(tampil, "Maks Min   Laju ");
	CALL SUBOPT_0x25
	__POINTW1FN _0x0,456
	CALL SUBOPT_0x29
; 0000 031A     lcd_puts(tampil);
; 0000 031B     kirim_string("c\r");
	__POINTW2MN _0xBC,43
	CALL SUBOPT_0x2A
; 0000 031C     sprintf(buffer,"%d\n",maks_PWM);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x37
; 0000 031D     kirim_string(buffer);
	CALL SUBOPT_0x2D
; 0000 031E     kirim_string("d\r");
	__POINTW2MN _0xBC,46
	CALL SUBOPT_0x2A
; 0000 031F     sprintf(buffer,"%d\n",min_PWM);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x38
; 0000 0320     kirim_string(buffer);
	CALL SUBOPT_0x2D
; 0000 0321     kirim_string("e\r");
	__POINTW2MN _0xBC,49
	CALL SUBOPT_0x2A
; 0000 0322     sprintf(buffer,"%d\n",kelajuan);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x39
; 0000 0323     kirim_string(buffer);
	CALL SUBOPT_0x2D
; 0000 0324     while(1){
_0x1A0:
; 0000 0325         if(aktifasi_serial){
	LDS  R30,_aktifasi_serial
	CPI  R30,0
	BRNE PC+3
	JMP _0x1A3
; 0000 0326             if(rx_counter){
	TST  R7
	BRNE PC+3
	JMP _0x1A4
; 0000 0327                 ambil_string(buffer);
	CALL SUBOPT_0x22
; 0000 0328                 if(!strcmp(buffer,"a")){
	CALL SUBOPT_0x23
	__POINTW2MN _0xBC,52
	CALL _strcmp
	CPI  R30,0
	BREQ PC+3
	JMP _0x1A5
; 0000 0329                     e_maks_PWM = maks_PWM; e_min_PWM = min_PWM; e_kelajuan = kelajuan;
	CALL SUBOPT_0x3A
; 0000 032A                     goto simpan;
	JMP  _0x165
; 0000 032B                 }else if(!strcmp(buffer,"b")){
_0x1A5:
	CALL SUBOPT_0x23
	__POINTW2MN _0xBC,54
	CALL _strcmp
	CPI  R30,0
	BREQ PC+3
	JMP _0x1A7
; 0000 032C                     goto siaga;
	RJMP _0xA7
; 0000 032D                 }else if(!strcmp(buffer,"c")){
_0x1A7:
	CALL SUBOPT_0x23
	__POINTW2MN _0xBC,56
	CALL _strcmp
	CPI  R30,0
	BREQ PC+3
	JMP _0x1A9
; 0000 032E                     indeks=0;
	LDI  R18,LOW(0)
; 0000 032F                     if(rx_counter){
	TST  R7
	BRNE PC+3
	JMP _0x1AA
; 0000 0330                         ambil_string(buffer);
	CALL SUBOPT_0x22
; 0000 0331                         maks_PWM = atoi(buffer);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x4
; 0000 0332                     }
; 0000 0333                 }else if(!strcmp(buffer,"d")){
_0x1AA:
	RJMP _0x1AB
_0x1A9:
	CALL SUBOPT_0x23
	__POINTW2MN _0xBC,58
	CALL _strcmp
	CPI  R30,0
	BREQ PC+3
	JMP _0x1AC
; 0000 0334                     indeks = 1;
	LDI  R18,LOW(1)
; 0000 0335                     if(rx_counter){
	TST  R7
	BRNE PC+3
	JMP _0x1AD
; 0000 0336                         ambil_string(buffer);
	CALL SUBOPT_0x22
; 0000 0337                         min_PWM = atoi(buffer);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x5
; 0000 0338                     }
; 0000 0339                 }else if(!strcmp(buffer,"e")){
_0x1AD:
	RJMP _0x1AE
_0x1AC:
	CALL SUBOPT_0x23
	__POINTW2MN _0xBC,60
	CALL _strcmp
	CPI  R30,0
	BREQ PC+3
	JMP _0x1AF
; 0000 033A                     indeks=2;
	LDI  R18,LOW(2)
; 0000 033B                     if(rx_counter){
	TST  R7
	BRNE PC+3
	JMP _0x1B0
; 0000 033C                         ambil_string(buffer);
	CALL SUBOPT_0x22
; 0000 033D                         kelajuan = atoi(buffer);
	CALL SUBOPT_0x31
	STS  _kelajuan,R30
	STS  _kelajuan+1,R31
; 0000 033E                     }
; 0000 033F                 }
_0x1B0:
; 0000 0340             }
_0x1AF:
_0x1AE:
_0x1AB:
_0x1A8:
_0x1A6:
; 0000 0341         }
_0x1A4:
; 0000 0342         if(kelajuan > maks_PWM){
_0x1A3:
	CALL SUBOPT_0xB
	CALL SUBOPT_0x3B
	CP   R30,R26
	CPC  R31,R27
	BRLT PC+3
	JMP _0x1B1
; 0000 0343             kelajuan = maks_PWM;
	CALL SUBOPT_0xB
	STS  _kelajuan,R30
	STS  _kelajuan+1,R31
; 0000 0344             if(aktifasi_serial){
	LDS  R30,_aktifasi_serial
	CPI  R30,0
	BRNE PC+3
	JMP _0x1B2
; 0000 0345                 kirim_string("e\r");
	__POINTW2MN _0xBC,62
	CALL SUBOPT_0x2A
; 0000 0346                 sprintf(buffer,"%d",kelajuan);
	__POINTW1FN _0x0,473
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x39
; 0000 0347                 kirim_string(buffer);
	CALL SUBOPT_0x2D
; 0000 0348             }
; 0000 0349         }
_0x1B2:
; 0000 034A         if(maks_PWM>255)maks_PWM=0;
_0x1B1:
	LDS  R26,_maks_PWM
	LDS  R27,_maks_PWM+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRGE PC+3
	JMP _0x1B3
	LDI  R30,LOW(0)
	STS  _maks_PWM,R30
	STS  _maks_PWM+1,R30
; 0000 034B         else if(maks_PWM<0)maks_PWM=255;
	RJMP _0x1B4
_0x1B3:
	LDS  R26,_maks_PWM+1
	TST  R26
	BRMI PC+3
	JMP _0x1B5
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CALL SUBOPT_0x4
; 0000 034C         else if(min_PWM>255)min_PWM=0;
	RJMP _0x1B6
_0x1B5:
	LDS  R26,_min_PWM
	LDS  R27,_min_PWM+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRGE PC+3
	JMP _0x1B7
	LDI  R30,LOW(0)
	STS  _min_PWM,R30
	STS  _min_PWM+1,R30
; 0000 034D         else if(min_PWM<0)min_PWM=255;
	RJMP _0x1B8
_0x1B7:
	LDS  R26,_min_PWM+1
	TST  R26
	BRMI PC+3
	JMP _0x1B9
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CALL SUBOPT_0x5
; 0000 034E         if(!MENU_ATAS){indeks++;if(indeks==3)indeks=0;delay_ms(90);}
_0x1B9:
_0x1B8:
_0x1B6:
_0x1B4:
	SBIC 0x13,2
	RJMP _0x1BA
	SUBI R18,-1
	CPI  R18,3
	BREQ PC+3
	JMP _0x1BB
	LDI  R18,LOW(0)
_0x1BB:
	LDI  R26,LOW(90)
	LDI  R27,0
	CALL _delay_ms
; 0000 034F         if(!MENU_BAWAH){indeks--;if(indeks==255)indeks=2;delay_ms(90);}
_0x1BA:
	SBIC 0x13,3
	RJMP _0x1BC
	SUBI R18,1
	CPI  R18,255
	BREQ PC+3
	JMP _0x1BD
	LDI  R18,LOW(2)
_0x1BD:
	LDI  R26,LOW(90)
	LDI  R27,0
	CALL _delay_ms
; 0000 0350         if(!TAMBAH_NILAI){
_0x1BC:
	SBIC 0x13,4
	RJMP _0x1BE
; 0000 0351             switch(indeks){
	MOV  R30,R18
	LDI  R31,0
; 0000 0352                 case 0 : maks_PWM++;break;
	SBIW R30,0
	BREQ PC+3
	JMP _0x1C2
	LDI  R26,LOW(_maks_PWM)
	LDI  R27,HIGH(_maks_PWM)
	CALL SUBOPT_0x0
	RJMP _0x1C1
; 0000 0353                 case 1 : min_PWM++;break;
_0x1C2:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x1C3
	LDI  R26,LOW(_min_PWM)
	LDI  R27,HIGH(_min_PWM)
	CALL SUBOPT_0x0
	RJMP _0x1C1
; 0000 0354                 case 2 : kelajuan++;break;
_0x1C3:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x1C1
	LDI  R26,LOW(_kelajuan)
	LDI  R27,HIGH(_kelajuan)
	CALL SUBOPT_0x0
; 0000 0355             }
_0x1C1:
; 0000 0356             if(aktifasi_serial){
	LDS  R30,_aktifasi_serial
	CPI  R30,0
	BRNE PC+3
	JMP _0x1C5
; 0000 0357                 if(indeks==0){
	CPI  R18,0
	BREQ PC+3
	JMP _0x1C6
; 0000 0358                     kirim_string("c\r");
	__POINTW2MN _0xBC,65
	CALL SUBOPT_0x2A
; 0000 0359                     sprintf(buffer,"%d\n",maks_PWM);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x37
; 0000 035A                     kirim_string(buffer);
	CALL SUBOPT_0x2D
; 0000 035B                 }else if(indeks==1){
	RJMP _0x1C7
_0x1C6:
	CPI  R18,1
	BREQ PC+3
	JMP _0x1C8
; 0000 035C                     kirim_string("d\r");
	__POINTW2MN _0xBC,68
	CALL SUBOPT_0x2A
; 0000 035D                     sprintf(buffer,"%d\n",min_PWM);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x38
; 0000 035E                     kirim_string(buffer);
	CALL SUBOPT_0x2D
; 0000 035F                 }else if(indeks==2){
	RJMP _0x1C9
_0x1C8:
	CPI  R18,2
	BREQ PC+3
	JMP _0x1CA
; 0000 0360                     kirim_string("e\r");
	__POINTW2MN _0xBC,71
	CALL SUBOPT_0x2A
; 0000 0361                     sprintf(buffer,"%d\n",kelajuan);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x39
; 0000 0362                     kirim_string(buffer);;
	CALL SUBOPT_0x2D
; 0000 0363                 }
; 0000 0364             }
_0x1CA:
_0x1C9:
_0x1C7:
; 0000 0365             delay_ms(70);
_0x1C5:
	CALL SUBOPT_0x32
; 0000 0366         }
; 0000 0367         if(!KURANG_NILAI){
_0x1BE:
	SBIC 0x13,5
	RJMP _0x1CB
; 0000 0368             switch(indeks){
	MOV  R30,R18
	LDI  R31,0
; 0000 0369                 case 0 : maks_PWM--;break;
	SBIW R30,0
	BREQ PC+3
	JMP _0x1CF
	LDI  R26,LOW(_maks_PWM)
	LDI  R27,HIGH(_maks_PWM)
	CALL SUBOPT_0x33
	RJMP _0x1CE
; 0000 036A                 case 1 : min_PWM--;break;
_0x1CF:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x1D0
	LDI  R26,LOW(_min_PWM)
	LDI  R27,HIGH(_min_PWM)
	CALL SUBOPT_0x33
	RJMP _0x1CE
; 0000 036B                 case 2 : kelajuan--;break;
_0x1D0:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x1CE
	LDI  R26,LOW(_kelajuan)
	LDI  R27,HIGH(_kelajuan)
	CALL SUBOPT_0x33
; 0000 036C             }
_0x1CE:
; 0000 036D             if(aktifasi_serial){
	LDS  R30,_aktifasi_serial
	CPI  R30,0
	BRNE PC+3
	JMP _0x1D2
; 0000 036E                 if(indeks==0){
	CPI  R18,0
	BREQ PC+3
	JMP _0x1D3
; 0000 036F                     kirim_string("c\r");
	__POINTW2MN _0xBC,74
	CALL SUBOPT_0x2A
; 0000 0370                     sprintf(buffer,"%d\n",maks_PWM);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x37
; 0000 0371                     kirim_string(buffer);
	CALL SUBOPT_0x2D
; 0000 0372                 }else if(indeks==1){
	RJMP _0x1D4
_0x1D3:
	CPI  R18,1
	BREQ PC+3
	JMP _0x1D5
; 0000 0373                     kirim_string("d\r");
	__POINTW2MN _0xBC,77
	CALL SUBOPT_0x2A
; 0000 0374                     sprintf(buffer,"%d\n",min_PWM);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x38
; 0000 0375                     kirim_string(buffer);
	CALL SUBOPT_0x2D
; 0000 0376                 }else if(indeks==2){
	RJMP _0x1D6
_0x1D5:
	CPI  R18,2
	BREQ PC+3
	JMP _0x1D7
; 0000 0377                     kirim_string("e\r");
	__POINTW2MN _0xBC,80
	CALL SUBOPT_0x2A
; 0000 0378                     sprintf(buffer,"%d\n",kelajuan);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x39
; 0000 0379                     kirim_string(buffer);;
	CALL SUBOPT_0x2D
; 0000 037A                 }
; 0000 037B             }
_0x1D7:
_0x1D6:
_0x1D4:
; 0000 037C             delay_ms(70);
_0x1D2:
	CALL SUBOPT_0x32
; 0000 037D         }
; 0000 037E         lcd_gotoxy(1,1);
_0x1CB:
	LDI  R30,LOW(1)
	CALL SUBOPT_0x1A
; 0000 037F         sprintf(tampil, "%d ", maks_PWM);
	CALL SUBOPT_0x25
	CALL SUBOPT_0x34
	CALL SUBOPT_0x37
; 0000 0380         lcd_puts(tampil);
	CALL SUBOPT_0x28
; 0000 0381         lcd_gotoxy(6,1);
	LDI  R30,LOW(6)
	CALL SUBOPT_0x1A
; 0000 0382         if(!min_PWM) sprintf(tampil, "%d ", min_PWM);
	LDS  R30,_min_PWM
	LDS  R31,_min_PWM+1
	SBIW R30,0
	BREQ PC+3
	JMP _0x1D8
	CALL SUBOPT_0x25
	CALL SUBOPT_0x34
	CALL SUBOPT_0x38
; 0000 0383         else sprintf(tampil, "-%d ", min_PWM);
	RJMP _0x1D9
_0x1D8:
	CALL SUBOPT_0x25
	__POINTW1FN _0x0,476
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x38
; 0000 0384         lcd_puts(tampil);
_0x1D9:
	CALL SUBOPT_0x28
; 0000 0385         lcd_gotoxy(12, 1);
	LDI  R30,LOW(12)
	CALL SUBOPT_0x1A
; 0000 0386         sprintf(tampil, "%d ", kelajuan);
	CALL SUBOPT_0x25
	CALL SUBOPT_0x34
	CALL SUBOPT_0x39
; 0000 0387         lcd_puts(tampil);
	CALL SUBOPT_0x28
; 0000 0388         lcd_gotoxy(0,1);lcd_putchar((indeks==0)?0x7E:32);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1A
	CPI  R18,0
	BREQ PC+3
	JMP _0x1DA
	LDI  R30,LOW(126)
	RJMP _0x1DB
_0x1DA:
	LDI  R30,LOW(32)
_0x1DB:
_0x1DC:
	CALL SUBOPT_0x35
; 0000 0389         lcd_gotoxy(5,1);lcd_putchar((indeks==1)?0x7E:32);
	CPI  R18,1
	BREQ PC+3
	JMP _0x1DD
	LDI  R30,LOW(126)
	RJMP _0x1DE
_0x1DD:
	LDI  R30,LOW(32)
_0x1DE:
_0x1DF:
	CALL SUBOPT_0x3C
; 0000 038A         lcd_gotoxy(11,1);lcd_putchar((indeks==2)?0x7E:32);
	CALL SUBOPT_0x1A
	CPI  R18,2
	BREQ PC+3
	JMP _0x1E0
	LDI  R30,LOW(126)
	RJMP _0x1E1
_0x1E0:
	LDI  R30,LOW(32)
_0x1E1:
_0x1E2:
	MOV  R26,R30
	CALL _lcd_putchar
; 0000 038B         if(!OK){while(!OK)delay_ms(10); e_maks_PWM = maks_PWM; e_min_PWM = min_PWM; e_kelajuan = kelajuan; indeks = 0; g ...
	SBIC 0x13,0
	RJMP _0x1E3
_0x1E4:
	SBIC 0x13,0
	RJMP _0x1E6
	CALL SUBOPT_0x36
	RJMP _0x1E4
_0x1E6:
	CALL SUBOPT_0x3A
	LDI  R18,LOW(0)
	RJMP _0x165
; 0000 038C         if(!BATAL){while(!BATAL)delay_ms(10);indeks = 0; goto menu;}
_0x1E3:
	SBIC 0x13,1
	RJMP _0x1E7
_0x1E8:
	SBIC 0x13,1
	RJMP _0x1EA
	CALL SUBOPT_0x36
	RJMP _0x1E8
_0x1EA:
	LDI  R18,LOW(0)
	RJMP _0xFC
; 0000 038D         delay_ms(10);
_0x1E7:
	CALL SUBOPT_0x36
; 0000 038E     }
	RJMP _0x1A0
_0x1A2:
; 0000 038F 
; 0000 0390     cek_motor:
_0xCF:
; 0000 0391     pwm_kanan=kelajuan;
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3E
; 0000 0392     pwm_kiri=kelajuan;
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3F
; 0000 0393     atur_pwm(pwm_kiri+k_stabilisator,pwm_kanan);
	CALL SUBOPT_0x40
; 0000 0394     lcd_clear();
	CALL SUBOPT_0x1F
; 0000 0395     lcd_gotoxy(0,0);
; 0000 0396     lcd_putsf("    Cek Motor   ");
	__POINTW2FN _0x0,481
	CALL _lcd_putsf
; 0000 0397     if(aktifasi_serial){
	LDS  R30,_aktifasi_serial
	CPI  R30,0
	BRNE PC+3
	JMP _0x1EB
; 0000 0398         while(1){
_0x1EC:
; 0000 0399             /*kirim_string("b\r");
; 0000 039A             sprintf(buffer,"%d\n",pwm_kiri);
; 0000 039B             kirim_string(buffer);
; 0000 039C             kirim_string("c\r");
; 0000 039D             sprintf(buffer,"%d\n",motor_kiri);
; 0000 039E             kirim_string(buffer);
; 0000 039F             kirim_string("d\r");
; 0000 03A0             sprintf(buffer,"%d\n",pwm_kanan);
; 0000 03A1             kirim_string(buffer);
; 0000 03A2             kirim_string("e\r");
; 0000 03A3             sprintf(buffer,"%d\n",motor_kanan);
; 0000 03A4             kirim_string(buffer);*/
; 0000 03A5             if(rx_counter){
	TST  R7
	BRNE PC+3
	JMP _0x1EF
; 0000 03A6                 ambil_string(buffer);
	CALL SUBOPT_0x22
; 0000 03A7                 if(!(strcmp(buffer,"a"))){
	CALL SUBOPT_0x23
	__POINTW2MN _0xBC,83
	CALL _strcmp
	CPI  R30,0
	BREQ PC+3
	JMP _0x1F0
; 0000 03A8                     atur_pwm(0,0);
	CALL SUBOPT_0x41
; 0000 03A9                     pwm_kanan=0;
	LDI  R30,LOW(0)
	STS  _pwm_kanan,R30
	STS  _pwm_kanan+1,R30
; 0000 03AA                     pwm_kiri=0;
	STS  _pwm_kiri,R30
	STS  _pwm_kiri+1,R30
; 0000 03AB                     goto siaga;
	RJMP _0xA7
; 0000 03AC                 }else if(!(strcmp(buffer,"b"))){
_0x1F0:
	CALL SUBOPT_0x23
	__POINTW2MN _0xBC,85
	CALL _strcmp
	CPI  R30,0
	BREQ PC+3
	JMP _0x1F2
; 0000 03AD                     if(rx_counter){
	TST  R7
	BRNE PC+3
	JMP _0x1F3
; 0000 03AE                         ambil_string(buffer);
	CALL SUBOPT_0x22
; 0000 03AF                         pwm_kiri = atoi(buffer);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x3F
; 0000 03B0                     }
; 0000 03B1                     if(rx_counter){
_0x1F3:
	TST  R7
	BRNE PC+3
	JMP _0x1F4
; 0000 03B2                         ambil_string(buffer);
	CALL SUBOPT_0x22
; 0000 03B3                         motor_kiri = atoi(buffer);
	CALL SUBOPT_0x31
	CPI  R30,0
	BRNE _0x1F5
	CBI  0x12,3
	RJMP _0x1F6
_0x1F5:
	SBI  0x12,3
_0x1F6:
; 0000 03B4                     }
; 0000 03B5                     if(rx_counter){
_0x1F4:
	TST  R7
	BRNE PC+3
	JMP _0x1F7
; 0000 03B6                         ambil_string(buffer);
	CALL SUBOPT_0x22
; 0000 03B7                         pwm_kanan = atoi(buffer);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x3E
; 0000 03B8                     }
; 0000 03B9                     if(rx_counter){
_0x1F7:
	TST  R7
	BRNE PC+3
	JMP _0x1F8
; 0000 03BA                         ambil_string(buffer);
	CALL SUBOPT_0x22
; 0000 03BB                         motor_kanan = atoi(buffer);
	CALL SUBOPT_0x31
	CPI  R30,0
	BRNE _0x1F9
	CBI  0x12,6
	RJMP _0x1FA
_0x1F9:
	SBI  0x12,6
_0x1FA:
; 0000 03BC                     }
; 0000 03BD                 }
_0x1F8:
; 0000 03BE 
; 0000 03BF                 /*}else if(!(strcmp(buffer,"c"))){
; 0000 03C0                     if(rx_counter){
; 0000 03C1                         ambil_string(buffer);
; 0000 03C2                         motor_kiri = atoi(buffer);
; 0000 03C3                     }
; 0000 03C4                 }else if(!(strcmp(buffer,"d"))){
; 0000 03C5                     if(rx_counter){
; 0000 03C6                         ambil_string(buffer);
; 0000 03C7                         pwm_kanan = atoi(buffer);
; 0000 03C8                     }
; 0000 03C9                 }else if(!(strcmp(buffer,"e"))){
; 0000 03CA                     if(rx_counter){
; 0000 03CB                         ambil_string(buffer);
; 0000 03CC                         motor_kanan = atoi(buffer);
; 0000 03CD                     }
; 0000 03CE 
; 0000 03CF                 }*/
; 0000 03D0                 if(motor_kiri)pwm_kiri-=255;
_0x1F2:
_0x1F1:
	SBIS 0x12,3
	RJMP _0x1FB
	LDS  R30,_pwm_kiri
	LDS  R31,_pwm_kiri+1
	SUBI R30,LOW(255)
	SBCI R31,HIGH(255)
	CALL SUBOPT_0x3F
; 0000 03D1                 if(motor_kanan)pwm_kanan-=255;
_0x1FB:
	SBIS 0x12,6
	RJMP _0x1FC
	LDS  R30,_pwm_kanan
	LDS  R31,_pwm_kanan+1
	SUBI R30,LOW(255)
	SBCI R31,HIGH(255)
	CALL SUBOPT_0x3E
; 0000 03D2                 atur_pwm(pwm_kiri+k_stabilisator,pwm_kanan);
_0x1FC:
	CALL SUBOPT_0x40
; 0000 03D3             }
; 0000 03D4             delay_ms(10);
_0x1EF:
	CALL SUBOPT_0x36
; 0000 03D5         }
	RJMP _0x1EC
_0x1EE:
; 0000 03D6     }
; 0000 03D7     TIMSK = 0x01;
_0x1EB:
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 03D8     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1A
; 0000 03D9     lcd_putsf("     Lurus      ");
	__POINTW2FN _0x0,498
	CALL SUBOPT_0x42
; 0000 03DA     atur_pwm(kelajuan+k_stabilisator,kelajuan);
	CALL SUBOPT_0x43
; 0000 03DB     delay_ms(1500);
; 0000 03DC     lcd_gotoxy(0,1);
; 0000 03DD     lcd_putsf("  Belok Kanan   ");
	__POINTW2FN _0x0,515
	CALL SUBOPT_0x42
; 0000 03DE     atur_pwm(kelajuan+k_stabilisator,-(kelajuan));
	CALL SUBOPT_0x44
	CALL SUBOPT_0x45
; 0000 03DF     delay_ms(1500);
; 0000 03E0     lcd_gotoxy(0,1);
; 0000 03E1     lcd_putsf("   Belok Kiri   ");
	__POINTW2FN _0x0,532
	CALL _lcd_putsf
; 0000 03E2     atur_pwm((-kelajuan)+k_stabilisator,kelajuan);
	CALL SUBOPT_0x44
	CALL SUBOPT_0x46
	CALL SUBOPT_0x43
; 0000 03E3     delay_ms(1500);
; 0000 03E4     lcd_gotoxy(0,1);
; 0000 03E5     lcd_putsf("     Mundur     ");
	__POINTW2FN _0x0,549
	CALL _lcd_putsf
; 0000 03E6     atur_pwm((-kelajuan)+k_stabilisator,-(kelajuan));
	CALL SUBOPT_0x44
	CALL SUBOPT_0x46
	CALL SUBOPT_0x44
	CALL SUBOPT_0x45
; 0000 03E7     delay_ms(1500);
; 0000 03E8     lcd_gotoxy(0,1);
; 0000 03E9     lcd_putsf("    Berhenti    ");
	__POINTW2FN _0x0,566
	CALL _lcd_putsf
; 0000 03EA     atur_pwm(0,0);
	CALL SUBOPT_0x41
; 0000 03EB     delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 03EC     TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 03ED     lcd_gotoxy(0,0);
	CALL SUBOPT_0x18
; 0000 03EE     lcd_putsf("Total Waktu     ");
	__POINTW2FN _0x0,583
	CALL SUBOPT_0x19
; 0000 03EF     lcd_gotoxy(0,1);
; 0000 03F0     sprintf(tampil,"%ds:%dms     ",detik,cacah);
	CALL SUBOPT_0x25
	CALL SUBOPT_0x47
; 0000 03F1     lcd_puts(tampil);
; 0000 03F2     delay_ms(1500);
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	CALL _delay_ms
; 0000 03F3     cacah=0;
	CALL SUBOPT_0x2
; 0000 03F4     detik=0;
	CALL SUBOPT_0x48
; 0000 03F5     goto menu;
	RJMP _0xFC
; 0000 03F6 
; 0000 03F7     kalibrasi:
_0x14F:
; 0000 03F8     j = 0;
	LDI  R19,LOW(0)
; 0000 03F9     indeks=0;
	LDI  R18,LOW(0)
; 0000 03FA     lcd_clear();
	CALL _lcd_clear
; 0000 03FB     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1A
; 0000 03FC     lcd_putsf("Kalibrasi...    ");
	__POINTW2FN _0x0,614
	CALL _lcd_putsf
; 0000 03FD     TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 03FE     while(1){
_0x1FD:
; 0000 03FF         TR_1=1;TR_2=0;
	SBI  0x15,6
	CBI  0x15,7
; 0000 0400         delay_us(200);
	__DELAY_USW 800
; 0000 0401         for(i=0;i<7;i++){
	LDI  R16,LOW(0)
_0x205:
	CPI  R16,7
	BRLO PC+3
	JMP _0x206
; 0000 0402             nilai_adc[i]=read_adc(7-i);
	CALL SUBOPT_0x49
	PUSH R31
	PUSH R30
	LDI  R30,LOW(7)
	SUB  R30,R16
	MOV  R26,R30
	CALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0403         }
_0x204:
	SUBI R16,-1
	RJMP _0x205
_0x206:
; 0000 0404         TR_1=0;TR_2=1;
	CBI  0x15,6
	SBI  0x15,7
; 0000 0405         delay_us(200);
	__DELAY_USW 800
; 0000 0406         for(i=7;i<14;i++){
	LDI  R16,LOW(7)
_0x20C:
	CPI  R16,14
	BRLO PC+3
	JMP _0x20D
; 0000 0407             nilai_adc[i]=read_adc(i-6);
	CALL SUBOPT_0x49
	PUSH R31
	PUSH R30
	MOV  R26,R16
	SUBI R26,LOW(6)
	CALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0408         }
_0x20B:
	SUBI R16,-1
	RJMP _0x20C
_0x20D:
; 0000 0409         if(!j){
	CPI  R19,0
	BREQ PC+3
	JMP _0x20E
; 0000 040A              for(i = 0;i < 14;i++){
	LDI  R16,LOW(0)
_0x210:
	CPI  R16,14
	BRLO PC+3
	JMP _0x211
; 0000 040B                 ambang_atas[i] = nilai_adc[i];
	CALL SUBOPT_0x4A
	LD   R30,Z
	ST   X,R30
; 0000 040C                 ambang_bawah[i] = nilai_adc[i];
	CALL SUBOPT_0x4B
	LD   R30,Z
	ST   X,R30
; 0000 040D             }
_0x20F:
	SUBI R16,-1
	RJMP _0x210
_0x211:
; 0000 040E             j++;
	SUBI R19,-1
; 0000 040F         }
; 0000 0410         for(i = 0;i < 14;i++){
_0x20E:
	LDI  R16,LOW(0)
_0x213:
	CPI  R16,14
	BRLO PC+3
	JMP _0x214
; 0000 0411             if(nilai_adc[i] > ambang_atas[i]){ambang_atas[i] = nilai_adc[i];}
	CALL SUBOPT_0x49
	LD   R26,Z
	CALL SUBOPT_0x4C
	LD   R30,Z
	CP   R30,R26
	BRLO PC+3
	JMP _0x215
	CALL SUBOPT_0x4A
	LD   R30,Z
	ST   X,R30
; 0000 0412             if(nilai_adc[i] < ambang_bawah[i]){ambang_bawah[i] = nilai_adc[i];}
_0x215:
	CALL SUBOPT_0x49
	LD   R26,Z
	CALL SUBOPT_0x4D
	CP   R26,R30
	BRLO PC+3
	JMP _0x216
	CALL SUBOPT_0x4B
	LD   R30,Z
	ST   X,R30
; 0000 0413         }
_0x216:
_0x212:
	SUBI R16,-1
	RJMP _0x213
_0x214:
; 0000 0414         if(cacah>80){
	CALL SUBOPT_0x1
	CPI  R26,LOW(0x51)
	LDI  R30,HIGH(0x51)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x217
; 0000 0415             cacah=0;
	CALL SUBOPT_0x2
; 0000 0416             lcd_gotoxy(indeks,0);
	ST   -Y,R18
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 0417             lcd_putchar((j==1)?0xff:32);
	CPI  R19,1
	BREQ PC+3
	JMP _0x218
	LDI  R30,LOW(255)
	RJMP _0x219
_0x218:
	LDI  R30,LOW(32)
_0x219:
_0x21A:
	MOV  R26,R30
	CALL _lcd_putchar
; 0000 0418             if(indeks<15){indeks++;}
	CPI  R18,15
	BRLO PC+3
	JMP _0x21B
	SUBI R18,-1
; 0000 0419             else{indeks=0;j=(j==1)?2:1;}
	RJMP _0x21C
_0x21B:
	LDI  R18,LOW(0)
	CPI  R19,1
	BREQ PC+3
	JMP _0x21D
	LDI  R30,LOW(2)
	RJMP _0x21E
_0x21D:
	LDI  R30,LOW(1)
_0x21E:
_0x21F:
	MOV  R19,R30
_0x21C:
; 0000 041A         }
; 0000 041B         if(!OK){
_0x217:
	SBIC 0x13,0
	RJMP _0x220
; 0000 041C             TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 041D             cacah=0;
	CALL SUBOPT_0x2
; 0000 041E             detik=0;
	CALL SUBOPT_0x48
; 0000 041F             sensor_mati;
	CBI  0x15,6
	CBI  0x15,7
; 0000 0420             while(!OK)delay_ms(20);
_0x225:
	SBIC 0x13,0
	RJMP _0x227
	CALL SUBOPT_0x1C
	RJMP _0x225
_0x227:
; 0000 0421 for(i = 0;i < 14;i++){
	LDI  R16,LOW(0)
_0x229:
	CPI  R16,14
	BRLO PC+3
	JMP _0x22A
; 0000 0422                 e_n_tengah[i] = (ambang_atas[i] + ambang_bawah[i])/2;
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_e_n_tengah)
	SBCI R31,HIGH(-_e_n_tengah)
	MOVW R22,R30
	CALL SUBOPT_0x4C
	LD   R26,Z
	LDI  R27,0
	CALL SUBOPT_0x4D
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	MOVW R26,R22
	CALL SUBOPT_0x4E
; 0000 0423                 e_ambang_atas[i] = ambang_atas[i];
	SUBI R26,LOW(-_e_ambang_atas)
	SBCI R27,HIGH(-_e_ambang_atas)
	CALL SUBOPT_0x4C
	LD   R30,Z
	CALL SUBOPT_0x4E
; 0000 0424                 e_ambang_bawah[i] = ambang_bawah[i];
	SUBI R26,LOW(-_e_ambang_bawah)
	SBCI R27,HIGH(-_e_ambang_bawah)
	CALL SUBOPT_0x4D
	CALL __EEPROMWRB
; 0000 0425             }
_0x228:
	SUBI R16,-1
	RJMP _0x229
_0x22A:
; 0000 0426             indeks=1;
	LDI  R18,LOW(1)
; 0000 0427             goto simpan;
	RJMP _0x165
; 0000 0428         }
; 0000 0429         if(!BATAL){TIMSK=0x00;cacah=0;detik=0;sensor_mati; while(!BATAL)delay_ms(20); indeks=1;goto menu;}
_0x220:
	SBIC 0x13,1
	RJMP _0x22B
	LDI  R30,LOW(0)
	OUT  0x39,R30
	CALL SUBOPT_0x2
	CALL SUBOPT_0x48
	CBI  0x15,6
	CBI  0x15,7
_0x230:
	SBIC 0x13,1
	RJMP _0x232
	CALL SUBOPT_0x1C
	RJMP _0x230
_0x232:
	LDI  R18,LOW(1)
	RJMP _0xFC
; 0000 042A     }
_0x22B:
	RJMP _0x1FD
_0x1FF:
; 0000 042B 
; 0000 042C     stabilisator:
_0x141:
; 0000 042D     lcd_gotoxy(0,0);
	CALL SUBOPT_0x18
; 0000 042E     lcd_putsf("Stabilisator    ");
	__POINTW2FN _0x0,631
	CALL SUBOPT_0x19
; 0000 042F     lcd_gotoxy(0,1);
; 0000 0430     lcd_putchar(0x7E);
	LDI  R26,LOW(126)
	CALL _lcd_putchar
; 0000 0431     while(1){
_0x233:
; 0000 0432         if(!TAMBAH_NILAI){k_stabilisator++; if(k_stabilisator > 255){k_stabilisator = -255;}}
	SBIC 0x13,4
	RJMP _0x236
	LDI  R26,LOW(_k_stabilisator)
	LDI  R27,HIGH(_k_stabilisator)
	CALL SUBOPT_0x0
	LDS  R26,_k_stabilisator
	LDS  R27,_k_stabilisator+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRGE PC+3
	JMP _0x237
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	CALL SUBOPT_0x8
_0x237:
; 0000 0433         if(!KURANG_NILAI){k_stabilisator--; if(k_stabilisator < -255){k_stabilisator = 255;}}
_0x236:
	SBIC 0x13,5
	RJMP _0x238
	LDI  R26,LOW(_k_stabilisator)
	LDI  R27,HIGH(_k_stabilisator)
	CALL SUBOPT_0x33
	LDS  R26,_k_stabilisator
	LDS  R27,_k_stabilisator+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRLT PC+3
	JMP _0x239
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CALL SUBOPT_0x8
_0x239:
; 0000 0434         lcd_gotoxy(1,1);
_0x238:
	LDI  R30,LOW(1)
	CALL SUBOPT_0x1A
; 0000 0435         sprintf(tampil, "%d              ", k_stabilisator);
	CALL SUBOPT_0x25
	__POINTW1FN _0x0,648
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x50
; 0000 0436         lcd_puts(tampil);
	CALL SUBOPT_0x28
; 0000 0437         if(!OK){while(!OK)delay_ms(20); e_k_stabilisator = k_stabilisator; goto simpan;}
	SBIC 0x13,0
	RJMP _0x23A
_0x23B:
	SBIC 0x13,0
	RJMP _0x23D
	CALL SUBOPT_0x1C
	RJMP _0x23B
_0x23D:
	CALL SUBOPT_0x4F
	LDI  R26,LOW(_e_k_stabilisator)
	LDI  R27,HIGH(_e_k_stabilisator)
	CALL __EEPROMWRW
	RJMP _0x165
; 0000 0438         if(!BATAL){while(!BATAL)delay_ms(20); goto menu;}
_0x23A:
	SBIC 0x13,1
	RJMP _0x23E
_0x23F:
	SBIC 0x13,1
	RJMP _0x241
	CALL SUBOPT_0x1C
	RJMP _0x23F
_0x241:
	RJMP _0xFC
; 0000 0439         delay_ms(100);
_0x23E:
	CALL SUBOPT_0x1D
; 0000 043A     }
	RJMP _0x233
_0x235:
; 0000 043B 
; 0000 043C     delay_mulai:
_0x152:
; 0000 043D     lcd_clear();
	CALL SUBOPT_0x1F
; 0000 043E     lcd_gotoxy(0,0);
; 0000 043F     lcd_putsf("Delay Awal      ");
	__POINTW2FN _0x0,665
	CALL SUBOPT_0x19
; 0000 0440     lcd_gotoxy(0,1);
; 0000 0441     lcd_putchar(0x7E);
	LDI  R26,LOW(126)
	CALL _lcd_putchar
; 0000 0442     while(1){
_0x242:
; 0000 0443         if(!TAMBAH_NILAI)delay_awal++;
	SBIC 0x13,4
	RJMP _0x245
	LDS  R30,_delay_awal
	SUBI R30,-LOW(1)
	STS  _delay_awal,R30
; 0000 0444         if(!KURANG_NILAI)delay_awal--;
_0x245:
	SBIC 0x13,5
	RJMP _0x246
	LDS  R30,_delay_awal
	SUBI R30,LOW(1)
	STS  _delay_awal,R30
; 0000 0445         lcd_gotoxy(1,1);
_0x246:
	LDI  R30,LOW(1)
	CALL SUBOPT_0x1A
; 0000 0446         sprintf(tampil,"%d  ",delay_awal);
	CALL SUBOPT_0x25
	__POINTW1FN _0x0,682
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_delay_awal
	CALL SUBOPT_0x51
; 0000 0447         lcd_puts(tampil);
	CALL SUBOPT_0x28
; 0000 0448         if(!OK){
	SBIC 0x13,0
	RJMP _0x247
; 0000 0449             while(!OK)delay_ms(20);
_0x248:
	SBIC 0x13,0
	RJMP _0x24A
	CALL SUBOPT_0x1C
	RJMP _0x248
_0x24A:
; 0000 044A e_delay_awal = delay_awal;
	LDS  R30,_delay_awal
	LDI  R26,LOW(_e_delay_awal)
	LDI  R27,HIGH(_e_delay_awal)
	CALL __EEPROMWRB
; 0000 044B             indeks=2;
	LDI  R18,LOW(2)
; 0000 044C             goto simpan;
	RJMP _0x165
; 0000 044D         }
; 0000 044E         if(!BATAL){
_0x247:
	SBIC 0x13,1
	RJMP _0x24B
; 0000 044F             while(!BATAL)delay_ms(20);
_0x24C:
	SBIC 0x13,1
	RJMP _0x24E
	CALL SUBOPT_0x1C
	RJMP _0x24C
_0x24E:
; 0000 0450 indeks=2;
	LDI  R18,LOW(2)
; 0000 0451             goto menu;
	RJMP _0xFC
; 0000 0452         }
; 0000 0453         delay_ms(100);
_0x24B:
	CALL SUBOPT_0x1D
; 0000 0454     }
	RJMP _0x242
_0x244:
; 0000 0455 
; 0000 0456     counter_1:
_0x144:
; 0000 0457     while(!OK||!MENU_ATAS||!MENU_BAWAH)delay_ms(20);
_0x24F:
	SBIS 0x13,0
	RJMP _0x252
	SBIS 0x13,2
	RJMP _0x252
	SBIS 0x13,3
	RJMP _0x252
	RJMP _0x251
_0x252:
	CALL SUBOPT_0x1C
	RJMP _0x24F
_0x251:
; 0000 0458 i = 0;
	LDI  R16,LOW(0)
; 0000 0459     indeks = 0;
	LDI  R18,LOW(0)
; 0000 045A     lcd_clear();
	CALL _lcd_clear
; 0000 045B     while(1){
_0x254:
; 0000 045C         if(!MENU_ATAS){indeks++;if(indeks==6)indeks=0;}
	SBIC 0x13,2
	RJMP _0x257
	SUBI R18,-1
	CPI  R18,6
	BREQ PC+3
	JMP _0x258
	LDI  R18,LOW(0)
_0x258:
; 0000 045D         if(!MENU_BAWAH){indeks--;if(indeks==255)indeks=5;}
_0x257:
	SBIC 0x13,3
	RJMP _0x259
	SUBI R18,1
	CPI  R18,255
	BREQ PC+3
	JMP _0x25A
	LDI  R18,LOW(5)
_0x25A:
; 0000 045E         if(!TAMBAH_NILAI){
_0x259:
	SBIC 0x13,4
	RJMP _0x25B
; 0000 045F             switch(indeks){
	MOV  R30,R18
	LDI  R31,0
; 0000 0460                 case 0 : i++;if(i == JML_INDEKS)i= 0;break;
	SBIW R30,0
	BREQ PC+3
	JMP _0x25F
	SUBI R16,-1
	CPI  R16,90
	BREQ PC+3
	JMP _0x260
	LDI  R16,LOW(0)
_0x260:
	RJMP _0x25E
; 0000 0461                 case 1 : c_delay[i]++;if(c_delay[i] == 100)c_delay[i]=0;break;
_0x25F:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x261
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_c_delay)
	SBCI R27,HIGH(-_c_delay)
	CALL SUBOPT_0x52
	SUBI R30,LOW(-_c_delay)
	SBCI R31,HIGH(-_c_delay)
	LD   R26,Z
	CPI  R26,LOW(0x64)
	BREQ PC+3
	JMP _0x262
	CALL SUBOPT_0x53
	LDI  R26,LOW(0)
	STD  Z+0,R26
_0x262:
	RJMP _0x25E
; 0000 0462                 case 2 : c_timer[i]++;if(c_timer[i] == 100)c_timer[i]=0;break;
_0x261:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x263
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_c_timer)
	SBCI R27,HIGH(-_c_timer)
	CALL SUBOPT_0x52
	SUBI R30,LOW(-_c_timer)
	SBCI R31,HIGH(-_c_timer)
	LD   R26,Z
	CPI  R26,LOW(0x64)
	BREQ PC+3
	JMP _0x264
	CALL SUBOPT_0x54
	LDI  R26,LOW(0)
	STD  Z+0,R26
_0x264:
	RJMP _0x25E
; 0000 0463                 case 3 : c_aksi[i]++;if(c_aksi[i] == 4)c_aksi[i] = 0;delay_ms(20);break;
_0x263:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x265
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_c_aksi)
	SBCI R27,HIGH(-_c_aksi)
	CALL SUBOPT_0x52
	SUBI R30,LOW(-_c_aksi)
	SBCI R31,HIGH(-_c_aksi)
	LD   R26,Z
	CPI  R26,LOW(0x4)
	BREQ PC+3
	JMP _0x266
	CALL SUBOPT_0x55
	LDI  R26,LOW(0)
	STD  Z+0,R26
_0x266:
	CALL SUBOPT_0x1C
	RJMP _0x25E
; 0000 0464                 case 4 : c_sensor_ki[i]++;if(c_sensor_ki[i] == 6)c_sensor_ki[i] = 0;delay_ms(20);break;
_0x265:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x267
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_c_sensor_ki)
	SBCI R27,HIGH(-_c_sensor_ki)
	CALL SUBOPT_0x52
	SUBI R30,LOW(-_c_sensor_ki)
	SBCI R31,HIGH(-_c_sensor_ki)
	LD   R26,Z
	CPI  R26,LOW(0x6)
	BREQ PC+3
	JMP _0x268
	CALL SUBOPT_0x56
	LDI  R26,LOW(0)
	STD  Z+0,R26
_0x268:
	CALL SUBOPT_0x1C
	RJMP _0x25E
; 0000 0465                 case 5 : c_sensor_ka[i]++;if(c_sensor_ka[i] == 6)c_sensor_ka[i] = 0;delay_ms(20);break;
_0x267:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x25E
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_c_sensor_ka)
	SBCI R27,HIGH(-_c_sensor_ka)
	CALL SUBOPT_0x52
	SUBI R30,LOW(-_c_sensor_ka)
	SBCI R31,HIGH(-_c_sensor_ka)
	LD   R26,Z
	CPI  R26,LOW(0x6)
	BREQ PC+3
	JMP _0x26A
	CALL SUBOPT_0x57
	LDI  R26,LOW(0)
	STD  Z+0,R26
_0x26A:
	CALL SUBOPT_0x1C
; 0000 0466             }
_0x25E:
; 0000 0467         }
; 0000 0468         if(!KURANG_NILAI){
_0x25B:
	SBIC 0x13,5
	RJMP _0x26B
; 0000 0469             switch(indeks){
	MOV  R30,R18
	LDI  R31,0
; 0000 046A                 case 0 : i--;if(i == 255){i = (JML_INDEKS-1);}break;
	SBIW R30,0
	BREQ PC+3
	JMP _0x26F
	SUBI R16,1
	CPI  R16,255
	BREQ PC+3
	JMP _0x270
	LDI  R16,LOW(89)
_0x270:
	RJMP _0x26E
; 0000 046B                 case 1 : c_delay[i]--;if(c_delay[i] == 255)c_delay[i]=99;break;
_0x26F:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x271
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_c_delay)
	SBCI R27,HIGH(-_c_delay)
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
	CALL SUBOPT_0x53
	LD   R26,Z
	CPI  R26,LOW(0xFF)
	BREQ PC+3
	JMP _0x272
	CALL SUBOPT_0x53
	LDI  R26,LOW(99)
	STD  Z+0,R26
_0x272:
	RJMP _0x26E
; 0000 046C                 case 2 : c_timer[i]--;if(c_timer[i] == 255)c_timer[i]=99;break;
_0x271:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x273
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_c_timer)
	SBCI R27,HIGH(-_c_timer)
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
	CALL SUBOPT_0x54
	LD   R26,Z
	CPI  R26,LOW(0xFF)
	BREQ PC+3
	JMP _0x274
	CALL SUBOPT_0x54
	LDI  R26,LOW(99)
	STD  Z+0,R26
_0x274:
	RJMP _0x26E
; 0000 046D                 case 3 : c_aksi[i]--;delay_ms(20);break;
_0x273:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x275
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_c_aksi)
	SBCI R27,HIGH(-_c_aksi)
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
	CALL SUBOPT_0x1C
	RJMP _0x26E
; 0000 046E                 case 4 : c_sensor_ki[i]--;if(c_sensor_ki[i] == 255) c_sensor_ki[i] = 5;delay_ms(20);break;
_0x275:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x276
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_c_sensor_ki)
	SBCI R27,HIGH(-_c_sensor_ki)
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
	CALL SUBOPT_0x56
	LD   R26,Z
	CPI  R26,LOW(0xFF)
	BREQ PC+3
	JMP _0x277
	CALL SUBOPT_0x56
	LDI  R26,LOW(5)
	STD  Z+0,R26
_0x277:
	CALL SUBOPT_0x1C
	RJMP _0x26E
; 0000 046F                 case 5 : c_sensor_ka[i]--;if(c_sensor_ka[i] == 255) c_sensor_ka[i] = 5;delay_ms(20);break;
_0x276:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x26E
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_c_sensor_ka)
	SBCI R27,HIGH(-_c_sensor_ka)
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
	CALL SUBOPT_0x57
	LD   R26,Z
	CPI  R26,LOW(0xFF)
	BREQ PC+3
	JMP _0x279
	CALL SUBOPT_0x57
	LDI  R26,LOW(5)
	STD  Z+0,R26
_0x279:
	CALL SUBOPT_0x1C
; 0000 0470             }
_0x26E:
; 0000 0471         }
; 0000 0472         lcd_gotoxy(1,0);
_0x26B:
	CALL SUBOPT_0x58
; 0000 0473         sprintf(tampil, "I:%d ",i+1);
	CALL SUBOPT_0x59
; 0000 0474         lcd_puts(tampil);
	CALL SUBOPT_0x28
; 0000 0475         lcd_gotoxy(6,0);
	CALL SUBOPT_0x5A
; 0000 0476         sprintf(tampil, "D:%d ",c_delay[i]);
	CALL SUBOPT_0x25
	__POINTW1FN _0x0,693
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x53
	LD   R30,Z
	CALL SUBOPT_0x51
; 0000 0477         lcd_puts(tampil);
	CALL SUBOPT_0x28
; 0000 0478         lcd_gotoxy(12,0);
	LDI  R30,LOW(12)
	CALL SUBOPT_0x5B
; 0000 0479         sprintf(tampil, "T:%d ",c_timer[i]);
	CALL SUBOPT_0x25
	__POINTW1FN _0x0,699
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x54
	LD   R30,Z
	CALL SUBOPT_0x51
; 0000 047A         lcd_puts(tampil);
	CALL SUBOPT_0x28
; 0000 047B         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x1A
; 0000 047C         switch(c_aksi[i]){
	CALL SUBOPT_0x55
	LD   R30,Z
	LDI  R31,0
; 0000 047D             case 0:lcd_putsf("A:Lu");break;
	SBIW R30,0
	BREQ PC+3
	JMP _0x27D
	__POINTW2FN _0x0,705
	CALL _lcd_putsf
	RJMP _0x27C
; 0000 047E             case 1:lcd_putsf("A:Ka");break;
_0x27D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x27E
	__POINTW2FN _0x0,710
	CALL _lcd_putsf
	RJMP _0x27C
; 0000 047F             case 2:lcd_putsf("A:Ki");break;
_0x27E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x27F
	__POINTW2FN _0x0,715
	CALL _lcd_putsf
	RJMP _0x27C
; 0000 0480             case 3:lcd_putsf("A:St");break;
_0x27F:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x281
	__POINTW2FN _0x0,720
	CALL _lcd_putsf
	RJMP _0x27C
; 0000 0481             default :
_0x281:
; 0000 0482                 if(c_aksi[i] == 4){c_aksi[i] = 0;}
	CALL SUBOPT_0x55
	LD   R26,Z
	CPI  R26,LOW(0x4)
	BREQ PC+3
	JMP _0x282
	CALL SUBOPT_0x55
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0483                 else{c_aksi[i] = 3;}
	RJMP _0x283
_0x282:
	CALL SUBOPT_0x55
	LDI  R26,LOW(3)
	STD  Z+0,R26
_0x283:
; 0000 0484             break;
; 0000 0485         }
_0x27C:
; 0000 0486         lcd_gotoxy(6,1);
	LDI  R30,LOW(6)
	CALL SUBOPT_0x1A
; 0000 0487         sprintf(tampil, "Ki:%d ",c_sensor_ki[i]);
	CALL SUBOPT_0x25
	__POINTW1FN _0x0,725
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x56
	LD   R30,Z
	CALL SUBOPT_0x51
; 0000 0488         lcd_puts(tampil);
	CALL SUBOPT_0x28
; 0000 0489         lcd_gotoxy(12,1);
	LDI  R30,LOW(12)
	CALL SUBOPT_0x1A
; 0000 048A         sprintf(tampil, "Ka:%d",c_sensor_ka[i]);
	CALL SUBOPT_0x25
	__POINTW1FN _0x0,732
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x57
	LD   R30,Z
	CALL SUBOPT_0x51
; 0000 048B         lcd_puts(tampil);
	CALL SUBOPT_0x28
; 0000 048C         lcd_gotoxy(0,0);lcd_putchar((indeks==0)?0x7E:32);
	CALL SUBOPT_0x18
	CPI  R18,0
	BREQ PC+3
	JMP _0x284
	LDI  R30,LOW(126)
	RJMP _0x285
_0x284:
	LDI  R30,LOW(32)
_0x285:
_0x286:
	CALL SUBOPT_0x5C
; 0000 048D         lcd_gotoxy(5,0);lcd_putchar((indeks==1)?0x7E:32);
	CPI  R18,1
	BREQ PC+3
	JMP _0x287
	LDI  R30,LOW(126)
	RJMP _0x288
_0x287:
	LDI  R30,LOW(32)
_0x288:
_0x289:
	CALL SUBOPT_0x3C
; 0000 048E         lcd_gotoxy(11,0);lcd_putchar((indeks==2)?0x7E:32);
	CALL SUBOPT_0x5B
	CPI  R18,2
	BREQ PC+3
	JMP _0x28A
	LDI  R30,LOW(126)
	RJMP _0x28B
_0x28A:
	LDI  R30,LOW(32)
_0x28B:
_0x28C:
	CALL SUBOPT_0x5D
; 0000 048F         lcd_gotoxy(0,1);lcd_putchar((indeks==3)?0x7E:32);
	CPI  R18,3
	BREQ PC+3
	JMP _0x28D
	LDI  R30,LOW(126)
	RJMP _0x28E
_0x28D:
	LDI  R30,LOW(32)
_0x28E:
_0x28F:
	CALL SUBOPT_0x35
; 0000 0490         lcd_gotoxy(5,1);lcd_putchar((indeks==4)?0x7E:32);
	CPI  R18,4
	BREQ PC+3
	JMP _0x290
	LDI  R30,LOW(126)
	RJMP _0x291
_0x290:
	LDI  R30,LOW(32)
_0x291:
_0x292:
	CALL SUBOPT_0x3C
; 0000 0491         lcd_gotoxy(11,1);lcd_putchar((indeks==5)?0x7E:32);
	CALL SUBOPT_0x1A
	CPI  R18,5
	BREQ PC+3
	JMP _0x293
	LDI  R30,LOW(126)
	RJMP _0x294
_0x293:
	LDI  R30,LOW(32)
_0x294:
_0x295:
	MOV  R26,R30
	CALL _lcd_putchar
; 0000 0492         if(!OK){
	SBIC 0x13,0
	RJMP _0x296
; 0000 0493             while(!OK){
_0x297:
	SBIC 0x13,0
	RJMP _0x299
; 0000 0494                 if(!MENU_ATAS){
	SBIC 0x13,2
	RJMP _0x29A
; 0000 0495                     goto counter_2;
	RJMP _0x29B
; 0000 0496                 }else if(!MENU_BAWAH){
_0x29A:
	SBIC 0x13,3
	RJMP _0x29D
; 0000 0497                     goto counter_3;
	RJMP _0x29E
; 0000 0498                 }
; 0000 0499                 delay_ms(20);
_0x29D:
_0x29C:
	CALL SUBOPT_0x1C
; 0000 049A             }
	RJMP _0x297
_0x299:
; 0000 049B             for(i = 0;i < JML_INDEKS;i++){
	LDI  R16,LOW(0)
_0x2A0:
	CPI  R16,90
	BRLO PC+3
	JMP _0x2A1
; 0000 049C                 e_c_delay[i] = c_delay[i];
	CALL SUBOPT_0x5E
	LD   R30,Z
	CALL SUBOPT_0x4E
; 0000 049D                 e_c_aksi[i] = c_aksi[i];
	CALL SUBOPT_0x5F
	LD   R30,Z
	CALL SUBOPT_0x4E
; 0000 049E                 e_c_sensor_ki[i] = c_sensor_ki[i];
	CALL SUBOPT_0x60
	LD   R30,Z
	CALL SUBOPT_0x4E
; 0000 049F                 e_c_sensor_ka[i] = c_sensor_ka[i];
	CALL SUBOPT_0x61
	LD   R30,Z
	CALL SUBOPT_0x4E
; 0000 04A0                 e_c_timer[i] = c_timer[i];
	CALL SUBOPT_0x62
	LD   R30,Z
	CALL SUBOPT_0x4E
; 0000 04A1                 e_c_cp[i] = c_cp[i];
	CALL SUBOPT_0x63
; 0000 04A2                 e_c_invert[i] = c_invert[i];
	CALL SUBOPT_0x64
; 0000 04A3                 e_c_laju_ki[i] = c_laju_ki[i];
	CALL SUBOPT_0x65
; 0000 04A4                 e_c_laju_ka[i] = c_laju_ka[i];
	CALL SUBOPT_0x66
; 0000 04A5                 e_c_laju[i]=c_laju[i];
	CALL SUBOPT_0x67
; 0000 04A6             }
_0x29F:
	SUBI R16,-1
	RJMP _0x2A0
_0x2A1:
; 0000 04A7             indeks=3;
	LDI  R18,LOW(3)
; 0000 04A8             goto simpan;
	RJMP _0x165
; 0000 04A9         }
; 0000 04AA         if(!BATAL){
_0x296:
	SBIC 0x13,1
	RJMP _0x2A2
; 0000 04AB             while(!BATAL)delay_ms(20);
_0x2A3:
	SBIC 0x13,1
	RJMP _0x2A5
	CALL SUBOPT_0x1C
	RJMP _0x2A3
_0x2A5:
; 0000 04AC indeks=3;
	LDI  R18,LOW(3)
; 0000 04AD             goto menu;
	JMP  _0xFC
; 0000 04AE         }
; 0000 04AF         delay_ms(80);
_0x2A2:
	CALL SUBOPT_0x68
; 0000 04B0     }
	RJMP _0x254
_0x256:
; 0000 04B1 
; 0000 04B2     counter_2:
_0x29B:
; 0000 04B3     while(!OK||!MENU_ATAS||!MENU_BAWAH)delay_ms(20);
_0x2A6:
	SBIS 0x13,0
	RJMP _0x2A9
	SBIS 0x13,2
	RJMP _0x2A9
	SBIS 0x13,3
	RJMP _0x2A9
	RJMP _0x2A8
_0x2A9:
	CALL SUBOPT_0x1C
	RJMP _0x2A6
_0x2A8:
; 0000 04B4 indeks=0;
	LDI  R18,LOW(0)
; 0000 04B5     lcd_clear();
	CALL _lcd_clear
; 0000 04B6     while(1){
_0x2AB:
; 0000 04B7         if(!MENU_ATAS){indeks++;while(!MENU_ATAS)delay_ms(20);if(indeks==5)indeks=0;}
	SBIC 0x13,2
	RJMP _0x2AE
	SUBI R18,-1
_0x2AF:
	SBIC 0x13,2
	RJMP _0x2B1
	CALL SUBOPT_0x1C
	RJMP _0x2AF
_0x2B1:
	CPI  R18,5
	BREQ PC+3
	JMP _0x2B2
	LDI  R18,LOW(0)
_0x2B2:
; 0000 04B8         if(!MENU_BAWAH){indeks--;while(!MENU_BAWAH)delay_ms(20);if(indeks==255)indeks=4;}
_0x2AE:
	SBIC 0x13,3
	RJMP _0x2B3
	SUBI R18,1
_0x2B4:
	SBIC 0x13,3
	RJMP _0x2B6
	CALL SUBOPT_0x1C
	RJMP _0x2B4
_0x2B6:
	CPI  R18,255
	BREQ PC+3
	JMP _0x2B7
	LDI  R18,LOW(4)
_0x2B7:
; 0000 04B9         if(!TAMBAH_NILAI){
_0x2B3:
	SBIC 0x13,4
	RJMP _0x2B8
; 0000 04BA             switch(indeks){
	MOV  R30,R18
	LDI  R31,0
; 0000 04BB                 case 0:i++;if(i==JML_INDEKS)i=0;delay_ms(30);break;
	SBIW R30,0
	BREQ PC+3
	JMP _0x2BC
	SUBI R16,-1
	CPI  R16,90
	BREQ PC+3
	JMP _0x2BD
	LDI  R16,LOW(0)
_0x2BD:
	LDI  R26,LOW(30)
	LDI  R27,0
	CALL _delay_ms
	RJMP _0x2BB
; 0000 04BC                 case 1:c_cp[i]=1;break;
_0x2BC:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2BE
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_c_cp)
	SBCI R31,HIGH(-_c_cp)
	LDI  R26,LOW(1)
	STD  Z+0,R26
	RJMP _0x2BB
; 0000 04BD                 case 2:c_invert[i]=1;break;
_0x2BE:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2BF
	CALL SUBOPT_0x69
	LDI  R26,LOW(1)
	STD  Z+0,R26
	RJMP _0x2BB
; 0000 04BE                 case 3:c_laju_ki[i]++;if(c_laju_ki[i]==0)c_laju_ki[i]=255;break;
_0x2BF:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2C0
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_c_laju_ki)
	SBCI R27,HIGH(-_c_laju_ki)
	CALL SUBOPT_0x52
	SUBI R30,LOW(-_c_laju_ki)
	SBCI R31,HIGH(-_c_laju_ki)
	LD   R30,Z
	CPI  R30,0
	BREQ PC+3
	JMP _0x2C1
	CALL SUBOPT_0x6A
	LDI  R26,LOW(255)
	STD  Z+0,R26
_0x2C1:
	RJMP _0x2BB
; 0000 04BF                 case 4:c_laju_ka[i]++;if(c_laju_ka[i]==0)c_laju_ka[i]=255;break;
_0x2C0:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2BB
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_c_laju_ka)
	SBCI R27,HIGH(-_c_laju_ka)
	CALL SUBOPT_0x52
	SUBI R30,LOW(-_c_laju_ka)
	SBCI R31,HIGH(-_c_laju_ka)
	LD   R30,Z
	CPI  R30,0
	BREQ PC+3
	JMP _0x2C3
	CALL SUBOPT_0x6B
	LDI  R26,LOW(255)
	STD  Z+0,R26
_0x2C3:
; 0000 04C0             }
_0x2BB:
; 0000 04C1         }
; 0000 04C2         if(!KURANG_NILAI){
_0x2B8:
	SBIC 0x13,5
	RJMP _0x2C4
; 0000 04C3             switch(indeks){
	MOV  R30,R18
	LDI  R31,0
; 0000 04C4                 case 0:i--;if(i==255)i=(JML_INDEKS-1);delay_ms(30);break;
	SBIW R30,0
	BREQ PC+3
	JMP _0x2C8
	SUBI R16,1
	CPI  R16,255
	BREQ PC+3
	JMP _0x2C9
	LDI  R16,LOW(89)
_0x2C9:
	LDI  R26,LOW(30)
	LDI  R27,0
	CALL _delay_ms
	RJMP _0x2C7
; 0000 04C5                 case 1:c_cp[i]=(!i)?1:1;break;
_0x2C8:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2CA
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_c_cp)
	SBCI R27,HIGH(-_c_cp)
	CPI  R16,0
	BREQ PC+3
	JMP _0x2CB
	LDI  R30,LOW(1)
	RJMP _0x2CC
_0x2CB:
	LDI  R30,LOW(1)
_0x2CC:
_0x2CD:
	ST   X,R30
	RJMP _0x2C7
; 0000 04C6                 case 2:c_invert[i]=0;break;
_0x2CA:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2CE
	CALL SUBOPT_0x69
	LDI  R26,LOW(0)
	STD  Z+0,R26
	RJMP _0x2C7
; 0000 04C7                 case 3:c_laju_ki[i]--;if(c_laju_ki[i]==0)c_laju_ki[i]=1;break;
_0x2CE:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2CF
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_c_laju_ki)
	SBCI R27,HIGH(-_c_laju_ki)
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
	CALL SUBOPT_0x6A
	LD   R30,Z
	CPI  R30,0
	BREQ PC+3
	JMP _0x2D0
	CALL SUBOPT_0x6A
	LDI  R26,LOW(1)
	STD  Z+0,R26
_0x2D0:
	RJMP _0x2C7
; 0000 04C8                 case 4:c_laju_ka[i]--;if(c_laju_ka[i]==0)c_laju_ka[i]=1;break;
_0x2CF:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2C7
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_c_laju_ka)
	SBCI R27,HIGH(-_c_laju_ka)
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
	CALL SUBOPT_0x6B
	LD   R30,Z
	CPI  R30,0
	BREQ PC+3
	JMP _0x2D2
	CALL SUBOPT_0x6B
	LDI  R26,LOW(1)
	STD  Z+0,R26
_0x2D2:
; 0000 04C9             }
_0x2C7:
; 0000 04CA         }
; 0000 04CB         if(c_laju_ki[i]>maks_PWM)c_laju_ki[i]=1;
_0x2C4:
	CALL SUBOPT_0x6A
	CALL SUBOPT_0x6C
	BRLT PC+3
	JMP _0x2D3
	CALL SUBOPT_0x6A
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0000 04CC         if(c_laju_ka[i]>maks_PWM)c_laju_ka[i]=1;
_0x2D3:
	CALL SUBOPT_0x6B
	CALL SUBOPT_0x6C
	BRLT PC+3
	JMP _0x2D4
	CALL SUBOPT_0x6B
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0000 04CD         lcd_gotoxy(1,0);
_0x2D4:
	CALL SUBOPT_0x58
; 0000 04CE         sprintf(tampil,"I:%d ",i+1);
	CALL SUBOPT_0x59
; 0000 04CF         lcd_puts(tampil);
	CALL SUBOPT_0x28
; 0000 04D0         lcd_gotoxy(6,0);
	CALL SUBOPT_0x5A
; 0000 04D1         lcd_putsf("S:");
	__POINTW2FN _0x0,738
	CALL _lcd_putsf
; 0000 04D2         lcd_gotoxy(8,0);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x5B
; 0000 04D3         switch(c_cp[i]){
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_c_cp)
	SBCI R31,HIGH(-_c_cp)
	LD   R30,Z
	LDI  R31,0
; 0000 04D4             case 0:lcd_putsf("--");break;
	SBIW R30,0
	BREQ PC+3
	JMP _0x2D8
	__POINTW2FN _0x0,741
	CALL _lcd_putsf
	RJMP _0x2D7
; 0000 04D5             case 1:lcd_putsf("CP");break;
_0x2D8:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2D7
	__POINTW2FN _0x0,744
	CALL _lcd_putsf
; 0000 04D6         }
_0x2D7:
; 0000 04D7         lcd_gotoxy(11,0);
	LDI  R30,LOW(11)
	CALL SUBOPT_0x5B
; 0000 04D8         switch(c_invert[i]){
	CALL SUBOPT_0x69
	LD   R30,Z
	LDI  R31,0
; 0000 04D9             case 0:lcd_putsf("NoInv");break;
	SBIW R30,0
	BREQ PC+3
	JMP _0x2DD
	__POINTW2FN _0x0,747
	CALL _lcd_putsf
	RJMP _0x2DC
; 0000 04DA             case 1:lcd_putsf("Invrt");break;
_0x2DD:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2DC
	__POINTW2FN _0x0,753
	CALL _lcd_putsf
; 0000 04DB         }
_0x2DC:
; 0000 04DC         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x1A
; 0000 04DD         sprintf(tampil,"LKi:%d  ",c_laju_ki[i]);
	CALL SUBOPT_0x25
	__POINTW1FN _0x0,759
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x6A
	LD   R30,Z
	CALL SUBOPT_0x51
; 0000 04DE         lcd_puts(tampil);
	CALL SUBOPT_0x28
; 0000 04DF         lcd_gotoxy(9,1);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x1A
; 0000 04E0         sprintf(tampil,"LKa:%d  ",c_laju_ka[i]);
	CALL SUBOPT_0x25
	__POINTW1FN _0x0,768
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x6B
	LD   R30,Z
	CALL SUBOPT_0x51
; 0000 04E1         lcd_puts(tampil);
	CALL SUBOPT_0x28
; 0000 04E2         lcd_gotoxy(0,0);lcd_putchar((indeks==0)?0x7E:32);
	CALL SUBOPT_0x18
	CPI  R18,0
	BREQ PC+3
	JMP _0x2DF
	LDI  R30,LOW(126)
	RJMP _0x2E0
_0x2DF:
	LDI  R30,LOW(32)
_0x2E0:
_0x2E1:
	CALL SUBOPT_0x5C
; 0000 04E3         lcd_gotoxy(5,0);lcd_putchar((indeks==1)?0x7E:32);
	CPI  R18,1
	BREQ PC+3
	JMP _0x2E2
	LDI  R30,LOW(126)
	RJMP _0x2E3
_0x2E2:
	LDI  R30,LOW(32)
_0x2E3:
_0x2E4:
	MOV  R26,R30
	CALL _lcd_putchar
; 0000 04E4         lcd_gotoxy(10,0);lcd_putchar((indeks==2)?0x7E:32);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x5B
	CPI  R18,2
	BREQ PC+3
	JMP _0x2E5
	LDI  R30,LOW(126)
	RJMP _0x2E6
_0x2E5:
	LDI  R30,LOW(32)
_0x2E6:
_0x2E7:
	CALL SUBOPT_0x5D
; 0000 04E5         lcd_gotoxy(0,1);lcd_putchar((indeks==3)?0x7E:32);
	CPI  R18,3
	BREQ PC+3
	JMP _0x2E8
	LDI  R30,LOW(126)
	RJMP _0x2E9
_0x2E8:
	LDI  R30,LOW(32)
_0x2E9:
_0x2EA:
	MOV  R26,R30
	CALL _lcd_putchar
; 0000 04E6         lcd_gotoxy(8,1);lcd_putchar((indeks==4)?0x7E:32);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x1A
	CPI  R18,4
	BREQ PC+3
	JMP _0x2EB
	LDI  R30,LOW(126)
	RJMP _0x2EC
_0x2EB:
	LDI  R30,LOW(32)
_0x2EC:
_0x2ED:
	MOV  R26,R30
	CALL _lcd_putchar
; 0000 04E7         if(!OK){
	SBIC 0x13,0
	RJMP _0x2EE
; 0000 04E8             while(!OK){
_0x2EF:
	SBIC 0x13,0
	RJMP _0x2F1
; 0000 04E9                 if(!MENU_ATAS){
	SBIC 0x13,2
	RJMP _0x2F2
; 0000 04EA                     goto counter_3;
	RJMP _0x29E
; 0000 04EB                 }else if(!MENU_BAWAH){
_0x2F2:
	SBIC 0x13,3
	RJMP _0x2F4
; 0000 04EC                     goto counter_1;
	RJMP _0x144
; 0000 04ED                 }
; 0000 04EE                 delay_ms(20);
_0x2F4:
_0x2F3:
	CALL SUBOPT_0x1C
; 0000 04EF             }
	RJMP _0x2EF
_0x2F1:
; 0000 04F0             for(i = 0;i < JML_INDEKS;i++){
	LDI  R16,LOW(0)
_0x2F6:
	CPI  R16,90
	BRLO PC+3
	JMP _0x2F7
; 0000 04F1                 e_c_delay[i] = c_delay[i];
	CALL SUBOPT_0x5E
	LD   R30,Z
	CALL SUBOPT_0x4E
; 0000 04F2                 e_c_aksi[i] = c_aksi[i];
	CALL SUBOPT_0x5F
	LD   R30,Z
	CALL SUBOPT_0x4E
; 0000 04F3                 e_c_sensor_ki[i] = c_sensor_ki[i];
	CALL SUBOPT_0x60
	LD   R30,Z
	CALL SUBOPT_0x4E
; 0000 04F4                 e_c_sensor_ka[i] = c_sensor_ka[i];
	CALL SUBOPT_0x61
	LD   R30,Z
	CALL SUBOPT_0x4E
; 0000 04F5                 e_c_timer[i] = c_timer[i];
	CALL SUBOPT_0x62
	LD   R30,Z
	CALL SUBOPT_0x4E
; 0000 04F6                 e_c_cp[i] = c_cp[i];
	CALL SUBOPT_0x63
; 0000 04F7                 e_c_invert[i] = c_invert[i];
	CALL SUBOPT_0x64
; 0000 04F8                 e_c_laju_ki[i] = c_laju_ki[i];
	CALL SUBOPT_0x65
; 0000 04F9                 e_c_laju_ka[i] = c_laju_ka[i];
	CALL SUBOPT_0x66
; 0000 04FA                 e_c_laju[i]=c_laju[i];
	CALL SUBOPT_0x67
; 0000 04FB             }
_0x2F5:
	SUBI R16,-1
	RJMP _0x2F6
_0x2F7:
; 0000 04FC             indeks=3;
	LDI  R18,LOW(3)
; 0000 04FD             goto simpan;
	RJMP _0x165
; 0000 04FE         }
; 0000 04FF         if(!BATAL){
_0x2EE:
	SBIC 0x13,1
	RJMP _0x2F8
; 0000 0500             while(!BATAL)delay_ms(20);
_0x2F9:
	SBIC 0x13,1
	RJMP _0x2FB
	CALL SUBOPT_0x1C
	RJMP _0x2F9
_0x2FB:
; 0000 0501 indeks=3;
	LDI  R18,LOW(3)
; 0000 0502             goto menu;
	JMP  _0xFC
; 0000 0503         }
; 0000 0504         delay_ms(80);
_0x2F8:
	CALL SUBOPT_0x68
; 0000 0505     }
	RJMP _0x2AB
_0x2AD:
; 0000 0506 
; 0000 0507     counter_3:
_0x29E:
; 0000 0508     while(!OK||!MENU_ATAS||!MENU_BAWAH)delay_ms(20);
_0x2FC:
	SBIS 0x13,0
	RJMP _0x2FF
	SBIS 0x13,2
	RJMP _0x2FF
	SBIS 0x13,3
	RJMP _0x2FF
	RJMP _0x2FE
_0x2FF:
	CALL SUBOPT_0x1C
	RJMP _0x2FC
_0x2FE:
; 0000 0509 indeks=0;
	LDI  R18,LOW(0)
; 0000 050A     lcd_clear();
	CALL _lcd_clear
; 0000 050B     while(1){
_0x301:
; 0000 050C         if(!MENU_ATAS){indeks++;while(!MENU_ATAS)delay_ms(20);if(indeks==2)indeks=0;}
	SBIC 0x13,2
	RJMP _0x304
	SUBI R18,-1
_0x305:
	SBIC 0x13,2
	RJMP _0x307
	CALL SUBOPT_0x1C
	RJMP _0x305
_0x307:
	CPI  R18,2
	BREQ PC+3
	JMP _0x308
	LDI  R18,LOW(0)
_0x308:
; 0000 050D         if(!MENU_BAWAH){indeks--;while(!MENU_BAWAH)delay_ms(20);if(indeks==255)indeks=1;}
_0x304:
	SBIC 0x13,3
	RJMP _0x309
	SUBI R18,1
_0x30A:
	SBIC 0x13,3
	RJMP _0x30C
	CALL SUBOPT_0x1C
	RJMP _0x30A
_0x30C:
	CPI  R18,255
	BREQ PC+3
	JMP _0x30D
	LDI  R18,LOW(1)
_0x30D:
; 0000 050E         if(!TAMBAH_NILAI){
_0x309:
	SBIC 0x13,4
	RJMP _0x30E
; 0000 050F             switch(indeks){
	MOV  R30,R18
	LDI  R31,0
; 0000 0510                 case 0:i++;if(i==JML_INDEKS)i=0;break;
	SBIW R30,0
	BREQ PC+3
	JMP _0x312
	SUBI R16,-1
	CPI  R16,90
	BREQ PC+3
	JMP _0x313
	LDI  R16,LOW(0)
_0x313:
	RJMP _0x311
; 0000 0511                 case 1:c_laju[i]++;if(c_laju[i]==0)c_laju[i]=255;break;
_0x312:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x311
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_c_laju)
	SBCI R27,HIGH(-_c_laju)
	CALL SUBOPT_0x52
	SUBI R30,LOW(-_c_laju)
	SBCI R31,HIGH(-_c_laju)
	LD   R30,Z
	CPI  R30,0
	BREQ PC+3
	JMP _0x315
	CALL SUBOPT_0x6D
	LDI  R26,LOW(255)
	STD  Z+0,R26
_0x315:
; 0000 0512             }
_0x311:
; 0000 0513         }
; 0000 0514         if(!KURANG_NILAI){
_0x30E:
	SBIC 0x13,5
	RJMP _0x316
; 0000 0515             switch(indeks){
	MOV  R30,R18
	LDI  R31,0
; 0000 0516                 case 0:i--;if(i==255)i=(JML_INDEKS-1);break;
	SBIW R30,0
	BREQ PC+3
	JMP _0x31A
	SUBI R16,1
	CPI  R16,255
	BREQ PC+3
	JMP _0x31B
	LDI  R16,LOW(89)
_0x31B:
	RJMP _0x319
; 0000 0517                 case 1:c_laju[i]--;if(c_laju[i]==0)c_laju[i]=1;break;
_0x31A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x319
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_c_laju)
	SBCI R27,HIGH(-_c_laju)
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
	CALL SUBOPT_0x6D
	LD   R30,Z
	CPI  R30,0
	BREQ PC+3
	JMP _0x31D
	CALL SUBOPT_0x6D
	LDI  R26,LOW(1)
	STD  Z+0,R26
_0x31D:
; 0000 0518             }
_0x319:
; 0000 0519         }
; 0000 051A         if(c_laju[i]>maks_PWM)c_laju[i]=1;
_0x316:
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x6C
	BRLT PC+3
	JMP _0x31E
	CALL SUBOPT_0x6D
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0000 051B         lcd_gotoxy(1,0);
_0x31E:
	CALL SUBOPT_0x58
; 0000 051C         sprintf(tampil,"I:%d ",i+1);
	CALL SUBOPT_0x59
; 0000 051D         lcd_puts(tampil);
	CALL SUBOPT_0x28
; 0000 051E         lcd_gotoxy(6,0);
	CALL SUBOPT_0x5A
; 0000 051F         sprintf(tampil,"L:%d  ",c_laju[i]);
	CALL SUBOPT_0x25
	__POINTW1FN _0x0,777
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x6D
	LD   R30,Z
	CALL SUBOPT_0x51
; 0000 0520         lcd_puts(tampil);
	CALL SUBOPT_0x28
; 0000 0521         lcd_gotoxy(0,0);lcd_putchar((indeks==0)?0x7E:32);
	CALL SUBOPT_0x18
	CPI  R18,0
	BREQ PC+3
	JMP _0x31F
	LDI  R30,LOW(126)
	RJMP _0x320
_0x31F:
	LDI  R30,LOW(32)
_0x320:
_0x321:
	CALL SUBOPT_0x5C
; 0000 0522         lcd_gotoxy(5,0);lcd_putchar((indeks==1)?0x7E:32);
	CPI  R18,1
	BREQ PC+3
	JMP _0x322
	LDI  R30,LOW(126)
	RJMP _0x323
_0x322:
	LDI  R30,LOW(32)
_0x323:
_0x324:
	MOV  R26,R30
	CALL _lcd_putchar
; 0000 0523         if(!OK){
	SBIC 0x13,0
	RJMP _0x325
; 0000 0524             while(!OK){
_0x326:
	SBIC 0x13,0
	RJMP _0x328
; 0000 0525                 if(!MENU_ATAS){
	SBIC 0x13,2
	RJMP _0x329
; 0000 0526                     goto counter_1;
	RJMP _0x144
; 0000 0527                 }else if(!MENU_BAWAH){
_0x329:
	SBIC 0x13,3
	RJMP _0x32B
; 0000 0528                     goto counter_2;
	RJMP _0x29B
; 0000 0529                 }
; 0000 052A                 delay_ms(20);
_0x32B:
_0x32A:
	CALL SUBOPT_0x1C
; 0000 052B             }
	RJMP _0x326
_0x328:
; 0000 052C             for(i = 0;i < JML_INDEKS;i++){
	LDI  R16,LOW(0)
_0x32D:
	CPI  R16,90
	BRLO PC+3
	JMP _0x32E
; 0000 052D                 e_c_delay[i] = c_delay[i];
	CALL SUBOPT_0x5E
	LD   R30,Z
	CALL SUBOPT_0x4E
; 0000 052E                 e_c_aksi[i] = c_aksi[i];
	CALL SUBOPT_0x5F
	LD   R30,Z
	CALL SUBOPT_0x4E
; 0000 052F                 e_c_sensor_ki[i] = c_sensor_ki[i];
	CALL SUBOPT_0x60
	LD   R30,Z
	CALL SUBOPT_0x4E
; 0000 0530                 e_c_sensor_ka[i] = c_sensor_ka[i];
	CALL SUBOPT_0x61
	LD   R30,Z
	CALL SUBOPT_0x4E
; 0000 0531                 e_c_timer[i] = c_timer[i];
	CALL SUBOPT_0x62
	LD   R30,Z
	CALL SUBOPT_0x4E
; 0000 0532                 e_c_cp[i] = c_cp[i];
	CALL SUBOPT_0x63
; 0000 0533                 e_c_invert[i] = c_invert[i];
	CALL SUBOPT_0x64
; 0000 0534                 e_c_laju_ki[i] = c_laju_ki[i];
	CALL SUBOPT_0x65
; 0000 0535                 e_c_laju_ka[i] = c_laju_ka[i];
	CALL SUBOPT_0x66
; 0000 0536                 e_c_laju[i]=c_laju[i];
	CALL SUBOPT_0x67
; 0000 0537             }
_0x32C:
	SUBI R16,-1
	RJMP _0x32D
_0x32E:
; 0000 0538             indeks=3;
	LDI  R18,LOW(3)
; 0000 0539             goto simpan;
	RJMP _0x165
; 0000 053A         }
; 0000 053B         if(!BATAL){
_0x325:
	SBIC 0x13,1
	RJMP _0x32F
; 0000 053C             while(!BATAL)delay_ms(20);
_0x330:
	SBIC 0x13,1
	RJMP _0x332
	CALL SUBOPT_0x1C
	RJMP _0x330
_0x332:
; 0000 053D indeks=3;
	LDI  R18,LOW(3)
; 0000 053E             goto menu;
	JMP  _0xFC
; 0000 053F         }
; 0000 0540         delay_ms(80);
_0x32F:
	CALL SUBOPT_0x68
; 0000 0541     }
	RJMP _0x301
_0x303:
; 0000 0542 
; 0000 0543     //mastiin klau udah di simpen
; 0000 0544     simpan:
_0x165:
; 0000 0545     lcd_clear();
	CALL SUBOPT_0x1F
; 0000 0546     lcd_gotoxy(0,0);
; 0000 0547     lcd_putsf("Simpan...       ");
	__POINTW2FN _0x0,784
	CALL _lcd_putsf
; 0000 0548     for(i=0;i<16;i++){
	LDI  R16,LOW(0)
_0x334:
	CPI  R16,16
	BRLO PC+3
	JMP _0x335
; 0000 0549         lcd_gotoxy(i,1);
	ST   -Y,R16
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 054A         lcd_putchar(0xFF);
	LDI  R26,LOW(255)
	CALL _lcd_putchar
; 0000 054B         delay_ms(62);
	LDI  R26,LOW(62)
	LDI  R27,0
	CALL _delay_ms
; 0000 054C     }
_0x333:
	SUBI R16,-1
	RJMP _0x334
_0x335:
; 0000 054D     if(aktifasi_serial){if(!strcmp(buffer,"a"))goto siaga;}
	LDS  R30,_aktifasi_serial
	CPI  R30,0
	BRNE PC+3
	JMP _0x336
	CALL SUBOPT_0x23
	__POINTW2MN _0xBC,87
	CALL _strcmp
	CPI  R30,0
	BREQ PC+3
	JMP _0x337
	JMP  _0xA7
_0x337:
; 0000 054E     goto menu;
_0x336:
	JMP  _0xFC
; 0000 054F 
; 0000 0550     keluar:
_0x105:
; 0000 0551     indeks=0;
	LDI  R18,LOW(0)
; 0000 0552     for(i=0;i<JML_INDEKS;i++){
	LDI  R16,LOW(0)
_0x339:
	CPI  R16,90
	BRLO PC+3
	JMP _0x33A
; 0000 0553         if(indeks==indeks_cp)break;
	MOVW R30,R20
	MOV  R26,R18
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ PC+3
	JMP _0x33B
	RJMP _0x33A
; 0000 0554         if(c_cp[i])indeks++;
_0x33B:
	CALL SUBOPT_0x20
	BRNE PC+3
	JMP _0x33C
	SUBI R18,-1
; 0000 0555     }
_0x33C:
_0x338:
	SUBI R16,-1
	RJMP _0x339
_0x33A:
; 0000 0556     c_i=i;
	STS  _c_i,R16
; 0000 0557     kelajuan_normal = kelajuan;
	LDS  R30,_kelajuan
	STS  _kelajuan_normal,R30
; 0000 0558     lcd_clear();
	CALL _lcd_clear
; 0000 0559     LCD = 0;
	CBI  0x18,3
; 0000 055A     if(c_i)goto mulai;
	LDS  R30,_c_i
	CPI  R30,0
	BRNE PC+3
	JMP _0x33F
	RJMP _0x340
; 0000 055B     atur_pwm(kelajuan+k_stabilisator,kelajuan);
_0x33F:
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x3B
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x3B
	CALL _atur_pwm
; 0000 055C     delay_ms((!delay_awal)?1:delay_awal*10);
	LDS  R30,_delay_awal
	LDI  R31,0
	SBIW R30,0
	BREQ PC+3
	JMP _0x341
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x342
_0x341:
	LDS  R26,_delay_awal
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
_0x342:
_0x343:
	MOVW R26,R30
	CALL _delay_ms
; 0000 055D     mulai:
_0x340:
; 0000 055E     if(!c_i||!mode){cacah=0;detik=0;TIMSK=0x01;}//Ditaruh di akhir karena sifatnya interrupt
	LDS  R30,_c_i
	CPI  R30,0
	BRNE PC+3
	JMP _0x345
	LDS  R30,_mode
	CPI  R30,0
	BRNE PC+3
	JMP _0x345
	RJMP _0x344
_0x345:
	CALL SUBOPT_0x2
	CALL SUBOPT_0x48
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 055F }
_0x344:
	CALL __LOADLOCR6
	ADIW R28,10
	RET
; .FEND

	.DSEG
_0xBC:
	.BYTE 0x59
;//=====================================================================================
;void  baca_bit_sensor(){
; 0000 0561 void  baca_bit_sensor(){

	.CSEG
_baca_bit_sensor:
; .FSTART _baca_bit_sensor
; 0000 0562     unsigned char i;
; 0000 0563     sensor=0;
	ST   -Y,R17
;	i -> R17
	LDI  R30,LOW(0)
	STS  _sensor,R30
	STS  _sensor+1,R30
; 0000 0564     TR_1 = 1; TR_2 = 0;
	CALL SUBOPT_0xE
; 0000 0565     delay_us(150);
; 0000 0566     for(i = 0;i < 7;i++){
_0x34C:
	CPI  R17,7
	BRLO PC+3
	JMP _0x34D
; 0000 0567         if(read_adc(7-i) > n_tengah[i]){sensor |= (1<<i);}
	LDI  R30,LOW(7)
	SUB  R30,R17
	MOV  R26,R30
	CALL _read_adc
	MOV  R26,R30
	CALL SUBOPT_0xA
	LD   R30,Z
	CP   R30,R26
	BRLO PC+3
	JMP _0x34E
	CALL SUBOPT_0x6E
; 0000 0568     }
_0x34E:
_0x34B:
	SUBI R17,-1
	RJMP _0x34C
_0x34D:
; 0000 0569     TR_1 = 0; TR_2 = 1;
	CALL SUBOPT_0x17
; 0000 056A     delay_us(150);
; 0000 056B     for(i = 7;i < 14;i++){
_0x354:
	CPI  R17,14
	BRLO PC+3
	JMP _0x355
; 0000 056C         if(read_adc(i-6) > n_tengah[i]){sensor |= (1<<i);}
	MOV  R26,R17
	SUBI R26,LOW(6)
	CALL _read_adc
	MOV  R26,R30
	CALL SUBOPT_0xA
	LD   R30,Z
	CP   R30,R26
	BRLO PC+3
	JMP _0x356
	CALL SUBOPT_0x6E
; 0000 056D     }
_0x356:
_0x353:
	SUBI R17,-1
	RJMP _0x354
_0x355:
; 0000 056E     if(flag_invert)sensor=~sensor;
	SBRS R2,3
	RJMP _0x357
	CALL SUBOPT_0x6F
	COM  R30
	COM  R31
	STS  _sensor,R30
	STS  _sensor+1,R31
; 0000 056F }
_0x357:
	LD   R17,Y+
	RET
; .FEND
;//=====================================================================================
;void kendali_PID(){
; 0000 0571 void kendali_PID(){
_kendali_PID:
; .FSTART _kendali_PID
; 0000 0572     baca_bit_sensor();
	CALL _baca_bit_sensor
; 0000 0573     switch(sensor){
	CALL SUBOPT_0x6F
; 0000 0574         //=================Garis Hitam=================
; 0000 0575         case 0b00000000000001 :                         error = 13;break;
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x35B
	CALL SUBOPT_0x70
	RJMP _0x35A
; 0000 0576         case 0b00000000000011 : case 0b00000000000111 : error = 12;break;
_0x35B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x35C
	RJMP _0x35D
_0x35C:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x35E
_0x35D:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL SUBOPT_0x71
	RJMP _0x35A
; 0000 0577         case 0b00000000000010 :                         error = 11;break;
_0x35E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x35F
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CALL SUBOPT_0x71
	RJMP _0x35A
; 0000 0578         case 0b00000000000110 : case 0b00000000001110 : error = 10;break;
_0x35F:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x360
	RJMP _0x361
_0x360:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x362
_0x361:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x71
	RJMP _0x35A
; 0000 0579         case 0b00000000000100 :                         error = 9;break;
_0x362:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x363
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CALL SUBOPT_0x71
	RJMP _0x35A
; 0000 057A         case 0b00000000001100 : case 0b00000000011100 : error = 8;break;
_0x363:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x364
	RJMP _0x365
_0x364:
	CPI  R30,LOW(0x1C)
	LDI  R26,HIGH(0x1C)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x366
_0x365:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x71
	RJMP _0x35A
; 0000 057B         case 0b00000000001000 :                         error = 7;break;
_0x366:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x367
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x71
	RJMP _0x35A
; 0000 057C         case 0b00000000011000 : case 0b00000000111000 : error = 6;break;
_0x367:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x368
	RJMP _0x369
_0x368:
	CPI  R30,LOW(0x38)
	LDI  R26,HIGH(0x38)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x36A
_0x369:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL SUBOPT_0x71
	RJMP _0x35A
; 0000 057D         case 0b00000000010000 :                         error = 5;break;
_0x36A:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x36B
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x71
	RJMP _0x35A
; 0000 057E         case 0b00000000110000 : case 0000000001110000 : error = 4;break;
_0x36B:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x36C
	RJMP _0x36D
_0x36C:
	CPI  R30,LOW(0x49000)
	LDI  R26,HIGH(0x49000)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x36E
_0x36D:
	CALL SUBOPT_0x72
	RJMP _0x35A
; 0000 057F         case 0b00000000100000 :                         error = 3;break;
_0x36E:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x36F
	CALL SUBOPT_0x73
	RJMP _0x35A
; 0000 0580         case 0b00000001100000 : case 0b00000011100000 : error = 2;break;
_0x36F:
	CPI  R30,LOW(0x60)
	LDI  R26,HIGH(0x60)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x370
	RJMP _0x371
_0x370:
	CPI  R30,LOW(0xE0)
	LDI  R26,HIGH(0xE0)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x372
_0x371:
	CALL SUBOPT_0x74
	RJMP _0x35A
; 0000 0581         case 0b00000001000000 :                         error = 1;break;
_0x372:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x373
	CALL SUBOPT_0x75
	RJMP _0x35A
; 0000 0582         case 0b00000011000000 : case 0b00000111100000 : error = 0;break;
_0x373:
	CPI  R30,LOW(0xC0)
	LDI  R26,HIGH(0xC0)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x374
	RJMP _0x375
_0x374:
	CPI  R30,LOW(0x1E0)
	LDI  R26,HIGH(0x1E0)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x376
_0x375:
	CALL SUBOPT_0x76
	RJMP _0x35A
; 0000 0583         case 0b00000010000000 :                         error = -1;break;
_0x376:
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x377
	CALL SUBOPT_0x77
	RJMP _0x35A
; 0000 0584         case 0b00000110000000 : case 0b00000111000000 : error = -2;break;
_0x377:
	CPI  R30,LOW(0x180)
	LDI  R26,HIGH(0x180)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x378
	RJMP _0x379
_0x378:
	CPI  R30,LOW(0x1C0)
	LDI  R26,HIGH(0x1C0)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x37A
_0x379:
	CALL SUBOPT_0x78
	RJMP _0x35A
; 0000 0585         case 0b00000100000000 :                         error = -3;break;
_0x37A:
	CPI  R30,LOW(0x100)
	LDI  R26,HIGH(0x100)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x37B
	CALL SUBOPT_0x79
	RJMP _0x35A
; 0000 0586         case 0b00001100000000 : case 0b00001110000000 : error = -4;break;
_0x37B:
	CPI  R30,LOW(0x300)
	LDI  R26,HIGH(0x300)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x37C
	RJMP _0x37D
_0x37C:
	CPI  R30,LOW(0x380)
	LDI  R26,HIGH(0x380)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x37E
_0x37D:
	CALL SUBOPT_0x7A
	RJMP _0x35A
; 0000 0587         case 0b00001000000000 :                         error = -5;break;
_0x37E:
	CPI  R30,LOW(0x200)
	LDI  R26,HIGH(0x200)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x37F
	LDI  R30,LOW(65531)
	LDI  R31,HIGH(65531)
	CALL SUBOPT_0x71
	RJMP _0x35A
; 0000 0588         case 0b00011000000000 : case 0b00011100000000 : error = -6;break;
_0x37F:
	CPI  R30,LOW(0x600)
	LDI  R26,HIGH(0x600)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x380
	RJMP _0x381
_0x380:
	CPI  R30,LOW(0x700)
	LDI  R26,HIGH(0x700)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x382
_0x381:
	LDI  R30,LOW(65530)
	LDI  R31,HIGH(65530)
	CALL SUBOPT_0x71
	RJMP _0x35A
; 0000 0589         case 0b00010000000000 :                         error = -7;break;
_0x382:
	CPI  R30,LOW(0x400)
	LDI  R26,HIGH(0x400)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x383
	LDI  R30,LOW(65529)
	LDI  R31,HIGH(65529)
	CALL SUBOPT_0x71
	RJMP _0x35A
; 0000 058A         case 0b00110000000000 : case 0b00111000000000 : error = -8;break;
_0x383:
	CPI  R30,LOW(0xC00)
	LDI  R26,HIGH(0xC00)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x384
	RJMP _0x385
_0x384:
	CPI  R30,LOW(0xE00)
	LDI  R26,HIGH(0xE00)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x386
_0x385:
	LDI  R30,LOW(65528)
	LDI  R31,HIGH(65528)
	CALL SUBOPT_0x71
	RJMP _0x35A
; 0000 058B         case 0b00100000000000 :                         error = -9;break;
_0x386:
	CPI  R30,LOW(0x800)
	LDI  R26,HIGH(0x800)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x387
	LDI  R30,LOW(65527)
	LDI  R31,HIGH(65527)
	CALL SUBOPT_0x71
	RJMP _0x35A
; 0000 058C         case 0b01100000000000 : case 0b01110000000000 : error = -10;break;
_0x387:
	CPI  R30,LOW(0x1800)
	LDI  R26,HIGH(0x1800)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x388
	RJMP _0x389
_0x388:
	CPI  R30,LOW(0x1C00)
	LDI  R26,HIGH(0x1C00)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x38A
_0x389:
	LDI  R30,LOW(65526)
	LDI  R31,HIGH(65526)
	CALL SUBOPT_0x71
	RJMP _0x35A
; 0000 058D         case 0b01000000000000 :                         error = -11;break;
_0x38A:
	CPI  R30,LOW(0x1000)
	LDI  R26,HIGH(0x1000)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x38B
	LDI  R30,LOW(65525)
	LDI  R31,HIGH(65525)
	CALL SUBOPT_0x71
	RJMP _0x35A
; 0000 058E         case 0b11000000000000 : case 0b11100000000000 : error = -12;break;
_0x38B:
	CPI  R30,LOW(0x3000)
	LDI  R26,HIGH(0x3000)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x38C
	RJMP _0x38D
_0x38C:
	CPI  R30,LOW(0x3800)
	LDI  R26,HIGH(0x3800)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x38E
_0x38D:
	LDI  R30,LOW(65524)
	LDI  R31,HIGH(65524)
	CALL SUBOPT_0x71
	RJMP _0x35A
; 0000 058F         case 0b10000000000000 :                         error = -13;break;
_0x38E:
	CPI  R30,LOW(0x2000)
	LDI  R26,HIGH(0x2000)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x38F
	LDI  R30,LOW(65523)
	LDI  R31,HIGH(65523)
	CALL SUBOPT_0x71
	RJMP _0x35A
; 0000 0590         //================Putih Semua==================
; 0000 0591         case 0b00000000000000 :
_0x38F:
	SBIW R30,0
	BREQ PC+3
	JMP _0x390
; 0000 0592         if(!mode){
	LDS  R30,_mode
	CPI  R30,0
	BREQ PC+3
	JMP _0x391
; 0000 0593             if(error>2)error = 13;
	LDS  R26,_error
	LDS  R27,_error+1
	SBIW R26,3
	BRGE PC+3
	JMP _0x392
	CALL SUBOPT_0x70
; 0000 0594             else if(error<-2)error = -13;
	RJMP _0x393
_0x392:
	LDS  R26,_error
	LDS  R27,_error+1
	CPI  R26,LOW(0xFFFE)
	LDI  R30,HIGH(0xFFFE)
	CPC  R27,R30
	BRLT PC+3
	JMP _0x394
	LDI  R30,LOW(65523)
	LDI  R31,HIGH(65523)
	CALL SUBOPT_0x71
; 0000 0595             else error = 0;
	RJMP _0x395
_0x394:
	CALL SUBOPT_0x76
; 0000 0596         }
_0x395:
_0x393:
; 0000 0597         break;
_0x391:
	RJMP _0x35A
; 0000 0598         //==================Dua garis==================
; 0000 0599         case 0b00000000110011 : case 0b00000000010011 : case 0b00000000001001 : error=5;break;
_0x390:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x396
	RJMP _0x397
_0x396:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x398
_0x397:
	RJMP _0x399
_0x398:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x39A
_0x399:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x71
	RJMP _0x35A
; 0000 059A         case 0b00000001100110 : case 0b00000000100110 : case 0b00000000110010 : error=4;break;
_0x39A:
	CPI  R30,LOW(0x66)
	LDI  R26,HIGH(0x66)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x39B
	RJMP _0x39C
_0x39B:
	CPI  R30,LOW(0x26)
	LDI  R26,HIGH(0x26)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x39D
_0x39C:
	RJMP _0x39E
_0x39D:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x39F
_0x39E:
	CALL SUBOPT_0x72
	RJMP _0x35A
; 0000 059B         case 0b00000001001100 : case 0b00000001101100 : case 0b00000001100100 : error=3;break;
_0x39F:
	CPI  R30,LOW(0x4C)
	LDI  R26,HIGH(0x4C)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3A0
	RJMP _0x3A1
_0x3A0:
	CPI  R30,LOW(0x6C)
	LDI  R26,HIGH(0x6C)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3A2
_0x3A1:
	RJMP _0x3A3
_0x3A2:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3A4
_0x3A3:
	CALL SUBOPT_0x73
	RJMP _0x35A
; 0000 059C         case 0b00000010011000 : case 0b00000001001000 : error=2;break;
_0x3A4:
	CPI  R30,LOW(0x98)
	LDI  R26,HIGH(0x98)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3A5
	RJMP _0x3A6
_0x3A5:
	CPI  R30,LOW(0x48)
	LDI  R26,HIGH(0x48)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3A7
_0x3A6:
	CALL SUBOPT_0x74
	RJMP _0x35A
; 0000 059D         case 0b00000100110000 : case 0b00000110110000 : case 0b00000110010000 : case 0b00000010010000 : error=1;break;
_0x3A7:
	CPI  R30,LOW(0x130)
	LDI  R26,HIGH(0x130)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3A8
	RJMP _0x3A9
_0x3A8:
	CPI  R30,LOW(0x1B0)
	LDI  R26,HIGH(0x1B0)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3AA
_0x3A9:
	RJMP _0x3AB
_0x3AA:
	CPI  R30,LOW(0x190)
	LDI  R26,HIGH(0x190)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3AC
_0x3AB:
	RJMP _0x3AD
_0x3AC:
	CPI  R30,LOW(0x90)
	LDI  R26,HIGH(0x90)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3AE
_0x3AD:
	CALL SUBOPT_0x75
	RJMP _0x35A
; 0000 059E         case 0b00000100100000 : case 0b00001100110000 :  error=0;break;
_0x3AE:
	CPI  R30,LOW(0x120)
	LDI  R26,HIGH(0x120)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3AF
	RJMP _0x3B0
_0x3AF:
	CPI  R30,LOW(0x330)
	LDI  R26,HIGH(0x330)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3B1
_0x3B0:
	CALL SUBOPT_0x76
	RJMP _0x35A
; 0000 059F         case 0b00001100100000 : case 0b00001101100000 : case 0b00001001100000 : case 0b00001001000000 : error=-1;break;
_0x3B1:
	CPI  R30,LOW(0x320)
	LDI  R26,HIGH(0x320)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3B2
	RJMP _0x3B3
_0x3B2:
	CPI  R30,LOW(0x360)
	LDI  R26,HIGH(0x360)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3B4
_0x3B3:
	RJMP _0x3B5
_0x3B4:
	CPI  R30,LOW(0x260)
	LDI  R26,HIGH(0x260)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3B6
_0x3B5:
	RJMP _0x3B7
_0x3B6:
	CPI  R30,LOW(0x240)
	LDI  R26,HIGH(0x240)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3B8
_0x3B7:
	CALL SUBOPT_0x77
	RJMP _0x35A
; 0000 05A0         case 0b00011001000000 : case 0b00010010000000 : error=-2;break;
_0x3B8:
	CPI  R30,LOW(0x640)
	LDI  R26,HIGH(0x640)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3B9
	RJMP _0x3BA
_0x3B9:
	CPI  R30,LOW(0x480)
	LDI  R26,HIGH(0x480)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3BB
_0x3BA:
	CALL SUBOPT_0x78
	RJMP _0x35A
; 0000 05A1         case 0b00110010000000 : case 0b00110110000000 : case 0b00100110000000 : error=-3;break;
_0x3BB:
	CPI  R30,LOW(0xC80)
	LDI  R26,HIGH(0xC80)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3BC
	RJMP _0x3BD
_0x3BC:
	CPI  R30,LOW(0xD80)
	LDI  R26,HIGH(0xD80)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3BE
_0x3BD:
	RJMP _0x3BF
_0x3BE:
	CPI  R30,LOW(0x980)
	LDI  R26,HIGH(0x980)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3C0
_0x3BF:
	CALL SUBOPT_0x79
	RJMP _0x35A
; 0000 05A2         case 0b01100110000000 : case 0b01100100000000 : case 0b01001100000000 : error=-4;break;
_0x3C0:
	CPI  R30,LOW(0x1980)
	LDI  R26,HIGH(0x1980)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3C1
	RJMP _0x3C2
_0x3C1:
	CPI  R30,LOW(0x1900)
	LDI  R26,HIGH(0x1900)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3C3
_0x3C2:
	RJMP _0x3C4
_0x3C3:
	CPI  R30,LOW(0x1300)
	LDI  R26,HIGH(0x1300)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3C5
_0x3C4:
	CALL SUBOPT_0x7A
	RJMP _0x35A
; 0000 05A3         case 0b11001100000000 : case 0b11001000000000 : case 0b10010000000000 : error=-5;break;
_0x3C5:
	CPI  R30,LOW(0x3300)
	LDI  R26,HIGH(0x3300)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3C6
	RJMP _0x3C7
_0x3C6:
	CPI  R30,LOW(0x3200)
	LDI  R26,HIGH(0x3200)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3C8
_0x3C7:
	RJMP _0x3C9
_0x3C8:
	CPI  R30,LOW(0x2400)
	LDI  R26,HIGH(0x2400)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3CA
_0x3C9:
	LDI  R30,LOW(65531)
	LDI  R31,HIGH(65531)
	CALL SUBOPT_0x71
	RJMP _0x35A
; 0000 05A4         //=============Hitam Samping==================
; 0000 05A5         case 0b0000000000001111 : error = 4;break;
_0x3CA:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3CB
	CALL SUBOPT_0x72
	RJMP _0x35A
; 0000 05A6         case 0b0000000000011111 : error = 3;break;
_0x3CB:
	CPI  R30,LOW(0x1F)
	LDI  R26,HIGH(0x1F)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3CC
	CALL SUBOPT_0x73
	RJMP _0x35A
; 0000 05A7         case 0b0000000000111111 : error = 2;break;
_0x3CC:
	CPI  R30,LOW(0x3F)
	LDI  R26,HIGH(0x3F)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3CD
	CALL SUBOPT_0x74
	RJMP _0x35A
; 0000 05A8         case 0b0000000001111111 : error = 1;break;
_0x3CD:
	CPI  R30,LOW(0x7F)
	LDI  R26,HIGH(0x7F)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3CE
	CALL SUBOPT_0x75
	RJMP _0x35A
; 0000 05A9         case 0b1111111100000000 : case 0b0000000011111111 : error = 0;break;
_0x3CE:
	CPI  R30,LOW(0xFF00)
	LDI  R26,HIGH(0xFF00)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3CF
	RJMP _0x3D0
_0x3CF:
	CPI  R30,LOW(0xFF)
	LDI  R26,HIGH(0xFF)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3D1
_0x3D0:
	CALL SUBOPT_0x76
	RJMP _0x35A
; 0000 05AA         case 0b1111111000000000 : error = -1;break;
_0x3D1:
	CPI  R30,LOW(0xFE00)
	LDI  R26,HIGH(0xFE00)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3D2
	CALL SUBOPT_0x77
	RJMP _0x35A
; 0000 05AB         case 0b1111110000000000 : error = -2;break;
_0x3D2:
	CPI  R30,LOW(0xFC00)
	LDI  R26,HIGH(0xFC00)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3D3
	CALL SUBOPT_0x78
	RJMP _0x35A
; 0000 05AC         case 0b1111100000000000 : error = -3;break;
_0x3D3:
	CPI  R30,LOW(0xF800)
	LDI  R26,HIGH(0xF800)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3D4
	CALL SUBOPT_0x79
	RJMP _0x35A
; 0000 05AD         case 0b1111000000000000 : error = -4;break;
_0x3D4:
	CPI  R30,LOW(0xF000)
	LDI  R26,HIGH(0xF000)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3D6
	CALL SUBOPT_0x7A
	RJMP _0x35A
; 0000 05AE         //============================================
; 0000 05AF         default :break;
_0x3D6:
; 0000 05B0     }
_0x35A:
; 0000 05B1 
; 0000 05B2     if(mode){
	LDS  R30,_mode
	CPI  R30,0
	BRNE PC+3
	JMP _0x3D7
; 0000 05B3         if(timer_aktif&&(detik*1000+cacah)>=target_timer){
	SBRS R2,1
	RJMP _0x3D9
	CALL SUBOPT_0x7B
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,_target_timer
	LDS  R31,_target_timer+1
	CP   R26,R30
	CPC  R27,R31
	BRSH PC+3
	JMP _0x3D9
	RJMP _0x3DA
_0x3D9:
	RJMP _0x3D8
_0x3DA:
; 0000 05B4             timer_aktif=0;
	CLT
	BLD  R2,1
; 0000 05B5             kelajuan = kelajuan_normal;
	LDS  R30,_kelajuan_normal
	CALL SUBOPT_0x7
; 0000 05B6             c_i++;
	CALL SUBOPT_0x7C
; 0000 05B7             if(c_i>=JML_INDEKS){
	BRSH PC+3
	JMP _0x3DB
; 0000 05B8                 c_i=(JML_INDEKS-1);
	LDI  R30,LOW(89)
	STS  _c_i,R30
; 0000 05B9                 flag_berhenti=1;
	SET
	BLD  R2,2
; 0000 05BA             }
; 0000 05BB         }
_0x3DB:
; 0000 05BC         else if(timer_aktif)goto lewat;
	RJMP _0x3DC
_0x3D8:
	SBRS R2,1
	RJMP _0x3DD
	RJMP _0x3DE
; 0000 05BD         sen_dep = (sensor&0b00000111100000)?1:(c_sensor_ki[c_i]&&c_sensor_ka[c_i])?1:!(c_sensor_ki[c_i]|c_sensor_ka[c_i] ...
_0x3DD:
_0x3DC:
	CALL SUBOPT_0x6F
	ANDI R30,LOW(0x1E0)
	ANDI R31,HIGH(0x1E0)
	SBIW R30,0
	BRNE PC+3
	JMP _0x3DF
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x3E0
_0x3DF:
	CALL SUBOPT_0x7D
	LD   R30,Z
	LDI  R31,0
	SBIW R30,0
	BRNE PC+3
	JMP _0x3E2
	CALL SUBOPT_0x7E
	SBIW R30,0
	BRNE PC+3
	JMP _0x3E2
	RJMP _0x3E3
_0x3E2:
	RJMP _0x3E4
_0x3E3:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x3E5
_0x3E4:
	CALL SUBOPT_0x7D
	LD   R26,Z
	LDI  R27,0
	CALL SUBOPT_0x7E
	OR   R30,R26
	OR   R31,R27
	CALL __LNEGW1
	LDI  R31,0
_0x3E5:
_0x3E6:
_0x3E0:
_0x3E1:
	STS  _sen_dep,R30
	STS  _sen_dep+1,R31
; 0000 05BE         sen_ki = (c_sensor_ki[c_i])?sensor&sensor_ki[c_sensor_ki[c_i]]:!(sensor>>9);
	CALL SUBOPT_0x7D
	LD   R30,Z
	LDI  R31,0
	SBIW R30,0
	BRNE PC+3
	JMP _0x3E7
	CALL SUBOPT_0x7D
	LD   R30,Z
	LDI  R26,LOW(_sensor_ki)
	LDI  R27,HIGH(_sensor_ki)
	CALL SUBOPT_0x7F
	RJMP _0x3E8
_0x3E7:
	LDS  R26,_sensor
	LDS  R27,_sensor+1
	LDI  R30,LOW(9)
	CALL __ASRW12
	CALL __LNEGW1
	LDI  R31,0
_0x3E8:
_0x3E9:
	STS  _sen_ki,R30
	STS  _sen_ki+1,R31
; 0000 05BF         sen_ka = (c_sensor_ka[c_i])?sensor&sensor_ka[c_sensor_ka[c_i]]:!(sensor<<9);
	CALL SUBOPT_0x7E
	SBIW R30,0
	BRNE PC+3
	JMP _0x3EA
	LDS  R30,_c_i
	LDI  R31,0
	SUBI R30,LOW(-_c_sensor_ka)
	SBCI R31,HIGH(-_c_sensor_ka)
	LD   R30,Z
	LDI  R26,LOW(_sensor_ka)
	LDI  R27,HIGH(_sensor_ka)
	CALL SUBOPT_0x7F
	RJMP _0x3EB
_0x3EA:
	LDS  R26,_sensor
	LDS  R27,_sensor+1
	LDI  R30,LOW(9)
	CALL __LSLW12
	CALL __LNEGW1
	LDI  R31,0
_0x3EB:
_0x3EC:
	STS  _sen_ka,R30
	STS  _sen_ka+1,R31
; 0000 05C0         if(sen_dep&&sen_ki&&sen_ka){
	LDS  R30,_sen_dep
	LDS  R31,_sen_dep+1
	SBIW R30,0
	BRNE PC+3
	JMP _0x3EE
	LDS  R30,_sen_ki
	LDS  R31,_sen_ki+1
	SBIW R30,0
	BRNE PC+3
	JMP _0x3EE
	LDS  R30,_sen_ka
	LDS  R31,_sen_ka+1
	SBIW R30,0
	BRNE PC+3
	JMP _0x3EE
	RJMP _0x3EF
_0x3EE:
	RJMP _0x3ED
_0x3EF:
; 0000 05C1             sensor_mati;
	CBI  0x15,6
	CBI  0x15,7
; 0000 05C2             switch(c_aksi[c_i]){
	LDS  R30,_c_i
	LDI  R31,0
	SUBI R30,LOW(-_c_aksi)
	SBCI R31,HIGH(-_c_aksi)
	LD   R30,Z
	LDI  R31,0
; 0000 05C3                 case 0: atur_pwm(c_laju_ki[c_i],c_laju_ka[c_i]);break;
	SBIW R30,0
	BREQ PC+3
	JMP _0x3F7
	CALL SUBOPT_0x80
	LD   R26,Z
	LDI  R27,0
	CALL _atur_pwm
	RJMP _0x3F6
; 0000 05C4                 case 1: atur_pwm(c_laju_ki[c_i],-(c_laju_ka[c_i]));break;
_0x3F7:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3F8
	CALL SUBOPT_0x80
	LD   R30,Z
	LDI  R31,0
	CALL __ANEGW1
	MOVW R26,R30
	CALL _atur_pwm
	RJMP _0x3F6
; 0000 05C5                 case 2: atur_pwm(-(c_laju_ki[c_i]),c_laju_ka[c_i]);break;
_0x3F8:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3F9
	LDS  R30,_c_i
	LDI  R31,0
	SUBI R30,LOW(-_c_laju_ki)
	SBCI R31,HIGH(-_c_laju_ki)
	LD   R30,Z
	LDI  R31,0
	CALL __ANEGW1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_c_i
	LDI  R31,0
	SUBI R30,LOW(-_c_laju_ka)
	SBCI R31,HIGH(-_c_laju_ka)
	LD   R26,Z
	LDI  R27,0
	CALL _atur_pwm
	RJMP _0x3F6
; 0000 05C6                 case 3: atur_pwm(0,0);flag_berhenti=1;break;
_0x3F9:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3F6
	CALL SUBOPT_0x41
	SET
	BLD  R2,2
; 0000 05C7             }
_0x3F6:
; 0000 05C8             LCD=1;delay_ms((c_delay[c_i])?c_delay[c_i]*10:1);LCD=0;
	SBI  0x18,3
	LDS  R30,_c_i
	LDI  R31,0
	SUBI R30,LOW(-_c_delay)
	SBCI R31,HIGH(-_c_delay)
	LD   R30,Z
	LDI  R31,0
	SBIW R30,0
	BRNE PC+3
	JMP _0x3FD
	LDS  R30,_c_i
	LDI  R31,0
	SUBI R30,LOW(-_c_delay)
	SBCI R31,HIGH(-_c_delay)
	LD   R26,Z
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	RJMP _0x3FE
_0x3FD:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0x3FE:
_0x3FF:
	MOVW R26,R30
	CALL _delay_ms
	CBI  0x18,3
; 0000 05C9             if(c_invert[c_i])flag_invert=!flag_invert;
	LDS  R30,_c_i
	LDI  R31,0
	SUBI R30,LOW(-_c_invert)
	SBCI R31,HIGH(-_c_invert)
	LD   R30,Z
	CPI  R30,0
	BRNE PC+3
	JMP _0x402
	LDI  R30,LOW(8)
	EOR  R2,R30
; 0000 05CA             if(c_timer[c_i]&&!timer_aktif){timer_aktif=1;kelajuan=c_laju[c_i];target_timer=detik*1000+cacah+c_timer[c_i] ...
_0x402:
	LDS  R30,_c_i
	LDI  R31,0
	SUBI R30,LOW(-_c_timer)
	SBCI R31,HIGH(-_c_timer)
	LD   R30,Z
	CPI  R30,0
	BRNE PC+3
	JMP _0x404
	SBRC R2,1
	RJMP _0x404
	RJMP _0x405
_0x404:
	RJMP _0x403
_0x405:
	SET
	BLD  R2,1
	LDS  R30,_c_i
	LDI  R31,0
	SUBI R30,LOW(-_c_laju)
	SBCI R31,HIGH(-_c_laju)
	LD   R30,Z
	CALL SUBOPT_0x7
	CALL SUBOPT_0x7B
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	LDS  R30,_c_i
	LDI  R31,0
	SUBI R30,LOW(-_c_timer)
	SBCI R31,HIGH(-_c_timer)
	LD   R26,Z
	LDI  R30,LOW(100)
	MUL  R30,R26
	MOVW R30,R0
	ADD  R30,R22
	ADC  R31,R23
	STS  _target_timer,R30
	STS  _target_timer+1,R31
; 0000 05CB             else{c_i++;if(c_i>=JML_INDEKS){c_i=JML_INDEKS-1;flag_berhenti=1;}}
	RJMP _0x406
_0x403:
	CALL SUBOPT_0x7C
	BRSH PC+3
	JMP _0x407
	LDI  R30,LOW(89)
	STS  _c_i,R30
	SET
	BLD  R2,2
_0x407:
_0x406:
; 0000 05CC         }
; 0000 05CD         lewat:
_0x3ED:
_0x3DE:
; 0000 05CE     }
; 0000 05CF 
; 0000 05D0     //error = SP - PV;
; 0000 05D1     P = (kP * error);
_0x3D7:
	CALL SUBOPT_0x81
	MOVW R26,R10
	CALL __MULW12
	STS  _P,R30
	STS  _P+1,R31
; 0000 05D2 
; 0000 05D3     // kalau mau make integrasi bisa dihapus tanda komennya
; 0000 05D4     //I = I + error;
; 0000 05D5     //I = (kI * I);
; 0000 05D6 
; 0000 05D7     pesat_error = error - error_terakhir;
	LDS  R26,_error_terakhir
	LDS  R27,_error_terakhir+1
	CALL SUBOPT_0x81
	SUB  R30,R26
	SBC  R31,R27
	STS  _pesat_error,R30
	STS  _pesat_error+1,R31
; 0000 05D8     D = (kD * pesat_error);
	LDS  R26,_kD
	LDS  R27,_kD+1
	CALL __MULW12
	STS  _D,R30
	STS  _D+1,R31
; 0000 05D9     error_terakhir = error;
	CALL SUBOPT_0x81
	STS  _error_terakhir,R30
	STS  _error_terakhir+1,R31
; 0000 05DA 
; 0000 05DB     PID = P + D;//+ I
	LDS  R30,_D
	LDS  R31,_D+1
	LDS  R26,_P
	LDS  R27,_P+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _PID,R30
	STS  _PID+1,R31
; 0000 05DC     pwm_kanan = kelajuan - PID;
	LDS  R26,_PID
	LDS  R27,_PID+1
	CALL SUBOPT_0x3D
	SUB  R30,R26
	SBC  R31,R27
	CALL SUBOPT_0x3E
; 0000 05DD     pwm_kiri = kelajuan + PID;
	LDS  R30,_PID
	LDS  R31,_PID+1
	CALL SUBOPT_0x3B
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x3F
; 0000 05DE 
; 0000 05DF     atur_pwm(pwm_kiri + k_stabilisator, pwm_kanan);
	CALL SUBOPT_0x40
; 0000 05E0 }
	RET
; .FEND
;
;//=====================================================================================
;void inisialisasi(){
; 0000 05E3 void inisialisasi(){
_inisialisasi:
; .FSTART _inisialisasi
; 0000 05E4     //yang input diaktifasiin pull up dulu
; 0000 05E5     //kaya PORT A dan C
; 0000 05E6     PORTA = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0000 05E7     DDRA = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 05E8     PORTC = 0x3F;
	LDI  R30,LOW(63)
	OUT  0x15,R30
; 0000 05E9     DDRC = 0xC0;
	LDI  R30,LOW(192)
	OUT  0x14,R30
; 0000 05EA     PORTB = 0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 05EB     DDRB = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 05EC     PORTD = 0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 05ED     DDRD = 0x78;
	LDI  R30,LOW(120)
	OUT  0x11,R30
; 0000 05EE     //setting PWM (mode fast PWM)
; 0000 05EF     TCCR1A=0xA1;
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 05F0     TCCR1B=0x03;
	LDI  R30,LOW(3)
	OUT  0x2E,R30
; 0000 05F1     //Prescaler saya pake 64, Clock ADC nya 250KHz
; 0000 05F2     ADMUX = ADC_VREF_TYPE;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 05F3     ADCSRA = 0x86;
	LDI  R30,LOW(134)
	OUT  0x6,R30
; 0000 05F4     //UART buat komunikasi serial 8bit non Interrupt
; 0000 05F5     /*UCSRB = (1 << RXEN)|(1 << TXEN);
; 0000 05F6     UCSRC = (1 << URSEL)|(1 << UCSZ0)|(1 << UCSZ1);
; 0000 05F7     UBRRH = (BAUD_PRESCALE >> 8);
; 0000 05F8     UBRRL = BAUD_PRESCALE;*/
; 0000 05F9     UCSRA = 0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 05FA     UCSRB = (1 << RXCIE) | (1 << TXCIE) | (1 << RXEN) | (1 << TXEN);
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 05FB     UCSRC = (1 << URSEL) | (1 << UCSZ0) | (1 << UCSZ1);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 05FC     UBRRH = (BAUD_PRESCALE >> 8);
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 05FD     UBRRL = BAUD_PRESCALE;
	LDI  R30,LOW(103)
	OUT  0x9,R30
; 0000 05FE     //timer
; 0000 05FF     TCCR0 = 0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 0600     TCNT0 = 0xF0;
	LDI  R30,LOW(240)
	OUT  0x32,R30
; 0000 0601     TIMSK = 0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0602     #asm("sei")
	sei
; 0000 0603     TIMSK = 0x00;
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 0604 }
	RET
; .FEND
;//=====================================================================================
;void main(void){
; 0000 0606 void main(void){
_main:
; .FSTART _main
; 0000 0607     unsigned char i;
; 0000 0608     //char ch[17];
; 0000 0609     if(e_reset_setting){
;	i -> R17
	LDI  R26,LOW(_e_reset_setting)
	LDI  R27,HIGH(_e_reset_setting)
	CALL __EEPROMRDB
	CPI  R30,0
	BRNE PC+3
	JMP _0x408
; 0000 060A         e_kP = 20;
	LDI  R26,LOW(_e_kP)
	LDI  R27,HIGH(_e_kP)
	LDI  R30,LOW(20)
	CALL __EEPROMWRB
; 0000 060B         e_kI = 0;
	LDI  R26,LOW(_e_kI)
	LDI  R27,HIGH(_e_kI)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 060C         e_kD = 45;
	LDI  R26,LOW(_e_kD)
	LDI  R27,HIGH(_e_kD)
	LDI  R30,LOW(45)
	CALL __EEPROMWRB
; 0000 060D         e_maks_PWM = 200;
	LDI  R26,LOW(_e_maks_PWM)
	LDI  R27,HIGH(_e_maks_PWM)
	LDI  R30,LOW(200)
	CALL __EEPROMWRB
; 0000 060E         e_min_PWM = 200;
	LDI  R26,LOW(_e_min_PWM)
	LDI  R27,HIGH(_e_min_PWM)
	CALL __EEPROMWRB
; 0000 060F         e_kelajuan = 150;
	LDI  R26,LOW(_e_kelajuan)
	LDI  R27,HIGH(_e_kelajuan)
	LDI  R30,LOW(150)
	CALL __EEPROMWRB
; 0000 0610         e_delay_awal=0;
	LDI  R26,LOW(_e_delay_awal)
	LDI  R27,HIGH(_e_delay_awal)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 0611         e_k_stabilisator=0;
	LDI  R26,LOW(_e_k_stabilisator)
	LDI  R27,HIGH(_e_k_stabilisator)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
; 0000 0612         for(i=0;i<JML_INDEKS;i++){
	LDI  R17,LOW(0)
_0x40A:
	CPI  R17,90
	BRLO PC+3
	JMP _0x40B
; 0000 0613             e_c_delay[i]=25;
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_e_c_delay)
	SBCI R27,HIGH(-_e_c_delay)
	LDI  R30,LOW(25)
	CALL SUBOPT_0x82
; 0000 0614             e_c_timer[i]=0;
	SUBI R26,LOW(-_e_c_timer)
	SBCI R27,HIGH(-_e_c_timer)
	LDI  R30,LOW(0)
	CALL SUBOPT_0x82
; 0000 0615             e_c_aksi[i]=1;
	SUBI R26,LOW(-_e_c_aksi)
	SBCI R27,HIGH(-_e_c_aksi)
	LDI  R30,LOW(1)
	CALL SUBOPT_0x82
; 0000 0616             e_c_sensor_ka[i]=3;
	SUBI R26,LOW(-_e_c_sensor_ka)
	SBCI R27,HIGH(-_e_c_sensor_ka)
	LDI  R30,LOW(3)
	CALL SUBOPT_0x82
; 0000 0617             e_c_sensor_ki[i]=3;
	SUBI R26,LOW(-_e_c_sensor_ki)
	SBCI R27,HIGH(-_e_c_sensor_ki)
	LDI  R30,LOW(3)
	CALL SUBOPT_0x82
; 0000 0618             e_c_cp[i]=(!i)?1:0;
	SUBI R26,LOW(-_e_c_cp)
	SBCI R27,HIGH(-_e_c_cp)
	CPI  R17,0
	BREQ PC+3
	JMP _0x40C
	LDI  R30,LOW(1)
	RJMP _0x40D
_0x40C:
	LDI  R30,LOW(0)
_0x40D:
_0x40E:
	CALL SUBOPT_0x82
; 0000 0619             e_c_invert[i]=0;
	SUBI R26,LOW(-_e_c_invert)
	SBCI R27,HIGH(-_e_c_invert)
	LDI  R30,LOW(0)
	CALL SUBOPT_0x83
; 0000 061A             e_c_laju[i]=e_kelajuan;
	SUBI R30,LOW(-_e_c_laju)
	SBCI R31,HIGH(-_e_c_laju)
	MOVW R0,R30
	CALL SUBOPT_0x6
	MOVW R26,R0
	CALL SUBOPT_0x83
; 0000 061B             e_c_laju_ki[i]=e_kelajuan;
	SUBI R30,LOW(-_e_c_laju_ki)
	SBCI R31,HIGH(-_e_c_laju_ki)
	MOVW R0,R30
	CALL SUBOPT_0x6
	MOVW R26,R0
	CALL SUBOPT_0x83
; 0000 061C             e_c_laju_ka[i]=e_kelajuan;
	SUBI R30,LOW(-_e_c_laju_ka)
	SBCI R31,HIGH(-_e_c_laju_ka)
	MOVW R0,R30
	CALL SUBOPT_0x6
	MOVW R26,R0
	CALL __EEPROMWRB
; 0000 061D         }
_0x409:
	SUBI R17,-1
	RJMP _0x40A
_0x40B:
; 0000 061E         for(i=0;i<14;i++){
	LDI  R17,LOW(0)
_0x410:
	CPI  R17,14
	BRLO PC+3
	JMP _0x411
; 0000 061F             e_ambang_atas[i]=200;
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_e_ambang_atas)
	SBCI R27,HIGH(-_e_ambang_atas)
	LDI  R30,LOW(200)
	CALL SUBOPT_0x82
; 0000 0620             e_ambang_bawah[i]=100;
	SUBI R26,LOW(-_e_ambang_bawah)
	SBCI R27,HIGH(-_e_ambang_bawah)
	LDI  R30,LOW(100)
	CALL SUBOPT_0x82
; 0000 0621             e_n_tengah[i]=150;
	SUBI R26,LOW(-_e_n_tengah)
	SBCI R27,HIGH(-_e_n_tengah)
	LDI  R30,LOW(150)
	CALL __EEPROMWRB
; 0000 0622         }
_0x40F:
	SUBI R17,-1
	RJMP _0x410
_0x411:
; 0000 0623         e_reset_setting=0;
	LDI  R26,LOW(_e_reset_setting)
	LDI  R27,HIGH(_e_reset_setting)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 0624     }
; 0000 0625     baca_eeprom();
_0x408:
	CALL _baca_eeprom
; 0000 0626     inisialisasi();
	CALL _inisialisasi
; 0000 0627     atur_pwm(0,0);
	CALL SUBOPT_0x41
; 0000 0628     lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 0629     LCD=1;
	SBI  0x18,3
; 0000 062A     /*while(1){
; 0000 062B         if(!OK){
; 0000 062C             while(!OK)delay_ms(20);
; 0000 062D             kirim_string("WOY\n");
; 0000 062E             kirim_string("100\n");
; 0000 062F         }
; 0000 0630         if(rx_counter){
; 0000 0631             lcd_gotoxy(0,0);
; 0000 0632             ambil_string(ch);
; 0000 0633             if(!strcmp(ch,"69")){
; 0000 0634                 sprintf(tampil,"%d",atoi(ch));
; 0000 0635                 lcd_puts(tampil);
; 0000 0636             //if(UCSRA & (1 << RXC)){
; 0000 0637                 lcd_gotoxy(0,1);
; 0000 0638                 ambil_string(ch);
; 0000 0639                 sprintf(tampil,"%d",atoi(ch));
; 0000 063A                 lcd_puts(tampil);
; 0000 063B             //}
; 0000 063C             }
; 0000 063D         }
; 0000 063E         //delay_ms(100);
; 0000 063F     }*/
; 0000 0640     pertama:
_0x414:
; 0000 0641     logika_password();
	CALL _logika_password
; 0000 0642     if(hitung_password<7)goto pertama;
	LDS  R26,_hitung_password
	CPI  R26,LOW(0x7)
	BRLO PC+3
	JMP _0x415
	RJMP _0x414
; 0000 0643     lcd_gotoxy(0,0);
_0x415:
	CALL SUBOPT_0x18
; 0000 0644     lcd_putsf("     Tim LC     ");
	__POINTW2FN _0x0,801
	CALL SUBOPT_0x19
; 0000 0645     lcd_gotoxy(0,1);
; 0000 0646     lcd_putsf("      2017      ");
	__POINTW2FN _0x0,818
	CALL _lcd_putsf
; 0000 0647     for(i = 0;i < 10;i++){
	LDI  R17,LOW(0)
_0x417:
	CPI  R17,10
	BRLO PC+3
	JMP _0x418
; 0000 0648         klap_klip;
	SBI  0x15,6
	CBI  0x15,7
	CBI  0x18,3
	CALL SUBOPT_0x1D
	CBI  0x15,6
	SBI  0x15,7
	SBI  0x18,3
	CALL SUBOPT_0x1D
; 0000 0649     }
_0x416:
	SUBI R17,-1
	RJMP _0x417
_0x418:
; 0000 064A     for(i = 0;i < 7;i++)define_char(c[i], i);
	LDI  R17,LOW(0)
_0x426:
	CPI  R17,7
	BRLO PC+3
	JMP _0x427
	MOV  R30,R17
	LDI  R31,0
	CALL __LSLW3
	SUBI R30,LOW(-_c*2)
	SBCI R31,HIGH(-_c*2)
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R17
	CALL _define_char
_0x425:
	SUBI R17,-1
	RJMP _0x426
_0x427:
; 0000 064B masuk_menu:
_0x428:
; 0000 064C     menu();
	CALL _menu
; 0000 064D     while (1){
_0x429:
; 0000 064E     // Please write your application code here
; 0000 064F         if(!OK||flag_berhenti){
	SBIS 0x13,0
	RJMP _0x42D
	SBRC R2,2
	RJMP _0x42D
	RJMP _0x42C
_0x42D:
; 0000 0650             if(!mode||flag_berhenti)TIMSK=0x00;//Ditaruh paling awal karena sifatnya interrupt
	LDS  R30,_mode
	CPI  R30,0
	BRNE PC+3
	JMP _0x430
	SBRC R2,2
	RJMP _0x430
	RJMP _0x42F
_0x430:
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 0651             atur_pwm(0,0);
_0x42F:
	CALL SUBOPT_0x41
; 0000 0652             sensor_mati;
	CBI  0x15,6
	CBI  0x15,7
; 0000 0653             error=0;
	CALL SUBOPT_0x76
; 0000 0654             error_terakhir=0;
	LDI  R30,LOW(0)
	STS  _error_terakhir,R30
	STS  _error_terakhir+1,R30
; 0000 0655             flag_berhenti=0;
	CLT
	BLD  R2,2
; 0000 0656             timer_aktif=0;
	BLD  R2,1
; 0000 0657             LCD=1;
	SBI  0x18,3
; 0000 0658             if(c_aksi[c_i]==3||c_i==(JML_INDEKS-1)||!mode){
	LDS  R30,_c_i
	LDI  R31,0
	SUBI R30,LOW(-_c_aksi)
	SBCI R31,HIGH(-_c_aksi)
	LD   R26,Z
	CPI  R26,LOW(0x3)
	BRNE PC+3
	JMP _0x439
	LDS  R26,_c_i
	CPI  R26,LOW(0x59)
	BRNE PC+3
	JMP _0x439
	LDS  R30,_mode
	CPI  R30,0
	BRNE PC+3
	JMP _0x439
	RJMP _0x438
_0x439:
; 0000 0659                 lcd_gotoxy(0,0);
	CALL SUBOPT_0x18
; 0000 065A                 lcd_putsf("Total Waktu     ");
	__POINTW2FN _0x0,583
	CALL SUBOPT_0x19
; 0000 065B                 lcd_gotoxy(0,1);
; 0000 065C                 sprintf(tampil,"%ds:%dms     ",detik,cacah);
	CALL SUBOPT_0x25
	CALL SUBOPT_0x47
; 0000 065D                 lcd_puts(tampil);
; 0000 065E                 detik=0;
	CALL SUBOPT_0x48
; 0000 065F                 cacah=0;
	CALL SUBOPT_0x2
; 0000 0660                 while(!OK)delay_ms(20);
_0x43B:
	SBIC 0x13,0
	RJMP _0x43D
	CALL SUBOPT_0x1C
	RJMP _0x43B
_0x43D:
; 0000 0661 while(1){if(!PINC.0){while(!PINC.0)delay_ms(20);break;}}
_0x43E:
	SBIC 0x13,0
	RJMP _0x441
_0x442:
	SBIC 0x13,0
	RJMP _0x444
	CALL SUBOPT_0x1C
	RJMP _0x442
_0x444:
	RJMP _0x440
_0x441:
	RJMP _0x43E
_0x440:
; 0000 0662             }else {while(!OK)delay_ms(20);}
	RJMP _0x445
_0x438:
_0x446:
	SBIC 0x13,0
	RJMP _0x448
	CALL SUBOPT_0x1C
	RJMP _0x446
_0x448:
_0x445:
; 0000 0663             goto masuk_menu;
	RJMP _0x428
; 0000 0664         }
; 0000 0665         kendali_PID();
_0x42C:
	CALL _kendali_PID
; 0000 0666     }
	RJMP _0x429
_0x42B:
; 0000 0667 }
_0x449:
	RJMP _0x449
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
; .FSTART _put_buff_G100
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BRNE PC+3
	JMP _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ PC+3
	JMP _0x2000011
	RJMP _0x2000012
_0x2000011:
	__CPWRN 16,17,2
	BRSH PC+3
	JMP _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x0
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRPL PC+3
	JMP _0x2000014
	CALL SUBOPT_0x0
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__ftoe_G100:
; .FSTART __ftoe_G100
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x1E
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2000019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2000000,0
	CALL _strcpyf
	CALL __LOADLOCR4
	ADIW R28,16
	RET
_0x2000019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2000018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2000000,1
	CALL _strcpyf
	CALL __LOADLOCR4
	ADIW R28,16
	RET
_0x2000018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRSH PC+3
	JMP _0x200001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x200001B:
	LDD  R17,Y+11
_0x200001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BRNE PC+3
	JMP _0x200001E
	CALL SUBOPT_0x84
	RJMP _0x200001C
_0x200001E:
	__GETD1S 12
	CALL __CPD10
	BREQ PC+3
	JMP _0x200001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x84
	RJMP _0x2000020
_0x200001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x85
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2000021
	CALL SUBOPT_0x84
_0x2000022:
	CALL SUBOPT_0x85
	BRSH PC+3
	JMP _0x2000024
	CALL SUBOPT_0x86
	CALL SUBOPT_0x87
	RJMP _0x2000022
_0x2000024:
	RJMP _0x2000025
_0x2000021:
_0x2000026:
	CALL SUBOPT_0x85
	BRLO PC+3
	JMP _0x2000028
	CALL SUBOPT_0x86
	CALL SUBOPT_0x88
	CALL SUBOPT_0x89
	SUBI R19,LOW(1)
	RJMP _0x2000026
_0x2000028:
	CALL SUBOPT_0x84
_0x2000025:
	__GETD1S 12
	CALL SUBOPT_0x8A
	CALL SUBOPT_0x89
	CALL SUBOPT_0x85
	BRSH PC+3
	JMP _0x2000029
	CALL SUBOPT_0x86
	CALL SUBOPT_0x87
_0x2000029:
_0x2000020:
	LDI  R17,LOW(0)
_0x200002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRSH PC+3
	JMP _0x200002C
	__GETD2S 4
	CALL SUBOPT_0x8B
	CALL SUBOPT_0x8A
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	__PUTD1S 4
	CALL SUBOPT_0x86
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 4
	CALL __MULF12
	CALL SUBOPT_0x86
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x89
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE PC+3
	JMP _0x200002D
	RJMP _0x200002A
_0x200002D:
	CALL SUBOPT_0x8C
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x200002A
_0x200002C:
	CALL SUBOPT_0x8F
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRLT PC+3
	JMP _0x200002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	ST   X,R30
	RJMP _0x200002F
_0x200002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
	ST   X,R30
_0x200002F:
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x8F
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x8F
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
	CALL __LOADLOCR4
	ADIW R28,16
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x0
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2000032
	MOV  R30,R17
	CPI  R30,0
	BREQ PC+3
	JMP _0x2000036
	CPI  R18,37
	BREQ PC+3
	JMP _0x2000037
	LDI  R17,LOW(1)
	RJMP _0x2000038
_0x2000037:
	CALL SUBOPT_0x90
_0x2000038:
	RJMP _0x2000035
_0x2000036:
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x2000039
	CPI  R18,37
	BREQ PC+3
	JMP _0x200003A
	CALL SUBOPT_0x90
	LDI  R17,LOW(0)
	RJMP _0x2000035
_0x200003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BREQ PC+3
	JMP _0x200003B
	LDI  R16,LOW(1)
	RJMP _0x2000035
_0x200003B:
	CPI  R18,43
	BREQ PC+3
	JMP _0x200003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003C:
	CPI  R18,32
	BREQ PC+3
	JMP _0x200003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003D:
	RJMP _0x200003E
_0x2000039:
	CPI  R30,LOW(0x2)
	BREQ PC+3
	JMP _0x200003F
_0x200003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BREQ PC+3
	JMP _0x2000040
	ORI  R16,LOW(128)
	RJMP _0x2000035
_0x2000040:
	RJMP _0x2000041
_0x200003F:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x2000042
_0x2000041:
	CPI  R18,48
	BRSH PC+3
	JMP _0x2000044
	CPI  R18,58
	BRLO PC+3
	JMP _0x2000044
	RJMP _0x2000045
_0x2000044:
	RJMP _0x2000043
_0x2000045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2000035
_0x2000043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BREQ PC+3
	JMP _0x2000046
	LDI  R17,LOW(4)
	RJMP _0x2000035
_0x2000046:
	RJMP _0x2000047
	RJMP _0x2000048
_0x2000042:
	CPI  R30,LOW(0x4)
	BREQ PC+3
	JMP _0x2000049
_0x2000048:
	CPI  R18,48
	BRSH PC+3
	JMP _0x200004B
	CPI  R18,58
	BRLO PC+3
	JMP _0x200004B
	RJMP _0x200004C
_0x200004B:
	RJMP _0x200004A
_0x200004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2000035
_0x200004A:
_0x2000047:
	CPI  R18,108
	BREQ PC+3
	JMP _0x200004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2000035
_0x200004D:
	RJMP _0x200004E
_0x2000049:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x2000035
_0x200004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BREQ PC+3
	JMP _0x2000053
	CALL SUBOPT_0x91
	CALL SUBOPT_0x92
	CALL SUBOPT_0x91
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x93
	RJMP _0x2000054
	RJMP _0x2000055
_0x2000053:
	CPI  R30,LOW(0x45)
	BREQ PC+3
	JMP _0x2000056
_0x2000055:
	RJMP _0x2000057
_0x2000056:
	CPI  R30,LOW(0x65)
	BREQ PC+3
	JMP _0x2000058
_0x2000057:
	RJMP _0x2000059
_0x2000058:
	CPI  R30,LOW(0x66)
	BREQ PC+3
	JMP _0x200005A
_0x2000059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x94
	CALL SUBOPT_0x95
	CALL SUBOPT_0x96
	LDD  R26,Y+13
	TST  R26
	BRPL PC+3
	JMP _0x200005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ PC+3
	JMP _0x200005C
	RJMP _0x200005D
_0x200005C:
	LDD  R26,Y+21
	CPI  R26,LOW(0x20)
	BREQ PC+3
	JMP _0x200005E
	RJMP _0x200005F
_0x200005E:
	RJMP _0x2000060
_0x200005B:
	CALL SUBOPT_0x26
	CALL __ANEGF1
	CALL SUBOPT_0x97
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x200005D:
	SBRS R16,7
	RJMP _0x2000061
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x93
	RJMP _0x2000062
_0x2000061:
_0x200005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2000062:
_0x2000060:
	SBRC R16,5
	RJMP _0x2000063
	LDI  R20,LOW(6)
_0x2000063:
	CPI  R18,102
	BREQ PC+3
	JMP _0x2000064
	CALL SUBOPT_0x26
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x2000065
_0x2000064:
	CALL SUBOPT_0x26
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CALL __ftoe_G100
_0x2000065:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x98
	RJMP _0x2000066
	RJMP _0x2000067
_0x200005A:
	CPI  R30,LOW(0x73)
	BREQ PC+3
	JMP _0x2000068
_0x2000067:
	CALL SUBOPT_0x96
	CALL SUBOPT_0x99
	CALL SUBOPT_0x98
	RJMP _0x2000069
	RJMP _0x200006A
_0x2000068:
	CPI  R30,LOW(0x70)
	BREQ PC+3
	JMP _0x200006B
_0x200006A:
	CALL SUBOPT_0x96
	CALL SUBOPT_0x99
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000069:
	ANDI R16,LOW(127)
	CPI  R20,0
	BRNE PC+3
	JMP _0x200006D
	CP   R20,R17
	BRLO PC+3
	JMP _0x200006D
	RJMP _0x200006E
_0x200006D:
	RJMP _0x200006C
_0x200006E:
	MOV  R17,R20
_0x200006C:
_0x2000066:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x200006F
	RJMP _0x2000070
_0x200006B:
	CPI  R30,LOW(0x64)
	BREQ PC+3
	JMP _0x2000071
_0x2000070:
	RJMP _0x2000072
_0x2000071:
	CPI  R30,LOW(0x69)
	BREQ PC+3
	JMP _0x2000073
_0x2000072:
	ORI  R16,LOW(4)
	RJMP _0x2000074
_0x2000073:
	CPI  R30,LOW(0x75)
	BREQ PC+3
	JMP _0x2000075
_0x2000074:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2000076
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x9A
	LDI  R17,LOW(10)
	RJMP _0x2000077
_0x2000076:
	__GETD1N 0x2710
	CALL SUBOPT_0x9A
	LDI  R17,LOW(5)
	RJMP _0x2000077
	RJMP _0x2000078
_0x2000075:
	CPI  R30,LOW(0x58)
	BREQ PC+3
	JMP _0x2000079
_0x2000078:
	ORI  R16,LOW(8)
	RJMP _0x200007A
_0x2000079:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x20000B8
_0x200007A:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x200007C
	__GETD1N 0x10000000
	CALL SUBOPT_0x9A
	LDI  R17,LOW(8)
	RJMP _0x2000077
_0x200007C:
	__GETD1N 0x1000
	CALL SUBOPT_0x9A
	LDI  R17,LOW(4)
_0x2000077:
	CPI  R20,0
	BRNE PC+3
	JMP _0x200007D
	ANDI R16,LOW(127)
	RJMP _0x200007E
_0x200007D:
	LDI  R20,LOW(1)
_0x200007E:
	SBRS R16,1
	RJMP _0x200007F
	CALL SUBOPT_0x96
	CALL SUBOPT_0x94
	ADIW R26,4
	CALL SUBOPT_0x95
	RJMP _0x2000080
_0x200007F:
	SBRS R16,2
	RJMP _0x2000081
	CALL SUBOPT_0x96
	CALL SUBOPT_0x99
	CALL __CWD1
	CALL SUBOPT_0x97
	RJMP _0x2000082
_0x2000081:
	CALL SUBOPT_0x96
	CALL SUBOPT_0x99
	CLR  R22
	CLR  R23
	CALL SUBOPT_0x97
_0x2000082:
_0x2000080:
	SBRS R16,2
	RJMP _0x2000083
	LDD  R26,Y+13
	TST  R26
	BRMI PC+3
	JMP _0x2000084
	CALL SUBOPT_0x26
	CALL __ANEGD1
	CALL SUBOPT_0x97
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2000084:
	LDD  R30,Y+21
	CPI  R30,0
	BRNE PC+3
	JMP _0x2000085
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2000086
_0x2000085:
	ANDI R16,LOW(251)
_0x2000086:
_0x2000083:
	MOV  R19,R20
_0x200006F:
	SBRC R16,0
	RJMP _0x2000087
_0x2000088:
	CP   R17,R21
	BRLO PC+3
	JMP _0x200008B
	CP   R19,R21
	BRLO PC+3
	JMP _0x200008B
	RJMP _0x200008C
_0x200008B:
	RJMP _0x200008A
_0x200008C:
	SBRS R16,7
	RJMP _0x200008D
	SBRS R16,2
	RJMP _0x200008E
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x200008F
_0x200008E:
	LDI  R18,LOW(48)
_0x200008F:
	RJMP _0x2000090
_0x200008D:
	LDI  R18,LOW(32)
_0x2000090:
	CALL SUBOPT_0x90
	SUBI R21,LOW(1)
	RJMP _0x2000088
_0x200008A:
_0x2000087:
_0x2000091:
	CP   R17,R20
	BRLO PC+3
	JMP _0x2000093
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000094
	CALL SUBOPT_0x9B
	BRNE PC+3
	JMP _0x2000095
	SUBI R21,LOW(1)
_0x2000095:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2000094:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x93
	CPI  R21,0
	BRNE PC+3
	JMP _0x2000096
	SUBI R21,LOW(1)
_0x2000096:
	SUBI R20,LOW(1)
	RJMP _0x2000091
_0x2000093:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BREQ PC+3
	JMP _0x2000097
_0x2000098:
	CPI  R19,0
	BRNE PC+3
	JMP _0x200009A
	SBRS R16,3
	RJMP _0x200009B
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x200009C
_0x200009B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x200009C:
	CALL SUBOPT_0x90
	CPI  R21,0
	BRNE PC+3
	JMP _0x200009D
	SUBI R21,LOW(1)
_0x200009D:
	SUBI R19,LOW(1)
	RJMP _0x2000098
_0x200009A:
	RJMP _0x200009E
_0x2000097:
_0x20000A0:
	CALL SUBOPT_0x9C
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRSH PC+3
	JMP _0x20000A2
	SBRS R16,3
	RJMP _0x20000A3
	SUBI R18,-LOW(55)
	RJMP _0x20000A4
_0x20000A3:
	SUBI R18,-LOW(87)
_0x20000A4:
	RJMP _0x20000A5
_0x20000A2:
	SUBI R18,-LOW(48)
_0x20000A5:
	SBRS R16,4
	RJMP _0x20000A6
	RJMP _0x20000A7
_0x20000A6:
	CPI  R18,49
	BRLO PC+3
	JMP _0x20000A9
	__GETD2S 16
	__CPD2N 0x1
	BRNE PC+3
	JMP _0x20000A9
	RJMP _0x20000A8
_0x20000A9:
	RJMP _0x20000AB
_0x20000A8:
	CP   R20,R19
	BRSH PC+3
	JMP _0x20000AC
	LDI  R18,LOW(48)
	RJMP _0x20000AB
_0x20000AC:
	CP   R21,R19
	BRSH PC+3
	JMP _0x20000AE
	SBRC R16,0
	RJMP _0x20000AE
	RJMP _0x20000AF
_0x20000AE:
	RJMP _0x20000AD
_0x20000AF:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20000B0
	LDI  R18,LOW(48)
_0x20000AB:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20000B1
	CALL SUBOPT_0x9B
	BRNE PC+3
	JMP _0x20000B2
	SUBI R21,LOW(1)
_0x20000B2:
_0x20000B1:
_0x20000B0:
_0x20000A7:
	CALL SUBOPT_0x90
	CPI  R21,0
	BRNE PC+3
	JMP _0x20000B3
	SUBI R21,LOW(1)
_0x20000B3:
_0x20000AD:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x9C
	CALL __MODD21U
	CALL SUBOPT_0x97
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x9A
_0x200009F:
	__GETD1S 16
	CALL __CPD10
	BRNE PC+3
	JMP _0x20000A1
	RJMP _0x20000A0
_0x20000A1:
_0x200009E:
	SBRS R16,0
	RJMP _0x20000B4
_0x20000B5:
	CPI  R21,0
	BRNE PC+3
	JMP _0x20000B7
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x93
	RJMP _0x20000B5
_0x20000B7:
_0x20000B4:
_0x20000B8:
_0x2000054:
	LDI  R17,LOW(0)
_0x2000052:
_0x2000035:
	RJMP _0x2000030
_0x2000032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x9D
	SBIW R30,0
	BREQ PC+3
	JMP _0x20000B9
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
_0x20000B9:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x9D
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __print_G100
	MOVW R18,R30
	CALL SUBOPT_0x9E
	MOVW R30,R18
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
; .FSTART __lcd_write_nibble_G101
	ST   -Y,R26
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x18,R30
	__DELAY_USB 27
	SBI  0x18,2
	__DELAY_USB 27
	CBI  0x18,2
	__DELAY_USB 27
	ADIW R28,1
	RET
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	CALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	CALL __lcd_write_nibble_G101
	__DELAY_USW 200
	ADIW R28,1
	RET
; .FEND
_lcd_write_byte:
; .FSTART _lcd_write_byte
	ST   -Y,R26
	LDD  R26,Y+1
	CALL __lcd_write_data
	SBI  0x18,0
	LD   R26,Y
	CALL __lcd_write_data
	CBI  0x18,0
	ADIW R28,2
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	CALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x9F
	LDI  R26,LOW(12)
	CALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x9F
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE PC+3
	JMP _0x2020005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO PC+3
	JMP _0x2020005
	RJMP _0x2020004
_0x2020005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	CALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ PC+3
	JMP _0x2020007
	ADIW R28,1
	RET
_0x2020007:
_0x2020004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x18,0
	LD   R26,Y
	CALL __lcd_write_data
	CBI  0x18,0
	ADIW R28,1
	RET
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x202000A
	MOV  R26,R17
	CALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x202000B:
	CALL SUBOPT_0x3
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x202000D
	MOV  R26,R17
	CALL _lcd_putchar
	RJMP _0x202000B
_0x202000D:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x17
	ORI  R30,LOW(0xF0)
	OUT  0x17,R30
	SBI  0x17,2
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x18,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	CALL SUBOPT_0x1C
	CALL SUBOPT_0xA0
	CALL SUBOPT_0xA0
	CALL SUBOPT_0xA0
	LDI  R26,LOW(32)
	CALL __lcd_write_nibble_G101
	__DELAY_USW 400
	LDI  R26,LOW(40)
	CALL __lcd_write_data
	LDI  R26,LOW(4)
	CALL __lcd_write_data
	LDI  R26,LOW(133)
	CALL __lcd_write_data
	LDI  R26,LOW(6)
	CALL __lcd_write_data
	CALL _lcd_clear
	ADIW R28,1
	RET
; .FEND

	.CSEG
_atoi:
; .FSTART _atoi
	ST   -Y,R27
	ST   -Y,R26
   	ldd  r27,y+1
   	ld   r26,y
__atoi0:
   	ld   r30,x
        mov  r24,r26
	MOV  R26,R30
	CALL _isspace
        mov  r26,r24
   	tst  r30
   	breq __atoi1
   	adiw r26,1
   	rjmp __atoi0
__atoi1:
   	clt
   	ld   r30,x
   	cpi  r30,'-'
   	brne __atoi2
   	set
   	rjmp __atoi3
__atoi2:
   	cpi  r30,'+'
   	brne __atoi4
__atoi3:
   	adiw r26,1
__atoi4:
   	clr  r22
   	clr  r23
__atoi5:
   	ld   r30,x
        mov  r24,r26
	MOV  R26,R30
	CALL _isdigit
        mov  r26,r24
   	tst  r30
   	breq __atoi6
   	movw r30,r22
   	lsl  r22
   	rol  r23
   	lsl  r22
   	rol  r23
   	add  r22,r30
   	adc  r23,r31
   	lsl  r22
   	rol  r23
   	ld   r30,x+
   	clr  r31
   	subi r30,'0'
   	add  r22,r30
   	adc  r23,r31
   	rjmp __atoi5
__atoi6:
   	movw r30,r22
   	brtc __atoi7
   	com  r30
   	com  r31
   	adiw r30,1
__atoi7:
   	adiw r28,2
   	ret
; .FEND
_ftoa:
; .FSTART _ftoa
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x1E
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x204000D
	CALL SUBOPT_0xA1
	__POINTW2FN _0x2040000,0
	CALL SUBOPT_0xA2
	RET
_0x204000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x204000C
	CALL SUBOPT_0xA1
	__POINTW2FN _0x2040000,1
	CALL SUBOPT_0xA2
	RET
_0x204000C:
	LDD  R26,Y+12
	TST  R26
	BRMI PC+3
	JMP _0x204000F
	__GETD1S 9
	CALL __ANEGF1
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xA4
	LDI  R30,LOW(45)
	ST   X,R30
_0x204000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRSH PC+3
	JMP _0x2040010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2040010:
	LDD  R17,Y+8
_0x2040011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BRNE PC+3
	JMP _0x2040013
	CALL SUBOPT_0xA5
	CALL SUBOPT_0x8B
	CALL SUBOPT_0xA6
	RJMP _0x2040011
_0x2040013:
	CALL SUBOPT_0xA7
	CALL __ADDF12
	CALL SUBOPT_0xA3
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	CALL SUBOPT_0xA6
_0x2040014:
	CALL SUBOPT_0xA7
	CALL __CMPF12
	BRSH PC+3
	JMP _0x2040016
	CALL SUBOPT_0xA5
	CALL SUBOPT_0x88
	CALL SUBOPT_0xA6
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRSH PC+3
	JMP _0x2040017
	CALL SUBOPT_0xA1
	__POINTW2FN _0x2040000,5
	CALL SUBOPT_0xA2
	RET
_0x2040017:
	RJMP _0x2040014
_0x2040016:
	CPI  R17,0
	BREQ PC+3
	JMP _0x2040018
	CALL SUBOPT_0xA4
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2040019
_0x2040018:
_0x204001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BRNE PC+3
	JMP _0x204001C
	CALL SUBOPT_0xA5
	CALL SUBOPT_0x8B
	CALL SUBOPT_0x8A
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0xA6
	CALL SUBOPT_0xA7
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0xA4
	CALL SUBOPT_0x8D
	LDI  R31,0
	CALL SUBOPT_0xA5
	CALL __CWD1
	CALL __CDF1
	CALL __MULF12
	CALL SUBOPT_0xA8
	CALL SUBOPT_0x8E
	CALL SUBOPT_0xA3
	RJMP _0x204001A
_0x204001C:
_0x2040019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ PC+3
	JMP _0x204001D
	CALL SUBOPT_0x9E
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
_0x204001D:
	CALL SUBOPT_0xA4
	LDI  R30,LOW(46)
	ST   X,R30
_0x204001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BRNE PC+3
	JMP _0x2040020
	CALL SUBOPT_0xA8
	CALL SUBOPT_0x88
	CALL SUBOPT_0xA3
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0xA4
	CALL SUBOPT_0x8D
	LDI  R31,0
	CALL SUBOPT_0xA8
	CALL __CWD1
	CALL __CDF1
	CALL SUBOPT_0x8E
	CALL SUBOPT_0xA3
	RJMP _0x204001E
_0x2040020:
	CALL SUBOPT_0x9E
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
; .FEND

	.DSEG

	.CSEG

	.CSEG
_strcmp:
; .FSTART _strcmp
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmp0:
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strcmp1
    tst  r22
    brne strcmp0
strcmp3:
    clr  r30
    ret
strcmp1:
    sub  r22,r23
    breq strcmp3
    ldi  r30,1
    brcc strcmp2
    subi r30,2
strcmp2:
    ret
; .FEND
_strcpyf:
; .FSTART _strcpyf
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG
_isdigit:
; .FSTART _isdigit
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,'0'
    brlo isdigit0
    cpi  r31,'9'+1
    brlo isdigit1
isdigit0:
    clr  r30
isdigit1:
    ret
; .FEND
_isspace:
; .FSTART _isspace
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,' '
    breq isspace1
    cpi  r31,9
    brlo isspace0
    cpi  r31,13+1
    brlo isspace1
isspace0:
    clr  r30
isspace1:
    ret
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL __GETD1S0
	ADIW R28,4
	RET
__floor1:
    brtc __floor0
	CALL __GETD1S0
	__GETD2N 0x3F800000
	CALL __SUBF12
	ADIW R28,4
	RET
; .FEND

	.DSEG
_rx_buffer:
	.BYTE 0x8
_tx_buffer:
	.BYTE 0x8

	.ESEG
_e_kP:
	.BYTE 0x1
_e_kI:
	.BYTE 0x1
_e_kD:
	.BYTE 0x1
_e_maks_PWM:
	.BYTE 0x1
_e_min_PWM:
	.BYTE 0x1
_e_kelajuan:
	.BYTE 0x1
_e_n_tengah:
	.BYTE 0xE
_e_ambang_atas:
	.BYTE 0xE
_e_ambang_bawah:
	.BYTE 0xE
_e_k_stabilisator:
	.BYTE 0x2
_e_delay_awal:
	.BYTE 0x1
_e_reset_setting:
	.DB  0x1
_e_c_delay:
	.BYTE 0x5A
_e_c_timer:
	.BYTE 0x5A
_e_c_aksi:
	.BYTE 0x5A
_e_c_sensor_ka:
	.BYTE 0x5A
_e_c_sensor_ki:
	.BYTE 0x5A
_e_c_cp:
	.BYTE 0x5A
_e_c_invert:
	.BYTE 0x5A
_e_c_laju:
	.BYTE 0x5A
_e_c_laju_ki:
	.BYTE 0x5A
_e_c_laju_ka:
	.BYTE 0x5A

	.DSEG
_kD:
	.BYTE 0x2
_maks_PWM:
	.BYTE 0x2
_min_PWM:
	.BYTE 0x2
_kelajuan:
	.BYTE 0x2
_k_stabilisator:
	.BYTE 0x2
_delay_awal:
	.BYTE 0x1
_nilai_adc:
	.BYTE 0xE
_ambang_atas:
	.BYTE 0xE
_ambang_bawah:
	.BYTE 0xE
_n_tengah:
	.BYTE 0xE
_c_delay:
	.BYTE 0x5A
_c_timer:
	.BYTE 0x5A
_c_aksi:
	.BYTE 0x5A
_c_sensor_ka:
	.BYTE 0x5A
_c_sensor_ki:
	.BYTE 0x5A
_c_cp:
	.BYTE 0x5A
_c_invert:
	.BYTE 0x5A
_c_laju:
	.BYTE 0x5A
_c_laju_ki:
	.BYTE 0x5A
_c_laju_ka:
	.BYTE 0x5A
_tampil:
	.BYTE 0x10
_buffer:
	.BYTE 0x12
_cacah:
	.BYTE 0x2
_detik:
	.BYTE 0x2
_target_timer:
	.BYTE 0x2
_sensor_ka:
	.BYTE 0xC
_sensor_ki:
	.BYTE 0xC
_PID:
	.BYTE 0x2
_P:
	.BYTE 0x2
_D:
	.BYTE 0x2
_error:
	.BYTE 0x2
_error_terakhir:
	.BYTE 0x2
_pesat_error:
	.BYTE 0x2
_pwm_kiri:
	.BYTE 0x2
_pwm_kanan:
	.BYTE 0x2
_c_i:
	.BYTE 0x1
_kelajuan_normal:
	.BYTE 0x1
_mode:
	.BYTE 0x1
_aktifasi_serial:
	.BYTE 0x1
_sensor:
	.BYTE 0x2
_sen_dep:
	.BYTE 0x2
_sen_ki:
	.BYTE 0x2
_sen_ka:
	.BYTE 0x2
_hitung_tekan:
	.BYTE 0x1
_hitung_password:
	.BYTE 0x1
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x0:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LDS  R26,_cacah
	LDS  R27,_cacah+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	STS  _cacah,R30
	STS  _cacah+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	STS  _maks_PWM,R30
	STS  _maks_PWM+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	STS  _min_PWM,R30
	STS  _min_PWM+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(_e_kelajuan)
	LDI  R27,HIGH(_e_kelajuan)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LDI  R31,0
	STS  _kelajuan,R30
	STS  _kelajuan+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	STS  _k_stabilisator,R30
	STS  _k_stabilisator+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x9:
	CALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xA:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_n_tengah)
	SBCI R31,HIGH(-_n_tengah)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xB:
	LDS  R30,_maks_PWM
	LDS  R31,_maks_PWM+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDS  R30,_min_PWM
	LDS  R31,_min_PWM+1
	CALL __ANEGW1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDS  R26,_min_PWM
	LDS  R27,_min_PWM+1
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	SBI  0x15,6
	CBI  0x15,7
	__DELAY_USW 600
	LDI  R17,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xF:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_nilai_adc)
	SBCI R31,HIGH(-_nilai_adc)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	ST   X,R30
	LDI  R30,LOW(14)
	SUB  R30,R17
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
	LDI  R16,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x11:
	LD   R24,Z
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_ambang_atas)
	SBCI R31,HIGH(-_ambang_atas)
	LD   R22,Z
	CLR  R23
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_ambang_atas)
	SBCI R31,HIGH(-_ambang_atas)
	LD   R26,Z
	LDI  R27,0
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x12:
	LD   R30,Z
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __DIVW21
	MOVW R26,R30
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x13:
	ADIW R30,1
	CALL __MULW12
	MOVW R26,R30
	MOVW R30,R22
	SUB  R30,R26
	SBC  R31,R27
	MOV  R26,R24
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	CALL __MULW12
	MOVW R26,R30
	MOVW R30,R22
	SUB  R30,R26
	SBC  R31,R27
	MOV  R26,R24
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	LD   R26,Z
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_ambang_atas)
	SBCI R31,HIGH(-_ambang_atas)
	LD   R30,Z
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	MOV  R30,R16
	LDI  R31,0
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	CBI  0x15,6
	SBI  0x15,7
	__DELAY_USW 600
	LDI  R17,LOW(7)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:72 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:77 WORDS
SUBOPT_0x19:
	CALL _lcd_putsf
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 36 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0x1A:
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1B:
	LDS  R30,_hitung_password
	SUBI R30,-LOW(1)
	STS  _hitung_password,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 50 TIMES, CODE SIZE REDUCTION:95 WORDS
SUBOPT_0x1C:
	LDI  R26,LOW(20)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1D:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1F:
	CALL _lcd_clear
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x20:
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_c_cp)
	SBCI R31,HIGH(-_c_cp)
	LD   R30,Z
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(_tampil)
	LDI  R31,HIGH(_tampil)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,74
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	ADIW R30,1
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R26,LOW(_tampil)
	LDI  R27,HIGH(_tampil)
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x22:
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	JMP  _ambil_string

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x24:
	CALL _lcd_putsf
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(_tampil)
	LDI  R31,HIGH(_tampil)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 39 TIMES, CODE SIZE REDUCTION:149 WORDS
SUBOPT_0x27:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x28:
	LDI  R26,LOW(_tampil)
	LDI  R27,HIGH(_tampil)
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x29:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x2A:
	CALL _kirim_string
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x2B:
	__POINTW1FN _0x0,442
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2C:
	MOVW R30,R10
	CALL __CWD1
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x2D:
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	JMP  _kirim_string

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2E:
	MOVW R30,R12
	CALL __CWD1
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2F:
	LDS  R30,_kD
	LDS  R31,_kD+1
	CALL __CWD1
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x30:
	MOV  R30,R10
	LDI  R26,LOW(_e_kP)
	LDI  R27,HIGH(_e_kP)
	CALL __EEPROMWRB
	MOV  R30,R12
	LDI  R26,LOW(_e_kI)
	LDI  R27,HIGH(_e_kI)
	CALL __EEPROMWRB
	LDS  R30,_kD
	LDI  R26,LOW(_e_kD)
	LDI  R27,HIGH(_e_kD)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x31:
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	JMP  _atoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x32:
	LDI  R26,LOW(70)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x33:
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x34:
	__POINTW1FN _0x0,77
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x35:
	MOV  R26,R30
	CALL _lcd_putchar
	LDI  R30,LOW(5)
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x36:
	LDI  R26,LOW(10)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x37:
	CALL SUBOPT_0xB
	CALL __CWD1
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x38:
	LDS  R30,_min_PWM
	LDS  R31,_min_PWM+1
	CALL __CWD1
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x39:
	LDS  R30,_kelajuan
	LDS  R31,_kelajuan+1
	CALL __CWD1
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3A:
	LDS  R30,_maks_PWM
	LDI  R26,LOW(_e_maks_PWM)
	LDI  R27,HIGH(_e_maks_PWM)
	CALL __EEPROMWRB
	LDS  R30,_min_PWM
	LDI  R26,LOW(_e_min_PWM)
	LDI  R27,HIGH(_e_min_PWM)
	CALL __EEPROMWRB
	LDS  R30,_kelajuan
	LDI  R26,LOW(_e_kelajuan)
	LDI  R27,HIGH(_e_kelajuan)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x3B:
	LDS  R26,_kelajuan
	LDS  R27,_kelajuan+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	MOV  R26,R30
	CALL _lcd_putchar
	LDI  R30,LOW(11)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3D:
	LDS  R30,_kelajuan
	LDS  R31,_kelajuan+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3E:
	STS  _pwm_kanan,R30
	STS  _pwm_kanan+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3F:
	STS  _pwm_kiri,R30
	STS  _pwm_kiri+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x40:
	LDS  R30,_k_stabilisator
	LDS  R31,_k_stabilisator+1
	LDS  R26,_pwm_kiri
	LDS  R27,_pwm_kiri+1
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	LDS  R26,_pwm_kanan
	LDS  R27,_pwm_kanan+1
	JMP  _atur_pwm

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x41:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	JMP  _atur_pwm

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x42:
	CALL _lcd_putsf
	LDS  R30,_k_stabilisator
	LDS  R31,_k_stabilisator+1
	CALL SUBOPT_0x3B
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x43:
	CALL SUBOPT_0x3B
	CALL _atur_pwm
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	CALL _delay_ms
	LDI  R30,LOW(0)
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x44:
	CALL SUBOPT_0x3D
	CALL __ANEGW1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x45:
	MOVW R26,R30
	CALL _atur_pwm
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	CALL _delay_ms
	LDI  R30,LOW(0)
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x46:
	LDS  R26,_k_stabilisator
	LDS  R27,_k_stabilisator+1
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x47:
	__POINTW1FN _0x0,600
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_detik
	LDS  R31,_detik+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_cacah
	LDS  R31,_cacah+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x48:
	LDI  R30,LOW(0)
	STS  _detik,R30
	STS  _detik+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x49:
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_nilai_adc)
	SBCI R31,HIGH(-_nilai_adc)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_ambang_atas)
	SBCI R27,HIGH(-_ambang_atas)
	RJMP SUBOPT_0x49

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4B:
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_ambang_bawah)
	SBCI R27,HIGH(-_ambang_bawah)
	RJMP SUBOPT_0x49

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4C:
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_ambang_atas)
	SBCI R31,HIGH(-_ambang_atas)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4D:
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_ambang_bawah)
	SBCI R31,HIGH(-_ambang_bawah)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 29 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x4E:
	CALL __EEPROMWRB
	MOV  R26,R16
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4F:
	LDS  R30,_k_stabilisator
	LDS  R31,_k_stabilisator+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x50:
	CALL __CWD1
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x51:
	CLR  R31
	CLR  R22
	CLR  R23
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x52:
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x53:
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_c_delay)
	SBCI R31,HIGH(-_c_delay)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x54:
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_c_timer)
	SBCI R31,HIGH(-_c_timer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x55:
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_c_aksi)
	SBCI R31,HIGH(-_c_aksi)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x56:
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_c_sensor_ki)
	SBCI R31,HIGH(-_c_sensor_ki)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x57:
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_c_sensor_ka)
	SBCI R31,HIGH(-_c_sensor_ka)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x58:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x59:
	__POINTW1FN _0x0,687
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	LDI  R31,0
	ADIW R30,1
	RJMP SUBOPT_0x50

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5A:
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x5B:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5C:
	MOV  R26,R30
	CALL _lcd_putchar
	LDI  R30,LOW(5)
	RJMP SUBOPT_0x5B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5D:
	MOV  R26,R30
	CALL _lcd_putchar
	LDI  R30,LOW(0)
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5E:
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_e_c_delay)
	SBCI R27,HIGH(-_e_c_delay)
	RJMP SUBOPT_0x53

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5F:
	SUBI R26,LOW(-_e_c_aksi)
	SBCI R27,HIGH(-_e_c_aksi)
	RJMP SUBOPT_0x55

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x60:
	SUBI R26,LOW(-_e_c_sensor_ki)
	SBCI R27,HIGH(-_e_c_sensor_ki)
	RJMP SUBOPT_0x56

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x61:
	SUBI R26,LOW(-_e_c_sensor_ka)
	SBCI R27,HIGH(-_e_c_sensor_ka)
	RJMP SUBOPT_0x57

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x62:
	SUBI R26,LOW(-_e_c_timer)
	SBCI R27,HIGH(-_e_c_timer)
	RJMP SUBOPT_0x54

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x63:
	SUBI R26,LOW(-_e_c_cp)
	SBCI R27,HIGH(-_e_c_cp)
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_c_cp)
	SBCI R31,HIGH(-_c_cp)
	LD   R30,Z
	RJMP SUBOPT_0x4E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x64:
	SUBI R26,LOW(-_e_c_invert)
	SBCI R27,HIGH(-_e_c_invert)
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_c_invert)
	SBCI R31,HIGH(-_c_invert)
	LD   R30,Z
	RJMP SUBOPT_0x4E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x65:
	SUBI R26,LOW(-_e_c_laju_ki)
	SBCI R27,HIGH(-_e_c_laju_ki)
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_c_laju_ki)
	SBCI R31,HIGH(-_c_laju_ki)
	LD   R30,Z
	RJMP SUBOPT_0x4E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x66:
	SUBI R26,LOW(-_e_c_laju_ka)
	SBCI R27,HIGH(-_e_c_laju_ka)
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_c_laju_ka)
	SBCI R31,HIGH(-_c_laju_ka)
	LD   R30,Z
	RJMP SUBOPT_0x4E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x67:
	SUBI R26,LOW(-_e_c_laju)
	SBCI R27,HIGH(-_e_c_laju)
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_c_laju)
	SBCI R31,HIGH(-_c_laju)
	LD   R30,Z
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x68:
	LDI  R26,LOW(80)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x69:
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_c_invert)
	SBCI R31,HIGH(-_c_invert)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6A:
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_c_laju_ki)
	SBCI R31,HIGH(-_c_laju_ki)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6B:
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_c_laju_ka)
	SBCI R31,HIGH(-_c_laju_ka)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6C:
	LD   R26,Z
	CALL SUBOPT_0xB
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6D:
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_c_laju)
	SBCI R31,HIGH(-_c_laju)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x6E:
	MOV  R30,R17
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	LDS  R26,_sensor
	LDS  R27,_sensor+1
	OR   R30,R26
	OR   R31,R27
	STS  _sensor,R30
	STS  _sensor+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6F:
	LDS  R30,_sensor
	LDS  R31,_sensor+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x70:
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	STS  _error,R30
	STS  _error+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 44 TIMES, CODE SIZE REDUCTION:83 WORDS
SUBOPT_0x71:
	STS  _error,R30
	STS  _error+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x72:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RJMP SUBOPT_0x71

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x73:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0x71

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x74:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP SUBOPT_0x71

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x75:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0x71

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x76:
	LDI  R30,LOW(0)
	STS  _error,R30
	STS  _error+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x77:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP SUBOPT_0x71

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x78:
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	RJMP SUBOPT_0x71

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x79:
	LDI  R30,LOW(65533)
	LDI  R31,HIGH(65533)
	RJMP SUBOPT_0x71

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7A:
	LDI  R30,LOW(65532)
	LDI  R31,HIGH(65532)
	RJMP SUBOPT_0x71

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7B:
	LDS  R30,_detik
	LDS  R31,_detik+1
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12U
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7C:
	LDS  R30,_c_i
	SUBI R30,-LOW(1)
	STS  _c_i,R30
	LDS  R26,_c_i
	CPI  R26,LOW(0x5A)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7D:
	LDS  R30,_c_i
	LDI  R31,0
	SUBI R30,LOW(-_c_sensor_ki)
	SBCI R31,HIGH(-_c_sensor_ki)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7E:
	LDS  R30,_c_i
	LDI  R31,0
	SUBI R30,LOW(-_c_sensor_ka)
	SBCI R31,HIGH(-_c_sensor_ka)
	LD   R30,Z
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x7F:
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	LDS  R26,_sensor
	LDS  R27,_sensor+1
	AND  R30,R26
	AND  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x80:
	LDS  R30,_c_i
	LDI  R31,0
	SUBI R30,LOW(-_c_laju_ki)
	SBCI R31,HIGH(-_c_laju_ki)
	LD   R30,Z
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_c_i
	LDI  R31,0
	SUBI R30,LOW(-_c_laju_ka)
	SBCI R31,HIGH(-_c_laju_ka)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x81:
	LDS  R30,_error
	LDS  R31,_error+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x82:
	CALL __EEPROMWRB
	MOV  R26,R17
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x83:
	CALL __EEPROMWRB
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x84:
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x85:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x86:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x87:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x88:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x89:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8A:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8B:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8C:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8D:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8E:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8F:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x90:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x91:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x92:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x93:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x94:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x95:
	CALL __GETD1P
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x96:
	CALL SUBOPT_0x91
	RJMP SUBOPT_0x92

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x97:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x98:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x99:
	CALL SUBOPT_0x94
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9A:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x9B:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9C:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9D:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9E:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9F:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA0:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G101
	__DELAY_USW 400
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA1:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA2:
	CALL _strcpyf
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA3:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xA4:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA5:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA6:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA7:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA8:
	__GETD2S 9
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__ASRW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __ASRW12R
__ASRW12L:
	ASR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRW12L
__ASRW12R:
	RET

__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__LNEGW1:
	OR   R30,R31
	LDI  R30,1
	BREQ __LNEGW1F
	LDI  R30,0
__LNEGW1F:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
