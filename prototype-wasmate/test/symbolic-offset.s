        .text
        .globl  f
        .type   f,@function
f:                     # @f
        .param          i32
        .param          i32
# BB#0:                                 # %entry
        i32.store       $discard=, m+4($0), $1
        return
func_end0:
        .size   f, func_end0-f

        .type   m,@object  # @m
        .data
        .align  2
m:
        .int32  1
        .int32  0
        .int32  0
        .size   m, 12
