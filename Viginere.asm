.data
cipherText: 		.space 		100
welcome: 		.asciiz 	"Welcome to the Vigenere Cipher Generator\n"
givenKey:		.asciiz		"\nGiven Key is: "
givenText: 		.asciiz 	"\nThe Given Text is: "
encryptedText:		.asciiz		"\nThe encrypted text is: "
decryptedText:		.asciiz		"\nThe decrypted text is: "

.text
#Welcome
la $a0, welcome
li $v0, 4
syscall

#Grab Program Arguments
move $t0, $a1
lw $s0, 0($t0) #Key
lw $s1, 4($t0) #Cleartext
la $s2, cipherText #Save cipherText address

#Print Key
la $a0, givenKey
li $v0, 4
syscall
move $a0, $s0
li $v0, 4
syscall

#Print Given Text
la $a0, givenText
li $v0, 4
syscall
move $a0, $s1
li $v0, 4
syscall

#ENCODING
move $a0, $s0 #Prepare variables for encode subroutine
move $a1, $s1
move $a2, $s2
jal encode

#Print Encrypted Message
la $a0, encryptedText
li $v0, 4
syscall
move $a0, $s2
li $v0, 4
syscall

#DECODING
move $a0, $s0 #Prepare variables for encode subroutine
move $a1, $s2
move $a2, $s1
jal decode

#Print Encrypted Message
la $a0, decryptedText
li $v0, 4
syscall
move $a0, $s1
li $v0, 4
syscall

#END END END END END
li $v0, 10
syscall
#END END END END END



encode:
move $t0, $a0 #Move base addresses
move $t1, $a1
	#t0, t1 holds pointers for respective $a base addresses [terminated after strlen]
	#$t2 temporary register for strlen character [terminated after strlen]
	#$t4, $t5 holds strlen Key and Cleartext respectively
	strlenKey1:
	lb $t2, 0($t0) #Load from current memory address
	beqz $t2, strlenClearText #Check null
	addi $t4, $t4, 1 #Increment Strlen
	addi $t0, $t0, 1 #Increment address
	j strlenKey1
	strlenClearText:
	lb $t2, 0($t1) #Load from current memory address
	beqz $t2, encodeWhilePre #Check null
	addi $t5, $t5, 1 #Increment Strlen
	addi $t1, $t1, 1 #Increment address
	j strlenClearText
encodeWhilePre:
move $t3, $0 #Clear $t3 to serve as i
encodeWhile:
bge $t3, $t5, endEncode #End if reaches the strlen of Clear text
rem $t9, $t3, $t4 #$t9 = i % lk
add $t0, $a0, $t9 #$t0 holds current key address
add $t1, $a1, $t3 #$t1 holds current cleartext address
add $t2, $a2, $t3 #$t2 holds current cipher address
lb $t9, ($t0) #Load current key
lb $t8, ($t1) #Load current cleartext
add $t7, $t8, $t9 #Add cleartext and key
rem $t7, $t7, 128
sb $t7, ($t2) #Store encoded cipher into $t7
addi $t3, $t3, 1 #i += 1
j encodeWhile
endEncode:
add $t0, $a2, $t5 #Store null at end
li $t1, '\0'
sb $t1, ($t0)
li $t0, 0
li $t1, 0
li $t2, 0
li $t3, 0
li $t4, 0
li $t5, 0
li $t6, 0
li $t7, 0
li $t8, 0
li $t9, 0
jr $ra

decode:
move $t0, $a0 #Move base addresses
move $t1, $a1
	#t0, t1 holds pointers for respective $a base addresses [terminated after strlen]
	#$t2 temporary register for strlen character [terminated after strlen]
	#$t4, $t5 holds strlen Key and Cleartext respectively
	strlenKey2:
	lb $t2, 0($t0) #Load from current memory address
	beqz $t2, strlenCipherText #Check null
	addi $t4, $t4, 1 #Increment Strlen
	addi $t0, $t0, 1 #Increment address
	j strlenKey2
	strlenCipherText:
	lb $t2, 0($t1) #Load from current memory address
	beqz $t2, decodeWhilePre #Check null
	addi $t5, $t5, 1 #Increment Strlen
	addi $t1, $t1, 1 #Increment address
	j strlenCipherText
decodeWhilePre:
move $t3, $0 #Clear $t3 to serve as i
decodeWhile:
bge $t3, $t5, endDecode #End if reaches the strlen of Cipher
rem $t9, $t3, $t4 #$t9 = i % lk
add $t0, $a0, $t9 #$t0 holds current key address
add $t1, $a1, $t3 #$t1 holds current cipher address
add $t2, $a2, $t3 #$t2 holds current cleartext address
lb $t9, ($t0) #Load current key
lb $t8, ($t1) #Load current cipher
sub $t7, $t8, $t9 #Add cleartext and key
addi $t7, $t7, 128 #Add 128 to eliminate negatives
rem $t7, $t7, 128
sb $t7, ($t2) #Store encoded cipher into memory
addi $t3, $t3, 1 #i += 1
j decodeWhile
endDecode:
add $t0, $a2, $t5
li $t1, '\0'
sb $t1, ($t0)
li $t0, 0
li $t1, 0
li $t2, 0
li $t3, 0
li $t4, 0
li $t5, 0
li $t6, 0
li $t7, 0
li $t8, 0
li $t9, 0
jr $ra
