		
	#GAME PROPERTIES
.eqv	KEY_PRESSED		0xffff0000 
.eqv	BASE_ADDRESS		0x10008000	#starting address of bitmap display
.eqv	REFRESH_RATE		40

.eqv	JUMP		0x77	#w ASCII
.eqv	LEFT		0x61	#a ASCII
.eqv	DOWN		0x73	#s ASCII
.eqv	RIGHT		0x64	#d ASCII
.eqv	ABILITY		0x71 	#q ASCII
.eqv	INTERACT 	0x65	#e ASCII
.eqv	RESTART		0x70	#p ASCII

	#COLOURS
#map creation
.eqv	PURPLE		0x5E3A6E
.eqv	DARK_PURPLE	0x44304D
.eqv 	LIGHT_PURPLE	0x9353B0

.eqv	BORDER_COLOUR	0xC9C8AF
.eqv	PLATFORM_COLOUR 0xE8E7D3
#.eqv	PLATFORM_COLOUR 0xF5F4DF

#character model
.eqv	BLACK		0x000000
.eqv 	PEACH		0xFFD9D6
.eqv	LIGHT_GREY	0xD1D1D1
.eqv	GREY		0x7D7D7D
.eqv	BROWN		0x915500
.eqv	SWORD_COLOUR	0xD1DEDB
.eqv	PLAYER_RED	0xFF4747

#enemy model
.eqv	GREEN		0x4DBF4D
.eqv	LIGHT_GREEN	0xC1FFBD
.eqv	ENEMY_RED	0xFF7575

#health bar
.eqv	HEALTH_RED		0xFF1100



.data
	#ENTITY MODELS
#each index in the array represents a pixel of the player model on the bitmap display
playerModel:		.word	3724	3728	3596	3600	3468	3472	3340	3344	
playerHealth:		.word	3	#when playerHealth == 0, the game should restart
playerDamaged:		.word	0	# 0 < playerDamaged <= 5 if player is in damaged state. Otherwise playerDamaged == 0

#Level 1 enemies:
#first 4 pixels denote the body, last two pixels denote the health bar
e1m1:			.word	3772	3776	3644	3648	3388	3392
e2m1:			.word	1
e3m3:			.word	1
e4m4:			.word	1


#Level 2 enemies:


#Level 3 enemies:


	#GAME PROPERTIES
playerDirection:		.word	1		#0 => player is facing left, 1 => player is facing right
currLevel:			.word	1		#stores the level that the player is currently on

#enemyHit == 1 iff an enemy has been hit by a sword in the current frame
#This variable is used later (in the same frame) to update enemyHealth
e1m1Hit:			.word	0	#0 == no hits, 1 == 1 hit, 2 == 2 hits (i.e enemy is killed)	
e1m1Direction:			.word	0	#similar to playerDirection
e1m1Position:			.word   0	#used for bounding enemy movement


enemyHitOffset:			.word   0	#stores the offset of enemy
enemyHitCounter:		.word	0	#this acts as a counter for how long the enemies stay red	

#BufferDelays
enemyMovementBuffer:             .word	0	#used as a buffer so that movement updates don't occur every refresh

.text

.globl main

#sequence of steps:

#Calling convention:
#reserve v0-v1 for syscalls OR counters
#use a0-a3 for function calls
#use t0-t8 for temporary storage
#use s0-s7 for longer temporary storage
#caller pushes variables
#callee pops variables 

	#MAP GENERATION
	
#F: sets up the background and border on bitmap display for each level
setupDisplay:
	#load colours
	li $s1, PURPLE
	li $s2, DARK_PURPLE
	li $s3, LIGHT_PURPLE
	li $s4, BORDER_COLOUR

	li $t0, 1024	#load numOfRemPixels
	li $s5, 4	#load rate of incrementation

	#fill screen with pixels
BG_START:
	bltz 	$t0, BG_END		#while (numOfRemPixels > 0): 	
	mult 	$t0, $s5
	mflo 	$t1		
	addi	$t1, $t1, BASE_ADDRESS	#add baseAddress to get current pixelAddress		
	sw	$s1, ($t1)		#change colour of pixelAddress	
		
	subi $t0, $t0, 1		#decrement counter
	j BG_START
BG_END:

	#setup boundaries for the bitmap display
	#t0 == index, t1 == left tracker, t2 == right trackrer, t3 == top tracker, t4 == bottom tracker
	li $t0, 0	#keep track of index
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
BORDER_START:
	bgt 	$t0, 31, BORDER_END
	
	#update left & right borders
	addi 	$s6, $0, 128	#rate of change per pixel change in y
	mult 	$t0, $s6
	mflo	$s7		#s7 == 128*counter 
	#update left-border pixel
	addi	$t1, $s7, 0		#left-most pixel doesn't add extra val to map
	addi	$t1, $t1, BASE_ADDRESS
	sw 	$s4, ($t1)
	#update right-border pixel
	addi	$t2, $s7, 124		#right-most pixel adds 124 to properly map
	addi	$t2, $t2, BASE_ADDRESS
	sw	$s4, ($t2)
	
	#update top & bottom borders
	mult	$t0, $s5	#s5 stores 4, from a previous assignment above
	mflo	$s7		#s7 == 4*counter 
	#update top-border pixel
	addi	$t3, $s7, 0
	addi	$t3, $t3, BASE_ADDRESS
	sw	$s4, ($t3)
	#update bottom-border pixel
	addi	$t4, $s7, 3968
	addi	$t4, $t4, BASE_ADDRESS
	sw	$s4, ($t4)
	
	#increment index counter
	addi 	$t0, $t0, 1
	j BORDER_START
BORDER_END:
	
	#add an additional row for floor
	li 	$t0, 0 
	li 	$t1, 0 
FLOOR_START:
	bgt	$t0, 31, FLOOR_END
	
	mult 	$t0, $s5
	mflo 	$t2
	addi 	$t1, $t2, 3840		#add the offset + 30*32*4
	addi 	$t1, $t1, BASE_ADDRESS
	sw	$s4, ($t1)
	#increment index counter
	addi $t0, $t0, 1
	j FLOOR_START
FLOOR_END:
	
	jr $ra	#return to caller	


#NOTATION USED FOR MAPS:
#U1M1 => unpassible platform #1 for map 1, P1M2 => passible platform #1 for map 2, and so on...
#F: redraws the platforms for level currentLevel
refreshPlatforms:
	#determine the level we want to update platforms for
	la	$a0, currLevel		
	lw	$a0, ($a0)
	beq	$a0, 1,	REFRESH_LEVEL_ONE
	beq	$a0, 2, REFRESH_LEVEL_TWO

REFRESH_LEVEL_ONE:
	li	$a0, PLATFORM_COLOUR		#load plaform colour	
	#P1M1:	x->24-28, y->27
	li	$a1, BASE_ADDRESS		
	addi	$a1, $a1, 3552			#compute bitmap address of platform's starting pixel 
	sw	$a0, ($a1)
	sw	$a0, 4($a1)
	sw	$a0, 8($a1)
	sw	$a0, 12($a1)
	sw	$a0, 16($a1)
	sw	$a0, 20($a1)
	
	#P2M1:	x->25-27, y->24
	li	$a1, BASE_ADDRESS		
	addi	$a1, $a1, 3176			#compute bitmap address of platform's starting pixel 
	sw	$a0, ($a1)
	sw	$a0, 4($a1)
	sw	$a0, 8($a1)
	
	#P2M1:	x->27-29, y->21
	li	$a1, BASE_ADDRESS		
	addi	$a1, $a1, 2796			#compute bitmap address of platform's starting pixel 
	sw	$a0, ($a1)
	sw	$a0, 4($a1)
	sw	$a0, 8($a1)
	
	#P2M1:	x->25-27, y->18
	li	$a1, BASE_ADDRESS		
	addi	$a1, $a1, 2404			#compute bitmap address of platform's starting pixel 
	sw	$a0, ($a1)
	sw	$a0, 4($a1)
	sw	$a0, 8($a1)

REFRESH_LEVEL_TWO:
	jr $ra					#return to gameLoop
	
#F: draws level one onto the bitmap display & loads enemies
generateLevelOne:
	#setup entrances
	#add unpassible platforms (use BORDER_COLOUR)

	#U1M1: y-> 23-18, x->1-20
	li	$a0, 18	#y-counter
U1M1_OUTER_START:
	beq 	$a0, 23, U1M1_OUTER_END		#branch when y == 23
	
	li	$a1, 1	#x-counter		#reset x-counter each iteration
U1M1_INNER_START:
	beq	$a1, 23, U1M1_INNER_END		#branch when x == 23

	#compute bitmap address == (y*32 + x)*4 + BASE_ADDRESS
	addi 	$t0, $0, 32
	mult	$a0, $t0			#y*32
	mflo	$t0				
	add	$t0, $t0, $a1			#t0 == y*32 + x
	li	$t1, 4
	mult	$t0, $t1			#(y*32 + x)*4
	mflo	$t0				#t0 == (y*32 + x)*4
	addi	$t0, $t0, BASE_ADDRESS		#t0 is now equal to valid bitmap address
	#update the pixel @ bitmap address stored in t0
	li	$t1, BORDER_COLOUR
	sw	$t1, ($t0)		
	#increment x-counter
	addi	$a1, $a1, 1
	j U1M1_INNER_START			#return to start of loop
U1M1_INNER_END:

	#increment y-counter
	addi	$a0, $a0, 1
	j U1M1_OUTER_START
U1M1_OUTER_END:


	#U1M2: y-> 10-8, x-> 10 - 30 
	li	$a0, 8	#y-counter
U2M1_OUTER_START:
	beq 	$a0, 11, U2M1_OUTER_END		#branch when y == 11
	
	li	$a1, 10	#x-counter		#reset x-counter each iteration
U2M1_INNER_START:
	beq	$a1, 31, U2M1_INNER_END		#branch when x == 31

	#compute bitmap address == (y*32 + x)*4 + BASE_ADDRESS
	addi 	$t0, $0, 32
	mult	$a0, $t0			#y*32
	mflo	$t0				
	add	$t0, $t0, $a1			#t0 == y*32 + x
	li	$t1, 4
	mult	$t0, $t1			#(y*32 + x)*4
	mflo	$t0				#t0 == (y*32 + x)*4
	addi	$t0, $t0, BASE_ADDRESS		#t0 is now equal to valid bitmap address
	#update the pixel @ bitmap address stored in t0
	li	$t1, BORDER_COLOUR
	sw	$t1, ($t0)		
	#increment x-counter
	addi	$a1, $a1, 1
	j U2M1_INNER_START			#return to start of loop
U2M1_INNER_END:

	#increment y-counter
	addi	$a0, $a0, 1
	j U2M1_OUTER_START
U2M1_OUTER_END:
	
	#setup warrior playerModel
	addi	$sp, $sp, -4	#make room for return address
	sw	$ra, ($sp)	#push return address onto stack
	jal	setupWarrior
	lw	$ra, 0($sp) 	#pop return address from stack
	addi	$sp, $sp, 4	#update sp
	
	jr $ra			#return to caller

#F: draws level two onto the bitmap display
generateLevelTwo:


#F: draws level three onto the bitmap display
generateLevelThree:



		#ENEMY MODEL GENERATION
	
#F: loads enemies onto map for level currLevel, based on 
loadEnemies:
	#determine current level
	la	$a0, currLevel
	lw	$a0, ($a0)
	beq	$a0, 1, LOAD_LEVEL_ONE_ENEMIES_START
	beq	$a0, 2, LOAD_LEVEL_TWO_ENEMIES
	
	#otherwise LOAD_LEVEL_THREE_ENEMIES

#t0-t5 will be used to store bitmap addresses of enemyModel
#store colours in a1-a2
LOAD_LEVEL_ONE_ENEMIES_START:
	#load e1m1 offsets (e1m1[0:5])
	la	$a0, e1m1		#load memory address of e1m1[0]
	lw	$a0, ($a0)		#load offset stored in e1m1[0]
	addi	$t0, $a0, BASE_ADDRESS	#compute bitmap address of e1m1[0]
	addi	$t1, $t0, 4		#compute bitmap address of e1m1[1]
	addi	$t3, $t1, -128		#compute bitmap address of e1m1[3]
	addi	$t2, $t3, -4		#compute bitmap address of e1m1[2]
	addi	$t4, $t2, -256		#compute bitmap address of e1m1[4]
	addi	$t5, $t4, 4		#compute bitmap address of e1m1[5]
	
	#redraw pixel at bitmap addresses
	#load colours
	li	$a1, LIGHT_GREEN	#colour for enemyModel's body
	li	$a2, GREEN		#colour for enemyModel's health bar
	li	$a3, ENEMY_RED
	
	#Check whether enemy is DAMGED or KILLED via e1m1Hit variable
	la	$a0, e1m1Hit
	lw	$a0, ($a0)			#load e1m1Hit value
	beq	$a0, 2, e1m1_KILLED		#branch if enemy has been hit twice/killed
	beq	$a0, 1, e1m1_DAMAGED1		#branch if enemy has been recently or previously hit	
	
	#otherwise load the enemies as normal
	sw	$a1, ($t0)		#enemyModel[0]
	sw	$a1, ($t1)		#enemyModel[1]
	sw	$a1, ($t2)		#enemyModel[2]
	sw	$a1, ($t3)		#enemyModel[3]
	sw	$a2, ($t4)		#enemyModel[4]
	sw	$a2, ($t5)		#enemyModel[5]
	j e1m1_LOAD_END
	
e1m1_DAMAGED1:
	sw	$a2, ($t4)		#enemyModel[4]
	sw	$a3, ($t5)		#enemyModel[5]
	
	#if enemyHitCounter == 0, then enemy should be green, otherwise branch to make enemy red
	la	$a0, enemyHitCounter	
	lw	$a0, ($a0)		#load value in enemyHitCounter		
	bgtz	$a0, e1m1_DAMAGED2	
	
	#Otherwise, make enemy green
	sw	$a1, ($t0)		#enemyModel[0]
	sw	$a1, ($t1)		#enemyModel[1]
	sw	$a1, ($t2)		#enemyModel[2]
	sw	$a1, ($t3)		#enemyModel[3]
	j e1m1_LOAD_END

e1m1_DAMAGED2:
	#make enemy red
	sw	$a3, ($t0)		#enemyModel[0]
	sw	$a3, ($t1)		#enemyModel[1]
	sw	$a3, ($t2)		#enemyModel[2]
	sw	$a3, ($t3)		#enemyModel[3]
	j e1m1_LOAD_END

e1m1_KILLED:
	li	$a0, PURPLE		#load purple
	#replace enemy colours with background colours
	sw	$a0, ($t0)		#enemyModel[0]
	sw	$a0, ($t1)		#enemyModel[1]
	sw	$a0, ($t2)		#enemyModel[2]
	sw	$a0, ($t3)		#enemyModel[3]
	sw	$a0, ($t3)		#enemyModel[4]
	sw	$a0, ($t3)		#enemyModel[5]
	j e1m1_LOAD_END
e1m1_LOAD_END:

LOAD_LEVEL_ONE_ENEMIES_END:

LOAD_LEVEL_TWO_ENEMIES:

	jr $ra	#return to gameLoop

	#COLLISION HANDLING

#F: checks if playerModel is touching enemy Model 
#assumes that enemyModels are overlapping playerModels by this point 
enemyCollision:
	#load variables
	la	$a0, playerModel
	lw	$a0, ($a0)		#get first playerModel offset
	addi	$a0, $a0, BASE_ADDRESS	#compute bitmap address[0]
	
	#check if any of playerModels bitmap address colour == LIGHT_GREEN
	lw	$a1, ($a0)		#load colour
	beq 	$a1, LIGHT_GREEN, $enemyCollisionTrue
	
	addi	$a0, $a0, 4		#compute bitmap address[1]
	lw	$a1, ($a0)		#load colour
	beq 	$a1, LIGHT_GREEN, $enemyCollisionTrue
	
	addi	$a0, $a0, -128		#compute bitmap address[3]
	lw	$a1, ($a0)		#load colour
	beq 	$a1, LIGHT_GREEN, $enemyCollisionTrue
	
	addi	$a0, $a0, -4		#compute bitmap address[2]
	lw	$a1, ($a0)		#load colour
	beq 	$a1, LIGHT_GREEN, $enemyCollisionTrue
	
	addi	$a0, $a0, -128		#compute bitmap address[4]
	lw	$a1, ($a0)		#load colour
	beq 	$a1, LIGHT_GREEN, $enemyCollisionTrue
	
	addi	$a0, $a0, 4		#compute bitmap address[5]
	lw	$a1, ($a0)		#load colour
	beq 	$a1, LIGHT_GREEN, $enemyCollisionTrue
	
	addi	$a0, $a0, -128		#compute bitmap address[7]
	lw	$a1, ($a0)		#load colour
	beq 	$a1, LIGHT_GREEN, $enemyCollisionTrue
	
	addi	$a0, $a0, -4		#compute bitmap address[6]
	lw	$a1, ($a0)		#load colour
	beq 	$a1, LIGHT_GREEN, $enemyCollisionTrue
	#otherwise, player and enemy are not touching
	j	enemyCollisionFalse
	
enemyCollisionTrue:
	


enemyCollisionFalse:

	jr	$ra	#return to gameLoop


	#PLAYER MODEL GENERATION	
	
#F: draws the player model (warrior) for first level
setupWarrior:
	#load colours
	li $s0, PEACH
	li $s1, LIGHT_GREY
	li $s2, GREY
	li $s3, BLACK
	
	#load pixel offsets
	li	$t0, 3724
	addi	$t0, $t0, BASE_ADDRESS
	li	$t1, 3728
	addi	$t1, $t1 BASE_ADDRESS
	li	$t2, 3596
	addi	$t2, $t2 BASE_ADDRESS
	li	$t3, 3600
	addi	$t3, $t3 BASE_ADDRESS
	li	$t4, 3468
	addi	$t4, $t4 BASE_ADDRESS
	li	$t5, 3472
	addi	$t5, $t5 BASE_ADDRESS
	li	$t6, 3340
	addi	$t6, $t6 BASE_ADDRESS
	li	$t7, 3344
	addi	$t7, $t7 BASE_ADDRESS

	#update pixels
	sw	$s3, ($t0)
	sw	$s3, ($t1)
	sw	$s2, ($t2)
	sw	$s2, ($t3)
	sw	$s1, ($t4)
	sw	$s0, ($t5)
	sw	$s1, ($t6)
	sw	$s1, ($t7)
	
	jr $ra	#return to generateLevelOne
	
setupMage:

setupArcher:

#F: refreshes/redraws the playerModel
refreshPlayerModel:
	#load playerModel
	la	$a0, playerModel

	#update the playerModel array & playerModel drawing on bitmap display
	#update arr[0:1]
	li	$a1, BLACK		#load black
	lw	$t0, ($a0)
	addi	$t0, $t0, BASE_ADDRESS
	sw	$a1, ($t0)
	lw	$t1, 4($a0)
	addi	$t1, $t1, BASE_ADDRESS
	sw	$a1, ($t1)
	#update arr[2:3]
	li	$a1, GREY		#load grey
	lw	$t2, 8($a0)
	addi	$t2, $t2, BASE_ADDRESS
	sw	$a1, ($t2)
	lw	$t3, 12($a0)
	addi	$t3, $t3, BASE_ADDRESS
	sw	$a1, ($t3)
	#update arr[4:5]
	li	$a1, LIGHT_GREY		#load light grey 
	li	$a2, PEACH		#load peach
	lw	$t4, 16($a0)
	addi	$t4, $t4, BASE_ADDRESS	#compute address for new 4th pixel
	lw	$t5, 20($a0)
	addi	$t5, $t5, BASE_ADDRESS	#compute address for new 5th pixel
	
	la	$t8, playerDirection			#get address of playerDirection variable	
	lw	$t8, ($t8)				#t8 == val of playerDirection
	beq	$t8, 0, PLAYER_FACING_LEFT1
	#otherwise player is FacingRight
	sw	$a1, ($t4)		
	sw	$a2, ($t5)
	j PLAYER_FACING_RIGHT1				#j PLAYER_FACING_RIGHT1 skips playerFacingLeft
PLAYER_FACING_LEFT1:
	sw	$a2, ($t4)		
	sw	$a1, ($t5)	
PLAYER_FACING_RIGHT1:
	#update arr[6:7] (light grey already stored in a1)
	lw	$t6, 24($a0)
	addi	$t6, $t6, BASE_ADDRESS
	sw	$a1, ($t6)
	lw	$t7, 28($a0)
	addi	$t7, $t7, BASE_ADDRESS
	sw	$a1, ($t7)
	
	jr $ra	#return to gameLoop
	

#F: updates playerModel array and replaces old character model with updated model
#Assumes t0-t7 == old offsets, s0-s7 == new offsets
updatePlayerModel:

	#check if any new offsets are == LIGHT_GREEN (i.e playerModel is touching enemy)
	addi	$a0, $s0, BASE_ADDRESS	#compute bitmap address of newPlayerModel[0]
	lw	$a1, ($a0)		#load colour at address of newPlayerModel[0]
	beq	$a1, LIGHT_GREEN, UPDATE_PLAYER_DAMAGED
	addi	$a0, $a0, 4		#compute bitmap address of newPlayerModel[1]
	lw	$a1, ($a0)		#load colour at address of newPlayerModel[1]
	beq	$a1, LIGHT_GREEN, UPDATE_PLAYER_DAMAGED
	addi	$a0, $a0, -128		#compute bitmap address of newPlayerModel[3]
	lw	$a1, ($a0)		#load colour at address of newPlayerModel[3]
	beq	$a1, LIGHT_GREEN, UPDATE_PLAYER_DAMAGED
	addi	$a0, $a0, -4		#compute bitmap address of newPlayerModel[2]
	lw	$a1, ($a0)		#load colour at address of newPlayerModel[2]
	beq	$a1, LIGHT_GREEN, UPDATE_PLAYER_DAMAGED
	addi	$a0, $a0, -128		#compute bitmap address of newPlayerModel[4]
	lw	$a1, ($a0)		#load colour at address of newPlayerModel[4]
	beq	$a1, LIGHT_GREEN, UPDATE_PLAYER_DAMAGED
	addi	$a0, $a0, 4		#compute bitmap address of newPlayerModel[5]
	lw	$a1, ($a0)		#load colour at address of newPlayerModel[5]
	beq	$a1, LIGHT_GREEN, UPDATE_PLAYER_DAMAGED
	addi	$a0, $a0, -128		#compute bitmap address of newPlayerModel[7]
	lw	$a1, ($a0)		#load colour at address of newPlayerModel[7]
	beq	$a1, LIGHT_GREEN, UPDATE_PLAYER_DAMAGED
	addi	$a0, $a0, -4		#compute bitmap address of newPlayerModel[6]
	lw	$a1, ($a0)		#load colour at address of newPlayerModel[6]
	beq	$a1, LIGHT_GREEN, UPDATE_PLAYER_DAMAGED
	#if all cases fail, don't update playerDamaged
	j	UPDATE_PLAYER_DAMAGED_END	
	
UPDATE_PLAYER_DAMAGED:
	#if playerDamaged > 0, then skip this assignment
	la	$a0, playerDamaged
	lw	$a1, ($a0)
	bgtz    $a1, UPDATE_PLAYER_DAMAGED_END
	#else set playerDamaged = 1
	li	$a1, 1
	sw	$a1, ($a0)
UPDATE_PLAYER_DAMAGED_END:

	#load playerModel
	la	$a0, playerModel
	
	#before updating playerModel, replace the old playerModel with purple pixels
	li	$a1, PURPLE		#load purple
	addi	$t0, $t0, BASE_ADDRESS	#compute t0 == bitmap address
	sw	$a1, ($t0)		#fill old arr[0] with purple
	addi	$t1, $t1, BASE_ADDRESS	
	sw	$a1, ($t1)		
	addi	$t2, $t2, BASE_ADDRESS	
	sw	$a1, ($t2)		
	addi	$t3, $t3, BASE_ADDRESS	
	sw	$a1, ($t3)		
	addi	$t4, $t4, BASE_ADDRESS	
	sw	$a1, ($t4)		
	addi	$t5, $t5, BASE_ADDRESS	
	sw	$a1, ($t5)		
	addi	$t6, $t6, BASE_ADDRESS	
	sw	$a1, ($t6)		
	addi	$t7, $t7, BASE_ADDRESS	
	sw	$a1, ($t7)		
	
	#update the playerModel array & playerModel drawing on bitmap display
	#new arr[0:1]
	li	$a1, BLACK		#load Black
	sw	$s0, ($a0)		#store new offset into playerModel arr
	addi	$s0, $s0, BASE_ADDRESS	#compute pixel's new bitmap address
	sw	$a1, ($s0)		#update new pixel's colour
	sw	$s1, 4($a0)
	addi	$s1, $s1, BASE_ADDRESS
	sw	$a1, ($s1)		
	#new arr[2:3]
	li	$a1, GREY		#load grey
	sw	$s2, 8($a0)
	addi	$s2, $s2, BASE_ADDRESS
	sw	$a1, ($s2)		
	sw	$s3, 12($a0)
	addi	$s3, $s3, BASE_ADDRESS
	sw	$a1, ($s3)		
	#new arr[4:5] => should update pixel based on playerDirection
	li	$a1, LIGHT_GREY		#load light grey 
	li	$a2, PEACH		#load peach
	sw	$s4, 16($a0)
	addi	$s4, $s4, BASE_ADDRESS	#compute address for new 4th pixel
	sw	$s5, 20($a0)
	addi	$s5, $s5, BASE_ADDRESS	#compute address for new 5th pixel
	
	la	$t8, playerDirection			#get address of playerDirection variable	
	lw	$t8, ($t8)				#t8 == val of playerDirection
	beq	$t8, 0, PLAYER_FACING_LEFT2
	#otherwise player is FacingRight
	sw	$a1, ($s4)		
	sw	$a2, ($s5)
	j PLAYER_FACING_RIGHT2				#j PLAYER_FACING_RIGHT skips the updates for playerFacingLeft
PLAYER_FACING_LEFT2:
	sw	$a2, ($s4)		
	sw	$a1, ($s5)	
PLAYER_FACING_RIGHT2:
	#new arr[6:7]
	sw	$s6, 24($a0)
	addi	$s6, $s6, BASE_ADDRESS
	sw	$a1, ($s6)		
	sw	$s7, 28($a0)
	addi	$s7, $s7, BASE_ADDRESS
	sw	$a1, ($s7)		
	
	#now that the playerModel has been updated, updatePlayerHealth + damage indicator if playerDamaged == 1
	la	$a0, playerDamaged		
	lw	$a0, ($a0)				#load value in playerDamaged
	bne	$a0, 1, UPDATE_PLAYER_HEALTH_END	#branch if playerDamaged != 1
	
	#call to updatePlayerHealth
	addi	$sp, $sp, -4
	sw	$ra, ($sp)				#push ra to stack
	jal updatePlayerHealth 
	lw	$ra, ($sp)				#pop ra from stack
	addi	$sp, $sp, 4		

UPDATE_PLAYER_HEALTH_END:
	jr $ra	#return to playerMoveUp OR playerMoveRight ... and so on ... 


	#KEYBOARD INPUT HANDLING & PLAYER MOVEMENT

KEY_PRESSED_START:
	lw	$t1, 4($s0)			#assume from caller, s0 == KEY_PRESSED
	#every branch handling some keyboard input, 
	#should return to KEY_PRESSED_END found in GAMELOOP
	beq	$t1, RESTART, restartGame
	beq	$t1, JUMP, playerJump 
	beq	$t1, LEFT, playerMoveLeft
	beq	$t1, DOWN, playerMoveDown
	beq	$t1, RIGHT, playerMoveRight
	beq	$t1, ABILITY, playerAbility
	
	j KEY_PRESSED_END	#return to gameloop


restartGame:


#F: moves the player model a total of 3 units, wherein there is a slight delay between each unit up
playerJump:
	#initilaize counter for number of units moved up, v1 = 0
	li	$v1, 0
	#undergo jump iff player is touching the ground/platform
	la	$a0, playerModel
	lw	$a1, ($a0)				#load left bottom pixel's offset from playerModel
	lw	$a2, 4($a0)				#load right bottom pixel's offset from playerModel
	addi	$a1, $a1, 128				#move offset one layer down
	addi	$a2, $a2, 128				#move offset one layer down
	addi	$a1, $a1, BASE_ADDRESS			#compute new pixel's address
	addi	$a2, $a2, BASE_ADDRESS			#compute new pixel's address
	lw	$a1, ($a1)				#load the colour that is located at new bitmap address
	lw	$a2, ($a2)				#load the colour that is located at new bitmap address
	#commence jump_start if playerModel is currently atop a platform/the ground
	beq	$a1, BORDER_COLOUR, JUMP_START 	
	beq	$a2, BORDER_COLOUR, JUMP_START
	beq	$a1, PLATFORM_COLOUR, JUMP_START
	beq	$a2, PLATFORM_COLOUR, JUMP_START
	
	j KEY_PRESSED_END 				#skip JUMP_START if playerModel is not touching ground/floor platform
		
JUMP_START:	
	beq $v1, 3, JUMP_END	#branch if player moves 3 pixels up
	
	jal playerMoveUp
	#increment counter
	addi $v1, $v1, 1
	#call sleep to give illusion of jumping
	li $v0, 32
	li $a0, 40
	syscall 
	j JUMP_START
JUMP_END:
	#stay at top of jump for a bit of time 
	li $a0, 20
	syscall
	
	j KEY_PRESSED_END
	#jal generateLevelOne	#we really just need this to redraw the platforms 



#F: moves playerModel up one unit and updates its playerModel arr
playerMoveUp:
	#load new player model offsets
	#s0 - s7, will hold the new offests post-movement
	
	#load current position of playermodel
	la	$a0, playerModel  
	lw	$t0, ($a0)
	lw	$t1, 4($a0)
	lw	$t2, 8($a0)
	lw	$t3, 12($a0)
	lw	$t4, 16($a0)
	lw	$t5, 20($a0)
	lw	$t6, 24($a0)
	lw	$t7, 28($a0)
	#compute new offset of playerModel
	addi	$s0, $t0, -128
	addi	$s1, $t1, -128
	addi	$s2, $t2, -128
	addi	$s3, $t3, -128
	addi	$s4, $t4, -128
	addi	$s5, $t5, -128
	addi	$s6, $t6, -128
	addi	$s7, $t7, -128
	
	addi 	$sp, $sp, -4	#push ra to stack
	sw  	$ra, ($sp) 
	jal updatePlayerModel
	lw	$ra, ($sp) 	#pop ra from stack
	addi	$sp, $sp, 4
	
	jr $ra	#return to playerJump			



#F: moves playerModel one unit to the left, and upodates playerDirection
playerMoveLeft:
	#load new player model offsets
	#s0 - s7, will hold the new offests post-movement
	
	#load current position of playermodel
	la	$a0, playerModel  
	lw	$t0, ($a0)
	lw	$t1, 4($a0)
	lw	$t2, 8($a0)
	lw	$t3, 12($a0)
	lw	$t4, 16($a0)
	lw	$t5, 20($a0)
	lw	$t6, 24($a0)
	lw	$t7, 28($a0)
	#compute new offset of playerModel
	addi	$s0, $t0, -4
	addi	$s1, $t1, -4
	addi	$s2, $t2, -4
	addi	$s3, $t3, -4
	addi	$s4, $t4, -4
	addi	$s5, $t5, -4
	addi	$s6, $t6, -4
	addi	$s7, $t7, -4
	
	#check for possible collisions before redrawing
	#check for arr[0]
	addi	$a0, $s0, BASE_ADDRESS 
	lw	$a0, ($a0)					#load the colour that is located at bitmap address of $s0
	beq	$a0, BORDER_COLOUR, SKIP_PLAYER_MOVE_LEFT	#see if it will collide with an edge 
	#check for arr[2]
	addi	$a0, $s2, BASE_ADDRESS
	lw	$a0, ($a0)
	beq	$a0, BORDER_COLOUR, SKIP_PLAYER_MOVE_LEFT
	#check for arr[4]
	addi	$a0, $s4, BASE_ADDRESS
	lw	$a0, ($a0)
	beq	$a0, BORDER_COLOUR, SKIP_PLAYER_MOVE_LEFT
	#check for arr[6]
	addi	$a0, $s6, BASE_ADDRESS
	lw	$a0, ($a0)
	beq	$a0, BORDER_COLOUR, SKIP_PLAYER_MOVE_LEFT
	
	#if playerModel does NOT invoke collision, update playerDirection and its model
	#update playerDirection
	la 	$a0, playerDirection
	li	$a1, 0
	sw 	$a1, ($a0)		#playerDirection == 0 => player facing left
	#update playerModel
	jal updatePlayerModel
	
SKIP_PLAYER_MOVE_LEFT:
	j KEY_PRESSED_END	#return to gameloop



#F: moves playerModel one unit to the right, and upodates playerDirection
playerMoveRight:
	#load new player model offsets
	#s0 - s7, will hold the new offsets post-movement
	
	#load current position of playermodel
	la	$a0, playerModel  
	lw	$t0, ($a0)
	lw	$t1, 4($a0)
	lw	$t2, 8($a0)
	lw	$t3, 12($a0)
	lw	$t4, 16($a0)
	lw	$t5, 20($a0)
	lw	$t6, 24($a0)
	lw	$t7, 28($a0)
	#compute new offset of playerModel
	addi	$s0, $t0, 4
	addi	$s1, $t1, 4
	addi	$s2, $t2, 4
	addi	$s3, $t3, 4
	addi	$s4, $t4, 4
	addi	$s5, $t5, 4
	addi	$s6, $t6, 4
	addi	$s7, $t7, 4
	
	#check for possible collisions before redrawing
	#check for arr[1]
	addi	$a0, $s1, BASE_ADDRESS 
	lw	$a0, ($a0)					#load the colour that is located at bitmap address of $s0
	beq	$a0, BORDER_COLOUR, SKIP_PLAYER_MOVE_RIGHT	#see if it will collide with an edge 
	#check for arr[3]
	addi	$a0, $s3, BASE_ADDRESS
	lw	$a0, ($a0)
	beq	$a0, BORDER_COLOUR, SKIP_PLAYER_MOVE_RIGHT
	#check for arr[5]
	addi	$a0, $s5, BASE_ADDRESS
	lw	$a0, ($a0)
	beq	$a0, BORDER_COLOUR, SKIP_PLAYER_MOVE_RIGHT
	#check for arr[7]
	addi	$a0, $s7, BASE_ADDRESS
	lw	$a0, ($a0)
	beq	$a0, BORDER_COLOUR, SKIP_PLAYER_MOVE_RIGHT
	
	#if playerModel does NOT invoke collision, update playerDirection and its model
	#update playerDirection
	la 	$a0, playerDirection
	li	$a1, 1
	sw 	$a1, ($a0)		#playerDirection == 1 => player facing right
	
	#update playerModel
	jal updatePlayerModel

SKIP_PLAYER_MOVE_RIGHT:	
	j KEY_PRESSED_END	#return to gameloop

#allows a player to drop down from a platform, otherwise does nothing
playerMoveDown:
	#load new player model offsets
	#s0 - s7, will hold the new offests post-movement
	
	#load current position of playermodel
	la	$a0, playerModel  
	lw	$t0, ($a0)
	lw	$t1, 4($a0)
	lw	$t2, 8($a0)
	lw	$t3, 12($a0)
	lw	$t4, 16($a0)
	lw	$t5, 20($a0)
	lw	$t6, 24($a0)
	lw	$t7, 28($a0)
	#compute new offset of playerModel
	addi	$s0, $t0, 128
	addi	$s1, $t1, 128
	addi	$s2, $t2, 128
	addi	$s3, $t3, 128
	addi	$s4, $t4, 128
	addi	$s5, $t5, 128
	addi	$s6, $t6, 128
	addi	$s7, $t7, 128
	
	#check if player is currently on a platform
	#left-foot
	addi	$a0, $s0, BASE_ADDRESS
	lw	$a0, ($a0)
	beq	$a0, PLATFORM_COLOUR, PLAYER_MOVE_DOWN_START 
	#right-foot
	addi	$a0, $s1, BASE_ADDRESS
	lw	$a0, ($a0)
	beq	$a0, PLATFORM_COLOUR, PLAYER_MOVE_DOWN_START 
	#otherwise, skip the playerModel update
	j SKIP_PLAYER_MOVE_DOWN
	
PLAYER_MOVE_DOWN_START:
	jal	updatePlayerModel	#function call to update the playerModel
	
SKIP_PLAYER_MOVE_DOWN:
	j	KEY_PRESSED_END		#return to gameLoop

	
	
#F:performs an ability based on level currLevel
#1->stab attack, 2->temp invis, 3->shoot arrow
#LEVEL_ONE_ABILITY:
	#a0 & v0 reserved for syscall
	#a1-a2 reserved for colours
	#t0-t1 reserved for player pixels
playerAbility:
	#retrieve currLevel and decide which branch to execute
	la	$t0, currLevel
	lw	$t0, ($t0)
	beq	$t0, 1, LEVEL_ONE_ABILITY
	
LEVEL_ONE_ABILITY:
	#we need to check for playerDirection!
	la 	$t0, playerDirection
	lw	$t0, ($t0)
	#branch if playerModel is facing left
	beq	$t0, 0, LEVEL_ONE_ABILITY_LEFT_START	
	
	#RIGHT-FACING ATTACK
	#we start at pixel [3]
	#load playerModel
	la	$t0, playerModel	#load playerModel
	
	#prep call sleep w/ 20ms delay
	li	$a0, 30
	li	$v0, 32
	
	#perform attack animation
	#NOTE: every sword pixel must make a call to updateEnemyHealth to see if the pixel overlaps with an enemy bitmap address
	#This will require us to push to the bitmap address to the stack
	li	$a1, SWORD_COLOUR		#load sword colour
	li	$a2, PURPLE			#load background colour
	
	lw	$t1, 12($t0)			#load [3] pixel of playerModel
	#first pixel
	addi	$t1, $t1, 4			#load offset of pixel to right of [3]
	addi	$t1, $t1, BASE_ADDRESS		#compute bit address for pixel to the right of third pixel of playerModel
	addi	$sp, $sp, -4
	sw	$ra, ($sp)			#push ra to stack
	addi	$sp, $sp, -4
	sw	$t1, ($sp)			#push bitmapAddress to stack
	jal	updateEnemyHealth
	lw	$ra, ($sp)			#pop ra from stack
	addi	$sp, $sp, 4
	sw	$a1, ($t1)			#update pixel colour to sword
	
	#second pixel
	addi	$t1, $t1, -128			#adjust bitmap address to pixel above first pixel
	addi	$sp, $sp, -4
	sw	$ra, ($sp)			#push ra to stack
	addi	$sp, $sp, -4
	sw	$t1, ($sp)			#push bitmapAddress to stack
	jal	updateEnemyHealth
	lw	$ra, ($sp)			#pop ra from stack
	addi	$sp, $sp, 4
	sw	$a1, ($t1) 			#update pixel colour to sword
	syscall					
	#remove second pixel
	sw	$a2, ($t1) 			
	
	#third pixel
	addi	$t1, $t1, 4			#adjust bitmap address to the right of second pixel
	addi	$sp, $sp, -4
	sw	$ra, ($sp)			#push ra to stack
	addi	$sp, $sp, -4
	sw	$t1, ($sp)			#push bitmapAddress to stack
	jal	updateEnemyHealth
	lw	$ra, ($sp)			#pop ra from stack
	addi	$sp, $sp, 4
	sw	$a1, ($t1)			#update pixel to sword
	syscall
	#remove third pixel
	sw	$a2, ($t1)			
	
	#fourth pixel
	addi	$t1, $t1, 128			#adjust bitmap address to pixel below third pixel
	addi	$sp, $sp, -4
	sw	$ra, ($sp)			#push ra to stack
	addi	$sp, $sp, -4
	sw	$t1, ($sp)			#push bitmapAddress to stack
	jal	updateEnemyHealth
	lw	$ra, ($sp)			#pop ra from stack
	addi	$sp, $sp, 4
	sw	$a1, ($t1)			#update pixel to sword
	syscall					
	#remove fourth pixel
	sw	$a2, ($t1)			
	syscall					
	#remove first pixel
	addi	$t1, $t1, -4			#first pixel is to the left of fourth pixel's bitmap address
	sw	$a2, ($t1)				
	j LEVEL_ONE_ABILITY_LEFT_END		
	
	#LEFT-FACING ATTACK
LEVEL_ONE_ABILITY_LEFT_START:
	#we start at pixel [2]
	#load playerModel
	la	$t0, playerModel	#load playerModel
	
	#prep call sleep w/ 20ms delay
	li	$a0, 30
	li	$v0, 32
	
	#perform attack animation
	#NOTE: every sword pixel must make a call to updateEnemyHealth to see if the pixel overlaps with an enemy bitmap address
	#This will require us to push to the bitmap address to the stack
	li	$a1, SWORD_COLOUR		#load sword colour
	li	$a2, PURPLE			#load background colour
	
	lw	$t1, 8($t0)			#load [2] pixel of playerModel
	#first pixel
	addi	$t1, $t1, -4			#load offset of pixel to left of [2]
	addi	$t1, $t1, BASE_ADDRESS		#compute bit address for pixel to the right of third pixel of playerModel
	addi	$sp, $sp, -4
	sw	$ra, ($sp)			#push ra to stack
	addi	$sp, $sp, -4
	sw	$t1, ($sp)			#push bitmapAddress to stack
	jal	updateEnemyHealth
	lw	$ra, ($sp)			#pop ra from stack
	addi	$sp, $sp, 4
	sw	$a1, ($t1)			#update pixel colour to sword
	
	#second pixel
	addi	$t1, $t1, -128			#adjust bitmap address to pixel above first pixel
	addi	$sp, $sp, -4
	sw	$ra, ($sp)			#push ra to stack
	addi	$sp, $sp, -4
	sw	$t1, ($sp)			#push bitmapAddress to stack
	jal	updateEnemyHealth
	lw	$ra, ($sp)			#pop ra from stack
	addi	$sp, $sp, 4
	sw	$a1, ($t1) 			#update pixel colour to sword
	syscall					
	#remove second pixel
	sw	$a2, ($t1) 			
	
	#third pixel
	addi	$t1, $t1, -4			#adjust bitmap address to the left of second pixel
	addi	$sp, $sp, -4
	sw	$ra, ($sp)			#push ra to stack
	addi	$sp, $sp, -4
	sw	$t1, ($sp)			#push bitmapAddress to stack
	jal	updateEnemyHealth
	lw	$ra, ($sp)			#pop ra from stack
	addi	$sp, $sp, 4
	sw	$a1, ($t1)			#update pixel to sword
	syscall
	#remove third pixel
	sw	$a2, ($t1)			
	
	#fourth pixel
	addi	$t1, $t1, 128			#adjust bitmap address to offset of pixel below third pixel
	addi	$sp, $sp, -4
	sw	$ra, ($sp)			#push ra to stack
	addi	$sp, $sp, -4
	sw	$t1, ($sp)			#push bitmapAddress to stack
	jal	updateEnemyHealth
	lw	$ra, ($sp)			#pop ra from stack
	addi	$sp, $sp, 4
	sw	$a1, ($t1)			#update pixel to sword
	syscall					
	#remove fourth pixel
	sw	$a2, ($t1)			
	syscall					
	#remove first pixel
	addi	$t1, $t1, 4			#first pixel is to the right of fourth pixel's bitmap address
	sw	$a2, ($t1)			
				
LEVEL_ONE_ABILITY_LEFT_END:

	j KEY_PRESSED_END	#return to gameLoop


#F: moves player model 1 unit down and immediately returns to gameLoop if the playerModel's feet are 
#not already touching a platform. If they are touching a platform, does nothing
applyGravity:
	#load new player model offsets
	#t0 - t7 will hold the old offsets 
	#s0 - s7 will hold the new offsets (offsets post-movement)
	
	#load current position of playermodel
	la	$a0, playerModel  
	lw	$t0, ($a0)
	lw	$t1, 4($a0)
	lw	$t2, 8($a0)
	lw	$t3, 12($a0)
	lw	$t4, 16($a0)
	lw	$t5, 20($a0)
	lw	$t6, 24($a0)
	lw	$t7, 28($a0)
	#compute new offset of playerModel
	addi	$s0, $t0, 128
	addi	$s1, $t1, 128
	addi	$s2, $t2, 128
	addi	$s3, $t3, 128
	addi	$s4, $t4, 128
	addi	$s5, $t5, 128
	addi	$s6, $t6, 128
	addi	$s7, $t7, 128
	
	#check for possible collisions before redrawing
	#left foot
	addi	$a0, $s0, BASE_ADDRESS 				
	lw	$a0, ($a0)					#load the colour that is located at bitmap address of $s0
	beq	$a0, BORDER_COLOUR, SKIP_APPLY_GRAVITY		#skip updatePlayerModel if new "feet" overlap a platform/bottom boundary
	beq	$a0, PLATFORM_COLOUR, SKIP_APPLY_GRAVITY
	#right foot
	addi	$a0, $s1, BASE_ADDRESS
	lw	$a0, ($a0)
	beq	$a0, BORDER_COLOUR, SKIP_APPLY_GRAVITY
	beq	$a0, PLATFORM_COLOUR, SKIP_APPLY_GRAVITY
	
	#updatePlayerModel if playerModel is not touching a boundary
	addi 	$sp, $sp, -4	#push ra to stack
	sw  	$ra, ($sp) 
	jal updatePlayerModel
	lw	$ra, ($sp) 	#pop ra from stack
	addi	$sp, $sp, 4
	
	#add delay to make movement midair easier
	li	$v0, 32
	li	$a0, 30
	syscall				#call to sleep w/ 30 ms delay
	
SKIP_APPLY_GRAVITY:
	jr $ra	#return to gameLoop



#F: moves enemyModel 1 unit to the right
#assume address of enemyModel arr is stored in $a0
moveEnemyRight:
	#load background colour
	li	$v1, PURPLE
	
	#enemyModel[0]
	lw	$s0, ($a0)			#load the offset stored at address enemyModel[0] 
	addi	$s0, $s0, 4			
	sw	$s0, ($a0)			#store new offset
	#load pixel to the left of new offset, and store it in new offset bitmap address
	addi	$s0, $s0, BASE_ADDRESS		#compute bitmap address
	addi	$t0, $s0, -4			#compute bitmap address to the left
	lw	$v0, ($t0)
	sw	$v1, ($t0)			#replace old offset with background colour
	sw	$v0, ($s0)			#replace new bitmap address with left bitmap address colour
		
	#enemyModel[1]
	lw	$s0, 4($a0)			#load the offset stored at address enemyModel[1] 
	addi	$s0, $s0, 4			
	sw	$s0, 4($a0)			#store new offset
	#load pixel to the left of new offset, and store it in new offset bitmap address
	addi	$s0, $s0, BASE_ADDRESS		#compute bitmap address
	addi	$t0, $s0, -4			#compute bitmap address to the left
	lw	$v0, ($t0)
	sw	$v1, ($t0)			#replace old offset with background colour
	sw	$v0, ($s0)			#replace new bitmap address with left bitmap address colour
	
	#enemyModel[2]
	lw	$s0, 8($a0)			#load the offset stored at address enemyModel[1] 
	addi	$s0, $s0, 4			
	sw	$s0, 8($a0)			#store new offset
	#load pixel to the left of new offset, and store it in new offset bitmap address
	addi	$s0, $s0, BASE_ADDRESS		#compute bitmap address
	addi	$t0, $s0, -4			#compute bitmap address to the left
	lw	$v0, ($t0)
	sw	$v1, ($t0)			#replace old offset with background colour
	sw	$v0, ($s0)			#replace new bitmap address with left bitmap address colour
	
	#enemyModel[3]
	lw	$s0, 12($a0)			#load the offset stored at address enemyModel[1] 
	addi	$s0, $s0, 4			
	sw	$s0, 12($a0)			#store new offset
	#load pixel to the left of new offset, and store it in new offset bitmap address
	addi	$s0, $s0, BASE_ADDRESS		#compute bitmap address
	addi	$t0, $s0, -4			#compute bitmap address to the left
	lw	$v0, ($t0)
	sw	$v1, ($t0)			#replace old offset with background colour
	sw	$v0, ($s0)			#replace new bitmap address with left bitmap address colour
	
	#enemyModel[4]
	lw	$s0, 16($a0)			#load the offset stored at address enemyModel[1] 
	addi	$s0, $s0, 4			
	sw	$s0, 16($a0)			#store new offset
	#load pixel to the left of new offset, and store it in new offset bitmap address
	addi	$s0, $s0, BASE_ADDRESS		#compute bitmap address
	addi	$t0, $s0, -4			#compute bitmap address to the left
	lw	$v0, ($t0)
	sw	$v1, ($t0)			#replace old offset with background colour
	sw	$v0, ($s0)			#replace new bitmap address with left bitmap address colour
	
	#enemyModel[5]
	lw	$s0, 20($a0)			#load the offset stored at address enemyModel[1] 
	addi	$s0, $s0, 4			
	sw	$s0, 20($a0)			#store new offset
	#load pixel to the left of new offset, and store it in new offset bitmap address
	addi	$s0, $s0, BASE_ADDRESS		#compute bitmap address
	addi	$t0, $s0, -4			#compute bitmap address to the left
	lw	$v0, ($t0)
	sw	$v1, ($t0)			#replace old offset with background colour
	sw	$v0, ($s0)			#replace new bitmap address with left bitmap address colour
	
	jr 	$ra		#return to updateEnemyMovement



#F: moves enemyModel 1 unit to the left
#assume address of enemyModel arr is stored in $a0
moveEnemyLeft:
	#load background colour
	li	$v1, PURPLE
	
	#enemyModel[0]
	lw	$s0, ($a0)			#load the offset stored at address enemyModel[0] 
	addi	$s0, $s0, -4			
	sw	$s0, ($a0)			#store new offset
	#load pixel to the left of new offset, and store it in new offset bitmap address
	addi	$s0, $s0, BASE_ADDRESS		#compute bitmap address
	addi	$t0, $s0, 4			#compute bitmap address to the left
	lw	$v0, ($t0)
	sw	$v1, ($t0)			#replace old offset with background colour
	sw	$v0, ($s0)			#replace new bitmap address with left bitmap address colour
		
	#enemyModel[1]
	lw	$s0, 4($a0)			#load the offset stored at address enemyModel[1] 
	addi	$s0, $s0, -4			
	sw	$s0, 4($a0)			#store new offset
	#load pixel to the left of new offset, and store it in new offset bitmap address
	addi	$s0, $s0, BASE_ADDRESS		#compute bitmap address
	addi	$t0, $s0, 4			#compute bitmap address to the left
	lw	$v0, ($t0)
	sw	$v1, ($t0)			#replace old offset with background colour
	sw	$v0, ($s0)			#replace new bitmap address with left bitmap address colour
	
	#enemyModel[2]
	lw	$s0, 8($a0)			#load the offset stored at address enemyModel[1] 
	addi	$s0, $s0, -4			
	sw	$s0, 8($a0)			#store new offset
	#load pixel to the left of new offset, and store it in new offset bitmap address
	addi	$s0, $s0, BASE_ADDRESS		#compute bitmap address
	addi	$t0, $s0, 4			#compute bitmap address to the left
	lw	$v0, ($t0)
	sw	$v1, ($t0)			#replace old offset with background colour
	sw	$v0, ($s0)			#replace new bitmap address with left bitmap address colour
	
	#enemyModel[3]
	lw	$s0, 12($a0)			#load the offset stored at address enemyModel[1] 
	addi	$s0, $s0, -4			
	sw	$s0, 12($a0)			#store new offset
	#load pixel to the left of new offset, and store it in new offset bitmap address
	addi	$s0, $s0, BASE_ADDRESS		#compute bitmap address
	addi	$t0, $s0, 4			#compute bitmap address to the left
	lw	$v0, ($t0)
	sw	$v1, ($t0)			#replace old offset with background colour
	sw	$v0, ($s0)			#replace new bitmap address with left bitmap address colour
	
	#enemyModel[4]
	lw	$s0, 16($a0)			#load the offset stored at address enemyModel[1] 
	addi	$s0, $s0, -4			
	sw	$s0, 16($a0)			#store new offset
	#load pixel to the left of new offset, and store it in new offset bitmap address
	addi	$s0, $s0, BASE_ADDRESS		#compute bitmap address
	addi	$t0, $s0, 4			#compute bitmap address to the left
	lw	$v0, ($t0)
	sw	$v1, ($t0)			#replace old offset with background colour
	sw	$v0, ($s0)			#replace new bitmap address with left bitmap address colour
	
	#enemyModel[5]
	lw	$s0, 20($a0)			#load the offset stored at address enemyModel[1] 
	addi	$s0, $s0, -4			
	sw	$s0, 20($a0)			#store new offset
	#load pixel to the left of new offset, and store it in new offset bitmap address
	addi	$s0, $s0, BASE_ADDRESS		#compute bitmap address
	addi	$t0, $s0, 4			#compute bitmap address to the left
	lw	$v0, ($t0)
	sw	$v1, ($t0)			#replace old offset with background colour
	sw	$v0, ($s0)			#replace new bitmap address with left bitmap address colour
	
	jr	 $ra		#return to updateEnemyMovement



updateEnemyMovement:
	#push $ra to stack
	addi	$sp, $sp, -4
	sw	$ra, ($sp)
	
	#increment enemyMovementBuffer
	la	$a0, enemyMovementBuffer	#load buffer address
	lw	$a1, ($a0)			#load buffer value
	addi	$a1, $a1, 1			#increment buffer value
	sw	$a1, ($a0)				#store updated buffer value
	#if enemy buffer != 8 then skip movementUpdate
	bne	$a1, 8, UPDATE_ENEMY_MOVEMENT_END	

	#otherwise, execute the updateEnemyMovement and reset buffer
	sw	$0, ($a0)
	
	#updateEnemyMovement for enemies on currLevel
	la 	$a0, currLevel
	lw	$a0, ($a0)
	
	beq	$a0, 1,	UPDATE_ENEMY_MOVEMENT_ONE
	beq 	$a0, 2,	UPDATE_ENEMY_MOVEMENT_TWO
	
	#level One Enemies
UPDATE_ENEMY_MOVEMENT_ONE:
	
	#e1m1 -> movement bounded by [5 left from startpoint, 3 to right from startpoint]
	
	#if e1m1Hit == 2, (i.e e1m1 is killed) skip update
	la	$t0, e1m1Hit
	lw	$t0, ($t0)
	beq	$t0, 2, e1m1_MOVEMENT_END 
	
	#otherwise continue with the update
	#load direction and position
	la	$t0, e1m1Direction
	lw	$t0, ($t0)	
	la	$t1, e1m1Position
	lw	$t1, ($t1)	
	
	#branch to move_left if direction == 0
	beq	$t0, 0,	e1m1_MOVE_LEFT	
	
	#Otherwise, e1m1_MOVE_RIGHT:
	#if e1m1Position == 3, switch direction
	beq	$t1, 3, e1m1_RIGHT_TO_LEFT 
	
	#e1m1Position++
	la	$t2, e1m1Position	#load variable address
	addi	$t1, $t1, 1		#decrement from prev loaded e1m1Position
	sw	$t1, ($t2)		#store the updated e1m1Position
	
	#shift enemyModel 1 unit right
	la	$a0, e1m1
	jal moveEnemyRight
	j e1m1_MOVEMENT_END
	
	
e1m1_MOVE_LEFT: 
	#if e1m1Position == -5, switch direction
	beq	$t1, -5, e1m1_LEFT_TO_RIGHT
	
	#e1m1Position--
	la	$t2, e1m1Position	#load variable address
	addi	$t1, $t1, -1		#increment from prev loaded e1m1Position
	sw	$t1, ($t2)		#store the updated e1m1Position
	
	#shift enemyModel 1 unit left
	la	$a0, e1m1
	jal moveEnemyLeft
	j e1m1_MOVEMENT_END
	
	
e1m1_LEFT_TO_RIGHT:
	#update enemy direction
	li	$t2, 1
	la	$t0, e1m1Direction
	sw	$t2, ($t0)
	
	#e1m1Position++
	la	$t2, e1m1Position	#load variable address
	addi	$t1, $t1, 1		#increment from prev loaded e1m1Position
	sw	$t1, ($t2)		#store the updated e1m1Position
	
	#shift enemyModel 1 unit right
	la	$a0, e1m1
	jal moveEnemyRight
	j e1m1_MOVEMENT_END


e1m1_RIGHT_TO_LEFT:
	#update enemy direction
	la	$t0, e1m1Direction
	sw	$0, ($t0)
	
	#e1m1Position--
	la	$t2, e1m1Position	#load variable address
	addi	$t1, $t1, -1		#decrement from prev loaded e1m1Position
	sw	$t1, ($t2)		#store the updated e1m1Position
	
	#shift enemyModel 1 unit left
	la	$a0, e1m1
	jal moveEnemyLeft
	j e1m1_MOVEMENT_END
	
e1m1_MOVEMENT_END:

UPDATE_ENEMY_MOVEMENT_TWO:
	

UPDATE_ENEMY_MOVEMENT_END:
	#pop return address from the stack
	lw	$ra, ($sp)
	addi	$sp, $sp, 4	
	jr 	$ra			#return to gameLoop
	
	
	#HEALTH MECHANISM

#F: decreases playerHealth by 1 heart, and triggers damage indication
updatePlayerHealth:
	la 	$a0, playerHealth	#load playerHealth
	lw	$a1, ($a0)		#playerHealth val == remaining number of hearts 
	beq	$a1, 3,	decrement_player_health
	beq	$a1, 2, decrement_player_health
	
	#otherwise player will be losing his last heart and should be killed
	j	restartGame		#jump to gameOver (temporarily restart)
	
decrement_player_health:
	addi	$a1, $a1, -1	#decrement playerHealth by 1
	sw	$a1, ($a0)
	
	#change player to red
	li	$a1, PLAYER_RED		#load colour
	la	$a0, playerModel
	lw	$a0, ($a0)		#load first offset in playerModel array
	addi	$a0, $a0, BASE_ADDRESS	#compute bitmap address of playerModel[0]
	sw	$a1, ($a0)
	addi	$a0, $a0, 4	#compute bitmap address of playerModel[1]
	sw	$a1, ($a0)
	addi	$a0, $a0, -128	#compute bitmap address of playerModel[3]
	sw	$a1, ($a0)
	addi	$a0, $a0, -4	#compute bitmap address of playerModel[2]
	sw	$a1, ($a0)
	addi	$a0, $a0, -128	#compute bitmap address of playerModel[4]
	sw	$a1, ($a0)
	addi	$a0, $a0, 4	#compute bitmap address of playerModel[5]
	sw	$a1, ($a0)
	addi	$a0, $a0, -128	#compute bitmap address of playerModel[7]
	sw	$a1, ($a0)
	addi	$a0, $a0, -4	#compute bitmap address of playerModel[6]
	sw	$a1, ($a0)

	jr $ra			#return to updatePlayerModel



#F: displays number of remaining player Hearts onto bitmap display
#number of hearts to draw == playerHealth
loadPlayerHealth:
	li	$v0, PLAYER_RED		#load red
	li	$v1, PURPLE		#load purple
	la	$a0, playerHealth	#load playerHealth
	lw	$a0, ($a0)		#playerHealth val == remaining number of hearts 
	
	#initialize bitmap addresses before first heart
	li	$t0, 248	
	addi	$t0, $t0, BASE_ADDRESS		#heart pixel1
	li	$t1, 380	
	addi	$t1, $t1, BASE_ADDRESS		#heart pixel2
	li	$t2, 256	
	addi	$t2, $t2, BASE_ADDRESS		#heart pixel3
	
	#before redrawing hearts, replace hearts with background pixels
	
	#heart1
	move	$s0, $t0
	addi	$s0, $s0, 16
	sw	$v1, ($s0)
	
	move	$s1, $t1
	addi	$s1, $s1, 16
	sw	$v1, ($s1)
	
	move	$s2, $t2
	addi	$s2, $s2, 16
	sw	$v1, ($s2)
	#heart2
	addi	$s0, $s0, 16
	sw	$v1, ($s0)
	addi	$s1, $s1, 16
	sw	$v1, ($s1)
	addi	$s2, $s2, 16
	sw	$v1, ($s2)
	#heart3
	addi	$s0, $s0, 16
	sw	$v1, ($s0)
	addi	$s1, $s1, 16
	sw	$v1, ($s1)
	addi	$s2, $s2, 16
	sw	$v1, ($s2)
	
	#redraw the hearts for health bar
DRAW_HEART:
	addi	$t0, $t0, 16	#next heart's bitmap address
	addi	$t1, $t1, 16	#next heart's bitmap address
	addi	$t2, $t2, 16	#next heart's bitmap address
	sw	$v0, ($t0)
	sw	$v0, ($t1)
	sw	$v0, ($t2)

	addi	$a0, $a0, -1		#decrement num of Hearts left to draw by 1
	bne 	$a0, 0, DRAW_HEART

	jr $ra		#return to gameLoop
	
	
	
#F: this function updates the enemy health if an enemy exists at the bitmap address passed in
#should not use a0-a2, t0-t1 or v0
#assumes t7 == SWORD_COLOUR, t8 == PURPLE
#store bitmap address that was pushed in v1
updateEnemyHealth:
	#push bitmap address
	lw	$v1, ($sp)	#pop bitmap address from stack
	lw	$s0, ($v1)	#load colour at bitmap address
	addi	$sp, $sp, 4
	
	#check if an enemy was hit (i.e if the bitmap address colour is == LIGHT_GREEN (an enemy-coloured pixel) )
	bne	$s0, LIGHT_GREEN, UPDATE_ENEMY_HEALTH_END	#skip if bitmap address does not denote LIGHT_GREEN
	
	#else: determine which enemy was hit (iterate through each enemy to see if bitmap address matches)
	la	$s0, e1m1			#load address of e1m1
	lw	$s1, ($s0)			#load offset of e1m1[0] into s1
	#check if e1m1[0] matches
	addi	$s1, $s1, BASE_ADDRESS		#compute e1m1[0] bitmap address
	beq	$s1, $v1, UPDATE_e1m1_HEALTH
	#check if e1m1[1] matches
	addi	$s1, $s1, 4	
	beq	$s1, $v1, UPDATE_e1m1_HEALTH	
	#check if e1m1[3] matches		#we check e1m1[3] before e1m1[2] because it's easier to compute from prev $s0
	addi	$s1, $s1, -128	
	beq	$s1, $v1, UPDATE_e1m1_HEALTH	
	#check if e1m1[2] matches
	addi	$s1, $s1, -4	
	beq	$s1, $v1, UPDATE_e1m1_HEALTH
	
	#should not get to this point, because one of the enemies should match if LIGHT_GREEN was detected	
	j UPDATE_ENEMY_HEALTH_END
	
	
UPDATE_e1m1_HEALTH:	
	#at this point, $s0 should have the address to enemyModel[0] stored in it
	
	#check to see if enemy should reduce health OR if enemy should be killed based on health bar
	lw	$s1, 20($s0)			#load enemyModel[5] offset (last pixel denoting health bar)		
	addi	$s1, $s1, BASE_ADDRESS		#compute bitmap address
	lw	$s2, ($s1)			#store the colour of the enemy health bar

	#if enemyModel[5] == red, then the attack will kill the enemy 
	beq	$s2, ENEMY_RED, KILL_e1m1
	
	#else enemyModel[5] == green => then the attack will reduce the enemy health
	#update enemyModel's health bar 
	li	$v1, ENEMY_RED		
	sw	$v1, ($s1)			#update the enemy's 5th pixel to red
	
	#trigger damage indication onto enemyModel
	lw	$s1, ($s0) 
	addi	$s1, $s1, BASE_ADDRESS
	sw	$v1, ($s1)			#update enemyModel arr[0]
	
	addi	$s1, $s1, 4			#modify previously computed bitmap address
	sw	$v1, ($s1)			#update enemyModel arr[1]
	
	addi	$s1, $s1, -128			#modify previously computed bitmap address
	sw	$v1, ($s1)			#update enemyModel arr[3]
	
	addi	$s1, $s1, -4			#modify previously computed bitmap address
	sw	$v1, ($s1)			#update enemyModel arr[2]
	
	#start counter for damage indication time
	la	$s1, enemyHitCounter		#this allows for a delay between damage indications for our enemy
	li	$v1, 1
	sw	$v1, ($s1)			#start the counter at 1 (this triggers the count in our gameLoop) 
	
	#update e1m1Hit bool
	la	$s1, e1m1Hit
	lw	$v1, ($s1)
	addi	$v1, $v1, 1			#increment e1m1Hit variable by 1
	sw	$v1, ($s1)			#store updated e1m1Hit
	
	#store offset of the damaged enemy (to be later used by updateEnemyHitCounter)
	la	$v1, enemyHitOffset	#load variable offset
	lw	$s2, ($s0)		#load the value/offset stored in e1m1[0]
	sw	$s2, ($v1)		#store the offset inside variable
	j UPDATE_ENEMY_HEALTH_END

KILL_e1m1:
	#replace all enemy pixels with background coloured pixels
	#$s0 should have the address to enemyModel[0] stored in it
	#we want to modify the bitmap address, not the actual array
	li	$v1, PURPLE
	lw	$s1, ($s0)		#load enemyModel[0]
	addi	$s1, $s1, BASE_ADDRESS	#compute bitmap address enemyModel[0]
	sw	$v1, ($s1)		#update pixel
	
	lw	$s1, 4($s0)		#load enemyModel[1]
	addi	$s1, $s1, BASE_ADDRESS	#compute bitmap address enemyModel[1]
	sw	$v1, ($s1)		#update pixel
	
	lw	$s1, 8($s0)		#load enemyModel[2]
	addi	$s1, $s1, BASE_ADDRESS	#compute bitmap address enemyModel[2]
	sw	$v1, ($s1)		#update pixel
	
	lw	$s1, 12($s0)		#load enemyModel[3]
	addi	$s1, $s1, BASE_ADDRESS	#compute bitmap address enemyModel[3]
	sw	$v1, ($s1)		#update pixel
	
	lw	$s1, 16($s0)		#load enemyModel[4]
	addi	$s1, $s1, BASE_ADDRESS	#compute bitmap address enemyModel[4]
	sw	$v1, ($s1)		#update pixel
	
	lw	$s1, 20($s0)		#load enemyModel[5]
	addi	$s1, $s1, BASE_ADDRESS	#compute bitmap address enemyModel[5]
	sw	$v1, ($s1)		#update pixel
	
	#update e1m1Hit
	la	$s1, e1m1Hit
	addi	$v1, $0, 2		#e1m1Hit = 2 => enemy has been killed
	sw	$v1, ($s1)		#store updated e1m1Hit
	
	j UPDATE_ENEMY_HEALTH_END
	
UPDATE_ENEMY_HEALTH_END:
	jr	$ra			#return to playerAbility


#F: increments enemyHitCounter variable by 1 iff 1 <= enemyHitCounter < 10 . 
#If the counter is equal to 10, then the function changes the enemy @ address enemyHitOffset+BASE_ADDRESS back to green and resets counter
#If the counter is equal to 0, then the function makes no changes
updateEnemyHitCounter:
	la	$a0, enemyHitCounter
	lw	$a0, ($a0)				#load enemyHitCounter
	beq	$a0, 2, UPDATE_ENEMY_HIT_COUNTER_START	#counter == 4
	beq	$a0, 0, UPDATE_ENEMY_HIT_COUNTER_END	#counter == 0
	
	#otherwise the counter is in (0,10) and we should increment by 1:
	addi	$a0, $a0, 1
	la	$a1, enemyHitCounter
	sw	$a0, ($a1)				#store updated counter value into enemyHitCounter
	j UPDATE_ENEMY_HIT_COUNTER_END

UPDATE_ENEMY_HIT_COUNTER_START:
	#change enemyModel from red to green
	la	$a0, enemyHitOffset			
	lw	$a0, ($a0)				#load offset in enemyHitOffset	
	addi	$a0, $a0, BASE_ADDRESS			#compute bitmap address
	#update enemyModel pixels
	li	$a1, LIGHT_GREEN		
	sw	$a1, ($a0)				#update pixel[0]
	addi	$a0, $a0, 4	
	sw	$a1, ($a0)				#update pixel[1]
	addi	$a0, $a0, -128	
	sw	$a1, ($a0)				#update pixel[3]
	addi	$a0, $a0, -4	
	sw	$a1, ($a0)				#update pixel[2]
	#reset counter
	la	$a0, enemyHitCounter
	sw	$0, ($a0) 

UPDATE_ENEMY_HIT_COUNTER_END:
	jr $ra						#return to gameLoop
	
	
#EXTRA FEATURES

#trigger gameOver if health reaches 0 
displayGameOver:
	
	
#check for keyboard input
#check for char collision
#update entities (location)
#update game state
#erase objects' old position
#draw objects' new position
main:
	#for reset, make sure that all variables are reset before playing the game again 
	jal setupDisplay
	jal generateLevelOne
	jal loadEnemies

GAMELOOP_START:
	#process display refresh rate:
	li	 $v0, 32
	li	 $a0, REFRESH_RATE
	syscall 
	
	#check for keyboard input
	li 	$s0, KEY_PRESSED
	lw	$s1, ($s0)	
	bne 	$s1, 1, KEY_PRESSED_END 		#check if value stored in address KEY_PRESSED == 1
	#we want to branch if key was pressed, 
	#otherwise we don't process the key input 
	#and instead update other gameloop properties
	jal KEY_PRESSED_START

KEY_PRESSED_END:				#branch if no valid key was entered, or if key handling has finished
	
	#refresh platforms for current level
	jal refreshPlatforms
	
	#update enemyHitCounter
	jal updateEnemyHitCounter
	
	#update current position of enemies on the map
	jal updateEnemyMovement
	
	#refresh enemies 
	jal loadEnemies
	
	#at this popint, enemies overlap players, so we can check for player-enemy Collision
	#jal enemyCollision
	
	#refresh playerHealth
	jal loadPlayerHealth
	
	#we need to update playerDamaged Buffer
	
	#refresh playerModel
	jal refreshPlayerModel			#redraws playerModel to make platforms appear in background
	
	#update enemies
	
	#update Health
	
	#applyGravity if the playerModel's feet are not already touching a platform, otherwise does nothing
	jal applyGravity
	
	j GAMELOOP_START
GAMELOOP_END:
		
	#exit program
	li $v0, 10
	syscall