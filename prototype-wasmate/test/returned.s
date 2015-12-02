	.text
	.file	"/usr/local/google/home/binji/dev/github/wasm-experimental/prototype-wasmate/third_party/llvm/test/CodeGen/WebAssembly/returned.ll"
	.globl	_Z3foov
	.type	_Z3foov,@function
_Z3foov:
	.result 	i32
	i32.const	$push0=, 1
	call    	$push1=, _Znwm, $pop0
	call    	$push2=, _ZN5AppleC1Ev, $pop1
	return  	$pop2
func_end0:
	.size	_Z3foov, func_end0-_Z3foov

	.globl	_Z3barPvS_l
	.type	_Z3barPvS_l,@function
_Z3barPvS_l:
	.param  	i32, i32, i32
	.result 	i32
	call    	$push0=, memcpy, $0, $1, $2
	return  	$pop0
func_end1:
	.size	_Z3barPvS_l, func_end1-_Z3barPvS_l


	.imports
	.import _Znwm "" _Znwm (param i32) (result i32)
	.import _ZN5AppleC1Ev "" _ZN5AppleC1Ev (param i32) (result i32)
	.import memcpy "" memcpy (param i32 i32 i32) (result i32)
