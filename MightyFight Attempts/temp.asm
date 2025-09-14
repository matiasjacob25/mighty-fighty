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
	
	la	$a0, isPlayerFloatingp
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
	
	la	$a0, e3m2Direction
	li	$t0, 0
	sw	$t0, ($a0)
	
	la	$a0, e3m2Position
	li	$t0, 0
	sw	$t0, ($a0)
	
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
	
	
	
	
	
	
	
	
	
	
	
	
