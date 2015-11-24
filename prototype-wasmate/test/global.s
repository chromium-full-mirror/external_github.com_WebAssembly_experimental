	.text
	.file	"/usr/local/google/home/binji/dev/github/wasm-experimental/prototype-wasmate/third_party/llvm/test/CodeGen/WebAssembly/global.ll"
	.globl	foo
	.type	foo,@function
foo:
	.result 	i32
	.local  	i32
	i32.const	$push0=, answer
	i32.load	$0=, $pop0
	return  	$0
func_end0:
	.size	foo, func_end0-foo

	.type	g,@object
	.data
	.align	2
g:
	.int32	1337
	.size	g, 4

	.type	ud,@object
	.align	2
ud:
	.zero	4
	.size	ud, 4

	.type	nil,@object
	.lcomm	nil,4,2
	.type	z,@object
	.lcomm	z,4,2
	.type	one,@object
	.align	2
one:
	.int32	1
	.size	one, 4

	.type	answer,@object
	.align	2
answer:
	.int32	42
	.size	answer, 4

	.type	u32max,@object
	.align	2
u32max:
	.int32	4294967295
	.size	u32max, 4

	.type	ud64,@object
	.align	3
ud64:
	.zero	8
	.size	ud64, 8

	.type	nil64,@object
	.lcomm	nil64,8,3
	.type	z64,@object
	.lcomm	z64,8,3
	.type	twoP32,@object
	.align	3
twoP32:
	.int64	4294967296
	.size	twoP32, 8

	.type	u64max,@object
	.align	3
u64max:
	.int64	-1
	.size	u64max, 8

	.type	f32ud,@object
	.align	2
f32ud:
	.zero	4
	.size	f32ud, 4

	.type	f32nil,@object
	.lcomm	f32nil,4,2
	.type	f32z,@object
	.lcomm	f32z,4,2
	.type	f32nz,@object
	.align	2
f32nz:
	.int32	2147483648
	.size	f32nz, 4

	.type	f32two,@object
	.align	2
f32two:
	.int32	1073741824
	.size	f32two, 4

	.type	f64ud,@object
	.align	3
f64ud:
	.zero	8
	.size	f64ud, 8

	.type	f64nil,@object
	.lcomm	f64nil,8,3
	.type	f64z,@object
	.lcomm	f64z,8,3
	.type	f64nz,@object
	.align	3
f64nz:
	.int64	-9223372036854775808
	.size	f64nz, 8

	.type	f64two,@object
	.align	3
f64two:
	.int64	4611686018427387904
	.size	f64two, 8


