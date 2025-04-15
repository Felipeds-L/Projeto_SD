.data
    # espaço na memória onde vamos guardar o resultado do sw
    result: .word 0

.text
.globl main

main:
    addi $s1, $s0, 10   # $s1 = 10
    addi $s2, $s0, 11   # $s2 = 11
    add  $s3, $s1, $s2  # $s3 = 10 + 11 = 21
    sw   $s3, result    # guarda $s3 em mem[0]