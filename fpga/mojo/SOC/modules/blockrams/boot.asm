# set the offset for the jump
ld r8, 0xc
# try to load some immediate (upper 16bit)
ldu r11, 0xa5a5
# (and lower)
ld r13, 0xff
# try to multiply something
mul r11, r13
# now load from memory
ld r9, [r0 + 0x24]
# try to push
push r9
nop
nop
nop
# JUMP to halt
jrrl r8, r12
nop
nop
nop
# STOP THE CPU
hl
# this is loaded above
.word 0x01020304
