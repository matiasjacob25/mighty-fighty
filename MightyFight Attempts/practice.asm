# Bitmap display starter code
#
# Bitmap Display Configuration:
# - Unit width in pixels: 4
# - Unit height in pixels: 4
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp) #
.data 
	ONE_INCR:	.word	1	#INCREMENT BY ONE
	
.eqv BASE_ADDRESS	0x10008000
.eqv TOT_PIXEL	65536

.text
	li $t0, BASE_ADDRESS	
	li $t1, 0xff0000	#set colour to red 
	
	li $t3, 10073536
COLR_START:	beq $t0, $t3, COLR_END	#end when all pixels have been coloured
		addi $t0, $t0, 4	#increment counter by 1 
		sw  $t1, ($t0)
		j COLR_START	
COLR_END:


	
	#li $t TOT_PIXEL;
	#bne 
	#li $t1 
	
	
	

	li $v0, 10 # terminate the program gracefully 
	syscall
