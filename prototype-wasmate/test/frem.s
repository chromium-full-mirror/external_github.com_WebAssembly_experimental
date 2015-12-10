	.text
	.file	"/usr/local/google/home/binji/dev/github/wasm-experimental/prototype-wasmate/third_party/llvm/test/CodeGen/WebAssembly/frem.ll"
	.globl	frem32
	.type	frem32,@function
frem32:
	.param  	f32, f32
	.result 	f32
	call    	$push0=, fmodf, $0, $1
	return  	$pop0
func_end0:
	.size	frem32, func_end0-frem32

	.globl	frem64
	.type	frem64,@function
frem64:
	.param  	f64, f64
	.result 	f64
	call    	$push0=, fmod, $0, $1
	return  	$pop0
func_end1:
	.size	frem64, func_end1-frem64


