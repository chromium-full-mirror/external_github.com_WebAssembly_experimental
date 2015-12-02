	.text
	.file	"/usr/local/google/home/binji/dev/github/wasm-experimental/prototype-wasmate/third_party/llvm/test/CodeGen/WebAssembly/inline-asm.ll"
	.globl	foo
	.type	foo,@function
foo:
	.param  	i32
	.result 	i32
	#APP
	# $0 = aaa($0)
	#NO_APP
	return  	$0
func_end0:
	.size	foo, func_end0-foo

	.globl	bar
	.type	bar,@function
bar:
	.param  	i32, i32
	#APP
	# $1 = bbb($0)
	#NO_APP
	return
func_end1:
	.size	bar, func_end1-bar

	.globl	imm
	.type	imm,@function
imm:
	.result 	i32
	.local  	i32
	#APP
	# $0 = ccc(42)
	#NO_APP
	return  	$0
func_end2:
	.size	imm, func_end2-imm

	.globl	foo_i64
	.type	foo_i64,@function
foo_i64:
	.param  	i64
	.result 	i64
	#APP
	# $0 = aaa($0)
	#NO_APP
	return  	$0
func_end3:
	.size	foo_i64, func_end3-foo_i64


