	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/legalize.ll"
	.globl	shl_i3
	.type	shl_i3,@function
shl_i3:                                 # @shl_i3
	.param  	i32, i32, i32
	.result 	i32
# BB#0:
	i32.const	$push0=, 7
	i32.and 	$push1=, $1, $pop0
	i32.shl 	$push2=, $0, $pop1
	return  	$pop2
func_end0:
	.size	shl_i3, func_end0-shl_i3

	.globl	shl_i53
	.type	shl_i53,@function
shl_i53:                                # @shl_i53
	.param  	i64, i64, i32
	.result 	i64
# BB#0:
	i64.const	$push0=, 9007199254740991
	i64.and 	$push1=, $1, $pop0
	i64.shl 	$push2=, $0, $pop1
	return  	$pop2
func_end1:
	.size	shl_i53, func_end1-shl_i53

	.globl	sext_in_reg_i32_i64
	.type	sext_in_reg_i32_i64,@function
sext_in_reg_i32_i64:                    # @sext_in_reg_i32_i64
	.param  	i64
	.result 	i64
	.local  	i64
# BB#0:
	i64.const	$1=, 32
	i64.shl 	$push0=, $0, $1
	i64.shr_s	$push1=, $pop0, $1
	return  	$pop1
func_end2:
	.size	sext_in_reg_i32_i64, func_end2-sext_in_reg_i32_i64

	.globl	fpext_f32_f64
	.type	fpext_f32_f64,@function
fpext_f32_f64:                          # @fpext_f32_f64
	.param  	i32
	.result 	f64
# BB#0:
	f32.load	$push0=, 0($0)
	f64.promote/f32	$push1=, $pop0
	return  	$pop1
func_end3:
	.size	fpext_f32_f64, func_end3-fpext_f32_f64

	.globl	fpconv_f64_f32
	.type	fpconv_f64_f32,@function
fpconv_f64_f32:                         # @fpconv_f64_f32
	.param  	i32
	.result 	f32
# BB#0:
	f64.load	$push0=, 0($0)
	f32.demote/f64	$push1=, $pop0
	return  	$pop1
func_end4:
	.size	fpconv_f64_f32, func_end4-fpconv_f64_f32

	.globl	bigshift
	.type	bigshift,@function
bigshift:                               # @bigshift
	.param  	i32, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64
	.local  	i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i64, i32, i32, i32, i32, i32, i32, i64, i64, i64, i32, i32, i64, i64, i64, i32, i32, i64, i32, i32, i64, i32, i32, i32, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i64, i64, i64, i32, i64, i64, i32, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:
	i32.const	$181=, __stack_pointer
	i32.load	$181=, 0($181)
	i32.const	$182=, 1024
	i32.sub 	$279=, $181, $182
	i32.const	$182=, __stack_pointer
	i32.store	$279=, 0($182), $279
	i64.const	$push0=, 896
	i64.sub 	$push1=, $pop0, $17
	i32.const	$184=, 480
	i32.add 	$184=, $279, $184
	call    	__lshrti3, $184, $1, $2, $pop1
	i64.const	$push2=, -768
	i64.add 	$33=, $17, $pop2
	i32.const	$185=, 464
	i32.add 	$185=, $279, $185
	call    	__ashlti3, $185, $3, $4, $33
	i64.const	$push3=, -896
	i64.add 	$push4=, $17, $pop3
	i32.const	$186=, 496
	i32.add 	$186=, $279, $186
	call    	__ashlti3, $186, $1, $2, $pop4
	i64.const	$push5=, 640
	i64.sub 	$34=, $pop5, $17
	i32.const	$187=, 352
	i32.add 	$187=, $279, $187
	call    	__lshrti3, $187, $5, $6, $34
	i64.const	$push6=, -512
	i64.add 	$35=, $17, $pop6
	i32.const	$188=, 336
	i32.add 	$188=, $279, $188
	call    	__ashlti3, $188, $7, $8, $35
	i64.const	$push7=, -640
	i64.add 	$36=, $17, $pop7
	i32.const	$189=, 368
	i32.add 	$189=, $279, $189
	call    	__ashlti3, $189, $5, $6, $36
	i64.const	$push8=, 768
	i64.sub 	$37=, $pop8, $17
	i32.const	$190=, 432
	i32.add 	$190=, $279, $190
	call    	__lshrti3, $190, $3, $4, $37
	i64.const	$38=, 384
	i64.sub 	$39=, $38, $17
	i32.const	$191=, 864
	i32.add 	$191=, $279, $191
	call    	__lshrti3, $191, $9, $10, $39
	i64.const	$push9=, -256
	i64.add 	$40=, $17, $pop9
	i32.const	$192=, 848
	i32.add 	$192=, $279, $192
	call    	__ashlti3, $192, $11, $12, $40
	i64.const	$push10=, -384
	i64.add 	$41=, $17, $pop10
	i32.const	$193=, 880
	i32.add 	$193=, $279, $193
	call    	__ashlti3, $193, $9, $10, $41
	i32.const	$194=, 1008
	i32.add 	$194=, $279, $194
	call    	__ashlti3, $194, $15, $16, $17
	i64.const	$42=, 128
	i64.sub 	$51=, $42, $17
	i32.const	$195=, 960
	i32.add 	$195=, $279, $195
	call    	__lshrti3, $195, $13, $14, $51
	i64.const	$push11=, -128
	i64.add 	$43=, $17, $pop11
	i32.const	$196=, 976
	i32.add 	$196=, $279, $196
	call    	__ashlti3, $196, $13, $14, $43
	i64.const	$44=, 256
	i64.sub 	$45=, $44, $17
	i32.const	$197=, 816
	i32.add 	$197=, $279, $197
	call    	__lshrti3, $197, $11, $12, $45
	i64.const	$46=, 512
	i64.sub 	$47=, $46, $17
	i32.const	$198=, 240
	i32.add 	$198=, $279, $198
	call    	__lshrti3, $198, $7, $8, $47
	i32.const	$199=, 912
	i32.add 	$199=, $279, $199
	call    	__ashlti3, $199, $11, $12, $17
	i32.const	$200=, 928
	i32.add 	$200=, $279, $200
	call    	__lshrti3, $200, $9, $10, $51
	i32.const	$201=, 944
	i32.add 	$201=, $279, $201
	call    	__ashlti3, $201, $9, $10, $43
	i64.sub 	$48=, $44, $47
	i32.const	$202=, 80
	i32.add 	$202=, $279, $202
	call    	__ashlti3, $202, $7, $8, $48
	i64.sub 	$push12=, $42, $48
	i32.const	$203=, 96
	i32.add 	$203=, $279, $203
	call    	__lshrti3, $203, $5, $6, $pop12
	i64.sub 	$49=, $42, $47
	i32.const	$204=, 112
	i32.add 	$204=, $279, $204
	call    	__ashlti3, $204, $5, $6, $49
	i32.const	$205=, 48
	i32.add 	$205=, $279, $205
	call    	__lshrti3, $205, $3, $4, $47
	i32.const	$206=, 176
	i32.add 	$206=, $279, $206
	call    	__lshrti3, $206, $7, $8, $45
	i32.const	$207=, 288
	i32.add 	$207=, $279, $207
	call    	__lshrti3, $207, $1, $2, $34
	i32.const	$208=, 272
	i32.add 	$208=, $279, $208
	call    	__ashlti3, $208, $3, $4, $35
	i32.const	$209=, 304
	i32.add 	$209=, $279, $209
	call    	__ashlti3, $209, $1, $2, $36
	i32.const	$210=, 128
	i32.add 	$210=, $279, $210
	call    	__lshrti3, $210, $5, $6, $45
	i64.sub 	$push13=, $38, $47
	i32.const	$211=, 144
	i32.add 	$211=, $279, $211
	call    	__ashlti3, $211, $7, $8, $pop13
	i32.const	$212=, 160
	i32.add 	$212=, $279, $212
	call    	__lshrti3, $212, $7, $8, $51
	i32.const	$213=, 0
	i32.add 	$213=, $279, $213
	call    	__lshrti3, $213, $1, $2, $47
	i32.const	$214=, 16
	i32.add 	$214=, $279, $214
	call    	__ashlti3, $214, $3, $4, $49
	i32.const	$215=, 32
	i32.add 	$215=, $279, $215
	call    	__lshrti3, $215, $3, $4, $39
	i32.const	$216=, 64
	i32.add 	$216=, $279, $216
	call    	__ashlti3, $216, $5, $6, $48
	i32.const	$217=, 896
	i32.add 	$217=, $279, $217
	call    	__ashlti3, $217, $9, $10, $17
	i32.const	$218=, 256
	i32.add 	$218=, $279, $218
	call    	__ashlti3, $218, $1, $2, $35
	i32.const	$219=, 192
	i32.add 	$219=, $279, $219
	call    	__lshrti3, $219, $5, $6, $47
	i32.const	$220=, 208
	i32.add 	$220=, $279, $220
	call    	__ashlti3, $220, $7, $8, $49
	i32.const	$221=, 224
	i32.add 	$221=, $279, $221
	call    	__lshrti3, $221, $7, $8, $39
	i32.const	$222=, 768
	i32.add 	$222=, $279, $222
	call    	__lshrti3, $222, $9, $10, $45
	i64.sub 	$49=, $42, $45
	i32.const	$223=, 784
	i32.add 	$223=, $279, $223
	call    	__ashlti3, $223, $11, $12, $49
	i32.const	$224=, 800
	i32.add 	$224=, $279, $224
	call    	__lshrti3, $224, $11, $12, $51
	i32.const	$225=, 992
	i32.add 	$225=, $279, $225
	call    	__ashlti3, $225, $13, $14, $17
	i32.const	$226=, 832
	i32.add 	$226=, $279, $226
	call    	__ashlti3, $226, $9, $10, $40
	i32.const	$227=, 384
	i32.add 	$227=, $279, $227
	call    	__lshrti3, $227, $1, $2, $37
	i64.sub 	$push14=, $42, $37
	i32.const	$228=, 400
	i32.add 	$228=, $279, $228
	call    	__ashlti3, $228, $3, $4, $pop14
	i32.const	$229=, 416
	i32.add 	$229=, $279, $229
	call    	__lshrti3, $229, $3, $4, $34
	i32.const	$230=, 320
	i32.add 	$230=, $279, $230
	call    	__ashlti3, $230, $5, $6, $35
	i32.const	$231=, 448
	i32.add 	$231=, $279, $231
	call    	__ashlti3, $231, $1, $2, $33
	i32.const	$232=, 736
	i32.add 	$232=, $279, $232
	call    	__lshrti3, $232, $1, $2, $39
	i32.const	$233=, 720
	i32.add 	$233=, $279, $233
	call    	__ashlti3, $233, $3, $4, $40
	i32.const	$234=, 752
	i32.add 	$234=, $279, $234
	call    	__ashlti3, $234, $1, $2, $41
	i32.const	$235=, 592
	i32.add 	$235=, $279, $235
	call    	__ashlti3, $235, $7, $8, $17
	i32.const	$236=, 608
	i32.add 	$236=, $279, $236
	call    	__lshrti3, $236, $5, $6, $51
	i32.const	$237=, 624
	i32.add 	$237=, $279, $237
	call    	__ashlti3, $237, $5, $6, $43
	i32.const	$238=, 688
	i32.add 	$238=, $279, $238
	call    	__lshrti3, $238, $3, $4, $45
	i32.const	$239=, 640
	i32.add 	$239=, $279, $239
	call    	__lshrti3, $239, $1, $2, $45
	i32.const	$240=, 656
	i32.add 	$240=, $279, $240
	call    	__ashlti3, $240, $3, $4, $49
	i32.const	$241=, 672
	i32.add 	$241=, $279, $241
	call    	__lshrti3, $241, $3, $4, $51
	i32.const	$242=, 576
	i32.add 	$242=, $279, $242
	call    	__ashlti3, $242, $5, $6, $17
	i32.const	$243=, 704
	i32.add 	$243=, $279, $243
	call    	__ashlti3, $243, $1, $2, $40
	i32.const	$244=, 528
	i32.add 	$244=, $279, $244
	call    	__ashlti3, $244, $3, $4, $17
	i32.const	$245=, 544
	i32.add 	$245=, $279, $245
	call    	__lshrti3, $245, $1, $2, $51
	i32.const	$246=, 560
	i32.add 	$246=, $279, $246
	call    	__ashlti3, $246, $1, $2, $43
	i32.const	$247=, 512
	i32.add 	$247=, $279, $247
	call    	__ashlti3, $247, $1, $2, $17
	i64.load	$39=, 480($279)
	i64.load	$43=, 464($279)
	i64.load	$34=, 496($279)
	i64.const	$51=, 0
	i64.load	$49=, 352($279)
	i64.load	$36=, 336($279)
	i64.load	$38=, 368($279)
	i64.load	$41=, 432($279)
	i64.load	$58=, 864($279)
	i64.load	$59=, 848($279)
	i64.load	$60=, 880($279)
	i64.load	$63=, 1008($279)
	i64.load	$64=, 960($279)
	i64.load	$65=, 976($279)
	i64.load	$68=, 816($279)
	i64.load	$71=, 240($279)
	i64.lt_u	$50=, $33, $42
	i64.eq  	$52=, $33, $51
	i64.lt_u	$53=, $35, $42
	i64.eq  	$54=, $35, $51
	i64.lt_u	$55=, $37, $42
	i64.lt_u	$56=, $35, $44
	i64.lt_u	$57=, $40, $42
	i64.eq  	$61=, $40, $51
	i64.lt_u	$62=, $17, $42
	i64.eq  	$66=, $17, $51
	i64.lt_u	$67=, $45, $42
	i64.lt_u	$69=, $17, $44
	i64.lt_u	$70=, $47, $42
	i64.lt_u	$72=, $47, $44
	i64.lt_u	$73=, $17, $46
	i32.const	$74=, 8
	i32.const	$248=, 480
	i32.add 	$248=, $279, $248
	i32.add 	$push40=, $248, $74
	i64.load	$17=, 0($pop40)
	i32.const	$249=, 464
	i32.add 	$249=, $279, $249
	i32.add 	$push41=, $249, $74
	i64.load	$35=, 0($pop41)
	i32.const	$250=, 496
	i32.add 	$250=, $279, $250
	i32.add 	$push43=, $250, $74
	i64.load	$40=, 0($pop43)
	i32.const	$251=, 352
	i32.add 	$251=, $279, $251
	i32.add 	$push46=, $251, $74
	i64.load	$44=, 0($pop46)
	i32.const	$252=, 336
	i32.add 	$252=, $279, $252
	i32.add 	$push47=, $252, $74
	i64.load	$33=, 0($pop47)
	i32.const	$253=, 368
	i32.add 	$253=, $279, $253
	i32.add 	$push49=, $253, $74
	i64.load	$46=, 0($pop49)
	i32.const	$254=, 432
	i32.add 	$254=, $279, $254
	i32.add 	$push52=, $254, $74
	i64.load	$75=, 0($pop52)
	i32.const	$255=, 864
	i32.add 	$255=, $279, $255
	i32.add 	$push57=, $255, $74
	i64.load	$76=, 0($pop57)
	i32.const	$256=, 848
	i32.add 	$256=, $279, $256
	i32.add 	$push58=, $256, $74
	i64.load	$77=, 0($pop58)
	i32.const	$257=, 880
	i32.add 	$257=, $279, $257
	i32.add 	$push60=, $257, $74
	i64.load	$78=, 0($pop60)
	i32.const	$258=, 1008
	i32.add 	$258=, $279, $258
	i32.add 	$push63=, $258, $74
	i64.load	$79=, 0($pop63)
	i32.const	$259=, 960
	i32.add 	$259=, $279, $259
	i32.add 	$push64=, $259, $74
	i64.load	$80=, 0($pop64)
	i32.const	$260=, 976
	i32.add 	$260=, $279, $260
	i32.add 	$push66=, $260, $74
	i64.load	$81=, 0($pop66)
	i32.const	$261=, 816
	i32.add 	$261=, $279, $261
	i32.add 	$push69=, $261, $74
	i64.load	$82=, 0($pop69)
	i32.const	$262=, 240
	i32.add 	$262=, $279, $262
	i32.add 	$push74=, $262, $74
	i64.load	$83=, 0($pop74)
	i64.load	$84=, 912($279)
	i64.load	$85=, 928($279)
	i64.load	$86=, 944($279)
	i64.load	$88=, 80($279)
	i64.load	$89=, 96($279)
	i64.load	$90=, 112($279)
	i64.load	$92=, 48($279)
	i64.load	$93=, 176($279)
	i64.load	$95=, 288($279)
	i64.load	$96=, 272($279)
	i64.lt_u	$87=, $48, $42
	i64.eq  	$91=, $48, $51
	i64.eq  	$94=, $47, $51
	i64.load	$42=, 304($279)
	i32.const	$263=, 912
	i32.add 	$263=, $279, $263
	i32.add 	$push99=, $263, $74
	i64.load	$47=, 0($pop99)
	i32.const	$264=, 928
	i32.add 	$264=, $279, $264
	i32.add 	$push100=, $264, $74
	i64.load	$48=, 0($pop100)
	i32.const	$265=, 944
	i32.add 	$265=, $279, $265
	i32.add 	$push102=, $265, $74
	i64.load	$97=, 0($pop102)
	i32.const	$266=, 80
	i32.add 	$266=, $279, $266
	i32.add 	$push106=, $266, $74
	i64.load	$98=, 0($pop106)
	i32.const	$267=, 96
	i32.add 	$267=, $279, $267
	i32.add 	$push107=, $267, $74
	i64.load	$99=, 0($pop107)
	i32.const	$268=, 112
	i32.add 	$268=, $279, $268
	i32.add 	$push109=, $268, $74
	i64.load	$100=, 0($pop109)
	i32.const	$269=, 48
	i32.add 	$269=, $279, $269
	i32.add 	$push112=, $269, $74
	i64.load	$101=, 0($pop112)
	i32.const	$270=, 176
	i32.add 	$270=, $279, $270
	i32.add 	$push115=, $270, $74
	i64.load	$102=, 0($pop115)
	i32.const	$271=, 288
	i32.add 	$271=, $279, $271
	i32.add 	$push120=, $271, $74
	i64.load	$103=, 0($pop120)
	i32.const	$272=, 272
	i32.add 	$272=, $279, $272
	i32.add 	$push121=, $272, $74
	i64.load	$104=, 0($pop121)
	i32.const	$273=, 304
	i32.add 	$273=, $279, $273
	i32.add 	$push123=, $273, $74
	i64.load	$105=, 0($pop123)
	i64.load	$106=, 128($279)
	i64.load	$107=, 144($279)
	i64.load	$108=, 160($279)
	i64.load	$110=, 0($279)
	i64.load	$111=, 16($279)
	i64.load	$112=, 32($279)
	i64.load	$113=, 64($279)
	i64.load	$114=, 896($279)
	i64.eq  	$109=, $45, $51
	i64.load	$45=, 256($279)
	i32.const	$274=, 128
	i32.add 	$274=, $279, $274
	i32.add 	$push146=, $274, $74
	i64.load	$115=, 0($pop146)
	i32.const	$275=, 144
	i32.add 	$275=, $279, $275
	i32.add 	$push147=, $275, $74
	i64.load	$116=, 0($pop147)
	i32.const	$276=, 160
	i32.add 	$276=, $279, $276
	i32.add 	$push149=, $276, $74
	i64.load	$117=, 0($pop149)
	i32.const	$277=, 0
	i32.add 	$277=, $279, $277
	i32.add 	$push152=, $277, $74
	i64.load	$118=, 0($pop152)
	i32.const	$278=, 16
	i32.add 	$278=, $279, $278
	i32.add 	$push153=, $278, $74
	i64.load	$119=, 0($pop153)
	i32.const	$279=, 32
	i32.add 	$279=, $279, $279
	i32.add 	$push155=, $279, $74
	i64.load	$120=, 0($pop155)
	i32.const	$280=, 64
	i32.add 	$280=, $279, $280
	i32.add 	$push158=, $280, $74
	i64.load	$121=, 0($pop158)
	i32.const	$281=, 896
	i32.add 	$281=, $279, $281
	i32.add 	$push163=, $281, $74
	i64.load	$122=, 0($pop163)
	i32.const	$282=, 256
	i32.add 	$282=, $279, $282
	i32.add 	$push167=, $282, $74
	i64.load	$123=, 0($pop167)
	i64.load	$124=, 192($279)
	i64.load	$125=, 208($279)
	i64.load	$126=, 224($279)
	i64.load	$127=, 768($279)
	i64.load	$128=, 784($279)
	i64.load	$129=, 800($279)
	i64.load	$130=, 992($279)
	i64.load	$131=, 832($279)
	i64.load	$132=, 384($279)
	i64.load	$133=, 400($279)
	i64.load	$134=, 416($279)
	i64.load	$136=, 320($279)
	i64.eq  	$135=, $37, $51
	i64.load	$37=, 448($279)
	i32.const	$283=, 192
	i32.add 	$283=, $279, $283
	i32.add 	$push195=, $283, $74
	i64.load	$137=, 0($pop195)
	i32.const	$284=, 208
	i32.add 	$284=, $279, $284
	i32.add 	$push196=, $284, $74
	i64.load	$138=, 0($pop196)
	i32.const	$285=, 224
	i32.add 	$285=, $279, $285
	i32.add 	$push198=, $285, $74
	i64.load	$139=, 0($pop198)
	i32.const	$286=, 768
	i32.add 	$286=, $279, $286
	i32.add 	$push202=, $286, $74
	i64.load	$140=, 0($pop202)
	i32.const	$287=, 784
	i32.add 	$287=, $279, $287
	i32.add 	$push203=, $287, $74
	i64.load	$141=, 0($pop203)
	i32.const	$288=, 800
	i32.add 	$288=, $279, $288
	i32.add 	$push205=, $288, $74
	i64.load	$142=, 0($pop205)
	i32.const	$289=, 992
	i32.add 	$289=, $279, $289
	i32.add 	$push208=, $289, $74
	i64.load	$143=, 0($pop208)
	i32.const	$290=, 832
	i32.add 	$290=, $279, $290
	i32.add 	$push211=, $290, $74
	i64.load	$144=, 0($pop211)
	i32.const	$291=, 384
	i32.add 	$291=, $279, $291
	i32.add 	$push216=, $291, $74
	i64.load	$145=, 0($pop216)
	i32.const	$292=, 400
	i32.add 	$292=, $279, $292
	i32.add 	$push217=, $292, $74
	i64.load	$146=, 0($pop217)
	i32.const	$293=, 416
	i32.add 	$293=, $279, $293
	i32.add 	$push219=, $293, $74
	i64.load	$147=, 0($pop219)
	i32.const	$294=, 320
	i32.add 	$294=, $279, $294
	i32.add 	$push222=, $294, $74
	i64.load	$148=, 0($pop222)
	i32.const	$295=, 448
	i32.add 	$295=, $279, $295
	i32.add 	$push225=, $295, $74
	i64.load	$149=, 0($pop225)
	i64.load	$150=, 736($279)
	i64.load	$151=, 720($279)
	i64.load	$152=, 752($279)
	i64.load	$153=, 592($279)
	i64.load	$154=, 608($279)
	i64.load	$155=, 624($279)
	i64.load	$156=, 688($279)
	i32.const	$296=, 736
	i32.add 	$296=, $279, $296
	i32.add 	$push242=, $296, $74
	i64.load	$157=, 0($pop242)
	i32.const	$297=, 720
	i32.add 	$297=, $279, $297
	i32.add 	$push243=, $297, $74
	i64.load	$158=, 0($pop243)
	i32.const	$298=, 752
	i32.add 	$298=, $279, $298
	i32.add 	$push245=, $298, $74
	i64.load	$159=, 0($pop245)
	i32.const	$299=, 592
	i32.add 	$299=, $279, $299
	i32.add 	$push248=, $299, $74
	i64.load	$160=, 0($pop248)
	i32.const	$300=, 608
	i32.add 	$300=, $279, $300
	i32.add 	$push249=, $300, $74
	i64.load	$161=, 0($pop249)
	i32.const	$301=, 624
	i32.add 	$301=, $279, $301
	i32.add 	$push251=, $301, $74
	i64.load	$162=, 0($pop251)
	i32.const	$302=, 688
	i32.add 	$302=, $279, $302
	i32.add 	$push254=, $302, $74
	i64.load	$163=, 0($pop254)
	i64.load	$164=, 640($279)
	i64.load	$165=, 656($279)
	i64.load	$166=, 672($279)
	i64.load	$167=, 576($279)
	i64.load	$168=, 704($279)
	i32.const	$303=, 640
	i32.add 	$303=, $279, $303
	i32.add 	$push269=, $303, $74
	i64.load	$169=, 0($pop269)
	i32.const	$304=, 656
	i32.add 	$304=, $279, $304
	i32.add 	$push270=, $304, $74
	i64.load	$170=, 0($pop270)
	i32.const	$305=, 672
	i32.add 	$305=, $279, $305
	i32.add 	$push272=, $305, $74
	i64.load	$171=, 0($pop272)
	i32.const	$306=, 576
	i32.add 	$306=, $279, $306
	i32.add 	$push275=, $306, $74
	i64.load	$172=, 0($pop275)
	i32.const	$307=, 704
	i32.add 	$307=, $279, $307
	i32.add 	$push278=, $307, $74
	i64.load	$173=, 0($pop278)
	i64.load	$174=, 528($279)
	i64.load	$175=, 544($279)
	i64.load	$176=, 560($279)
	i32.const	$308=, 528
	i32.add 	$308=, $279, $308
	i32.add 	$push288=, $308, $74
	i64.load	$177=, 0($pop288)
	i32.const	$309=, 544
	i32.add 	$309=, $279, $309
	i32.add 	$push289=, $309, $74
	i64.load	$178=, 0($pop289)
	i32.const	$310=, 560
	i32.add 	$310=, $279, $310
	i32.add 	$push291=, $310, $74
	i64.load	$179=, 0($pop291)
	i64.load	$180=, 512($279)
	i32.add 	$push304=, $0, $74
	i32.const	$311=, 512
	i32.add 	$311=, $279, $311
	i32.add 	$push299=, $311, $74
	i64.load	$push300=, 0($pop299)
	i64.select	$push301=, $62, $pop300, $51
	i64.select	$push302=, $69, $pop301, $51
	i64.select	$push303=, $73, $pop302, $51
	i64.store	$discard=, 0($pop304), $pop303
	i64.select	$push296=, $62, $180, $51
	i64.select	$push297=, $69, $pop296, $51
	i64.select	$push298=, $73, $pop297, $51
	i64.store	$discard=, 0($0), $pop298
	i32.const	$push305=, 24
	i32.add 	$push306=, $0, $pop305
	i64.or  	$push290=, $177, $178
	i64.select	$push292=, $62, $pop290, $179
	i64.select	$push293=, $66, $4, $pop292
	i64.select	$push294=, $69, $pop293, $51
	i64.select	$push295=, $73, $pop294, $51
	i64.store	$discard=, 0($pop306), $pop295
	i32.const	$push307=, 16
	i32.add 	$push308=, $0, $pop307
	i64.or  	$push283=, $174, $175
	i64.select	$push284=, $62, $pop283, $176
	i64.select	$push285=, $66, $3, $pop284
	i64.select	$push286=, $69, $pop285, $51
	i64.select	$push287=, $73, $pop286, $51
	i64.store	$discard=, 0($pop308), $pop287
	i32.const	$push309=, 56
	i32.add 	$push310=, $0, $pop309
	i64.or  	$push250=, $160, $161
	i64.select	$push252=, $62, $pop250, $162
	i64.select	$push253=, $66, $8, $pop252
	i64.select	$push255=, $67, $163, $51
	i64.or  	$push256=, $pop253, $pop255
	i64.or  	$push244=, $158, $157
	i64.select	$push246=, $57, $pop244, $159
	i64.select	$push247=, $61, $4, $pop246
	i64.select	$push257=, $69, $pop256, $pop247
	i64.select	$push258=, $66, $8, $pop257
	i64.select	$push259=, $73, $pop258, $51
	i64.store	$discard=, 0($pop310), $pop259
	i32.const	$push311=, 48
	i32.add 	$push312=, $0, $pop311
	i64.or  	$push234=, $153, $154
	i64.select	$push235=, $62, $pop234, $155
	i64.select	$push236=, $66, $7, $pop235
	i64.select	$push237=, $67, $156, $51
	i64.or  	$push238=, $pop236, $pop237
	i64.or  	$push231=, $151, $150
	i64.select	$push232=, $57, $pop231, $152
	i64.select	$push233=, $61, $3, $pop232
	i64.select	$push239=, $69, $pop238, $pop233
	i64.select	$push240=, $66, $7, $pop239
	i64.select	$push241=, $73, $pop240, $51
	i64.store	$discard=, 0($pop312), $pop241
	i32.const	$push313=, 40
	i32.add 	$push314=, $0, $pop313
	i64.select	$push276=, $62, $172, $51
	i64.or  	$push271=, $169, $170
	i64.select	$push273=, $67, $pop271, $171
	i64.select	$push274=, $109, $2, $pop273
	i64.or  	$push277=, $pop276, $pop274
	i64.select	$push279=, $57, $173, $51
	i64.select	$push280=, $69, $pop277, $pop279
	i64.select	$push281=, $66, $6, $pop280
	i64.select	$push282=, $73, $pop281, $51
	i64.store	$discard=, 0($pop314), $pop282
	i32.const	$push315=, 32
	i32.add 	$push316=, $0, $pop315
	i64.select	$push263=, $62, $167, $51
	i64.or  	$push260=, $164, $165
	i64.select	$push261=, $67, $pop260, $166
	i64.select	$push262=, $109, $1, $pop261
	i64.or  	$push264=, $pop263, $pop262
	i64.select	$push265=, $57, $168, $51
	i64.select	$push266=, $69, $pop264, $pop265
	i64.select	$push267=, $66, $5, $pop266
	i64.select	$push268=, $73, $pop267, $51
	i64.store	$discard=, 0($pop316), $pop268
	i32.const	$push317=, 120
	i32.add 	$push318=, $0, $pop317
	i64.or  	$push65=, $79, $80
	i64.select	$push67=, $62, $pop65, $81
	i64.select	$push68=, $66, $16, $pop67
	i64.select	$push70=, $67, $82, $51
	i64.or  	$push71=, $pop68, $pop70
	i64.or  	$push59=, $77, $76
	i64.select	$push61=, $57, $pop59, $78
	i64.select	$push62=, $61, $12, $pop61
	i64.select	$push72=, $69, $pop71, $pop62
	i64.select	$push73=, $66, $16, $pop72
	i64.select	$push75=, $70, $83, $51
	i64.select	$push76=, $72, $pop75, $51
	i64.or  	$push77=, $pop73, $pop76
	i64.or  	$push48=, $33, $44
	i64.select	$push50=, $53, $pop48, $46
	i64.select	$push51=, $54, $8, $pop50
	i64.select	$push53=, $55, $75, $51
	i64.or  	$push54=, $pop51, $pop53
	i64.or  	$push42=, $35, $17
	i64.select	$push44=, $50, $pop42, $40
	i64.select	$push45=, $52, $4, $pop44
	i64.select	$push55=, $56, $pop54, $pop45
	i64.select	$push56=, $54, $8, $pop55
	i64.select	$push78=, $73, $pop77, $pop56
	i64.select	$push79=, $66, $16, $pop78
	i64.store	$discard=, 0($pop318), $pop79
	i32.const	$push319=, 112
	i32.add 	$push320=, $0, $pop319
	i64.or  	$push28=, $63, $64
	i64.select	$push29=, $62, $pop28, $65
	i64.select	$push30=, $66, $15, $pop29
	i64.select	$push31=, $67, $68, $51
	i64.or  	$push32=, $pop30, $pop31
	i64.or  	$push25=, $59, $58
	i64.select	$push26=, $57, $pop25, $60
	i64.select	$push27=, $61, $11, $pop26
	i64.select	$push33=, $69, $pop32, $pop27
	i64.select	$push34=, $66, $15, $pop33
	i64.select	$push35=, $70, $71, $51
	i64.select	$push36=, $72, $pop35, $51
	i64.or  	$push37=, $pop34, $pop36
	i64.or  	$push18=, $36, $49
	i64.select	$push19=, $53, $pop18, $38
	i64.select	$push20=, $54, $7, $pop19
	i64.select	$push21=, $55, $41, $51
	i64.or  	$push22=, $pop20, $pop21
	i64.or  	$push15=, $43, $39
	i64.select	$push16=, $50, $pop15, $34
	i64.select	$push17=, $52, $3, $pop16
	i64.select	$push23=, $56, $pop22, $pop17
	i64.select	$push24=, $54, $7, $pop23
	i64.select	$push38=, $73, $pop37, $pop24
	i64.select	$push39=, $66, $15, $pop38
	i64.store	$discard=, 0($pop320), $pop39
	i32.const	$push321=, 104
	i32.add 	$push322=, $0, $pop321
	i64.select	$push209=, $62, $143, $51
	i64.or  	$push204=, $140, $141
	i64.select	$push206=, $67, $pop204, $142
	i64.select	$push207=, $109, $10, $pop206
	i64.or  	$push210=, $pop209, $pop207
	i64.select	$push212=, $57, $144, $51
	i64.select	$push213=, $69, $pop210, $pop212
	i64.select	$push214=, $66, $14, $pop213
	i64.or  	$push197=, $137, $138
	i64.select	$push199=, $70, $pop197, $139
	i64.select	$push200=, $94, $6, $pop199
	i64.select	$push201=, $72, $pop200, $51
	i64.or  	$push215=, $pop214, $pop201
	i64.select	$push223=, $53, $148, $51
	i64.or  	$push218=, $145, $146
	i64.select	$push220=, $55, $pop218, $147
	i64.select	$push221=, $135, $2, $pop220
	i64.or  	$push224=, $pop223, $pop221
	i64.select	$push226=, $50, $149, $51
	i64.select	$push227=, $56, $pop224, $pop226
	i64.select	$push228=, $54, $6, $pop227
	i64.select	$push229=, $73, $pop215, $pop228
	i64.select	$push230=, $66, $14, $pop229
	i64.store	$discard=, 0($pop322), $pop230
	i32.const	$push323=, 96
	i32.add 	$push324=, $0, $pop323
	i64.select	$push179=, $62, $130, $51
	i64.or  	$push176=, $127, $128
	i64.select	$push177=, $67, $pop176, $129
	i64.select	$push178=, $109, $9, $pop177
	i64.or  	$push180=, $pop179, $pop178
	i64.select	$push181=, $57, $131, $51
	i64.select	$push182=, $69, $pop180, $pop181
	i64.select	$push183=, $66, $13, $pop182
	i64.or  	$push172=, $124, $125
	i64.select	$push173=, $70, $pop172, $126
	i64.select	$push174=, $94, $5, $pop173
	i64.select	$push175=, $72, $pop174, $51
	i64.or  	$push184=, $pop183, $pop175
	i64.select	$push188=, $53, $136, $51
	i64.or  	$push185=, $132, $133
	i64.select	$push186=, $55, $pop185, $134
	i64.select	$push187=, $135, $1, $pop186
	i64.or  	$push189=, $pop188, $pop187
	i64.select	$push190=, $50, $37, $51
	i64.select	$push191=, $56, $pop189, $pop190
	i64.select	$push192=, $54, $5, $pop191
	i64.select	$push193=, $73, $pop184, $pop192
	i64.select	$push194=, $66, $13, $pop193
	i64.store	$discard=, 0($pop324), $pop194
	i32.const	$push325=, 72
	i32.add 	$push326=, $0, $pop325
	i64.select	$push164=, $62, $122, $51
	i64.select	$push165=, $69, $pop164, $51
	i64.or  	$push154=, $118, $119
	i64.select	$push156=, $70, $pop154, $120
	i64.select	$push157=, $94, $2, $pop156
	i64.select	$push159=, $87, $121, $51
	i64.or  	$push160=, $pop157, $pop159
	i64.or  	$push148=, $115, $116
	i64.select	$push150=, $67, $pop148, $117
	i64.select	$push151=, $109, $6, $pop150
	i64.select	$push161=, $72, $pop160, $pop151
	i64.select	$push162=, $94, $2, $pop161
	i64.or  	$push166=, $pop165, $pop162
	i64.select	$push168=, $53, $123, $51
	i64.select	$push169=, $56, $pop168, $51
	i64.select	$push170=, $73, $pop166, $pop169
	i64.select	$push171=, $66, $10, $pop170
	i64.store	$discard=, 0($pop326), $pop171
	i32.const	$push327=, 64
	i32.add 	$push328=, $0, $pop327
	i64.select	$push139=, $62, $114, $51
	i64.select	$push140=, $69, $pop139, $51
	i64.or  	$push132=, $110, $111
	i64.select	$push133=, $70, $pop132, $112
	i64.select	$push134=, $94, $1, $pop133
	i64.select	$push135=, $87, $113, $51
	i64.or  	$push136=, $pop134, $pop135
	i64.or  	$push129=, $106, $107
	i64.select	$push130=, $67, $pop129, $108
	i64.select	$push131=, $109, $5, $pop130
	i64.select	$push137=, $72, $pop136, $pop131
	i64.select	$push138=, $94, $1, $pop137
	i64.or  	$push141=, $pop140, $pop138
	i64.select	$push142=, $53, $45, $51
	i64.select	$push143=, $56, $pop142, $51
	i64.select	$push144=, $73, $pop141, $pop143
	i64.select	$push145=, $66, $9, $pop144
	i64.store	$discard=, 0($pop328), $pop145
	i32.const	$push329=, 88
	i32.add 	$push330=, $0, $pop329
	i64.or  	$push101=, $47, $48
	i64.select	$push103=, $62, $pop101, $97
	i64.select	$push104=, $66, $12, $pop103
	i64.select	$push105=, $69, $pop104, $51
	i64.select	$push113=, $70, $101, $51
	i64.or  	$push108=, $98, $99
	i64.select	$push110=, $87, $pop108, $100
	i64.select	$push111=, $91, $8, $pop110
	i64.or  	$push114=, $pop113, $pop111
	i64.select	$push116=, $67, $102, $51
	i64.select	$push117=, $72, $pop114, $pop116
	i64.select	$push118=, $94, $4, $pop117
	i64.or  	$push119=, $pop105, $pop118
	i64.or  	$push122=, $104, $103
	i64.select	$push124=, $53, $pop122, $105
	i64.select	$push125=, $54, $4, $pop124
	i64.select	$push126=, $56, $pop125, $51
	i64.select	$push127=, $73, $pop119, $pop126
	i64.select	$push128=, $66, $12, $pop127
	i64.store	$discard=, 0($pop330), $pop128
	i32.const	$push331=, 80
	i32.add 	$push332=, $0, $pop331
	i64.or  	$push80=, $84, $85
	i64.select	$push81=, $62, $pop80, $86
	i64.select	$push82=, $66, $11, $pop81
	i64.select	$push83=, $69, $pop82, $51
	i64.select	$push87=, $70, $92, $51
	i64.or  	$push84=, $88, $89
	i64.select	$push85=, $87, $pop84, $90
	i64.select	$push86=, $91, $7, $pop85
	i64.or  	$push88=, $pop87, $pop86
	i64.select	$push89=, $67, $93, $51
	i64.select	$push90=, $72, $pop88, $pop89
	i64.select	$push91=, $94, $3, $pop90
	i64.or  	$push92=, $pop83, $pop91
	i64.or  	$push93=, $96, $95
	i64.select	$push94=, $53, $pop93, $42
	i64.select	$push95=, $54, $3, $pop94
	i64.select	$push96=, $56, $pop95, $51
	i64.select	$push97=, $73, $pop92, $pop96
	i64.select	$push98=, $66, $11, $pop97
	i64.store	$discard=, 0($pop332), $pop98
	i32.const	$183=, 1024
	i32.add 	$279=, $279, $183
	i32.const	$183=, __stack_pointer
	i32.store	$279=, 0($183), $279
	return
func_end5:
	.size	bigshift, func_end5-bigshift


	.section	".note.GNU-stack","",@progbits
