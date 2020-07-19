# set the offset for the jump
ld r8, 0x4
# try to load some immediate (upper 16bit)
ldu r11, 0xa5a5
# (and lower)
ld r13, 0xff
# try to multiply something
mul r11, r13
# now load from memory
ld r9, [r0 + 0x28]
# try to push
push r9
ld r1, 0x7
ld r10, 0x1c
jrrl r10
# JUMP to halt
jrrl r8, r12
nop
nop
ld r3, [r14]
pop r2
# STOP THE CPU
hl
# this is loaded above
fixed_value:
.word 00 00 00 c0

# function
# calling convention: r1, r2, r3, r4 argument, r5 return value
function:
ld r5, 0x2
mul r1, r5
jr r15
