
		#GAME PROPERTIES
.eqv	KEY_PRESSED	0xffff0000 
.eqv	BASE_ADDRESS	0x10008000	#starting address of bitmap display
.eqv	REFRESH_RATE	15

.eqv	JUMP		0x77	#w ASCII
.eqv	DOWN		0x78	#x ASCII
.eqv	LEFT		0x61	#a ASCII
.eqv	RIGHT		0x64	#d ASCII
.eqv	ATTACK		0x73 	#s ASCII
.eqv	INTERACT 	0x69	#i ASCII
.eqv	RESTART		0x70	#p ASCII

	#COLOURS
#background.
.eqv	RED		0xff0000
.eqv 	LIGHT_BLUE	0xE0FEFF

#character model
.eqv	BLACK		0x000000
.eqv	ORANGE		0xFFE485
.eqv	GREY		0xE3E6E3
.eqv	BROWN		0x9c7a05

#enemy model
.eqv	GREEN		0x00ff00
.eqv	LIGHT_GREEN	0xA5FC9F


.data 
	yVel:	.word	1
	applyGravity:	.word	0	#bool val for if we should apply gravity or not 
	playerModel: 	.word	272
	

.text

.globl main

#used to reset all data to simulate restarting the game
resetData:
	la $t0, playerModel
	addi $t1, $0, 272
	sw $t1, ($t0)
	
	j main	#return to main loop


generateLevelOne:

generateLevelTwo:

generateLevelThree:


#sets up the display for 1st map
setupDisplay: 
	li $t0, BASE_ADDRESS	#load base address of bitmap display
	
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
COL_START:	
	#first iter.
	bltz $t8, END_COL
	mult 	$t8, $s4
	mflo 	$s0		
	add	$s0, $s0, $t0	#add baseAddress to get current pixelAddress		
	sw	$s2, ($s0)	#change colour of pixelAddress	
		
	subi $t8, $t8, 1	#decrement counter
	j COL_START
	
END_COL:
	jr $ra


#draws the player model onto bitmap display
setupPlayerDisplay:
	#change the pixels in playerModel arr 
	#from background pixels to pixels for the player model
	li $a0, RED
	li $a1, BASE_ADDRESS
	sw $a0, 272($a1)	
	
	jr $ra		#jump back to main loop

###########-> Main Execution<-###########
main:
	jal setupDisplay
	jal setupPlayerDisplay

gameLoop:
	#setup sleep system call for refresh rate 
	li $v0, 32	
	li $a0, REFRESH_RATE
	syscall		
	
	#check for key input
	li $t9, KEY_PRESSED
	lw $t0, ($t9) 		#check if value stored in address KEY_PRESSED == 1
	beq $t0, 1, keyPressed
	
	#apply gravity to player model 
	jal moveDown
	
	j gameLoop	#for testing
	 
	
#check for char collision
#update entities (location)
#update game state
#erase objects' old position
#draw objects' new position

#updates pixel Model 
#Assumes a0 == playerModel Address, a1 == pre-move offset,
updatePlayerModel: 
	#tload colours
	li 	$t0, RED
	li 	$t1, LIGHT_BLUE
	
	#update playerModel variable
	sw 	$a2, ($a0)
	
	#draw new player pixel
	addi 	$a2, $a2, BASE_ADDRESS
	sw	$t0, ($a2)
	
	#replace player pixel with background
	addi	$a1, $a1, BASE_ADDRESS
	sw 	$t1, ($a1)
	
	j gameLoop	#return to gameLoop


#handles key inputs
#can expect a,w,d,x,s,i, or p as input
keyPressed:
	lw $t0, 4($t9)		#get ASCII val of key that was pressed
	beq $t0, RESTART,	restartGame
	beq $t0, JUMP, 		jump
	beq $t0, DOWN,		moveDown
	beq $t0, RIGHT, 	moveRight
	beq $t0, LEFT,		moveLeft
	
	
	j gameLoop	#should only reach here if no key was pressed

restartGame:
	#for testing we can jump to main (since our entire game is defined under main)
	j resetData

jump:
	la $a0, playerModel
	lw $a1, ($a0)
	addi $a2, $a1, -128	#move pixel up 1 layer in bitmap display 
	j updatePlayerModel

moveDown:
	la $a0, playerModel
	lw $a1, ($a0)
	
	
	
	addi $a2, $a1, 128	#move pixel up 1 layer in bitmap display 
	j updatePlayerModel

moveRight:
	la $a0, playerModel
	lw $a1, ($a0)
	addi $a2, $a1, 4	#move pixel up 1 layer in bitmap display 
	j updatePlayerModel

moveLeft:
	la $a0, playerModel
	lw $a1, ($a0)
	addi $a2, $a1, -4	#move pixel up 1 layer in bitmap display 
	j updatePlayerModel
	

attack: 
	


	#exit program
	li $v0, 10
	syscall 
	
	
	#HEART DISPLAY for testing
	li	$s0, RED
	
	li	$t0, 264
	addi	$t0, $t0, BASE_ADDRESS
	sw	$s0, ($t0)
	li	$t1, 396
	addi	$t1, $t1, BASE_ADDRESS
	sw	$s0, ($t1)
	li	$t2, 272
	addi	$t2, $t2, BASE_ADDRESS
	sw	$s0, ($t2)
	
	li	$t0, 280
	addi	$t0, $t0, BASE_ADDRESS
	sw	$s0, ($t0)
	li	$t1, 412
	addi	$t1, $t1, BASE_ADDRESS
	sw	$s0, ($t1)
	li	$t2, 288
	addi	$t2, $t2, BASE_ADDRESS
	sw	$s0, ($t2)
	
	li	$t0, 296
	addi	$t0, $t0, BASE_ADDRESS
	sw	$s0, ($t0)
	li	$t1, 428
	addi	$t1, $t1, BASE_ADDRESS
	sw	$s0, ($t1)
	li	$t2, 304
	addi	$t2, $t2, BASE_ADDRESS
	sw	$s0, ($t2)
	
	
	
	
	
	
	
	
	
	
	
