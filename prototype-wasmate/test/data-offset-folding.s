        .data
        .type   pad,@object             # @pad
        .globl  pad
        .align  2
pad:
        .int32  0
        .type   arr,@object             # @arr
        .globl  arr
        .align  4
arr:
        .zero   400
        .size   arr, 400

        .type   ptr,@object             # @ptr
        .globl  ptr
        .align  2
ptr:
        .int32  arr+80
        .size   ptr, 4
