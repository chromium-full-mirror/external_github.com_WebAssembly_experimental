	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/global.ll"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
# BB#0:
	i32.const	$push0=, 0
	i32.load	$push1=, answer($pop0)
	return  	$pop1
func_end0:
	.size	foo, func_end0-foo

	.globl	call_memcpy
	.type	call_memcpy,@function
call_memcpy:                            # @call_memcpy
	.param  	i32, i32, i32
	.result 	i32
# BB#0:
	call    	memcpy, $0, $1, $2
	return  	$0
func_end1:
	.size	call_memcpy, func_end1-call_memcpy

	.type	g,@object               # @g
	.data
	.align	2
g:
	.int32	1337                    # 0x539
	.size	g, 4

	.type	ud,@object              # @ud
	.align	2
ud:
	.zero	4
	.size	ud, 4

	.type	nil,@object             # @nil
	.lcomm	nil,4,2
	.type	z,@object               # @z
	.lcomm	z,4,2
	.type	one,@object             # @one
	.align	2
one:
	.int32	1                       # 0x1
	.size	one, 4

	.type	answer,@object          # @answer
	.align	2
answer:
	.int32	42                      # 0x2a
	.size	answer, 4

	.type	u32max,@object          # @u32max
	.align	2
u32max:
	.int32	4294967295              # 0xffffffff
	.size	u32max, 4

	.type	ud64,@object            # @ud64
	.align	3
ud64:
	.zero	8
	.size	ud64, 8

	.type	nil64,@object           # @nil64
	.lcomm	nil64,8,3
	.type	z64,@object             # @z64
	.lcomm	z64,8,3
	.type	twoP32,@object          # @twoP32
	.align	3
twoP32:
	.int64	4294967296              # 0x100000000
	.size	twoP32, 8

	.type	u64max,@object          # @u64max
	.align	3
u64max:
	.int64	-1                      # 0xffffffffffffffff
	.size	u64max, 8

	.type	f32ud,@object           # @f32ud
	.align	2
f32ud:
	.zero	4
	.size	f32ud, 4

	.type	f32nil,@object          # @f32nil
	.lcomm	f32nil,4,2
	.type	f32z,@object            # @f32z
	.lcomm	f32z,4,2
	.type	f32nz,@object           # @f32nz
	.align	2
f32nz:
	.int32	2147483648              # float -0
	.size	f32nz, 4

	.type	f32two,@object          # @f32two
	.align	2
f32two:
	.int32	1073741824              # float 2
	.size	f32two, 4

	.type	f64ud,@object           # @f64ud
	.align	3
f64ud:
	.zero	8
	.size	f64ud, 8

	.type	f64nil,@object          # @f64nil
	.lcomm	f64nil,8,3
	.type	f64z,@object            # @f64z
	.lcomm	f64z,8,3
	.type	f64nz,@object           # @f64nz
	.align	3
f64nz:
	.int64	-9223372036854775808    # double -0
	.size	f64nz, 8

	.type	f64two,@object          # @f64two
	.align	3
f64two:
	.int64	4611686018427387904     # double 2
	.size	f64two, 8

	.type	arr,@object             # @arr
	.bss
	.globl	arr
	.align	4
arr:
	.zero	512
	.size	arr, 512

	.type	ptr,@object             # @ptr
	.data
	.globl	ptr
	.align	2
ptr:
	.int32	arr+80
	.size	ptr, 4

	.type	rom,@object             # @rom
	.section	.rodata,"a",@progbits
	.globl	rom
	.align	4
rom:
	.zero	512
	.size	rom, 512


	.section	".note.GNU-stack","",@progbits
