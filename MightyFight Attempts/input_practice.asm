
.data 
	a: .asciiz "a was pressed"
	w: .asciiz "w was pressed"
	d: .asciiz "d was pressed"
	x: .asciiz "x was pressed"
	
	yVel:	.word	1
	gravity: .word	1	#measures how fast the sprite falls 
	

#character sprite
	playerModel: 	.word	3728 3732 3600 3604 3472 3476 3344 3348  	#our simple model will use 8 pixels => 8*4=32 bytes

	#GAME PROPERTIES
.eqv	KEY_PRESSED	0xffff0000 
.eqv	BASE_ADDRESS	0x10008000	#starting address of bitmap display
.eqv	REFRESH_RATE	45

.eqv	UP	0x77	#w ASCII
.eqv	DOWN	0x78	#x ASCII
.eqv	LEFT	0x61	#a ASCII
.eqv	RIGHT	0x64	#d ASCII
.eqv	ATTACK	0x73 	#s ASCII

	#COLOURS

#background.
.eqv	RED		0xff0000
.eqv	GREEN		0x00ff00
.eqv	LIGHT_GREEN	0xA5FC9F
.eqv 	LIGHT_BLUE	0xE0FEFF

#character model
.eqv	BLACK		0x000000
.eqv	ORANGE		0xFFE485
.eqv	GREY		0xE3E6E3
.eqv	BROWN		0x9c7a05

.text
.globl main

main: 	
	li $t0, BASE_ADDRESS	#load base address of bitmap display
	
#slime enemy
	#load colours 
	li $s1, GREEN
	li $s2, LIGHT_BLUE
	li $s3, RED
	
	li $t8, 1024	#load numOfRemPixels
	li $s4, 4	#load rate of incrementation
	
	#we're gonna test the delay of this by calling to sleep syscall
	li $s7, 1000
	
	#setup syscall to sleep
	addi $v0, $0, 32
	add $a0, $0, $s7
	
	#while (numOfRemPixels > 0): 
COL_START:	#first iter.
		bltz $t8, END_COL
		mult 	$t8, $s4
		mflo 	$s0		
		add	$s0, $s0, $t0	#add baseAddress to get current pixelAddress
		
		sw	$s2, ($s0)	#change colour of pixelAddress	
		
		subi $t8, $t8, 1	#decrement counter
		
		j COL_START
END_COL:

#Sprite Movement 

	#create character model
	li $s0, BASE_ADDRESS
	la $s1, playerModel
	
	li $s7, BLACK
	li $s6, ORANGE
	li $s5, GREY
	li $s4,	BROWN
	li $s2, LIGHT_BLUE
	
	#display character
	sw $s7,	3728($s0)
	sw $s7,	3732($s0)
	
	sw $s4,	3600($s0)
	sw $s4,	3604($s0)
	
	sw $s5,	3472($s0)
	sw $s6,	3476($s0)
	
	sw $s5,	3344($s0)
	sw $s5,	3348($s0)
	
	#Check for keyPressed input
keyPressed:
	li $a3, KEY_PRESSED
	lw $a0, 4($a3)
	
	beq $a0, UP, moveUp
	beq $a0, DOWN, moveDown
	beq $a0, LEFT, moveLeft
	beq $a0, RIGHT, moveRight

moveUp:
	sw $s2,	3728($s0)	#update pixels that will be changed into background
	sw $s2,	3732($s0)	
	
	sw $s7,	3600($s0)	#update player's new pixel positions 
	sw $s7,	3604($s0)
	
	sw $s4,	3472($s0)
	sw $s4,	3476($s0)
	
	sw $s5,	3344($s0)
	sw $s6,	3348($s0)
	
	sw $s5,	3216($s0)
	sw $s5,	3220($s0)
	syscall
	j keyPressed

moveDown:
	sw $s2,	3728($s0)	#update pixels that will be changed into background
	sw $s2,	3732($s0)	
	
	sw $s7,	3600($s0)	#update player's new pixel positions 
	sw $s7,	3604($s0)
	
	sw $s4,	3472($s0)
	sw $s4,	3476($s0)
	
	sw $s5,	3344($s0)
	sw $s6,	3348($s0)
	
	sw $s5,	3216($s0)
	sw $s5,	3220($s0)
	syscall
	j keyPressed

moveLeft:

moveRight:
	#down-movement
	
	
	
	#track the offsets of the character mode, and update them on each keypressed input
	
	
	#exit program
	li $v0, 10 
	syscall 

