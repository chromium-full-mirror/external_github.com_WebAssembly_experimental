	.text
	.file	"/usr/local/google/home/binji/dev/github/wasm-experimental/prototype-wasmate/third_party/llvm/test/CodeGen/WebAssembly/import.ll"
	.globl	f
	.type	f,@function
f:
	.param  	i32, f32, i64, i64, i32
	i32.call	$discard=, printi, $0
	f32.call	$discard=, printf, $1
	call    	printv
	call    	split_arg, $2, $3
	call    	expanded_arg, $4
	i32.call	$discard=, lowered_result
	return
func_end0:
	.size	f, func_end0-f


