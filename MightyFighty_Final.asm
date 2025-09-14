##################################################################### 
# 
# Bitmap Display Configuration: 
# - Unit width in pixels: 8 
# - Unit height in pixels: 8 
# - Display width in pixels: 256 
# - Display height in pixels: 256 
# - Base Address for Display: 0x10008000 ($gp) 
# 
# Which milestones have been reached in this submission? 
# - Milestone 1 (2/3) -> game display resolution is NOT 64x64 units 
# - Milestone 2 (5/5)
# - Milestone 3 (9/9)
#
# Which approved features have been implemented for milestone 3? 
# 1. Health/Score
# 2. Fail Condition
# 3. Win Condition
# 4. Moving Objects
# 5. Moving Platforms
# 6. Different Levels
# 7. Pick-up effects
# 
# Link to video demonstration for final submission: 
# - https://play.library.utoronto.ca/watch/0a9ea888ced018590ec09dc1577f0d6c
# 
# Are you OK with us sharing the video with people outside course staff? 
# - yes
# 
# Any additional information that the TA needs to know: 
# - I was deducted a mark for allowing movement past the bitmap display edges, however, I received 
#   confirmation via @237 post on Piazza that this is ok, as this edge-movement only exists in the 
#   final level (intentionally) and that level one and level two handle top, bottom, right, and left
#   edge collision as the requirements desire.
# 
##################################################################### 
		
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
.eqv	LAVA		0xFF6200

.eqv	BUTTON_COLOUR	0x630000

#pick ups
.eqv	WAND_CROWN	0xFFF717
.eqv	WAND_HANDLE	0xDBFFFD

.eqv	SHURIKEN	0xBCCCCC
.eqv	SHURIKEN_CENTER	0xFFFFFF

#character model:
.eqv	BLACK		0x000000
.eqv 	PEACH		0xFFD9D6
.eqv	LIGHT_GREY	0xD1D1D1
.eqv	GREY		0x7D7D7D
.eqv	SWORD_COLOUR	0xD1DEDB
.eqv	PLAYER_RED	0xFF4747
#character model: Ninja
.eqv	HEADBAND_COLOUR 0xD41900
.eqv	PLAYER_STEALTH	0xE1ECED
#character model: wizard
.eqv	BEARD_COLOUR	0xFFFFFA
.eqv	ROBE_COLOUR	0x5237ED
.eqv	PLAYER_FLOATING 0xFFF8BD

#enemy model
.eqv	GREEN		0x4DBF4D
.eqv	LIGHT_GREEN	0xC1FFBD
.eqv	ENEMY_RED	0xFF7575


#health bar
.eqv	HEALTH_RED		0xFF1100

#door
.eqv	BROWN		0x915500
.eqv	GOLD		0xFCC603
.eqv	PREV_DOOR	0xB89B93
.eqv	PREV_GOLD	0xFFD48A

#treasure chest
.eqv	CHEST_GOLD	0xE0B700
.eqv	CHEST_BASE	0x6E4000
.eqv	CHEST_CAP	0xA15E00
.eqv	CHEST_BUCKLE	0x757575



.data
	#ENTITY MODELS
#each index in the array represents a pixel of the player model on the bitmap display
playerModel:		.word	3724	3728	3596	3600	3468	3472	3340	3344	
playerHealth:		.word	3	#when playerHealth == 0, the game should restart
playerDamaged:		.word	0	# 0 < playerDamaged <= 10 if player is in damaged state. Otherwise playerDamaged == 0
playerMode:		.word	1	#1 => player is warrior, 2 => players is ninja, 3 => player is wizard

isPlayerStealthed:	.word	0	#1 => player is stealth, 0 => player is not stealth
stealthBuffer:		.word	0	#keeps track of stealth duration for Ninja ability

isPlayerFloating:	.word	0	#1 => player is floating, 0 => player is NOT floating
floatingBuffer:		.word	0	#keeps track of float duration for Wizard ability


#Level 1 enemies:
#first 4 pixels denote the body, last two pixels denote the health bar
e1m1:			.word	3772	3776	3644	3648	3388	3392
#enemyHit == 1 iff an enemy has been hit by a sword in the current frame
#This variable is used later (in the same frame) to update enemyHealth
e1m1Hit:			.word	0	#0 == no hits, 1 == 1 hit, 2 == 2 hits (i.e enemy is killed)	
e1m1Direction:			.word	0	#similar to playerDirection
e1m1Position:			.word   0	#used for bounding enemy movement

e2m1:				.word	2224	2228	2096	2100	1840    1844
e2m1Hit:			.word	0	#0 == no hits, 1 == 1 hit, 2 == 2 hits (i.e enemy is killed)	
e2m1Direction:			.word	0	#similar to playerDirection
e2m1Position:			.word   0	#used for bounding enemy movement

#Level 2 enemies:
e1m2:				.word	3360	3364	3232	3236	2976    2980	
e1m2Direction:			.word	0	#similar to playerDirection
e1m2Position:			.word   0	#used for bounding enemy movement

e2m2:				.word	2192	2196	2064	2068	1808    1812
e2m2Direction:			.word	0	#similar to playerDirection
e2m2Position:			.word   0	#used for bounding enemy movement

e3m2:				.word	1976	1980	1848	1852	1592    1596

e4m2:				.word	1180	1184	1052	1056	796    800
e4m2Direction:			.word	0	#similar to playerDirection
e4m2Position:			.word   0	#used for bounding enemy movement



	#GAME PROPERTIES
playerDirection:		.word	1		#0 => player is facing left, 1 => player is facing right
currLevel:			.word	1		#stores the level that the player is currently on

enemyHitOffset:			.word   0	#stores the offset of enemy
enemyHitCounter:		.word	0	#this acts as a counter for how long the enemies stay red	

#BufferDelays
enemyMovementBuffer:            .word	0	#used as a buffer so that movement updates don't occur every refresh

	#PICK UPS
wand:				.word	980	852	734
shuriken:			.word	864	732	736	740	608	

	#MAP GENERATION
#movingPlatform1 is an array that stores offsets of pixels belonging to moving platform in level 2
movingPlatform1:		.word	1880	1884	1888	1892	1896	1900	1904
movingPlatform1Direction:	.word	0	#0 => moving downward, 1 => moving upward
movingPlatform1Position:	.word	0	#bounded in [0, 10]	(where 10 => 10 units below start point)
movingPlatform1Buffer:		.word	0	#a counter that increments on each refresh. (updates movement after 5 refreshes)

#movingPlatform2 is an array that stores offsets of pixels belonging to moving platform in level 3
movingPlatform2:		.word	988	992	1006	1010	1014	1018	1022
movingPlatform2Direction:	.word	1	#0 => moving left, 1 => moving right
movingPlatform2Position:	.word	0	#bounded in [0, 10]	(where 10 => 10 units below start point)
movingPlatform2Buffer:		.word	0	#a counter that increments on each refresh. (updates movement after 5 refreshes)

treasureChest:			.word	3176	3180	3184	3048	3052	3056	2920	2924	2928

	#EXTRA
isButtonPressed:			.word	0	#0 => button not pressed, 1 => button has been pressed

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
#F: redraws any objects that require refreshing
#includes platforms for level currentLevel, redraws entrance Doors, and refreshes lava
refreshObjects:
	addi	$sp, $sp, -4
	sw	$ra, ($sp)			#push ra to stack
	
	li	$a0, PLATFORM_COLOUR		#load plaform colour
	#determine the level we want to update platforms for
	la	$a1, currLevel		
	lw	$a1, ($a1)
	beq	$a1, 2,	REFRESH_LEVEL_TWO
	beq	$a1, 3, REFRESH_LEVEL_THREE
	
	#otherwise REFRESH_LEVEL_ONE	
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
	
	#P3M1:	x->27-29, y->21
	li	$a1, BASE_ADDRESS		
	addi	$a1, $a1, 2796			#compute bitmap address of platform's starting pixel 
	sw	$a0, ($a1)
	sw	$a0, 4($a1)
	sw	$a0, 8($a1)
	
	#P4M1:	x->25-27, y->18
	li	$a1, BASE_ADDRESS		
	addi	$a1, $a1, 2404			#compute bitmap address of platform's starting pixel 
	sw	$a0, ($a1)
	sw	$a0, 4($a1)
	sw	$a0, 8($a1)
	
	#P5M1:	x->10-15, y->15
	li	$a1, BASE_ADDRESS		
	addi	$a1, $a1, 1936			#compute bitmap address of platform's starting pixel 
	sw	$a0, ($a1)
	sw	$a0, 4($a1)
	sw	$a0, 8($a1)
	sw	$a0, 12($a1)
	sw	$a0, 16($a1)
	
	#P6M1:	x->2-6, y->13
	li	$a1, BASE_ADDRESS		
	addi	$a1, $a1, 1544			#compute bitmap address of platform's starting pixel 
	sw	$a0, ($a1)
	sw	$a0, 4($a1)
	sw	$a0, 8($a1)
	sw	$a0, 12($a1)
	
	#P7M1:	y->11
	li	$a1, BASE_ADDRESS		
	addi	$a1, $a1, 1308			#compute bitmap address of platform's starting pixel 
	sw	$a0, ($a1)
	sw	$a0, 4($a1)
	sw	$a0, 8($a1)
	sw	$a0, 12($a1)
	
	#P8M1:	y->12
	li	$a1, BASE_ADDRESS		
	addi	$a1, $a1, 1460			#compute bitmap address of platform's starting pixel 
	sw	$a0, ($a1)
	sw	$a0, 4($a1)
	sw	$a0, 8($a1)
	
	#P9M1:	y->11
	li	$a1, BASE_ADDRESS		
	addi	$a1, $a1, 1216			#compute bitmap address of platform's starting pixel 
	sw	$a0, ($a1)
	sw	$a0, 4($a1)
	
	j REFRESH_OBJECTS_END
	
	
REFRESH_LEVEL_TWO:
	#redraw platforms
	#P1M2:	y->20
	li	$a1, 3096		
	addi	$a1, $a1, BASE_ADDRESS		#compute bitmap address of platform's starting pixel 
	sw	$a0, ($a1)
	sw	$a0, 4($a1)
	sw	$a0, 8($a1)
	sw	$a0, 12($a1)
	sw	$a0, 16($a1)
	
	#P2M2:	y->18
	li	$a1, 2696		
	addi	$a1, $a1, BASE_ADDRESS		#compute bitmap address of platform's starting pixel 
	sw	$a0, ($a1)
	sw	$a0, 4($a1)
	sw	$a0, 8($a1)
	sw	$a0, 12($a1)
	
	#P3M2:	y->15
	li	$a1, 2316	
	addi	$a1, $a1, BASE_ADDRESS		#compute bitmap address of platform's starting pixel 
	sw	$a0, ($a1)
	sw	$a0, 4($a1)
	sw	$a0, 8($a1)
	sw	$a0, 12($a1)
	
	#P4M2:	y->12
	li	$a1, 1940		
	addi	$a1, $a1, BASE_ADDRESS		#compute bitmap address of platform's starting pixel 
	sw	$a0, ($a1)
	sw	$a0, 4($a1)
	sw	$a0, 8($a1)
	
	#P5M2:	y->14
	li	$a1, 2472		
	addi	$a1, $a1, BASE_ADDRESS		#compute bitmap address of platform's starting pixel 
	sw	$a0, ($a1)
	sw	$a0, 4($a1)
	sw	$a0, 8($a1)
	sw	$a0, 12($a1)
	sw	$a0, 16($a1)
	
	#P6M2:	y->11
	li	$a1, 2104		
	addi	$a1, $a1, BASE_ADDRESS		#compute bitmap address of platform's starting pixel 
	sw	$a0, ($a1)
	sw	$a0, 4($a1)

	#P7M2:	y->8
	li	$a1, 1708		
	addi	$a1, $a1, BASE_ADDRESS		#compute bitmap address of platform's starting pixel 
	sw	$a0, ($a1)
	sw	$a0, 4($a1)
	sw	$a0, 8($a1)
	sw	$a0, 12($a1)
	
	#P8M2:	y->5
	li	$a1, 1300		
	addi	$a1, $a1, BASE_ADDRESS		#compute bitmap address of platform's starting pixel 
	sw	$a0, ($a1)
	sw	$a0, 4($a1)
	sw	$a0, 8($a1)
	sw	$a0, 12($a1)
	sw	$a0, 16($a1)
	sw	$a0, 20($a1)
	
	#P9M2:	platform before exit door
	li	$a1, 1068		
	addi	$a1, $a1, BASE_ADDRESS		#compute bitmap address of platform's starting pixel 
	sw	$a0, ($a1)
	sw	$a0, 4($a1)
	sw	$a0, 8($a1)
	sw	$a0, 12($a1)
	sw	$a0, 16($a1)
	
	#draw platform near entrance door
	li	$a1, 1116		
	addi	$a1, $a1, BASE_ADDRESS		#compute bitmap address of platform's starting pixel 
	sw	$a0, ($a1)
	sw	$a0, 4($a1)
	sw	$a0, 8($a1)
	sw	$a0, 12($a1)
	
	#draw entrance Door
	li	$a0, 1008		#first pixel starts @ 1008 + BASE_ADDRESS
	li	$a1, PREV_DOOR		#load colour for door 
	li	$a2, PREV_GOLD		#load colour for handle 
	addi	$a0, $a0, BASE_ADDRESS	
	sw	$a1, ($a0)		#draw door[0]
	addi	$a0, $a0, 4
	sw	$a1, ($a0)		#draw door[1]
	addi	$a0, $a0, -128
	sw	$a2, ($a0)		#draw door[3]
	addi	$a0, $a0, -4
	sw	$a1, ($a0)		#draw door[2]
	addi	$a0, $a0, -128
	sw	$a1, ($a0)		#draw door[4]
	addi	$a0, $a0, 4
	sw	$a1, ($a0)		#draw door[5]
	addi	$a0, $a0, -128
	sw	$a1, ($a0)		#draw door[7]
	addi	$a0, $a0, -4
	sw	$a1, ($a0)		#draw door[6]
	
	#lava
	#U5M2: start at y = 28 counter
	li	$a0, 28 	#y-counter
U5M2_OUTER_START:
	beq 	$a0, 30, U5M2_OUTER_END		#branch when y == 30
	
	li	$a1, 20	#x-counter		#reset x-counter each iteration
U5M2_INNER_START:
	beq	$a1, 31, U5M2_INNER_END		#branch when x == 31

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
	li	$t1, LAVA
	sw	$t1, ($t0)		
	#increment x-counter
	addi	$a1, $a1, 1
	j U5M2_INNER_START			#return to start of loop
U5M2_INNER_END:

	#increment y-counter
	addi	$a0, $a0, 1
	j U5M2_OUTER_START
U5M2_OUTER_END:

#draw movingPlatform1 -> movement bounded by [0, 10 pixels down from startpoint]
#this platform consists of 7 pixels
	la	$a0, movingPlatform1Buffer
	lw	$a1, ($a0)
	#if movingPlatformBuffer < 5, then skip update and reset movingPlatformBuffer
	blt	$a1, 5, INCREMENT_PLATFORM1_BUFFER
	
	#else, update moving platform and reset buffer
	sw	$0, ($a0)	#set buffer = 0
	#load direction and position
	la	$t0, movingPlatform1Direction
	lw	$t0, ($t0)	
	la	$t1, movingPlatform1Position
	lw	$t1, ($t1)	
	
	#branch to move_down if direction == 0
	beq	$t0, 0,	PLATFORM1_MOVE_DOWN	
	
	#Otherwise, move_up:
	#if platformPosition == 0, switch direction
	beq	$t1, 0, PLATFORM1_UP_TO_DOWN 
	
	#movingPlatform1Position--
	la	$t2, movingPlatform1Position	#load variable address
	addi	$t1, $t1, -1			#decrement from prev loaded e1m1Position
	sw	$t1, ($t2)			#store the updated e1m1Position
	
	#shift platform 1 unit up
	li	$v0, PURPLE
	li	$v1, PLATFORM_COLOUR
	la	$a0, movingPlatform1
	lw	$a1, ($a0)
	move	$a3, $a1		#copy offset[0] in a1 to a3, so we can keep things organized
	addi	$a2, $a1, BASE_ADDRESS	#store bitmap address using old arr offset[0] in a2 to keep organized
	addi	$t1, $a1, -128		#used to check if playerModel's feet offset matches above the platform
	#update array offsets change their corresponding bitmap addresses' pixels
	addi	$a1, $a1, -128
	sw	$a1, ($a0)		#update array[0] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 4($a0)		#update array[1] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 8($a0)		#update array[2] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 12($a0)		#update array[3] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 16($a0)		#update array[4] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 20($a0)		#update array[5] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 24($a0)		#update array[6] offset val
	
	#check for playerMoveUp calls
	#t1 == offset of new platform[0]
	la	$t0, playerModel
	lw	$t0, 4($t0)	
	#compare right foot offset to every new platform offset
	beq	$t1, $t0, playerMoveUpTrue1	#check if player[1] == new[0] 
	addi	$t1, $t1, 4
	beq	$t1, $t0, playerMoveUpTrue1	#check if player[1] == new[1] 
	addi	$t1, $t1, 4
	beq	$t1, $t0, playerMoveUpTrue1	#check if player[1] == new[2] 
	addi	$t1, $t1, 4
	beq	$t1, $t0, playerMoveUpTrue1	#check if player[1] == new[3] 
	addi	$t1, $t1, 4
	beq	$t1, $t0, playerMoveUpTrue1	#check if player[1] == new[4] 
	addi	$t1, $t1, 4
	beq	$t1, $t0, playerMoveUpTrue1	#check if player[1] == new[5] 
	addi	$t1, $t1, 4
	beq	$t1, $t0, playerMoveUpTrue1	#check if player[1] == new[6] 
	addi	$t1, $t1, 4
	beq	$t1, $t0, playerMoveUpTrue1	#check if playerModel's right foot is off platform, but left foot is still on
	#if all the checks fail, do not move player up
	j playerMoveUpFalse1		
	
playerMoveUpTrue1:
	addi	$sp, $sp, -4
	sw	$a2, ($sp)	#push a2 to stack
	jal	playerMoveUp
	lw	$a2, ($sp)	#pop a2 from stack
	addi	$sp, $sp, 4

playerMoveUpFalse1:
	
	#update new pixels
	addi	$a2, $a2, -128		#compute bitmap address of new platform[0]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[1]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[2]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[3]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[4]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[5]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[6]
	sw	$v1, ($a2)
	#remove old pixels
	addi	$a3, $a3, BASE_ADDRESS	#bitmap address using old array[0] offset val
	sw	$v0, ($a3)
	addi	$a3, $a3, 4		#bitmap address using old array[1] offset val
	sw	$v0, ($a3)
	addi	$a3, $a3, 4		#bitmap address using old array[2] offset val
	sw	$v0, ($a3)
	addi	$a3, $a3, 4		#bitmap address using old array[3] offset val
	sw	$v0, ($a3)
	addi	$a3, $a3, 4		#bitmap address using old array[4] offset val
	sw	$v0, ($a3)
	addi	$a3, $a3, 4		#bitmap address using old array[5] offset val
	sw	$v0, ($a3)
	addi	$a3, $a3, 4		#bitmap address using old array[6] offset val
	sw	$v0, ($a3)
	
	j PLATFORM1_MOVEMENT_END

		
PLATFORM1_MOVE_DOWN: 
	#if platformPosition == 10, switch direction
	beq	$t1, 10, PLATFORM1_DOWN_TO_UP
	
	#platformPosition++
	la	$t2, movingPlatform1Position	#load variable address
	addi	$t1, $t1, 1			#increment from prev loaded platformPosition
	sw	$t1, ($t2)			#store the updated platformPosition
	
	#shift platform 1 unit down
	li	$v0, PURPLE
	li	$v1, PLATFORM_COLOUR
	la	$a0, movingPlatform1
	lw	$a1, ($a0)
	move	$a3, $a1		#copy offset[0] in a1 to a3, so we can keep things organized
	addi	$a2, $a1, BASE_ADDRESS	#store bitmap address using old arr offset[0] in a2 to keep organized
	#update array offsets change their corresponding bitmap addresses' pixels
	addi	$a1, $a1, 128
	sw	$a1, ($a0)		#update array[0] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 4($a0)		#update array[1] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 8($a0)		#update array[2] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 12($a0)		#update array[3] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 16($a0)		#update array[4] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 20($a0)		#update array[5] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 24($a0)		#update array[6] offset val
	#update new pixels
	addi	$a2, $a2, 128		#compute bitmap address of new platform[0]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[1]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[2]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[3]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[4]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[5]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[6]
	sw	$v1, ($a2)
	#remove old pixels
	addi	$a3, $a3, BASE_ADDRESS	#bitmap address using old array[0] offset val
	sw	$v0, ($a3)
	addi	$a3, $a3, 4		#bitmap address using old array[1] offset val
	sw	$v0, ($a3)
	addi	$a3, $a3, 4		#bitmap address using old array[2] offset val
	sw	$v0, ($a3)
	addi	$a3, $a3, 4		#bitmap address using old array[3] offset val
	sw	$v0, ($a3)
	addi	$a3, $a3, 4		#bitmap address using old array[4] offset val
	sw	$v0, ($a3)
	addi	$a3, $a3, 4		#bitmap address using old array[5] offset val
	sw	$v0, ($a3)
	addi	$a3, $a3, 4		#bitmap address using old array[6] offset val
	sw	$v0, ($a3)
	
	j PLATFORM1_MOVEMENT_END
	
	
PLATFORM1_DOWN_TO_UP:
	#update platform direction
	li	$t2, 1
	la	$t0, movingPlatform1Direction
	sw	$t2, ($t0)
	
	#platformosition--
	la	$t2, movingPlatform1Position	#load variable address
	addi	$t1, $t1, -1		#increment from prev loaded platformPosition
	sw	$t1, ($t2)		#store the updated platformPosition
	
	#shift platform 1 unit up
	li	$v0, PURPLE
	li	$v1, PLATFORM_COLOUR
	la	$a0, movingPlatform1
	lw	$a1, ($a0)
	move	$a3, $a1		#copy offset[0] in a1 to a3, so we can keep things organized
	addi	$a2, $a1, BASE_ADDRESS	#store bitmap address using old arr offset[0] in a2 to keep organized
	addi	$t1, $a1, -128		#used to check if playerModel's feet offset matches above the platform
	#update array offsets change their corresponding bitmap addresses' pixels
	addi	$a1, $a1, -128
	sw	$a1, ($a0)		#update array[0] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 4($a0)		#update array[1] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 8($a0)		#update array[2] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 12($a0)		#update array[3] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 16($a0)		#update array[4] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 20($a0)		#update array[5] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 24($a0)		#update array[6] offset val
	
	#check for playerMoveUp calls
	#t1 == offset of new platform[0]
	la	$t0, playerModel
	lw	$t0, 4($t0)	
	#compare right foot offset to every new platform offset
	beq	$t1, $t0, playerMoveUpTrue2	#check if player[1] == new[0] 
	addi	$t1, $t1, 4
	beq	$t1, $t0, playerMoveUpTrue2	#check if player[1] == new[1] 
	addi	$t1, $t1, 4
	beq	$t1, $t0, playerMoveUpTrue2	#check if player[1] == new[2] 
	addi	$t1, $t1, 4
	beq	$t1, $t0, playerMoveUpTrue2	#check if player[1] == new[3] 
	addi	$t1, $t1, 4
	beq	$t1, $t0, playerMoveUpTrue2	#check if player[1] == new[4] 
	addi	$t1, $t1, 4
	beq	$t1, $t0, playerMoveUpTrue2	#check if player[1] == new[5] 
	addi	$t1, $t1, 4
	beq	$t1, $t0, playerMoveUpTrue2	#check if player[1] == new[6] 
	addi	$t1, $t1, 4
	beq	$t1, $t0, playerMoveUpTrue2	#check if playerModel's right foot is off platform, but left foot is still on
	#if all the checks fail, do not move player up
	j playerMoveUpFalse2		
	
playerMoveUpTrue2:
	addi	$sp, $sp, -4
	sw	$a2, ($sp)	#push a2 to stack
	jal	playerMoveUp
	lw	$a2, ($sp)	#pop a2 from stack
	addi	$sp, $sp, 4

playerMoveUpFalse2:
	
	#update new pixels
	
	addi	$a2, $a2, -128		#compute bitmap address of new platform[0]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[1]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[2]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[3]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[4]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[5]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[6]
	sw	$v1, ($a2)
	#remove old pixels
	addi	$a3, $a3, BASE_ADDRESS	#bitmap address using old array[0] offset val
	sw	$v0, ($a3)
	addi	$a3, $a3, 4		#bitmap address using old array[1] offset val
	sw	$v0, ($a3)
	addi	$a3, $a3, 4		#bitmap address using old array[2] offset val
	sw	$v0, ($a3)
	addi	$a3, $a3, 4		#bitmap address using old array[3] offset val
	sw	$v0, ($a3)
	addi	$a3, $a3, 4		#bitmap address using old array[4] offset val
	sw	$v0, ($a3)
	addi	$a3, $a3, 4		#bitmap address using old array[5] offset val
	sw	$v0, ($a3)
	addi	$a3, $a3, 4		#bitmap address using old array[6] offset val
	sw	$v0, ($a3)
	
	j PLATFORM1_MOVEMENT_END


PLATFORM1_UP_TO_DOWN:
	#update enemy direction
	la	$t0, movingPlatform1Direction
	sw	$0, ($t0)
	
	#platformPosition++
	la	$t2, movingPlatform1Position	#load variable address
	addi	$t1, $t1, 1		#decrement from prev loaded e1m1Position
	sw	$t1, ($t2)		#store the updated e1m1Position
	
	#shift platform 1 unit down
	li	$v0, PURPLE
	li	$v1, PLATFORM_COLOUR
	la	$a0, movingPlatform1
	lw	$a1, ($a0)
	move	$a3, $a1		#copy offset[0] in a1 to a3, so we can keep things organized
	addi	$a2, $a1, BASE_ADDRESS	#store bitmap address using old arr offset[0] in a2 to keep organized
	#update array offsets change their corresponding bitmap addresses' pixels
	addi	$a1, $a1, 128
	sw	$a1, ($a0)		#update array[0] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 4($a0)		#update array[1] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 8($a0)		#update array[2] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 12($a0)		#update array[3] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 16($a0)		#update array[4] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 20($a0)		#update array[5] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 24($a0)		#update array[6] offset val
	#update new pixels
	addi	$a2, $a2, 128		#compute bitmap address of new platform[0]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[1]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[2]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[3]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[4]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[5]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[6]
	sw	$v1, ($a2)
	#remove old pixels
	addi	$a3, $a3, BASE_ADDRESS	#bitmap address using old array[0] offset val
	sw	$v0, ($a3)
	addi	$a3, $a3, 4		#bitmap address using old array[1] offset val
	sw	$v0, ($a3)
	addi	$a3, $a3, 4		#bitmap address using old array[2] offset val
	sw	$v0, ($a3)
	addi	$a3, $a3, 4		#bitmap address using old array[3] offset val
	sw	$v0, ($a3)
	addi	$a3, $a3, 4		#bitmap address using old array[4] offset val
	sw	$v0, ($a3)
	addi	$a3, $a3, 4		#bitmap address using old array[5] offset val
	sw	$v0, ($a3)
	addi	$a3, $a3, 4		#bitmap address using old array[6] offset val
	sw	$v0, ($a3)
	j PLATFORM1_MOVEMENT_END

INCREMENT_PLATFORM1_BUFFER:
	addi	$a1, $a1, 1	#increment buffer val by 1 
	sw	$a1, ($a0)	#store updated buffer val
	j PLATFORM1_MOVEMENT_END
	
PLATFORM1_MOVEMENT_END:

	#refresh shuriken pickup if player hasn't picked it up yet
	la	$a0, playerMode
	lw	$a0, ($a0)
	beq	$a0, 2, removeShuriken
	
	#otherwise refresh shuriken 
	li	$a0, SHURIKEN 
	li	$a1, SHURIKEN_CENTER
	la	$t0, shuriken
	lw	$t0, ($t0)
	addi	$t0, $t0, BASE_ADDRESS
	li	$t1, PURPLE		
	sw	$a0, ($t0)		#redraw shuriken
	sw	$a0, -132($t0)
	sw	$a1, -128($t0)
	sw	$a0, -124($t0)
	sw	$a0, -256($t0)
	j 	refreshShurikenEnd
	
removeShuriken:
	#remove shuriken from the map
	la	$t0, shuriken
	lw	$t0, ($t0)
	addi	$t0, $t0, BASE_ADDRESS
	li	$t1, PURPLE		
	sw	$t1, ($t0)		#replace shuriken with purple
	sw	$t1, -132($t0)
	sw	$t1, -128($t0)
	sw	$t1, -124($t0)
	sw	$t1, -256($t0)
	j 	refreshShurikenEnd
	
refreshShurikenEnd:
	
	j REFRESH_OBJECTS_END		#return to gameLoop


REFRESH_LEVEL_THREE:
	#draw entrance door
	li	$a0, 964		#first pixel starts @ 1136 + BASE_ADDRESS
	li	$a1, PREV_DOOR		#load colour for door 
	li	$a2, PREV_GOLD		#load colour for handle 
	addi	$a0, $a0, BASE_ADDRESS	
	sw	$a1, ($a0)		#draw door[0]
	addi	$a0, $a0, 4
	sw	$a1, ($a0)		#draw door[1]
	addi	$a0, $a0, -128
	sw	$a2, ($a0)		#draw door[3]
	addi	$a0, $a0, -4
	sw	$a1, ($a0)		#draw door[2]
	addi	$a0, $a0, -128
	sw	$a1, ($a0)		#draw door[4]
	addi	$a0, $a0, 4
	sw	$a1, ($a0)		#draw door[5]
	addi	$a0, $a0, -128
	sw	$a1, ($a0)		#draw door[7]
	addi	$a0, $a0, -4
	sw	$a1, ($a0)		#draw door[6]

	#check if wand should be refreshed
	la	$a0, playerMode
	lw	$a0, ($a0)
	beq	$a0, 3, drawWandFalse
	
	#otherwise, draw wand pickup
	li	$t0, WAND_HANDLE
	li	$t1, WAND_CROWN
	la	$a0, wand
	lw	$a0, ($a0)
	addi	$a0, $a0, BASE_ADDRESS
	#handle
	sw	$t0, ($a0)
	addi	$a0, $a0, -128
	sw	$t0, ($a0) 
	#crown
	addi	$a0, $a0, -128
	sw	$t1, ($a0) 
drawWandFalse:

	#check if button should be refreshed
	la	$a0, isButtonPressed
	lw	$a0, ($a0)
	beq	$a0, 1, drawButtonFalse
	
	#otherwise, draw button 
	li	$a0, BUTTON_COLOUR
	li	$a1, 3380
	addi	$a1, $a1, BASE_ADDRESS
	sw	$a0, ($a1)
	sw	$a0, -128($a1)
drawButtonFalse:

	#redraw platforms
	li	$a0, PLATFORM_COLOUR
	#P1M3:	y->9
	li	$a1, 1704		
	addi	$a1, $a1, BASE_ADDRESS		#compute bitmap address of platform's starting pixel 
	sw	$a0, ($a1)
	sw	$a0, 4($a1)
	sw	$a0, 8($a1)
	sw	$a0, 12($a1)
	
	#P1M3:	y->9
	li	$a1, 2692		
	addi	$a1, $a1, BASE_ADDRESS		#compute bitmap address of platform's starting pixel 
	sw	$a0, ($a1)
	sw	$a0, 4($a1)
	sw	$a0, 8($a1)
	sw	$a0, 12($a1)
	
#U1M3_LAVA: y->10
	li	$a0, 10	#y-counter
U1M3_LAVA_OUTER_START:
	beq 	$a0, 13, U1M3_LAVA_OUTER_END		#branch when y == 13
	
	li	$a1, 23	#x-counter		#reset x-counter each iteration
U1M3_LAVA_INNER_START:
	beq	$a1, 32, U1M3_LAVA_INNER_END		#branch when x == 31

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
	li	$t1, LAVA
	sw	$t1, ($t0)		
	#increment x-counter
	addi	$a1, $a1, 1
	j U1M3_LAVA_INNER_START			#return to start of loop
U1M3_LAVA_INNER_END:

	#increment y-counter
	addi	$a0, $a0, 1
	j U1M3_LAVA_OUTER_START
U1M3_LAVA_OUTER_END:


#U3M3_LAVA: y->10
	li	$a0, 10	#y-counter
U3M3_LAVA_OUTER_START:
	beq 	$a0, 13, U3M3_LAVA_OUTER_END		#branch when y == 13
	
	li	$a1, 0	#x-counter		#reset x-counter each iteration
U3M3_LAVA_INNER_START:
	beq	$a1, 9, U3M3_LAVA_INNER_END		#branch when x == 9

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
	li	$t1, LAVA
	sw	$t1, ($t0)		
	#increment x-counter
	addi	$a1, $a1, 1
	j U3M3_LAVA_INNER_START			#return to start of loop
U3M3_LAVA_INNER_END:

	#increment y-counter
	addi	$a0, $a0, 1
	j U3M3_LAVA_OUTER_START
U3M3_LAVA_OUTER_END:


#U4M3_LAVA: y->20
	li	$a0, 20	#y-counter
U4M3_LAVA_OUTER_START:
	beq 	$a0, 21, U4M3_LAVA_OUTER_END		#branch when y == 21
	
	li	$a1, 6	#x-counter		#reset x-counter each iteration
U4M3_LAVA_INNER_START:
	beq	$a1, 14, U4M3_LAVA_INNER_END		#branch when x == 14

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
	li	$t1, LAVA
	sw	$t1, ($t0)		
	#increment x-counter
	addi	$a1, $a1, 1
	j U4M3_LAVA_INNER_START			#return to start of loop
U4M3_LAVA_INNER_END:

	#increment y-counter
	addi	$a0, $a0, 1
	j U4M3_LAVA_OUTER_START
U4M3_LAVA_OUTER_END:


#U5M3_LAVA: y->28
	li	$a0, 28	#y-counter
U5M3_LAVA_OUTER_START:
	beq 	$a0, 30, U5M3_LAVA_OUTER_END		#branch when y == 30
	
	li	$a1, 1	#x-counter		#reset x-counter each iteration
U5M3_LAVA_INNER_START:
	beq	$a1, 9, U5M3_LAVA_INNER_END		#branch when x == 9

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
	li	$t1, LAVA
	sw	$t1, ($t0)		
	#increment x-counter
	addi	$a1, $a1, 1
	j U5M3_LAVA_INNER_START			#return to start of loop
U5M3_LAVA_INNER_END:

	#increment y-counter
	addi	$a0, $a0, 1
	j U5M3_LAVA_OUTER_START
U5M3_LAVA_OUTER_END:


#draw movingPlatform2 -> movement bounded by [0, 11 pixels right from startpoint]
#this platform consists of 7 pixels
	la	$a0, movingPlatform2Buffer
	lw	$a1, ($a0)
	#if movingPlatformBuffer < 5, then skip update and reset movingPlatformBuffer
	blt	$a1, 5, INCREMENT_PLATFORM2_BUFFER
	
	#else, update moving platform and reset buffer
	sw	$0, ($a0)	#set buffer = 0
	#load direction and position
	la	$t0, movingPlatform2Direction
	lw	$t0, ($t0)	
	la	$t1, movingPlatform2Position
	lw	$t1, ($t1)	
	
	#branch to move_left if direction == 0
	beq	$t0, 0,	PLATFORM2_MOVE_LEFT	
	
	#Otherwise, move_right:
	#if platformPosition == 13, switch direction
	beq	$t1, 11, PLATFORM2_RIGHT_TO_LEFT
	
	#movingPlatform2Position++
	la	$t2, movingPlatform2Position	#load variable address
	addi	$t1, $t1, 1			#decrement from prev loaded e1m1Position
	sw	$t1, ($t2)			#store the updated e1m1Position
	
	#shift platform 1 unit right
	li	$v0, PURPLE
	li	$v1, PLATFORM_COLOUR
	la	$a0, movingPlatform2
	lw	$a1, ($a0)
	move	$a3, $a1		#copy offset[0] in a1 to a3, so we can keep things organized
	addi	$a2, $a1, BASE_ADDRESS	#store bitmap address using old arr offset[0] in a2 to keep organized
	addi	$t1, $a1, -128		#used to check if playerModel's feet offset matches above the platform
	
	#update array offsets change their corresponding bitmap addresses' pixels
	addi	$a1, $a1, 4
	sw	$a1, ($a0)		#update array[0] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 4($a0)		#update array[1] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 8($a0)		#update array[2] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 12($a0)		#update array[3] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 16($a0)		#update array[4] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 20($a0)		#update array[5] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 24($a0)		#update array[6] offset val
	
	#update new pixels
	addi	$a2, $a2, 4		#compute bitmap address of new platform[0]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[1]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[2]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[3]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[4]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[5]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[6]
	sw	$v1, ($a2)
	#remove old pixels
	addi	$a3, $a3, BASE_ADDRESS	#bitmap address using old array[0] offset val
	sw	$v0, ($a3)
	
	j PLATFORM2_MOVEMENT_END

		
PLATFORM2_MOVE_LEFT: 
	#if platformPosition == 0, switch direction
	beq	$t1, 0, PLATFORM2_LEFT_TO_RIGHT
	
	#platformPosition--
	la	$t2, movingPlatform2Position	#load variable address
	addi	$t1, $t1, -1			#increment from prev loaded platformPosition
	sw	$t1, ($t2)			#store the updated platformPosition
	
	#shift platform 1 unit left
	li	$v0, PURPLE
	li	$v1, PLATFORM_COLOUR
	la	$a0, movingPlatform2
	lw	$a1, ($a0)
	move	$a3, $a1		#copy offset[0] in a1 to a3, so we can keep things organized
	addi	$a2, $a1, BASE_ADDRESS	#store bitmap address using old arr offset[0] in a2 to keep organized
	
	#update array offsets change their corresponding bitmap addresses' pixels
	addi	$a1, $a1, -4
	sw	$a1, ($a0)		#update array[0] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 4($a0)		#update array[1] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 8($a0)		#update array[2] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 12($a0)		#update array[3] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 16($a0)		#update array[4] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 20($a0)		#update array[5] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 24($a0)		#update array[6] offset val
	
	#update new pixels
	addi	$a2, $a2, -4		#compute bitmap address of new platform[0]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[1]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[2]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[3]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[4]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[5]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[6]
	sw	$v1, ($a2)
	#remove old pixels
	addi	$a3, $a3, BASE_ADDRESS	#bitmap address using old array[0] offset val
	addi	$a3, $a3, 24
	sw	$v0, ($a3)		#we only need to replace the rightmost bit in the arr
	
	j PLATFORM2_MOVEMENT_END
	

PLATFORM2_LEFT_TO_RIGHT:
	#update platform direction
	li	$t2, 1
	la	$t0, movingPlatform2Direction
	sw	$t2, ($t0)
	
	#platformposition++
	la	$t2, movingPlatform2Position	#load variable address
	addi	$t1, $t1, 1		#increment from prev loaded platformPosition
	sw	$t1, ($t2)		#store the updated platformPosition
	
	#shift platform 1 unit right
	li	$v0, PURPLE
	li	$v1, PLATFORM_COLOUR
	la	$a0, movingPlatform2
	lw	$a1, ($a0)
	move	$a3, $a1		#copy offset[0] in a1 to a3, so we can keep things organized
	addi	$a2, $a1, BASE_ADDRESS	#store bitmap address using old arr offset[0] in a2 to keep organized
	addi	$t1, $a1, -128		#used to check if playerModel's feet offset matches above the platform
	
	#update array offsets change their corresponding bitmap addresses' pixels
	addi	$a1, $a1, 4
	sw	$a1, ($a0)		#update array[0] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 4($a0)		#update array[1] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 8($a0)		#update array[2] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 12($a0)		#update array[3] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 16($a0)		#update array[4] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 20($a0)		#update array[5] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 24($a0)		#update array[6] offset val
	
	#update new pixels
	addi	$a2, $a2, 4		#compute bitmap address of new platform[0]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[1]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[2]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[3]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[4]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[5]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[6]
	sw	$v1, ($a2)
	#remove old pixels
	addi	$a3, $a3, BASE_ADDRESS	#bitmap address using old array[0] offset val
	sw	$v0, ($a3)
	
	j PLATFORM2_MOVEMENT_END


PLATFORM2_RIGHT_TO_LEFT:
	#update enemy direction
	la	$t0, movingPlatform2Direction
	sw	$0, ($t0)
	
	#platformPosition--
	la	$t2, movingPlatform2Position	#load variable address
	addi	$t1, $t1, -1		#decrement from prev loaded e1m1Position
	sw	$t1, ($t2)		#store the updated e1m1Position
	
	#shift platform 1 unit left
	li	$v0, PURPLE
	li	$v1, PLATFORM_COLOUR
	la	$a0, movingPlatform2
	lw	$a1, ($a0)
	move	$a3, $a1		#copy offset[0] in a1 to a3, so we can keep things organized
	addi	$a2, $a1, BASE_ADDRESS	#store bitmap address using old arr offset[0] in a2 to keep organized
	
	#update array offsets change their corresponding bitmap addresses' pixels
	addi	$a1, $a1, -4
	sw	$a1, ($a0)		#update array[0] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 4($a0)		#update array[1] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 8($a0)		#update array[2] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 12($a0)		#update array[3] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 16($a0)		#update array[4] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 20($a0)		#update array[5] offset val
	addi	$a1, $a1, 4	
	sw	$a1, 24($a0)		#update array[6] offset val
	
	#update new pixels
	addi	$a2, $a2, -4		#compute bitmap address of new platform[0]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[1]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[2]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[3]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[4]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[5]
	sw	$v1, ($a2)
	addi	$a2, $a2, 4		#compute bitmap address of new platform[6]
	sw	$v1, ($a2)
	#remove old pixels
	addi	$a3, $a3, BASE_ADDRESS	#bitmap address using old array[0] offset val
	addi	$a3, $a3, 24		#only need to remove rightmost pixel
	sw	$v0, ($a3)
	j PLATFORM2_MOVEMENT_END

INCREMENT_PLATFORM2_BUFFER:
	addi	$a1, $a1, 1	#increment buffer val by 1 
	sw	$a1, ($a0)	#store updated buffer val
	j PLATFORM2_MOVEMENT_END	

PLATFORM2_MOVEMENT_END:
	j REFRESH_OBJECTS_END

REFRESH_OBJECTS_END:
	lw	$ra, ($sp)			#pop ra from stack
	addi	$sp, $sp, 4
	jr $ra					#return to gameLoop
	


#F: draws level one onto the bitmap display & loads enemies
generateLevelOne:
	addi	$sp, $sp, -4	
	sw	$ra, ($sp)	#push ra to stack
	#reset the map background and border
	jal setupDisplay

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


	#U2M1: y-> 10-8, x-> 19 - 30 
	li	$a0, 8	#y-counter
U2M1_OUTER_START:
	beq 	$a0, 11, U2M1_OUTER_END		#branch when y == 11
	
	li	$a1, 19	#x-counter		#reset x-counter each iteration
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
	
	#draw exit Door
	li	$a0, 1008		#first pixel starts @ 1136 + BASE_ADDRESS
	li	$a1, BROWN		#load colour for door 
	li	$a2, GOLD		#load colour for handle 
	addi	$a0, $a0, BASE_ADDRESS	
	sw	$a1, ($a0)		#draw door[0]
	addi	$a0, $a0, 4
	sw	$a1, ($a0)		#draw door[1]
	addi	$a0, $a0, -128
	sw	$a2, ($a0)		#draw door[3]
	addi	$a0, $a0, -4
	sw	$a1, ($a0)		#draw door[2]
	addi	$a0, $a0, -128
	sw	$a1, ($a0)		#draw door[4]
	addi	$a0, $a0, 4
	sw	$a1, ($a0)		#draw door[5]
	addi	$a0, $a0, -128
	sw	$a1, ($a0)		#draw door[7]
	addi	$a0, $a0, -4
	sw	$a1, ($a0)		#draw door[6]
	
	#setup warrior playerModel
	jal	setupWarrior		#$ra is already pushed to stack
	
	lw	$ra, 0($sp) 	#pop return address from stack
	addi	$sp, $sp, 4	#update sp
	jr $ra			#return to caller



#F: draws level two onto the bitmap display
generateLevelTwo:
	addi	$sp, $sp, -4	
	sw	$ra, ($sp)	#push ra to stack
	#reset the map background and border
	jal setupDisplay
	
	#update currLevel
	la	$a0, currLevel
	li	$a1, 2
	sw	$a1, ($a0)
	
	#add unpassible platforms (use BORDER_COLOUR)

#U1M2: start at y == 8
	li	$a0, 8	#starting val for y-counter 
U1M2_OUTER_START:
	beq 	$a0, 10, U1M2_OUTER_END		#branch when y == 11
	
	li	$a1, 16	#starting val for x-counter		#reset x-counter each iteration
U1M2_INNER_START:
	beq	$a1, 31, U1M2_INNER_END		#branch when x == 31

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
	j U1M2_INNER_START			#return to start of loop
U1M2_INNER_END:

	#increment y-counter
	addi	$a0, $a0, 1
	j U1M2_OUTER_START
U1M2_OUTER_END:

	
#wall in between two exit doors (7 bits high, 2 bits wide)
#U2M2: start at y = 1 counter
	li	$a0, 1 	#y-counter
U2M2_OUTER_START:
	beq 	$a0, 8, U2M2_OUTER_END		#branch when y == 8
	
	li	$a1, 20	#x-counter		#reset x-counter each iteration
U2M2_INNER_START:
	beq	$a1, 22, U2M2_INNER_END		#branch when x == 22

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
	j U2M2_INNER_START			#return to start of loop
U2M2_INNER_END:

	#increment y-counter
	addi	$a0, $a0, 1
	j U2M2_OUTER_START
U2M2_OUTER_END:


#block underneath exit door
#U3M2: start at y = 1 counter
	li	$a0, 10 	#y-counter
U3M2_OUTER_START:
	beq 	$a0, 20, U3M2_OUTER_END		#branch when y == 20
	
	li	$a1, 16	#x-counter		#reset x-counter each iteration
U3M2_INNER_START:
	beq	$a1, 20, U3M2_INNER_END		#branch when x == 20

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
	j U3M2_INNER_START			#return to start of loop
U3M2_INNER_END:

	#increment y-counter
	addi	$a0, $a0, 1
	j U3M2_OUTER_START
U3M2_OUTER_END:


#elevated floor
#U4M2: start at y = 27 counter
	li	$a0, 27 	#y-counter
U4M2_OUTER_START:
	beq 	$a0, 30, U4M2_OUTER_END		#branch when y == 30
	
	li	$a1, 1	#x-counter		#reset x-counter each iteration
U4M2_INNER_START:
	beq	$a1, 20, U4M2_INNER_END		#branch when x == 20

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
	j U4M2_INNER_START			#return to start of loop
U4M2_INNER_END:

	#increment y-counter
	addi	$a0, $a0, 1
	j U4M2_OUTER_START
U4M2_OUTER_END:

	#draw exit door
	li	$a0, 964		#first pixel starts @ 1136 + BASE_ADDRESS
	li	$a1, BROWN		#load colour for door 
	li	$a2, GOLD		#load colour for handle 
	addi	$a0, $a0, BASE_ADDRESS	
	sw	$a1, ($a0)		#draw door[0]
	addi	$a0, $a0, 4
	sw	$a1, ($a0)		#draw door[1]
	addi	$a0, $a0, -128
	sw	$a2, ($a0)		#draw door[3]
	addi	$a0, $a0, -4
	sw	$a1, ($a0)		#draw door[2]
	addi	$a0, $a0, -128
	sw	$a1, ($a0)		#draw door[4]
	addi	$a0, $a0, 4
	sw	$a1, ($a0)		#draw door[5]
	addi	$a0, $a0, -128
	sw	$a1, ($a0)		#draw door[7]
	addi	$a0, $a0, -4
	sw	$a1, ($a0)		#draw door[6]
	
	#create space near entrance door for a platform
	li	$a0, PURPLE
	li	$a1, 1116
	addi	$a1, $a1, BASE_ADDRESS
	sw	$a0, ($a1)
	addi	$a1,$a1, 4
	sw	$a0, ($a1)
	addi	$a1,$a1, 4
	sw	$a0, ($a1)
	addi	$a1,$a1, 4
	sw	$a0, ($a1)
	addi	$a1,$a1, 128
	sw	$a0, ($a1)
	addi	$a1,$a1, -4
	sw	$a0, ($a1)
	addi	$a1,$a1, -4
	sw	$a0, ($a1)
	addi	$a1,$a1, -4
	sw	$a0, ($a1)
	
	lw	$ra, 0($sp) 	#pop return address from stack
	addi	$sp, $sp, 4	#update sp
	jr $ra			#return to caller
	


#F: draws level three onto the bitmap display
generateLevelThree:
	#push ra to stack
	addi	$sp, $sp, -4	
	sw	$ra, ($sp)	
	#reset the map background and border
	jal setupDisplay
	
	#update currLevel
	la	$a0, currLevel
	li	$a1, 3
	sw	$a1, ($a0)

	#modify some borders to allow model to warp around the level
	li	$a0, PURPLE
	#left side
	li	$a1, 128
	addi	$a1, $a1, BASE_ADDRESS
	sw	$a0, ($a1)
	addi	$a1, $a1, 128
	sw	$a0, ($a1)
	addi	$a1, $a1, 128
	sw	$a0, ($a1)
	addi	$a1, $a1, 128
	sw	$a0, ($a1)
	addi	$a1, $a1, 128
	sw	$a0, ($a1)
	addi	$a1, $a1, 128
	sw	$a0, ($a1)
	addi	$a1, $a1, 128
	sw	$a0, ($a1)
	addi	$a1, $a1, 128
	sw	$a0, ($a1)
	addi	$a1, $a1, 128
	sw	$a0, ($a1)
	#right side
	li	$a1, 252
	addi	$a1, $a1, BASE_ADDRESS
	sw	$a0, ($a1)
	addi	$a1, $a1, 128
	sw	$a0, ($a1)
	addi	$a1, $a1, 128
	sw	$a0, ($a1)
	addi	$a1, $a1, 128
	sw	$a0, ($a1)
	addi	$a1, $a1, 128
	sw	$a0, ($a1)
	addi	$a1, $a1, 128
	sw	$a0, ($a1)
	addi	$a1, $a1, 128
	sw	$a0, ($a1)
	addi	$a1, $a1, 128
	sw	$a0, ($a1)
	addi	$a1, $a1, 128
	sw	$a0, ($a1)
	
	#treasure chest
	li	$s0, CHEST_GOLD
	li	$s1, CHEST_BASE
	li	$s2, CHEST_CAP
	li	$s3, CHEST_BUCKLE
	li	$a0, 3176
	addi	$a0, $a0, BASE_ADDRESS
	sw	$s0, ($a0)		#chest[0]
	sw	$s1, 4($a0)		#chest[1]
	sw	$s0, 8($a0)		#chest[2]
	sw	$s1, -128($a0)		#chest[3]
	sw	$s3, -124($a0)		#chest[4]
	sw	$s1, -120($a0)		#chest[5]
	sw	$s2, -256($a0)		#chest[6]
	sw	$s2, -252($a0)		#chest[7]
	sw	$s2, -248($a0)		#chest[8]

	#add unpassible platforms (use BORDER_COLOUR)
#U1M3: y->8
	li	$a0, 8	#y-counter
U1M3_OUTER_START:
	beq 	$a0, 14, U1M3_OUTER_END		#branch when y == 12
	
	li	$a1, 15	#x-counter		#reset x-counter each iteration
U1M3_INNER_START:
	beq	$a1, 31, U1M3_INNER_END		#branch when x == 31

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
	j U1M3_INNER_START			#return to start of loop
U1M3_INNER_END:

	#increment y-counter
	addi	$a0, $a0, 1
	j U1M3_OUTER_START
U1M3_OUTER_END:


#fill in some of U1M3 with purple
#U1M3_PURPLE: y->8
	li	$a0, 8	#y-counter
U1M3_PURPLE_OUTER_START:
	beq 	$a0, 10, U1M3_PURPLE_OUTER_END		#branch when y == 12
	
	li	$a1, 23	#x-counter		#reset x-counter each iteration
U1M3_PURPLE_INNER_START:
	beq	$a1, 31, U1M3_PURPLE_INNER_END		#branch when x == 31

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
	li	$t1, PURPLE
	sw	$t1, ($t0)		
	#increment x-counter
	addi	$a1, $a1, 1
	j U1M3_PURPLE_INNER_START			#return to start of loop
U1M3_PURPLE_INNER_END:

	#increment y-counter
	addi	$a0, $a0, 1
	j U1M3_PURPLE_OUTER_START
U1M3_PURPLE_OUTER_END:


#U2M3: the wall that divides left and right side
	li	$a0, 1	#y-counter
U2M3_OUTER_START:
	beq 	$a0, 30, U2M3_OUTER_END		#branch when y == 30
	
	li	$a1, 14	#x-counter		#reset x-counter each iteration
U2M3_INNER_START:
	beq	$a1, 15, U2M3_INNER_END		#branch when x == 14

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
	j U2M3_INNER_START			#return to start of loop
U2M3_INNER_END:

	#increment y-counter
	addi	$a0, $a0, 1
	j U2M3_OUTER_START
U2M3_OUTER_END:


#U3M3: y->8
	li	$a0, 10	#y-counter
U3M3_OUTER_START:
	beq 	$a0, 14, U3M3_OUTER_END		#branch when y == 14
	
	li	$a1, 0	#x-counter		#reset x-counter each iteration
U3M3_INNER_START:
	beq	$a1, 10, U3M3_INNER_END		#branch when x == 10

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
	j U3M3_INNER_START			#return to start of loop
U3M3_INNER_END:

	#increment y-counter
	addi	$a0, $a0, 1
	j U3M3_OUTER_START
U3M3_OUTER_END:


#U4M3: y->19
	li	$a0, 20	#y-counter
U4M3_OUTER_START:
	beq 	$a0, 22, U4M3_OUTER_END		#branch when y == 22
	
	li	$a1, 5	#x-counter		#reset x-counter each iteration
U4M3_INNER_START:
	beq	$a1, 15, U4M3_INNER_END		#branch when x == 15

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
	j U4M3_INNER_START			#return to start of loop
U4M3_INNER_END:

	#increment y-counter
	addi	$a0, $a0, 1
	j U4M3_OUTER_START
U4M3_OUTER_END:


#U5M3: y->27
	li	$a0, 28	#y-counter
U5M3_OUTER_START:
	beq 	$a0, 30, U5M3_OUTER_END		#branch when y == 30
	
	li	$a1, 1	#x-counter		#reset x-counter each iteration
U5M3_INNER_START:
	beq	$a1, 31, U5M3_INNER_END		#branch when x == 14

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
	j U5M3_INNER_START			#return to start of loop
U5M3_INNER_END:

	#increment y-counter
	addi	$a0, $a0, 1
	j U5M3_OUTER_START
U5M3_OUTER_END:


#CHEST_PLATEAU: y->27
	li	$a0, 25	#y-counter
CHEST_PLATEAU_OUTER_START:
	beq 	$a0, 30, CHEST_PLATEAU_OUTER_END		#branch when y == 30
	
	li	$a1, 24	#x-counter		#reset x-counter each iteration
CHEST_PLATEAU_INNER_START:
	beq	$a1, 31, CHEST_PLATEAU_INNER_END		#branch when x == 14

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
	j CHEST_PLATEAU_INNER_START			#return to start of loop
CHEST_PLATEAU_INNER_END:

	#increment y-counter
	addi	$a0, $a0, 1
	j CHEST_PLATEAU_OUTER_START
CHEST_PLATEAU_OUTER_END:
	#pop return address from stack
	lw	$ra, ($sp) 	
	addi	$sp, $sp, 4	
	jr $ra			#return to caller	



		#ENEMY MODEL GENERATION
	
#F: loads enemies onto map for level currLevel, based on 
loadEnemies:
	#determine current level
	la	$a0, currLevel
	lw	$a0, ($a0)
	beq	$a0, 2, LOAD_LEVEL_TWO_ENEMIES
	beq	$a0, 3, LOAD_LEVEL_THREE_ENEMIES
	
	#otherwise LOAD_LEVEL_ONE_ENEMIES
	#t0-t5 will be used to store bitmap addresses of enemyModel
	#store colours in a1-a2

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

#load e2m1 offsets (e1m1[0:5])
	la	$a0, e2m1		#load memory address of e1m1[0]
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
	
	#Check whether enemy is DAMGED or KILLED via e2m1Hit variable
	la	$a0, e2m1Hit
	lw	$a0, ($a0)			#load e2m1Hit value
	beq	$a0, 2, e2m1_KILLED		#branch if enemy has been hit twice/killed
	beq	$a0, 1, e2m1_DAMAGED1		#branch if enemy has been recently or previously hit	
	
	#otherwise load the enemies as normal
	sw	$a1, ($t0)		#enemyModel[0]
	sw	$a1, ($t1)		#enemyModel[1]
	sw	$a1, ($t2)		#enemyModel[2]
	sw	$a1, ($t3)		#enemyModel[3]
	sw	$a2, ($t4)		#enemyModel[4]
	sw	$a2, ($t5)		#enemyModel[5]
	j e2m1_LOAD_END
	
e2m1_DAMAGED1:
	sw	$a2, ($t4)		#enemyModel[4]
	sw	$a3, ($t5)		#enemyModel[5]
	
	#if enemyHitCounter == 0, then enemy should be green, otherwise branch to make enemy red
	la	$a0, enemyHitCounter	
	lw	$a0, ($a0)		#load value in enemyHitCounter		
	bgtz	$a0, e2m1_DAMAGED2	
	
	#Otherwise, make enemy green
	sw	$a1, ($t0)		#enemyModel[0]
	sw	$a1, ($t1)		#enemyModel[1]
	sw	$a1, ($t2)		#enemyModel[2]
	sw	$a1, ($t3)		#enemyModel[3]
	j e2m1_LOAD_END

e2m1_DAMAGED2:
	#make enemy red
	sw	$a3, ($t0)		#enemyModel[0]
	sw	$a3, ($t1)		#enemyModel[1]
	sw	$a3, ($t2)		#enemyModel[2]
	sw	$a3, ($t3)		#enemyModel[3]
	j e2m1_LOAD_END

e2m1_KILLED:
	li	$a0, PURPLE		#load purple
	#replace enemy colours with background colours
	sw	$a0, ($t0)		#enemyModel[0]
	sw	$a0, ($t1)		#enemyModel[1]
	sw	$a0, ($t2)		#enemyModel[2]
	sw	$a0, ($t3)		#enemyModel[3]
	sw	$a0, ($t3)		#enemyModel[4]
	sw	$a0, ($t3)		#enemyModel[5]
	j e2m1_LOAD_END
e2m1_LOAD_END:
	j LOAD_ENEMIES_END

LOAD_LEVEL_TWO_ENEMIES:
	#For level, we only need to load the enemies.

	#e1m2
	#load e1m2 offsets (e1m2[0:5])
	la	$a0, e1m2		#load memory address of e1m2[0]
	lw	$a0, ($a0)		#load offset stored in e1m2[0]
	addi	$t0, $a0, BASE_ADDRESS	#compute bitmap address of e1m2[0]
	addi	$t1, $t0, 4		#compute bitmap address of e1m2[1]
	addi	$t3, $t1, -128		#compute bitmap address of e1m2[3]
	addi	$t2, $t3, -4		#compute bitmap address of e1m2[2]
	addi	$t4, $t2, -256		#compute bitmap address of e1m2[4]
	addi	$t5, $t4, 4		#compute bitmap address of e1m2[5]
	
	#redraw pixel at bitmap addresses
	#load colours
	li	$a1, LIGHT_GREEN	#colour for enemyModel's body
	li	$a2, GREEN		#colour for enemyModel's health bar
	li	$a3, ENEMY_RED
	
	#load the enemies
	sw	$a1, ($t0)		#enemyModel[0]
	sw	$a1, ($t1)		#enemyModel[1]
	sw	$a1, ($t2)		#enemyModel[2]
	sw	$a1, ($t3)		#enemyModel[3]
	sw	$a2, ($t4)		#enemyModel[4]
	sw	$a2, ($t5)		#enemyModel[5]
	j e1m2_LOAD_END
e1m2_LOAD_END:

	#e2m2
	#load e2m2 offsets (e2m2[0:5])
	la	$a0, e2m2		#load memory address of e2m2[0]
	lw	$a0, ($a0)		#load offset stored in e2m2[0]
	addi	$t0, $a0, BASE_ADDRESS	#compute bitmap address of e2m2[0]
	addi	$t1, $t0, 4		#compute bitmap address of e2m2[1]
	addi	$t3, $t1, -128		#compute bitmap address of e2m2[3]
	addi	$t2, $t3, -4		#compute bitmap address of e2m2[2]
	addi	$t4, $t2, -256		#compute bitmap address of e2m2[4]
	addi	$t5, $t4, 4		#compute bitmap address of e2m2[5]
	
	#redraw pixel at bitmap addresses
	#load colours
	li	$a1, LIGHT_GREEN	#colour for enemyModel's body
	li	$a2, GREEN		#colour for enemyModel's health bar
	li	$a3, ENEMY_RED
	
	#load the enemies
	sw	$a1, ($t0)		#enemyModel[0]
	sw	$a1, ($t1)		#enemyModel[1]
	sw	$a1, ($t2)		#enemyModel[2]
	sw	$a1, ($t3)		#enemyModel[3]
	sw	$a2, ($t4)		#enemyModel[4]
	sw	$a2, ($t5)		#enemyModel[5]
	j e2m2_LOAD_END
e2m2_LOAD_END:

	#e3m2
	#load e3m2 offsets (e3m2[0:5])
	la	$a0, e3m2		#load memory address of e3m2[0]
	lw	$a0, ($a0)		#load offset stored in e3m2[0]
	addi	$t0, $a0, BASE_ADDRESS	#compute bitmap address of e3m2[0]
	addi	$t1, $t0, 4		#compute bitmap address of e3m2[1]
	addi	$t3, $t1, -128		#compute bitmap address of e3m2[3]
	addi	$t2, $t3, -4		#compute bitmap address of e3m2[2]
	addi	$t4, $t2, -256		#compute bitmap address of e3m2[4]
	addi	$t5, $t4, 4		#compute bitmap address of e3m2[5]
	
	#redraw pixel at bitmap addresses
	#load colours
	li	$a1, LIGHT_GREEN	#colour for enemyModel's body
	li	$a2, GREEN		#colour for enemyModel's health bar
	li	$a3, ENEMY_RED
	
	#load the enemies
	sw	$a1, ($t0)		#enemyModel[0]
	sw	$a1, ($t1)		#enemyModel[1]
	sw	$a1, ($t2)		#enemyModel[2]
	sw	$a1, ($t3)		#enemyModel[3]
	sw	$a2, ($t4)		#enemyModel[4]
	sw	$a2, ($t5)		#enemyModel[5]
	j e3m2_LOAD_END
e3m2_LOAD_END:

	#e4m2
	#load e4m2 offsets (e4m2[0:5])
	la	$a0, e4m2		#load memory address of e4m2[0]
	lw	$a0, ($a0)		#load offset stored in e4m2[0]
	addi	$t0, $a0, BASE_ADDRESS	#compute bitmap address of e4m2[0]
	addi	$t1, $t0, 4		#compute bitmap address of e4m2[1]
	addi	$t3, $t1, -128		#compute bitmap address of e4m2[3]
	addi	$t2, $t3, -4		#compute bitmap address of e4m2[2]
	addi	$t4, $t2, -256		#compute bitmap address of e4m2[4]
	addi	$t5, $t4, 4		#compute bitmap address of e4m2[5]
	
	#redraw pixel at bitmap addresses
	#load colours
	li	$a1, LIGHT_GREEN	#colour for enemyModel's body
	li	$a2, GREEN		#colour for enemyModel's health bar
	li	$a3, ENEMY_RED
	
	#load the enemies
	sw	$a1, ($t0)		#enemyModel[0]
	sw	$a1, ($t1)		#enemyModel[1]
	sw	$a1, ($t2)		#enemyModel[2]
	sw	$a1, ($t3)		#enemyModel[3]
	sw	$a2, ($t4)		#enemyModel[4]
	sw	$a2, ($t5)		#enemyModel[5]
	j e4m2_LOAD_END
e4m2_LOAD_END:
	j LOAD_ENEMIES_END

LOAD_LEVEL_THREE_ENEMIES:

LOAD_ENEMIES_END:

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
	#Also check if playerModel[0:3] == LAVA
	lw	$a1, ($a0)		#load colour
	beq 	$a1, LIGHT_GREEN, enemyCollisionTrue
	beq 	$a1, LAVA, lavaCollisionTrue
	
	addi	$a0, $a0, 4		#compute bitmap address[1]
	lw	$a1, ($a0)		#load colour
	beq 	$a1, LIGHT_GREEN, enemyCollisionTrue
	beq 	$a1, LAVA, lavaCollisionTrue
	
	addi	$a0, $a0, -128		#compute bitmap address[3]
	lw	$a1, ($a0)		#load colour
	beq 	$a1, LIGHT_GREEN, enemyCollisionTrue
	beq 	$a1, LAVA, lavaCollisionTrue
	
	addi	$a0, $a0, -4		#compute bitmap address[2]
	lw	$a1, ($a0)		#load colour
	beq 	$a1, LIGHT_GREEN, enemyCollisionTrue
	beq 	$a1, LAVA, lavaCollisionTrue
	
	addi	$a0, $a0, -128		#compute bitmap address[4]
	lw	$a1, ($a0)		#load colour
	beq 	$a1, LIGHT_GREEN, enemyCollisionTrue
	
	addi	$a0, $a0, 4		#compute bitmap address[5]
	lw	$a1, ($a0)		#load colour
	beq 	$a1, LIGHT_GREEN, enemyCollisionTrue
	
	addi	$a0, $a0, -128		#compute bitmap address[7]
	lw	$a1, ($a0)		#load colour
	beq 	$a1, LIGHT_GREEN, enemyCollisionTrue
	
	addi	$a0, $a0, -4		#compute bitmap address[6]
	lw	$a1, ($a0)		#load colour
	beq 	$a1, LIGHT_GREEN, enemyCollisionTrue
	
	#otherwise, player and enemy are not touching
	#and player is not in lava
	j	enemyCollisionFalse


	
enemyCollisionTrue:
	#skip if playerIsStealthed == true
	la	$a0, isPlayerStealthed
	lw	$a0, ($a0)
	beq	$a0, 1, enemyCollisionFalse

lavaCollisionTrue:
	#skip if playerDamaged > 0, then skip this assignment
	la	$a0, playerDamaged
	lw	$a1, ($a0)
	bgtz    $a1, enemyCollisionFalse
	
	#else set playerDamaged = 1
	li	$a1, 1
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
	#call to updatePlayerHealth
	addi	$sp, $sp, -4
	sw	$ra, ($sp)				#push ra to stack
	jal updatePlayerHealth 
	lw	$ra, ($sp)				#pop ra from stack
	addi	$sp, $sp, 4		
	
enemyCollisionFalse:
	jr	$ra	#return to gameLoop
	
	

	#PLAYER MODEL GENERATION	
	
#F: draws the player model (warrior) for first the first time 
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
	
#changes playerModel from ninja to mage
updateToWizard:
	#prep syscall
	li	$a0, 50
	li	$v0, 32
	
	#update playerMode
	la	$a1, playerMode
	li	$a2, 3
	sw	$a2, ($a1)
	
	#load colours
	li	$s0, BEARD_COLOUR
	li	$s1, ROBE_COLOUR
	li	$s2, PEACH
	li	$s3, WAND_HANDLE	#will be used to the sparkle effect
	li	$s4, PURPLE
	
	#can assume that when player touches the wand, playerDirection == 1
	#update each pixel individually
	la	$t0, playerModel
	lw	$t0, ($t0)
	addi	$t0, $t0, BASE_ADDRESS	#compute bitmap address of player[0]
	sw	$s1, ($t0)
	syscall
	addi	$t0, $t0, 4	#compute bitmap address of player[1]
	sw	$s1, ($t0)
	syscall
	addi	$t0, $t0, -132	#compute bitmap address of player[2]
	sw	$s1, ($t0)
	syscall
	addi	$t0, $t0, 4	#compute bitmap address of player[3]
	sw	$s0, ($t0)
	syscall
	addi	$t0, $t0, -132	#compute bitmap address of player[4]
	sw	$s0, ($t0)
	syscall
	addi	$t0, $t0, 4	#compute bitmap address of player[5]
	sw	$s2, ($t0)
	syscall
	addi	$t0, $t0, -132	#compute bitmap address of player[6]
	sw	$s0, ($t0)
	syscall
	addi	$t0, $t0, 4	#compute bitmap address of player[7]
	sw	$s0, ($t0)
	syscall
	
	jr	$ra		#return to caller
	
	
	
#changes playerModel from warrior to Ninja
updateToNinja:
	#prep syscall
	li	$a0, 50
	li	$v0, 32
	
	#update playerMode
	la	$a1, playerMode
	li	$a2, 2
	sw	$a2, ($a1)
	
	
	#load colours
	li	$s0, GREY
	li	$s1, BLACK
	li	$s2, PEACH
	li	$s3, HEADBAND_COLOUR
	
	#can assume that when player touches the wand, playerDirection == 0
	#update each pixel individually
	la	$t0, playerModel
	lw	$t0, ($t0)
	addi	$t0, $t0, BASE_ADDRESS	#compute bitmap address of player[0]
	sw	$s0, ($t0)
	syscall
	addi	$t0, $t0, 4	#compute bitmap address of player[1]
	sw	$s0, ($t0)
	syscall
	addi	$t0, $t0, -132	#compute bitmap address of player[2]
	sw	$s1, ($t0)
	syscall
	addi	$t0, $t0, 4	#compute bitmap address of player[3]
	sw	$s1, ($t0)
	syscall
	addi	$t0, $t0, -132	#compute bitmap address of player[4]
	sw	$s2, ($t0)
	syscall
	addi	$t0, $t0, 4	#compute bitmap address of player[5]
	sw	$s1, ($t0)
	syscall
	addi	$t0, $t0, -132	#compute bitmap address of player[6]
	sw	$s3, ($t0)
	syscall
	addi	$t0, $t0, 4	#compute bitmap address of player[7]
	sw	$s3, ($t0)
	syscall
	
	jr	$ra		#return to caller


#F: refreshes/redraws the playerModel using values stored in playerModel
refreshPlayerModel:
	#load playerModel
	la	$a0, playerModel
	
	#check if playerIsStealthed
	la	$a1, isPlayerStealthed
	lw	$a1, ($a1)
	beq	$a1, 0, refreshStealthedPlayerFalse
	
	#otherwise, refreshStealthedPlayerTrue
	li	$a1, PLAYER_STEALTH		#load colour
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
	j	REFRESH_PLAYER_MODEL_END 

refreshStealthedPlayerFalse:

	#check if playerIsFloating
	la	$a1, isPlayerFloating
	lw	$a1, ($a1)
	beq	$a1, 0, refreshFloatingPlayerFalse
	
	#otherwise, refreshFloatingPlayerTrue
	li	$a1, PLAYER_FLOATING	#load colour
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
	j	REFRESH_PLAYER_MODEL_END 

refreshFloatingPlayerFalse:
	#check if playerIsDamaged
	la	$a1, playerDamaged
	lw	$a1, ($a1)
	beq	$a1, 0, playerDamagedFalse
	#else refresh playerModel as red
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
	j	REFRESH_PLAYER_MODEL_END 
	
playerDamagedFalse:	
	#use playerMode to decide which playerModel to update to 
	la	$a1, playerMode
	lw	$a1, ($a1)
	beq	$a1, 2,	refreshNinja
	beq	$a1, 3, refreshWizard
	
	#otherwise refresh Warrior model
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
	
	j	REFRESH_PLAYER_MODEL_END

 refreshNinja:
 	#update arr[0:1]
	li	$a1, GREY		#load grey
	lw	$t0, ($a0)
	addi	$t0, $t0, BASE_ADDRESS
	sw	$a1, ($t0)
	lw	$t1, 4($a0)
	addi	$t1, $t1, BASE_ADDRESS
	sw	$a1, ($t1)
	#update arr[2:3]
	li	$a1, BLACK		#load black
	lw	$t2, 8($a0)
	addi	$t2, $t2, BASE_ADDRESS
	sw	$a1, ($t2)
	lw	$t3, 12($a0)
	addi	$t3, $t3, BASE_ADDRESS
	sw	$a1, ($t3)
	#update arr[4:5]
	li	$a1, BLACK		#load black 
	li	$a2, PEACH		#load peach
	lw	$t4, 16($a0)
	addi	$t4, $t4, BASE_ADDRESS	#compute address for new 4th pixel
	lw	$t5, 20($a0)
	addi	$t5, $t5, BASE_ADDRESS	#compute address for new 5th pixel
	
	la	$t8, playerDirection			#get address of playerDirection variable	
	lw	$t8, ($t8)				#t8 == val of playerDirection
	beq	$t8, 0, PLAYER_FACING_LEFT3
	#otherwise player is FacingRight
	sw	$a1, ($t4)		
	sw	$a2, ($t5)
	j PLAYER_FACING_RIGHT3				#j PLAYER_FACING_RIGHT1 skips playerFacingLeft
PLAYER_FACING_LEFT3:
	sw	$a2, ($t4)		
	sw	$a1, ($t5)	
PLAYER_FACING_RIGHT3:
	#update arr[6:7] (light grey already stored in a1)
	li	$a1, HEADBAND_COLOUR
	lw	$t6, 24($a0)
	addi	$t6, $t6, BASE_ADDRESS
	sw	$a1, ($t6)
	lw	$t7, 28($a0)
	addi	$t7, $t7, BASE_ADDRESS
	sw	$a1, ($t7)
	
	j	REFRESH_PLAYER_MODEL_END  

refreshWizard:
	#update arr[0:1]
	li	$a1, ROBE_COLOUR	#load robe colour
	lw	$t0, ($a0)
	addi	$t0, $t0, BASE_ADDRESS
	sw	$a1, ($t0)
	lw	$t1, 4($a0)
	addi	$t1, $t1, BASE_ADDRESS
	sw	$a1, ($t1)
	
	#update arr[2:3]
	li	$a2, BEARD_COLOUR		#load beard colour
	lw	$t2, 8($a0)
	addi	$t2, $t2, BASE_ADDRESS
	lw	$t3, 12($a0)
	addi	$t3, $t3, BASE_ADDRESS
	
	la	$t8, playerDirection			#get address of playerDirection variable	
	lw	$t8, ($t8)				#t8 == val of playerDirection
	beq	$t8, 0, PLAYER_FACING_LEFT5
	#otherwise player is FacingRight
	sw	$a1, ($t2)
	sw	$a2, ($t3)
	j PLAYER_FACING_RIGHT5				#j PLAYER_FACING_RIGHT1 skips playerFacingLeft
PLAYER_FACING_LEFT5:
	sw	$a2, ($t2)
	sw	$a1, ($t3)
PLAYER_FACING_RIGHT5:

	#update arr[4:5]
	li	$a1, BEARD_COLOUR
	li	$a2, PEACH		#load peach
	lw	$t4, 16($a0)
	addi	$t4, $t4, BASE_ADDRESS	#compute address for new 4th pixel
	lw	$t5, 20($a0)
	addi	$t5, $t5, BASE_ADDRESS	#compute address for new 5th pixel
	
	la	$t8, playerDirection			#get address of playerDirection variable	
	lw	$t8, ($t8)				#t8 == val of playerDirection
	beq	$t8, 0, PLAYER_FACING_LEFT6
	#otherwise player is FacingRight
	sw	$a1, ($t4)		
	sw	$a2, ($t5)
	j PLAYER_FACING_RIGHT6				#j PLAYER_FACING_RIGHT1 skips playerFacingLeft
PLAYER_FACING_LEFT6:
	sw	$a2, ($t4)		
	sw	$a1, ($t5)	
PLAYER_FACING_RIGHT6:
	#update arr[6:7] (beard colour already stored in a1)
	lw	$t6, 24($a0)
	addi	$t6, $t6, BASE_ADDRESS
	sw	$a1, ($t6)		
	lw	$t7, 28($a0)
	addi	$t7, $t7, BASE_ADDRESS
	sw	$a1, ($t7)
	
	j	REFRESH_PLAYER_MODEL_END 

REFRESH_PLAYER_MODEL_END:
	jr 	$ra	#return to gameLoop or updateDamagedPlayer


#F: updates playerModel array and replaces old character model with updated model
#Assumes t0-t7 == old offsets, s0-s7 == new offsets
updatePlayerModel:	
	#use playerMode to decide which playerModel to update to 
	la	$a0, playerMode
	lw	$a0, ($a0)
	beq	$a0, 2,	playerModelNinja
	beq	$a0, 3, playerModelWizard
	
	#otherwise update to playerModelWarrior
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
	
	j	updatePlayerModelEnd	


playerModelNinja:
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
	#if player is stealthed, make the movement grey
	la	$a1, isPlayerStealthed
	lw	$a1, ($a1)
	beq	$a1, 1, updateStealthedPlayerTrue
	
	#otherwise, updateStealthedPlayerFalse:
	#new arr[0:1]
	li	$a1, GREY		#load grey
	sw	$s0, ($a0)		#store new offset into playerModel arr
	addi	$s0, $s0, BASE_ADDRESS	#compute pixel's new bitmap address
	sw	$a1, ($s0)		#update new pixel's colour
	sw	$s1, 4($a0)
	addi	$s1, $s1, BASE_ADDRESS
	sw	$a1, ($s1)		
	#new arr[2:3]
	li	$a1, BLACK		#load black
	sw	$s2, 8($a0)
	addi	$s2, $s2, BASE_ADDRESS
	sw	$a1, ($s2)		
	sw	$s3, 12($a0)
	addi	$s3, $s3, BASE_ADDRESS
	sw	$a1, ($s3)		
	#new arr[4:5] => should update pixel based on playerDirection
	li	$a1, BLACK		#load light black
	li	$a2, PEACH		#load peach
	sw	$s4, 16($a0)
	addi	$s4, $s4, BASE_ADDRESS	#compute address for new 4th pixel
	sw	$s5, 20($a0)
	addi	$s5, $s5, BASE_ADDRESS	#compute address for new 5th pixel
	
	la	$t8, playerDirection			#get address of playerDirection variable	
	lw	$t8, ($t8)				#t8 == val of playerDirection
	beq	$t8, 0, PLAYER_FACING_LEFT4
	#otherwise player is FacingRight
	sw	$a1, ($s4)		
	sw	$a2, ($s5)
	j PLAYER_FACING_RIGHT4				#j PLAYER_FACING_RIGHT skips the updates for playerFacingLeft
PLAYER_FACING_LEFT4:
	sw	$a2, ($s4)		
	sw	$a1, ($s5)	
PLAYER_FACING_RIGHT4:
	#new arr[6:7]
	li	$a1, HEADBAND_COLOUR
	sw	$s6, 24($a0)
	addi	$s6, $s6, BASE_ADDRESS
	sw	$a1, ($s6)		
	sw	$s7, 28($a0)
	addi	$s7, $s7, BASE_ADDRESS
	sw	$a1, ($s7)
	
	j updatePlayerModelEnd

updateStealthedPlayerTrue:
	li	$a1, PLAYER_STEALTH	#load stealth colour
	#new arr[0:1]
	sw	$s0, ($a0)		#store new offset into playerModel arr
	addi	$s0, $s0, BASE_ADDRESS	#compute pixel's new bitmap address
	sw	$a1, ($s0)		#update new pixel's colour
	sw	$s1, 4($a0)
	addi	$s1, $s1, BASE_ADDRESS
	sw	$a1, ($s1)		
	#new arr[2:3]
	sw	$s2, 8($a0)
	addi	$s2, $s2, BASE_ADDRESS
	sw	$a1, ($s2)		
	sw	$s3, 12($a0)
	addi	$s3, $s3, BASE_ADDRESS
	sw	$a1, ($s3)	
	#new arr[4:5]	
	sw	$s4, 16($a0)
	addi	$s4, $s4, BASE_ADDRESS	#compute address for new 4th pixel
	sw	$s5, 20($a0)
	addi	$s5, $s5, BASE_ADDRESS	#compute address for new 5th pixel
	sw	$a1, ($s4)		
	sw	$a1, ($s5)			
	#new arr[6:7]
	sw	$s6, 24($a0)
	addi	$s6, $s6, BASE_ADDRESS
	sw	$a1, ($s6)		
	sw	$s7, 28($a0)
	addi	$s7, $s7, BASE_ADDRESS
	sw	$a1, ($s7)
	
	j updatePlayerModelEnd


playerModelWizard:
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
	#if player is floating
	la	$a1, isPlayerFloating
	lw	$a1, ($a1)
	beq	$a1, 1, updateFloatingPlayerTrue	
	
	#otherwise, updateFloatingPlayerFalse:
	#update the playerModel array & playerModel drawing on bitmap display
	#new arr[0:1]
	li	$a1, ROBE_COLOUR	#load wizard robe colour
	sw	$s0, ($a0)		#store new offset into playerModel arr
	addi	$s0, $s0, BASE_ADDRESS	#compute pixel's new bitmap address
	sw	$a1, ($s0)		#update new pixel's colour
	sw	$s1, 4($a0)
	addi	$s1, $s1, BASE_ADDRESS
	sw	$a1, ($s1)		
	#new arr[2:3] => should update pixel based on playerDirection
	li	$a2, BEARD_COLOUR	#load beard colour 
	sw	$s2, 8($a0)
	addi	$s2, $s2, BASE_ADDRESS
	sw	$s3, 12($a0)
	addi	$s3, $s3, BASE_ADDRESS
	
	la	$t8, playerDirection			#get address of playerDirection variable	
	lw	$t8, ($t8)				#t8 == val of playerDirection
	beq	$t8, 0, PLAYER_FACING_LEFT7
	#otherwise player is FacingRight
	sw	$a1, ($s2)		
	sw	$a2, ($s3)
	j PLAYER_FACING_RIGHT7				#j PLAYER_FACING_RIGHT skips the updates for playerFacingLeft
PLAYER_FACING_LEFT7:
	sw	$a2, ($s2)		
	sw	$a1, ($s3)
PLAYER_FACING_RIGHT7:		
	#new arr[4:5] => should update pixel based on playerDirection
	li	$a1, BEARD_COLOUR	#load beard colour
	li	$a2, PEACH		#load peach
	sw	$s4, 16($a0)
	addi	$s4, $s4, BASE_ADDRESS	#compute address for new 4th pixel
	sw	$s5, 20($a0)
	addi	$s5, $s5, BASE_ADDRESS	#compute address for new 5th pixel
	
	la	$t8, playerDirection			#get address of playerDirection variable	
	lw	$t8, ($t8)				#t8 == val of playerDirection
	beq	$t8, 0, PLAYER_FACING_LEFT8
	#otherwise player is FacingRight
	sw	$a1, ($s4)		
	sw	$a2, ($s5)
	j PLAYER_FACING_RIGHT8				#j PLAYER_FACING_RIGHT skips the updates for playerFacingLeft
PLAYER_FACING_LEFT8:
	sw	$a2, ($s4)		
	sw	$a1, ($s5)	
PLAYER_FACING_RIGHT8:
	#new arr[6:7]
	sw	$s6, 24($a0)
	addi	$s6, $s6, BASE_ADDRESS
	sw	$a1, ($s6)		
	sw	$s7, 28($a0)
	addi	$s7, $s7, BASE_ADDRESS
	sw	$a1, ($s7)
	
	j updatePlayerModelEnd

updateFloatingPlayerTrue:
	li	$a1, PLAYER_FLOATING	#load stealth colour
	#new arr[0:1]
	sw	$s0, ($a0)		#store new offset into playerModel arr
	addi	$s0, $s0, BASE_ADDRESS	#compute pixel's new bitmap address
	sw	$a1, ($s0)		#update new pixel's colour
	sw	$s1, 4($a0)
	addi	$s1, $s1, BASE_ADDRESS
	sw	$a1, ($s1)		
	#new arr[2:3]
	sw	$s2, 8($a0)
	addi	$s2, $s2, BASE_ADDRESS
	sw	$a1, ($s2)		
	sw	$s3, 12($a0)
	addi	$s3, $s3, BASE_ADDRESS
	sw	$a1, ($s3)	
	#new arr[4:5]	
	sw	$s4, 16($a0)
	addi	$s4, $s4, BASE_ADDRESS	#compute address for new 4th pixel
	sw	$s5, 20($a0)
	addi	$s5, $s5, BASE_ADDRESS	#compute address for new 5th pixel
	sw	$a1, ($s4)		
	sw	$a1, ($s5)			
	#new arr[6:7]
	sw	$s6, 24($a0)
	addi	$s6, $s6, BASE_ADDRESS
	sw	$a1, ($s6)		
	sw	$s7, 28($a0)
	addi	$s7, $s7, BASE_ADDRESS
	sw	$a1, ($s7)
	
	j updatePlayerModelEnd

updatePlayerModelEnd:
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



#F: resets all variable values, and then restarts the game
restartGame:
	#playerData
	la	$a0, playerModel
	li	$t0, 3724
	li	$t1, 3728
	li	$t2, 3596
	li	$t3, 3600
	li	$t4, 3468
	li	$t5, 3472
	li	$t6, 3340
	li	$t7, 3344
	sw	$t0, ($a0)
	sw	$t1, 4($a0)
	sw	$t2, 8($a0)
	sw	$t3, 12($a0)
	sw	$t4, 16($a0)
	sw	$t5, 20($a0)
	sw	$t6, 24($a0)
	sw	$t7, 28($a0)
	
	la	$a0, playerHealth
	li	$t0, 3
	sw	$t0, ($a0)
	
	la	$a0, playerDamaged
	li	$t0, 0
	sw	$t0, ($a0)
	
	la	$a0, playerMode
	li	$t0, 1
	sw	$t0, ($a0)
	
	la	$a0, isPlayerStealthed
	li	$t0, 0
	sw	$t0, ($a0)
	
	la	$a0, stealthBuffer
	li	$t0, 0
	sw	$t0, ($a0)
	
	la	$a0, isPlayerFloating
	li	$t0, 0
	sw	$t0, ($a0)
	
	la	$a0, floatingBuffer
	li	$t0, 0
	sw	$t0, ($a0)

	#Level 1 enemies:
	#e1m1
	la	$a0, e1m1
	li	$t0, 3772
	li	$t1, 3776
	li	$t2, 3644
	li	$t3, 3648
	li	$t4, 3388
	li	$t5, 3392
	sw	$t0, ($a0)
	sw	$t1, 4($a0)
	sw	$t2, 8($a0)
	sw	$t3, 12($a0)
	sw	$t4, 16($a0)
	sw	$t5, 20($a0)
	
	la	$a0, e1m1Hit
	li	$t0, 0
	sw	$t0, ($a0)
	
	la	$a0, e1m1Direction
	li	$t0, 0
	sw	$t0, ($a0)
	
	la	$a0, e1m1Position
	li	$t0, 0
	sw	$t0, ($a0)
	
	#e2m1
	la	$a0, e2m1
	li	$t0, 2224
	li	$t1, 2228
	li	$t2, 2096
	li	$t3, 2100
	li	$t4, 1840
	li	$t5, 1844
	sw	$t0, ($a0)
	sw	$t1, 4($a0)
	sw	$t2, 8($a0)
	sw	$t3, 12($a0)
	sw	$t4, 16($a0)
	sw	$t5, 20($a0)
	
	la	$a0, e2m1Hit
	li	$t0, 0
	sw	$t0, ($a0)
	
	la	$a0, e2m1Direction
	li	$t0, 0
	sw	$t0, ($a0)
	
	la	$a0, e2m1Position
	li	$t0, 0
	sw	$t0, ($a0)
	
	#Level 2 enemies:
	#e1m2
	la	$a0, e1m2
	li	$t0, 3360
	li	$t1, 3364
	li	$t2, 3232
	li	$t3, 3236
	li	$t4, 2976
	li	$t5, 2980
	sw	$t0, ($a0)
	sw	$t1, 4($a0)
	sw	$t2, 8($a0)
	sw	$t3, 12($a0)
	sw	$t4, 16($a0)
	sw	$t5, 20($a0)
	
	la	$a0, e1m2Direction
	li	$t0, 0
	sw	$t0, ($a0)
	
	la	$a0, e1m2Position
	li	$t0, 0
	sw	$t0, ($a0)
	
	#e2m2
	la	$a0, e2m2
	li	$t0, 2192
	li	$t1, 2196
	li	$t2, 2064
	li	$t3, 2068
	li	$t4, 1808
	li	$t5, 1812
	sw	$t0, ($a0)
	sw	$t1, 4($a0)
	sw	$t2, 8($a0)
	sw	$t3, 12($a0)
	sw	$t4, 16($a0)
	sw	$t5, 20($a0)
	
	la	$a0, e2m2Direction
	li	$t0, 0
	sw	$t0, ($a0)
	
	la	$a0, e2m2Position
	li	$t0, 0
	sw	$t0, ($a0)
	
	#e3m2
	la	$a0, e3m2
	li	$t0, 1976
	li	$t1, 1980
	li	$t2, 1848
	li	$t3, 1852
	li	$t4, 1592
	li	$t5, 1596
	sw	$t0, ($a0)
	sw	$t1, 4($a0)
	sw	$t2, 8($a0)
	sw	$t3, 12($a0)
	sw	$t4, 16($a0)
	sw	$t5, 20($a0)

	#e4m2
	la	$a0, e4m2
	li	$t0, 1180
	li	$t1, 1184
	li	$t2, 1052
	li	$t3, 1056
	li	$t4, 796
	li	$t5, 800
	sw	$t0, ($a0)
	sw	$t1, 4($a0)
	sw	$t2, 8($a0)
	sw	$t3, 12($a0)
	sw	$t4, 16($a0)
	sw	$t5, 20($a0)
	
	la	$a0, e4m2Direction
	li	$t0, 0
	sw	$t0, ($a0)
	
	la	$a0, e4m2Position
	li	$t0, 0
	sw	$t0, ($a0)

	#GAME PROPERTIES
	la	$a0, playerDirection
	li	$t0, 1
	sw	$t0, ($a0)
	
	la	$a0, currLevel
	li	$t0, 1
	sw	$t0, ($a0)
	
	la	$a0, enemyHitOffset
	li	$t0, 0
	sw	$t0, ($a0)
	
	la	$a0, enemyHitCounter
	li	$t0, 0
	sw	$t0, ($a0)
	
	#Buffers
	la	$a0, enemyMovementBuffer
	li	$t0, 0
	sw	$t0, ($a0)
	
	#PICKUPS
	la	$a0, wand
	li	$t0, 980
	li	$t1, 852
	li	$t2, 734
	sw	$t0, ($a0)
	sw	$t1, 4($a0)
	sw	$t2, 8($a0)
	
	la	$a0, shuriken
	li	$t0, 864
	li	$t1, 732
	li	$t2, 736
	li	$t3, 740
	li	$t4, 608
	sw	$t0, ($a0)
	sw	$t1, 4($a0)
	sw	$t2, 8($a0)
	sw	$t3, 12($a0)
	sw	$t4, 16($a0)

	#MAP GENERATION
	#movingPlatform1
	la	$a0, movingPlatform1
	li	$t0, 1880
	li	$t1, 1884
	li	$t2, 1888
	li	$t3, 1892
	li	$t4, 1896
	li	$t5, 1900
	li	$t6, 1904
	sw	$t0, ($a0)
	sw	$t1, 4($a0)
	sw	$t2, 8($a0)
	sw	$t3, 12($a0)
	sw	$t4, 16($a0)
	sw	$t5, 20($a0)
	sw	$t6, 24($a0)
	
	la	$a0, movingPlatform1Direction
	li	$t0, 0
	sw	$t0, ($a0)
	
	la	$a0, movingPlatform1Position
	li	$t0, 0
	sw	$t0, ($a0)
	
	la	$a0, movingPlatform1Buffer
	li	$t0, 0
	sw	$t0, ($a0)
	
	#movingPlatform2
	la	$a0, movingPlatform2
	li	$t0, 988
	li	$t1, 992
	li	$t2, 1006
	li	$t3, 1010
	li	$t4, 1014
	li	$t5, 1018
	li	$t6, 1022
	sw	$t0, ($a0)
	sw	$t1, 4($a0)
	sw	$t2, 8($a0)
	sw	$t3, 12($a0)
	sw	$t4, 16($a0)
	sw	$t5, 20($a0)
	sw	$t6, 24($a0)
	
	la	$a0, movingPlatform2Direction
	li	$t0, 1
	sw	$t0, ($a0)
	
	la	$a0, movingPlatform2Position
	li	$t0, 0
	sw	$t0, ($a0)
	
	la	$a0, movingPlatform2Buffer
	li	$t0, 0
	sw	$t0, ($a0)
	
	#treasureChest
	la	$a0, treasureChest
	li	$t0, 3176
	li	$t1, 3180
	li	$t2, 3184
	li	$t3, 3048
	li	$t4, 3052
	li	$t5, 3056
	li	$t6, 2920
	li	$t7, 2924
	li	$t8, 2928
	sw	$t0, ($a0)
	sw	$t1, 4($a0)
	sw	$t2, 8($a0)
	sw	$t3, 12($a0)
	sw	$t4, 16($a0)
	sw	$t5, 20($a0)
	sw	$t6, 24($a0)
	sw	$t7, 28($a0)
	sw	$t8, 32($a0)
	
	#EXTRA
	la	$a0, isButtonPressed
	li	$t0, 0
	sw	$t0, ($a0)
	
	j main	#iterate through entire program again w/ variables reset	



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
	
	j KEY_PRESSED_END	#return to gameLoop



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
	
	#check for possible collisions before redrawing
	#check for arr[6]
	addi	$a0, $s6, BASE_ADDRESS 
	lw	$a0, ($a0)					#load the colour that is located at bitmap address of $s0
	beq	$a0, BORDER_COLOUR, SKIP_PLAYER_MOVE_UP		#see if it will collide with an edge 
	beq	$a0, HEALTH_RED, SKIP_PLAYER_MOVE_UP		
	#check for arr[7]
	addi	$a0, $s7, BASE_ADDRESS
	lw	$a0, ($a0)
	beq	$a0, BORDER_COLOUR, SKIP_PLAYER_MOVE_UP
	beq	$a0, HEALTH_RED, SKIP_PLAYER_MOVE_UP
	
	#otherwise, update the playerModel
	addi 	$sp, $sp, -4	#push ra to stack
	sw  	$ra, ($sp) 
	jal updatePlayerModel
	lw	$ra, ($sp) 	#pop ra from stack
	addi	$sp, $sp, 4

SKIP_PLAYER_MOVE_UP:
	jr 	$ra	#return to playerJump			



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
	j KEY_PRESSED_END	#return to gameLoop



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
	j KEY_PRESSED_END	#return to gameLoop

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
#1->stab attack, 2->temp stealth, 3->float (maybe)
#MODE_ONE_ABILITY:
	#a0 & v0 reserved for syscall
	#a1-a2 reserved for colours
	#t0-t1 reserved for player pixels
playerAbility:
	#retrieve playerMode and decide which branch to execute
	la	$t0, playerMode
	lw	$t0, ($t0)
	beq	$t0, 2, MODE_TWO_ABILITY
	beq	$t0, 3, MODE_THREE_ABILITY
	
	#otherwise perform MOVE_ONE_ABILITY
	#we need to check for playerDirection!
	la 	$t0, playerDirection
	lw	$t0, ($t0)
	#branch if playerModel is facing left
	beq	$t0, 0, MODE_ONE_ABILITY_LEFT_START	
	
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
	j MODE_ONE_ABILITY_LEFT_END		
	
	#LEFT-FACING ATTACK
MODE_ONE_ABILITY_LEFT_START:
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
				
MODE_ONE_ABILITY_LEFT_END:
	j	PLAYER_ABILITY_END

MODE_TWO_ABILITY:
	la	$a0, isPlayerStealthed
	lw	$a1, ($a0) 
	#if player is already stealthed skip this ability
	beq	$a1, 1, MODE_TWO_ABILITY_END
	
	#otherwise update stealth bool
	li	$a1, 1
	sw	$a1, ($a0)		#set isPlayerStealthed = true	
	j 	MODE_TWO_ABILITY_END

MODE_TWO_ABILITY_END:
	j	PLAYER_ABILITY_END

MODE_THREE_ABILITY:
	la	$a0, isPlayerFloating
	lw	$a1, ($a0) 
	#if player is already floating skip this ability
	beq	$a1, 1, MODE_TWO_ABILITY_END
	
	#otherwise update float bool
	li	$a1, 1
	sw	$a1, ($a0)		#set isPlayerFloating= true	

MODE_THREE_ABILITY_END:
	j	PLAYER_ABILITY_END

PLAYER_ABILITY_END:

	j KEY_PRESSED_END	#return to gameLoop


#F: moves player model 1 unit down and immediately returns to gameLoop if the playerModel's feet are 
#not already touching a platform. If they are touching a platform, does nothing
#Note: if player is floating, the player does not fall every refresh
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
	
	#check to see if we invoke "playerFloating version" of applyGravity
	#(v0 and v1 are available to use)
	la	$v0, isPlayerFloating
	lw	$v0, ($v0)
	beq	$v0, 0, applyNormalGravity		#if NOTfloating, apply normal gravity
	
	#otherwise applyFloatingGravity:
	#apply gravity only when the floatingBuffer == 12
	la	$v0, floatingBuffer
	lw	$v0, ($v0)
	beq	$v0, 12, applyNormalGravity
	j	SKIP_APPLY_GRAVITY		#if buffer != 12, skip gravity call		

applyNormalGravity:

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
	
	beq	$a0, 2,	UPDATE_ENEMY_MOVEMENT_TWO
	beq 	$a0, 3,	UPDATE_ENEMY_MOVEMENT_THREE
	
	#otherwise, UPDATE_ENEMY_MOVEMENT_ONE
#level 1 enemies
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

#e2m1 -> movement bounded by [6 left from startpoint, 6 to right from startpoint]
	
	#if e2m1Hit == 2, (i.e e2m1 is killed) skip update
	la	$t0, e2m1Hit
	lw	$t0, ($t0)
	beq	$t0, 2, e2m1_MOVEMENT_END 
	
	#otherwise continue with the update
	#load direction and position
	la	$t0, e2m1Direction
	lw	$t0, ($t0)	
	la	$t1, e2m1Position
	lw	$t1, ($t1)	
	
	#branch to move_left if direction == 0
	beq	$t0, 0,	e2m1_MOVE_LEFT	
	
	#Otherwise, e1m1_MOVE_RIGHT:
	#if e2m1Position == 6, switch direction
	beq	$t1, 6, e2m1_RIGHT_TO_LEFT 
	
	#e1m1Position++
	la	$t2, e2m1Position	#load variable address
	addi	$t1, $t1, 1		#decrement from prev loaded e2m1Position
	sw	$t1, ($t2)		#store the updated e2m1Position
	
	#shift enemyModel 1 unit right
	la	$a0, e2m1
	jal moveEnemyRight
	j e2m1_MOVEMENT_END
	
	
e2m1_MOVE_LEFT: 
	#if e2m1Position == -5, switch direction
	beq	$t1, -6, e2m1_LEFT_TO_RIGHT
	
	#e2m1Position--
	la	$t2, e2m1Position	#load variable address
	addi	$t1, $t1, -1		#increment from prev loaded e2m1Position
	sw	$t1, ($t2)		#store the updated e2m1Position
	
	#shift enemyModel 1 unit left
	la	$a0, e2m1
	jal moveEnemyLeft
	j e2m1_MOVEMENT_END
	
	
e2m1_LEFT_TO_RIGHT:
	#update enemy direction
	li	$t2, 1
	la	$t0, e2m1Direction
	sw	$t2, ($t0)
	
	#e2m1Position++
	la	$t2, e2m1Position	#load variable address
	addi	$t1, $t1, 1		#increment from prev loaded e2m1Position
	sw	$t1, ($t2)		#store the updated e2m1Position
	
	#shift enemyModel 1 unit right
	la	$a0, e2m1
	jal moveEnemyRight
	j e2m1_MOVEMENT_END


e2m1_RIGHT_TO_LEFT:
	#update enemy direction
	la	$t0, e2m1Direction
	sw	$0, ($t0)
	
	#e1m1Position--
	la	$t2, e2m1Position	#load variable address
	addi	$t1, $t1, -1		#decrement from prev loaded e2m1Position
	sw	$t1, ($t2)		#store the updated e2m1Position
	
	#shift enemyModel 1 unit left
	la	$a0, e2m1
	jal moveEnemyLeft
	j e2m1_MOVEMENT_END
	
e2m1_MOVEMENT_END:
	j UPDATE_ENEMY_MOVEMENT_END	#return to caller after all enemies on the map have updated position


UPDATE_ENEMY_MOVEMENT_TWO:
#e1m2 -> movement bounded by [4 left from startpoint, 9 to right from startpoint]
	#load direction and position
	la	$t0, e1m2Direction
	lw	$t0, ($t0)	
	la	$t1, e1m2Position
	lw	$t1, ($t1)	
	
	#branch to move_left if direction == 0
	beq	$t0, 0,	e1m2_MOVE_LEFT	
	
	#Otherwise, e1m1_MOVE_RIGHT:
	#if e1m2Position == 9, switch direction
	beq	$t1, 9, e1m2_RIGHT_TO_LEFT 
	
	#e1m1Position++
	la	$t2, e1m2Position	#load variable address
	addi	$t1, $t1, 1		#decrement from prev loaded e1m2Position
	sw	$t1, ($t2)		#store the updated e1m2Position
	
	#shift enemyModel 1 unit right
	la	$a0, e1m2
	jal moveEnemyRight
	j e1m2_MOVEMENT_END
	
	
e1m2_MOVE_LEFT: 
	#if e1m2Position == -4, switch direction
	beq	$t1, -4, e1m2_LEFT_TO_RIGHT
	
	#e1m2Position--
	la	$t2, e1m2Position	#load variable address
	addi	$t1, $t1, -1		#increment from prev loaded e1m2Position
	sw	$t1, ($t2)		#store the updated e1m2Position
	
	#shift enemyModel 1 unit left
	la	$a0, e1m2
	jal moveEnemyLeft
	j e1m2_MOVEMENT_END
	
	
e1m2_LEFT_TO_RIGHT:
	#update enemy direction
	li	$t2, 1
	la	$t0, e1m2Direction
	sw	$t2, ($t0)
	
	#e1m2Position++
	la	$t2, e1m2Position	#load variable address
	addi	$t1, $t1, 1		#increment from prev loaded e1m2Position
	sw	$t1, ($t2)		#store the updated e1m2Position
	
	#shift enemyModel 1 unit right
	la	$a0, e1m2
	jal moveEnemyRight
	j e1m2_MOVEMENT_END


e1m2_RIGHT_TO_LEFT:
	#update enemy direction
	la	$t0, e1m2Direction
	sw	$0, ($t0)
	
	#e1m1Position--
	la	$t2, e1m2Position	#load variable address
	addi	$t1, $t1, -1		#decrement from prev loaded e1m2Position
	sw	$t1, ($t2)		#store the updated e1m2Position
	
	#shift enemyModel 1 unit left
	la	$a0, e1m2
	jal moveEnemyLeft
	j e1m2_MOVEMENT_END
	
e1m2_MOVEMENT_END:

#e2m2 -> movement bounded by [1 left from startpoint, 1 to right from startpoint]
	#load direction and position
	la	$t0, e2m2Direction
	lw	$t0, ($t0)	
	la	$t1, e2m2Position
	lw	$t1, ($t1)	
	
	#branch to move_left if direction == 0
	beq	$t0, 0,	e2m2_MOVE_LEFT	
	
	#Otherwise, e1m1_MOVE_RIGHT:
	#if e2m2Position == 1, switch direction
	beq	$t1, 1, e2m2_RIGHT_TO_LEFT 
	
	#e1m1Position++
	la	$t2, e2m2Position	#load variable address
	addi	$t1, $t1, 1		#decrement from prev loaded e2m2Position
	sw	$t1, ($t2)		#store the updated e2m2Position
	
	#shift enemyModel 1 unit right
	la	$a0, e2m2
	jal moveEnemyRight
	j e2m2_MOVEMENT_END
	
	
e2m2_MOVE_LEFT: 
	#if e2m2Position == -1, switch direction
	beq	$t1, -1, e2m2_LEFT_TO_RIGHT
	
	#e2m2Position--
	la	$t2, e2m2Position	#load variable address
	addi	$t1, $t1, -1		#increment from prev loaded e2m2Position
	sw	$t1, ($t2)		#store the updated e2m2Position
	
	#shift enemyModel 1 unit left
	la	$a0, e2m2
	jal moveEnemyLeft
	j e2m2_MOVEMENT_END
	
	
e2m2_LEFT_TO_RIGHT:
	#update enemy direction
	li	$t2, 1
	la	$t0, e2m2Direction
	sw	$t2, ($t0)
	
	#e2m2Position++
	la	$t2, e2m2Position	#load variable address
	addi	$t1, $t1, 1		#increment from prev loaded e2m2Position
	sw	$t1, ($t2)		#store the updated e2m2Position
	
	#shift enemyModel 1 unit right
	la	$a0, e2m2
	jal moveEnemyRight
	j e2m2_MOVEMENT_END


e2m2_RIGHT_TO_LEFT:
	#update enemy direction
	la	$t0, e2m2Direction
	sw	$0, ($t0)
	
	#e1m1Position--
	la	$t2, e2m2Position	#load variable address
	addi	$t1, $t1, -1		#decrement from prev loaded e2m2Position
	sw	$t1, ($t2)		#store the updated e2m2Position
	
	#shift enemyModel 1 unit left
	la	$a0, e2m2
	jal moveEnemyLeft
	j e2m2_MOVEMENT_END
	
e2m2_MOVEMENT_END:

#e4m2 -> movement bounded by [2 left from startpoint, 2 to right from startpoint]
	#load direction and position
	la	$t0, e4m2Direction
	lw	$t0, ($t0)	
	la	$t1, e4m2Position
	lw	$t1, ($t1)	
	
	#branch to move_left if direction == 0
	beq	$t0, 0,	e4m2_MOVE_LEFT	
	
	#Otherwise, e1m1_MOVE_RIGHT:
	#if e4m2Position == 2, switch direction
	beq	$t1, 2, e4m2_RIGHT_TO_LEFT 
	
	#e1m1Position++
	la	$t2, e4m2Position	#load variable address
	addi	$t1, $t1, 1		#decrement from prev loaded e4m2Position
	sw	$t1, ($t2)		#store the updated e4m2Position
	
	#shift enemyModel 1 unit right
	la	$a0, e4m2
	jal moveEnemyRight
	j e4m2_MOVEMENT_END
	
e4m2_MOVE_LEFT: 
	#if e4m2Position == -2, switch direction
	beq	$t1, -2, e4m2_LEFT_TO_RIGHT
	
	#e4m2Position--
	la	$t2, e4m2Position	#load variable address
	addi	$t1, $t1, -1		#increment from prev loaded e4m2Position
	sw	$t1, ($t2)		#store the updated e4m2Position
	
	#shift enemyModel 1 unit left
	la	$a0, e4m2
	jal moveEnemyLeft
	j e4m2_MOVEMENT_END
	
	
e4m2_LEFT_TO_RIGHT:
	#update enemy direction
	li	$t2, 1
	la	$t0, e4m2Direction
	sw	$t2, ($t0)
	
	#e4m2Position++
	la	$t2, e4m2Position	#load variable address
	addi	$t1, $t1, 1		#increment from prev loaded e4m2Position
	sw	$t1, ($t2)		#store the updated e4m2Position
	
	#shift enemyModel 1 unit right
	la	$a0, e4m2
	jal moveEnemyRight
	j e4m2_MOVEMENT_END


e4m2_RIGHT_TO_LEFT:
	#update enemy direction
	la	$t0, e4m2Direction
	sw	$0, ($t0)
	
	#e1m1Position--
	la	$t2, e4m2Position	#load variable address
	addi	$t1, $t1, -1		#decrement from prev loaded e4m2Position
	sw	$t1, ($t2)		#store the updated e4m2Position
	
	#shift enemyModel 1 unit left
	la	$a0, e4m2
	jal moveEnemyLeft
	j e4m2_MOVEMENT_END
	
e4m2_MOVEMENT_END:
	j UPDATE_ENEMY_MOVEMENT_END	#return to caller after all enemies on the map have updated position
	
UPDATE_ENEMY_MOVEMENT_THREE:

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
	j	displayGameOver		#jump to gameOver (temporarily restart)
	
decrement_player_health:
	addi	$a1, $a1, -1	#decrement playerHealth by 1
	sw	$a1, ($a0)

	jr $ra			#return to updatePlayerModel



#F: displays number of remaining player Hearts onto bitmap display
#number of hearts to draw == playerHealth
loadPlayerHealth:
	#initialize bitmap addresses for last heart
	li	$t0, 312	
	addi	$t0, $t0, BASE_ADDRESS		#heart pixel1
	li	$t1, 444	
	addi	$t1, $t1, BASE_ADDRESS		#heart pixel2
	li	$t2, 320	
	addi	$t2, $t2, BASE_ADDRESS		#heart pixel3
	
	#if hearts already exist, then we just want to be removing hearts
	li	$a0, 264
	addi	$a0, $a0, BASE_ADDRESS		#compute bitmap address of first heart pixel
	lw	$a0, ($a0)			#load colour at bitmap address
	beq	$a0, HEALTH_RED, REMOVE_HEART	#branch to removeHeart
	
	#else draw hearts for health bar for the first time
	li	$v0, HEALTH_RED			#load red
	
	#heart1
	addi	$t0, $t0, -16	#next heart's bitmap address
	addi	$t1, $t1, -16	#next heart's bitmap address
	addi	$t2, $t2, -16	#next heart's bitmap address
	sw	$v0, ($t0)
	sw	$v0, ($t1)
	sw	$v0, ($t2)
	#heart2
	addi	$t0, $t0, -16	#next heart's bitmap address
	addi	$t1, $t1, -16	#next heart's bitmap address
	addi	$t2, $t2, -16	#next heart's bitmap address
	sw	$v0, ($t0)
	sw	$v0, ($t1)
	sw	$v0, ($t2)
	#heart3
	addi	$t0, $t0, -16	#next heart's bitmap address
	addi	$t1, $t1, -16	#next heart's bitmap address
	addi	$t2, $t2, -16	#next heart's bitmap address
	sw	$v0, ($t0)
	sw	$v0, ($t1)
	sw	$v0, ($t2)
	
	j	loadPlayerHealthEnd
	
REMOVE_HEART:	
	li	$v0, PURPLE			#load purple
	#if playerHealth == 3, we don't need to remove anything
	la	$a0, playerHealth		#load playerHealth
	lw	$a0, ($a0)			#playerHealth val == remaining number of hearts 
	beq	$a0, 3, loadPlayerHealthEnd
	
	li	$a1, 3
	la	$a2, playerHealth
	lw	$a2, ($a2)			#load val stored in playerDamaged
	sub	$a0, $a1, $a2			#numOfHeartsToRemove == 3 - playerHealth
removeHeartLoop:
	addi	$t0, $t0, -16			#next heart's bitmap address
	addi	$t1, $t1, -16			#next heart's bitmap address
	addi	$t2, $t2, -16			#next heart's bitmap address
	sw	$v0, ($t0)
	sw	$v0, ($t1)
	sw	$v0, ($t2)
	
	addi	$a0, $a0, -1			#decrement numOfHeartsToRemove by 1
	bgtz	$a0, removeHeartLoop

loadPlayerHealthEnd:

	jr $ra		#return to gameLoop
	

#F: reverts playerModel back to original model if they are in a damaged state
updateDamagedPlayer:
	la	$a0, playerDamaged
	lw	$a1, ($a0)
	
	#if playerDamaged == 0, skip update
	beq	$a1, 0, updateDamagedPlayerEnd
	#if playerDamaged == 10, reset it to 0
	beq	$a1, 10, resetPlayerDamagedTrue	
	#else 0 < playerDamaged < 10 and should be incremented by 1 and store new value into playerDamaged
	addi	$a1, $a1, 1
	sw	$a1, ($a0)	
	j updateDamagedPlayerEnd

resetPlayerDamagedTrue:
	sw	$0, ($a0)		#set playerDamaged = 0	

updateDamagedPlayerEnd:
	jr	$ra		#return to gameLoop
	
	
	
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
	
	#e1m1
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
	
	#e2m2
	la	$s0, e2m1			#load address of e2m1
	lw	$s1, ($s0)			#load offset of e2m1[0] into s1
	#check if e2m1[0] matches
	addi	$s1, $s1, BASE_ADDRESS		#compute e2m1[0] bitmap address
	beq	$s1, $v1, UPDATE_e2m1_HEALTH
	#check if e2m1[1] matches
	addi	$s1, $s1, 4	
	beq	$s1, $v1, UPDATE_e2m1_HEALTH	
	#check if e2m1[3] matches		#we check e2m1[3] before e2m1[2] because it's easier to compute from prev $s0
	addi	$s1, $s1, -128	
	beq	$s1, $v1, UPDATE_e2m1_HEALTH	
	#check if e2m1[2] matches
	addi	$s1, $s1, -4	
	beq	$s1, $v1, UPDATE_e2m1_HEALTH
	
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

UPDATE_e2m1_HEALTH:
	#at this point, $s0 should have the address to enemyModel[0] stored in it
	
	#check to see if enemy should reduce health OR if enemy should be killed based on health bar
	lw	$s1, 20($s0)			#load enemyModel[5] offset (last pixel denoting health bar)		
	addi	$s1, $s1, BASE_ADDRESS		#compute bitmap address
	lw	$s2, ($s1)			#store the colour of the enemy health bar

	#if enemyModel[5] == red, then the attack will kill the enemy 
	beq	$s2, ENEMY_RED, KILL_e2m1
	
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
	la	$s1, e2m1Hit
	lw	$v1, ($s1)
	addi	$v1, $v1, 1			#increment e2m1Hit variable by 1
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

KILL_e2m1:
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
	
	#update e2m1Hit
	la	$s1, e2m1Hit
	addi	$v1, $0, 2		#e2m1Hit = 2 => enemy has been killed
	sw	$v1, ($s1)		#store updated e1m1Hit
	
	j UPDATE_ENEMY_HEALTH_END
	
UPDATE_ENEMY_HEALTH_END:
	jr	$ra			#return to playerAbility


#F: increments enemyHitCounter variable by 1 iff 1 <= enemyHitCounter < 2 . 
#If the counter is equal to 10, then the function changes the enemy @ address enemyHitOffset+BASE_ADDRESS back to green and resets counter
#If the counter is equal to 0, then the function makes no changes
updateEnemyHitCounter:
	la	$a0, enemyHitCounter
	lw	$a0, ($a0)				#load enemyHitCounter
	beq	$a0, 2, UPDATE_ENEMY_HIT_COUNTER_START	#counter == 2
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
	
	
#AUX. FUNCTIONS

#F: Check if player should advance to next level, or WIN!
nextLevel:
	#load playerModel
	la	$a0, playerModel
	#load currLvl
	la	$a1, currLevel
	lw	$a1, ($a1)		#load level value
	beq	$a1, 2, advanceToLevelThree
	beq	$a1, 3,	advanceToWin
	
	#otherwise check for advanceToLevelTwo
	#check if playerModel[1] pixel is touching door
	lw	$a0, 4($a0)		#load playerModel[1] offset	
	li	$a1, 1008		#offset of lvl 1's door's first pixel (hardcoded)
	beq	$a0, $a1, generateLevelTwo
	#otherwise
	j	nextLevelEnd

advanceToLevelThree: 
	#check if playerModel[1] pixel is touching door
	lw	$a0, 4($a0)		#load playerModel[1] offset		
	li	$a1, 964		#offset of lvl 2's door's first pixel (hardcoded)
	beq	$a0, $a1, generateLevelThree
	#otherwise
	j	nextLevelEnd
	
advanceToWin:
	#check if playerModel[1] pixel is touching treasure chest
	lw	$a0, 4($a0)		#load playerModel[1] offset
	la	$a1, treasureChest	
	lw	$a1, ($a1)
	beq	$a0, $a1, displayWin
	#otherwise
	j	nextLevelEnd
	
nextLevelEnd:
	jr	$ra		#return to gameLoop


#F: checks if playerModel has picked up a powerup
checkPickup:
	#push ra to stack
	addi	$sp, $sp,-4
	sw	$ra, ($sp)	
	
	#determine the level we are on
	la	$a0, currLevel		
	lw	$a0, ($a0)
	beq	$a0, 3, checkPickupLevel3
	
	#otherwise, checkPickupLevel2
	#if left side of playerModel is touching shuriken, then update player to Ninja
	li	$a0, SHURIKEN_CENTER	#use shuriken center colour for comparison
	la	$a1, playerModel
	
	lw	$a2, ($a1)
	addi	$a2, $a2, BASE_ADDRESS		#bitmap address player[0]
	lw	$a3, ($a2)			#get colour in bitmap address
	beq	$a3, $a0, updateToNinjaTrue  	#check if player[0] == SHURIKEN_CENTER
	
	addi	$a2, $a2, -128			#bitmap address player[2]
	lw	$a3, ($a2)
	beq	$a3, $a0, updateToNinjaTrue  	#check for player[2]
	
	addi	$a2, $a2, -128			#bitmap address player[4]
	lw	$a3, ($a2)
	beq	$a3, $a0, updateToNinjaTrue  	#check for player[4]
	
	addi	$a2, $a2, -128			#bitmap address player[6]
	lw	$a3, ($a2)
	beq	$a3, $a0, updateToNinjaTrue  	#check for player[6]
	#if all cases fail, the player is not touching the pickup
	j checkPickupEnd

updateToNinjaTrue:
	jal updateToNinja
	j checkPickupEnd
	
checkPickupLevel3:
	#if right side of playerModel is touching wand, then update player to Wizard
	li	$a0, WAND_HANDLE	#use wand handle colour for comparison
	la	$a1, playerModel
	
	lw	$a2, ($a1)
	addi	$a2, $a2, BASE_ADDRESS		
	addi	$a2, $a2, 4			#bitmap address player[1]
	lw	$a3, ($a2)			#get colour in bitmap address
	beq	$a3, $a0, updateToWizardTrue  	#check if player[1] == WAND_HANDLE
	
	addi	$a2, $a2, -128			#bitmap address player[3]
	lw	$a3, ($a2)
	beq	$a3, $a0, updateToWizardTrue  	#check for player[3]
	
	addi	$a2, $a2, -128			#bitmap address player[5]
	lw	$a3, ($a2)
	beq	$a3, $a0, updateToWizardTrue  	#check for player[5]
	
	addi	$a2, $a2, -128			#bitmap address player[7]
	lw	$a3, ($a2)
	beq	$a3, $a0, updateToWizardTrue  	#check for player[7]
	#if all cases fail, the player is not touching the pickup
	j checkPickupEnd

updateToWizardTrue:
	jal updateToWizard
	j checkPickupEnd

checkPickupEnd:	
	#pop ra from stack
	lw	$ra, ($sp)
	addi	$sp, $sp, 4		
	jr	$ra	#return to gameLoop
	
	
#F: updates any playerBuffers, if needed
updatePlayerBuffers:	
#stealthBuffer:
	#skip update if player isn't stealthed
	la	$a0, isPlayerStealthed
	lw	$a0, ($a0)
	beq	$a0, 0, resetStealthBufferFalse	
	
	#check if stealthBuffer $ playerSteal bool needs reset
	la	$a0, stealthBuffer
	lw	$a1, ($a0)
	beq	$a1, 25, resetStealthBufferTrue
	
	#otherwise, increment stealthBuffer
	addi	$a1, $a1, 1		#stealthBuffer++
	sw	$a1, ($a0)		#store updated stealthBuffer val
	j	resetStealthBufferFalse
	
resetStealthBufferTrue:	
	la	$a0, stealthBuffer
	la	$a1, isPlayerStealthed
	sw	$0, ($a0)	#set stealthBuffer == 0
	sw	$0, ($a1)	#set isPlayerStealthed = 0 (false)	

resetStealthBufferFalse:
	
#floatingBuffer:
	#skip update if player isn't floating
	la	$a0, isPlayerFloating
	lw	$a0, ($a0)
	beq	$a0, 0, resetFloatingBufferFalse	
	
	#check if floatBuffer and playerFloating bool needs reset
	la	$a0, floatingBuffer
	lw	$a1, ($a0)
	beq	$a1, 60, resetFloatingBufferTrue
	
	#otherwise, increment floatBuffer
	addi	$a1, $a1, 1		#floatingBuffer++
	sw	$a1, ($a0)		#store updated floatBuffer val
	j	resetFloatingBufferFalse
	
resetFloatingBufferTrue:	
	la	$a0, floatingBuffer
	la	$a1, isPlayerFloating
	sw	$0, ($a0)	#set floatBuffer == 0
	sw	$0, ($a1)	#set isPlayerFloating = 0 (false)	

resetFloatingBufferFalse:
	jr	$ra		#return to gameLoop

#F: checks whether button for lvl 3 secret door has been pressed or not
checkButtonPressed:
	#check if any of right-side of playerModel == BUTTON_COLOUR
	li	$v0, BUTTON_COLOUR
	la	$a0, playerModel
	lw	$a0, ($a0)
	addi	$a0, $a0, BASE_ADDRESS	#compute bitmap address
	
	addi	$a0, $a0, 4		#playerModel[1] bitmap address
	lw	$v1, ($a0)
	beq	$v1, BUTTON_COLOUR, buttonPressedTrue
	addi	$a0, $a0, -128		#playerModel[3] bitmap address
	lw	$v1, ($a0)
	beq	$v1, BUTTON_COLOUR, buttonPressedTrue
	addi	$a0, $a0, -128		#playerModel[5] bitmap address
	lw	$v1, ($a0)
	beq	$v1, BUTTON_COLOUR, buttonPressedTrue
	addi	$a0, $a0, -128		#playerModel[7] bitmap address
	lw	$v1, ($a0)
	beq	$v1, BUTTON_COLOUR, buttonPressedTrue
	#otherwise buttonPressedFalse
	j	buttonPressedEnd
	
buttonPressedTrue:
	#if buttonPressedvar == 1 skip to the animation
	la	$a0, isButtonPressed
	lw	$a0, ($a0)
	li	$a1, 1
	beq	$a0, $a1, buttonPressedEnd
	
	#prep sleep syscall
	li	$v0, 32
	li	$a0, 50
	
	#load colours
	li	$a1, PURPLE
	li	$a2, BORDER_COLOUR
	#break wall animation (3380 is the offset of first button pixel)
	li	$a3, 3512 	#offset of bottom of wall we want to delete
	addi	$a3, $a3, BASE_ADDRESS
	sw	$a1, ($a3)
	syscall
	sw	$a1, -128($a3)
	syscall
	sw	$a1, -256($a3)
	syscall
	sw	$a1, -384($a3)
	syscall
	sw	$a1, -512($a3)
	syscall
	sw	$a1, -640($a3)
	syscall
	#add steps to reach chest animation ()
	#step 1
	li	$a3, 3548
	addi	$a3, $a3, BASE_ADDRESS
	sw	$a2, ($a3)
	syscall
	sw	$a2, -4($a3)
	syscall
	sw	$a2, -8($a3)
	syscall
	sw	$a2, -12($a3)
	syscall
	sw	$a2, -16($a3)
	syscall
	sw	$a2, -20($a3)
	#step 2
	li	$a3, 3420
	addi	$a3, $a3, BASE_ADDRESS
	sw	$a2, ($a3)
	syscall
	sw	$a2, -4($a3)
	syscall
	sw	$a2, -8($a3)
	syscall
	
	#update buttonPressed var
	la	$t0, isButtonPressed
	li	$t1, 1
	sw	$t1, ($t0)
	
buttonPressedEnd:
	jr	$ra		#return to gameLoop

		
#F: displays WIN if player completes all levels
displayWin:
	#prep sleep syscall
	li	$v0, 32
	li	$a0, 50
	
	li	$v1, CHEST_GOLD
	la 	$a1, treasureChest
	lw	$a1, ($a1)
	addi	$a1, $a1, -1064
	addi	$a1, $a1, BASE_ADDRESS
	
	#draw 'W'
	sw	$v1, ($a1)
	syscall
	sw	$v1, 128($a1)
	syscall
	sw	$v1, 256($a1)
	syscall
	sw	$v1, 388($a1)
	syscall
	sw	$v1, 264($a1)
	syscall
	sw	$v1, 396($a1)
	syscall
	sw	$v1, 272($a1)
	syscall
	sw	$v1, 144($a1)
	syscall
	sw	$v1, 16($a1)
	syscall
	#draw 'I'
	sw	$v1, 24($a1)
	syscall
	sw	$v1, 152($a1)
	syscall
	sw	$v1, 280($a1)
	syscall
	sw	$v1, 408($a1)
	syscall
	#draw 'N' 
	sw	$v1, 416($a1)
	syscall
	sw	$v1, 288($a1)
	syscall
	sw	$v1, 160($a1)
	syscall
	sw	$v1, 32($a1)
	syscall
	sw	$v1, 164($a1)
	syscall
	sw	$v1, 296($a1)
	syscall
	sw	$v1, 428($a1)
	syscall
	sw	$v1, 300($a1)
	syscall
	sw	$v1, 172($a1)
	syscall
	sw	$v1, 44($a1)
	syscall
	#draw '!'
	sw	$v1, 436($a1)
	syscall 
	sw	$v1, 180($a1)
	syscall 
	sw	$v1, 52($a1)
	syscall 
	
	jr	$ra		#return to gameLoop

#F: displays GameOver or (Try Again) if playerHealth reaches 0
displayGameOver:
	#prep sleep syscall
	li	$v0, 32
	li	$a0, 35
	
	#reset screen
	jal setupDisplay
	
	li	$v1, PLAYER_RED
	li	$a1, 1320			
	addi	$a1, $a1, BASE_ADDRESS	#starting bitmap address
	#draw 'G'
	sw	$v1, ($a1)
	syscall
	sw	$v1, -4($a1)
	syscall
	sw	$v1, -8($a1)
	syscall
	sw	$v1, -12($a1)
	syscall
	sw	$v1, 116($a1)
	syscall
	sw	$v1, 244($a1)
	syscall
	sw	$v1, 372($a1)
	syscall
	sw	$v1, 500($a1)
	syscall
	sw	$v1, 504($a1)
	syscall
	sw	$v1, 508($a1)
	syscall
	sw	$v1, 512($a1)
	syscall
	sw	$v1, 384($a1)
	syscall
	sw	$v1, 256($a1)
	syscall
	sw	$v1, 252($a1)
	syscall
	#draw 'A'
	sw	$v1, 520($a1)
	syscall
	sw	$v1, 392($a1)
	syscall
	sw	$v1, 264($a1)
	syscall
	sw	$v1, 136($a1)
	syscall
	sw	$v1, 8($a1)
	syscall
	sw	$v1, 12($a1)
	syscall
	sw	$v1, 16($a1)
	syscall
	sw	$v1, 144($a1)
	syscall
	sw	$v1, 272($a1)
	syscall
	sw	$v1, 400($a1)
	syscall
	sw	$v1, 528($a1)
	syscall
	sw	$v1, 268($a1)
	syscall
	#draw 'M'
	sw	$v1, 536($a1)
	syscall
	sw	$v1, 408($a1)
	syscall
	sw	$v1, 280($a1)
	syscall
	sw	$v1, 152($a1)
	syscall
	sw	$v1, 24($a1)
	syscall
	sw	$v1, 28($a1)
	syscall
	sw	$v1, 32($a1)
	syscall
	sw	$v1, 160($a1)
	syscall
	sw	$v1, 288($a1)
	syscall
	sw	$v1, 416($a1)
	syscall
	sw	$v1, 544($a1)
	syscall
	sw	$v1, 36($a1)
	syscall
	sw	$v1, 40($a1)
	syscall
	sw	$v1, 168($a1)
	syscall
	sw	$v1, 296($a1)
	syscall
	sw	$v1, 424($a1)
	syscall
	sw	$v1, 552($a1)
	syscall
	#draw 'E'
	sw	$v1, 56($a1)
	syscall
	sw	$v1, 52($a1)
	syscall
	sw	$v1, 48($a1)
	syscall
	sw	$v1, 176($a1)
	syscall
	sw	$v1, 304($a1)
	syscall
	sw	$v1, 432($a1)
	syscall
	sw	$v1, 560($a1)
	syscall
	sw	$v1, 564($a1)
	syscall
	sw	$v1, 568($a1)
	syscall
	sw	$v1, 308($a1)
	syscall
	sw	$v1, 312($a1)
	syscall
	#draw 'O'
	sw	$v1, 760($a1)
	syscall
	sw	$v1, 888($a1)
	syscall
	sw	$v1, 1016($a1)
	syscall
	sw	$v1, 1144($a1)
	syscall
	sw	$v1, 1272($a1)
	syscall
	sw	$v1, 1276($a1)
	syscall
	sw	$v1, 1280($a1)
	syscall
	sw	$v1, 1284($a1)
	syscall
	sw	$v1, 1156($a1)
	syscall
	sw	$v1, 1028($a1)
	syscall
	sw	$v1, 900($a1)
	syscall
	sw	$v1, 772($a1)
	syscall
	sw	$v1, 768($a1)
	syscall
	sw	$v1, 764($a1)
	syscall
	#draw 'V'
	sw	$v1, 780($a1)
	syscall
	sw	$v1, 908($a1)
	syscall
	sw	$v1, 1036($a1)
	syscall
	sw	$v1, 1164($a1)
	syscall
	sw	$v1, 1296($a1)
	syscall
	sw	$v1, 1172($a1)
	syscall
	sw	$v1, 1044($a1)
	syscall
	sw	$v1, 916($a1)
	syscall
	sw	$v1, 788($a1)
	syscall
	#draw 'E'
	sw	$v1, 804($a1)
	syscall
	sw	$v1, 800($a1)
	syscall
	sw	$v1, 796($a1)
	syscall
	sw	$v1, 924($a1)
	syscall
	sw	$v1, 1052($a1)
	syscall
	sw	$v1, 1180($a1)
	syscall
	sw	$v1, 1308($a1)
	syscall
	sw	$v1, 1312($a1)
	syscall
	sw	$v1, 1316($a1)
	syscall
	sw	$v1, 1056($a1)
	syscall
	sw	$v1, 1060($a1)
	syscall
	#draw 'R'
	sw	$v1, 1324($a1)
	syscall
	sw	$v1, 1196($a1)
	syscall
	sw	$v1, 1068($a1)
	syscall
	sw	$v1, 940($a1)
	syscall
	sw	$v1, 812($a1)
	syscall
	sw	$v1, 816($a1)
	syscall
	sw	$v1, 820($a1)
	syscall
	sw	$v1, 948($a1)
	syscall
	sw	$v1, 1072($a1)
	syscall
	sw	$v1, 1204($a1)
	syscall
	sw	$v1, 1332($a1)
	syscall
	

	#check for keyboard input
	li 	$s0, KEY_PRESSED	
	#infinite loop until player decides to restart
RESTART_KEY_PRESSED_START:	
	lw	$t1, 4($s0)			#assume from caller, s0 == KEY_PRESSED
	beq	$t1, RESTART, restartGame
	j	RESTART_KEY_PRESSED_START
	
	
main:
	#for reset, make sure that all variables are reset before playing the game again 
	jal generateLevelOne
	#jal generateLevelTwo
	#jal generateLevelThree

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
	
	#refresh platforms (and doors) (and pickups) for current level
	jal refreshObjects
	
	#check if level 3 button has been pressed
	jal checkButtonPressed
	
	#update enemyHitCounter
	jal updateEnemyHitCounter
	#update current position of enemies on the map
	jal updateEnemyMovement
	#refresh enemies 
	jal loadEnemies
	
	#at this point, enemies overlap players and lava overlaps players,
	# so we can check for player-enemy Collision (consider lava as an enemy)
	jal enemyCollision
	#refresh health bar, and revert playerModel from damaged to undamaged state if needed
	jal loadPlayerHealth
	#reverts playerModel back to original model if they are in a damaged state
	jal updateDamagedPlayer
	
	#check if player picks up a powerup
	jal checkPickup
	
	#update playerBuffers
	jal updatePlayerBuffers
	#refresh playerModel
	jal refreshPlayerModel			#redraws playerModel to make platforms appear in background
	
	#applyGravity if the playerModel's feet are not already touching a platform, otherwise does nothing
	jal applyGravity
	
	#check for level completion
	jal nextLevel
	
	j GAMELOOP_START
GAMELOOP_END:
		
	#exit program
	li $v0, 10
	syscall
