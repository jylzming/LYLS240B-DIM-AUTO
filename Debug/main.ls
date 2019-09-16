   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.4 - 19 Dec 2007
3213                     	bsct
3214  0000               _brightness:
3215  0000 2b            	dc.b	43
3216  0001               _read_Flash:
3217  0001 00            	dc.b	0
3218  0002 000000000000  	ds.b	10
3219  000c               _second:
3220  000c 0000          	dc.w	0
3221  000e               _night_Time:
3222  000e a8c0          	dc.w	-22336
3223  0010               _relayStat:
3224  0010 00            	dc.b	0
3225  0011               _isDimmingConfiged:
3226  0011 00            	dc.b	0
3227  0012               _timeChanged:
3228  0012 00            	dc.b	0
3229  0013               L3712_ex_state:
3230  0013 00            	dc.b	0
3343                     ; 32 void DimmingMode(Mode mode)
3343                     ; 33 {
3345                     	switch	.text
3346  0000               _DimmingMode:
3348  0000 88            	push	a
3349  0001 5204          	subw	sp,#4
3350       00000004      OFST:	set	4
3353                     ; 34 	if(LIGHT == ON)
3355                     	btst	_PC_ODR_5
3356  0008 2403          	jruge	L64
3357  000a cc01a8        	jp	L1232
3358  000d               L64:
3359                     ; 36 		switch (mode)
3361  000d 7b05          	ld	a,(OFST+1,sp)
3363                     ; 64 			default:	break;
3364  000f 4d            	tnz	a
3365  0010 270b          	jreq	L5712
3366  0012 a002          	sub	a,#2
3367  0014 2603          	jrne	L05
3368  0016 cc00e2        	jp	L7712
3369  0019               L05:
3370  0019 aca801a8      	jpf	L1232
3371  001d               L5712:
3372                     ; 38 			case MODE0:
3372                     ; 39 				if((second >= 0) && (second < 0.4*night_Time))//50% Night Time, about 6 hours
3374  001d 9c            	rvf
3375  001e be0c          	ldw	x,_second
3376  0020 cd0000        	call	c_uitof
3378  0023 96            	ldw	x,sp
3379  0024 1c0001        	addw	x,#OFST-3
3380  0027 cd0000        	call	c_rtol
3382  002a be0e          	ldw	x,_night_Time
3383  002c cd0000        	call	c_uitof
3385  002f ae0018        	ldw	x,#L5332
3386  0032 cd0000        	call	c_fmul
3388  0035 96            	ldw	x,sp
3389  0036 1c0001        	addw	x,#OFST-3
3390  0039 cd0000        	call	c_fcmp
3392  003c 2d08          	jrsle	L7232
3393                     ; 40 					state = STATE1;
3395  003e 35010000      	mov	_state,#1
3397  0042 aca801a8      	jpf	L1232
3398  0046               L7232:
3399                     ; 41 				else if((second >= 0.4*night_Time) && (second < 0.6*night_Time))//35% Night Time, about 4 hours
3401  0046 9c            	rvf
3402  0047 be0c          	ldw	x,_second
3403  0049 cd0000        	call	c_uitof
3405  004c 96            	ldw	x,sp
3406  004d 1c0001        	addw	x,#OFST-3
3407  0050 cd0000        	call	c_rtol
3409  0053 be0e          	ldw	x,_night_Time
3410  0055 cd0000        	call	c_uitof
3412  0058 ae0018        	ldw	x,#L5332
3413  005b cd0000        	call	c_fmul
3415  005e 96            	ldw	x,sp
3416  005f 1c0001        	addw	x,#OFST-3
3417  0062 cd0000        	call	c_fcmp
3419  0065 2c29          	jrsgt	L3432
3421  0067 9c            	rvf
3422  0068 be0c          	ldw	x,_second
3423  006a cd0000        	call	c_uitof
3425  006d 96            	ldw	x,sp
3426  006e 1c0001        	addw	x,#OFST-3
3427  0071 cd0000        	call	c_rtol
3429  0074 be0e          	ldw	x,_night_Time
3430  0076 cd0000        	call	c_uitof
3432  0079 ae0014        	ldw	x,#L1532
3433  007c cd0000        	call	c_fmul
3435  007f 96            	ldw	x,sp
3436  0080 1c0001        	addw	x,#OFST-3
3437  0083 cd0000        	call	c_fcmp
3439  0086 2d08          	jrsle	L3432
3440                     ; 42 					state = STATE2;
3442  0088 35020000      	mov	_state,#2
3444  008c aca801a8      	jpf	L1232
3445  0090               L3432:
3446                     ; 43 				else if((second >= 0.6*night_Time) && (second < 0.8*night_Time)) //15% Night Time, about 2 hours
3448  0090 9c            	rvf
3449  0091 be0c          	ldw	x,_second
3450  0093 cd0000        	call	c_uitof
3452  0096 96            	ldw	x,sp
3453  0097 1c0001        	addw	x,#OFST-3
3454  009a cd0000        	call	c_rtol
3456  009d be0e          	ldw	x,_night_Time
3457  009f cd0000        	call	c_uitof
3459  00a2 ae0014        	ldw	x,#L1532
3460  00a5 cd0000        	call	c_fmul
3462  00a8 96            	ldw	x,sp
3463  00a9 1c0001        	addw	x,#OFST-3
3464  00ac cd0000        	call	c_fcmp
3466  00af 2c29          	jrsgt	L7532
3468  00b1 9c            	rvf
3469  00b2 be0c          	ldw	x,_second
3470  00b4 cd0000        	call	c_uitof
3472  00b7 96            	ldw	x,sp
3473  00b8 1c0001        	addw	x,#OFST-3
3474  00bb cd0000        	call	c_rtol
3476  00be be0e          	ldw	x,_night_Time
3477  00c0 cd0000        	call	c_uitof
3479  00c3 ae0010        	ldw	x,#L5632
3480  00c6 cd0000        	call	c_fmul
3482  00c9 96            	ldw	x,sp
3483  00ca 1c0001        	addw	x,#OFST-3
3484  00cd cd0000        	call	c_fcmp
3486  00d0 2d08          	jrsle	L7532
3487                     ; 44 					state = STATE3;
3489  00d2 35030000      	mov	_state,#3
3491  00d6 aca801a8      	jpf	L1232
3492  00da               L7532:
3493                     ; 46 					state = STATE4;
3495  00da 35040000      	mov	_state,#4
3496  00de aca801a8      	jpf	L1232
3497  00e2               L7712:
3498                     ; 49 			case MODE2:
3498                     ; 50 				if(second >= 0 && second < RX_Buf[0])
3500  00e2 b600          	ld	a,_RX_Buf
3501  00e4 5f            	clrw	x
3502  00e5 97            	ld	xl,a
3503  00e6 bf00          	ldw	c_x,x
3504  00e8 be0c          	ldw	x,_second
3505  00ea b300          	cpw	x,c_x
3506  00ec 2408          	jruge	L3732
3507                     ; 51 					state = STATE1;
3509  00ee 35010000      	mov	_state,#1
3511  00f2 aca801a8      	jpf	L1232
3512  00f6               L3732:
3513                     ; 52 				else if(second>=read_Flash[0] && second<(read_Flash[0]+read_Flash[2]))
3515  00f6 b601          	ld	a,_read_Flash
3516  00f8 5f            	clrw	x
3517  00f9 97            	ld	xl,a
3518  00fa bf00          	ldw	c_x,x
3519  00fc be0c          	ldw	x,_second
3520  00fe b300          	cpw	x,c_x
3521  0100 2515          	jrult	L7732
3523  0102 b601          	ld	a,_read_Flash
3524  0104 5f            	clrw	x
3525  0105 bb03          	add	a,_read_Flash+2
3526  0107 2401          	jrnc	L6
3527  0109 5c            	incw	x
3528  010a               L6:
3529  010a 02            	rlwa	x,a
3530  010b b30c          	cpw	x,_second
3531  010d 2308          	jrule	L7732
3532                     ; 53 					state = STATE2;
3534  010f 35020000      	mov	_state,#2
3536  0113 aca801a8      	jpf	L1232
3537  0117               L7732:
3538                     ; 54 				else if(second>=(read_Flash[0]+read_Flash[2]) && second<(read_Flash[0]+read_Flash[2]+read_Flash[4]))
3540  0117 b601          	ld	a,_read_Flash
3541  0119 5f            	clrw	x
3542  011a bb03          	add	a,_read_Flash+2
3543  011c 2401          	jrnc	L01
3544  011e 5c            	incw	x
3545  011f               L01:
3546  011f 02            	rlwa	x,a
3547  0120 b30c          	cpw	x,_second
3548  0122 2218          	jrugt	L3042
3550  0124 b601          	ld	a,_read_Flash
3551  0126 5f            	clrw	x
3552  0127 bb03          	add	a,_read_Flash+2
3553  0129 2401          	jrnc	L21
3554  012b 5c            	incw	x
3555  012c               L21:
3556  012c bb05          	add	a,_read_Flash+4
3557  012e 2401          	jrnc	L41
3558  0130 5c            	incw	x
3559  0131               L41:
3560  0131 02            	rlwa	x,a
3561  0132 b30c          	cpw	x,_second
3562  0134 2306          	jrule	L3042
3563                     ; 55 					state = STATE3;					
3565  0136 35030000      	mov	_state,#3
3567  013a 206c          	jra	L1232
3568  013c               L3042:
3569                     ; 56 				else if(second>=(read_Flash[0]+read_Flash[2]+read_Flash[4]) && second<(read_Flash[0]+read_Flash[2]+read_Flash[4]+read_Flash[6]))
3571  013c b601          	ld	a,_read_Flash
3572  013e 5f            	clrw	x
3573  013f bb03          	add	a,_read_Flash+2
3574  0141 2401          	jrnc	L61
3575  0143 5c            	incw	x
3576  0144               L61:
3577  0144 bb05          	add	a,_read_Flash+4
3578  0146 2401          	jrnc	L02
3579  0148 5c            	incw	x
3580  0149               L02:
3581  0149 02            	rlwa	x,a
3582  014a b30c          	cpw	x,_second
3583  014c 221d          	jrugt	L7042
3585  014e b601          	ld	a,_read_Flash
3586  0150 5f            	clrw	x
3587  0151 bb03          	add	a,_read_Flash+2
3588  0153 2401          	jrnc	L22
3589  0155 5c            	incw	x
3590  0156               L22:
3591  0156 bb05          	add	a,_read_Flash+4
3592  0158 2401          	jrnc	L42
3593  015a 5c            	incw	x
3594  015b               L42:
3595  015b bb07          	add	a,_read_Flash+6
3596  015d 2401          	jrnc	L62
3597  015f 5c            	incw	x
3598  0160               L62:
3599  0160 02            	rlwa	x,a
3600  0161 b30c          	cpw	x,_second
3601  0163 2306          	jrule	L7042
3602                     ; 57 					state = STATE4;
3604  0165 35040000      	mov	_state,#4
3606  0169 203d          	jra	L1232
3607  016b               L7042:
3608                     ; 58 				else if(second>=(read_Flash[0]+read_Flash[2]+read_Flash[4]+read_Flash[6]) && second<(read_Flash[0]+read_Flash[2]+read_Flash[4]+read_Flash[6]+read_Flash[8]))
3610  016b b601          	ld	a,_read_Flash
3611  016d 5f            	clrw	x
3612  016e bb03          	add	a,_read_Flash+2
3613  0170 2401          	jrnc	L03
3614  0172 5c            	incw	x
3615  0173               L03:
3616  0173 bb05          	add	a,_read_Flash+4
3617  0175 2401          	jrnc	L23
3618  0177 5c            	incw	x
3619  0178               L23:
3620  0178 bb07          	add	a,_read_Flash+6
3621  017a 2401          	jrnc	L43
3622  017c 5c            	incw	x
3623  017d               L43:
3624  017d 02            	rlwa	x,a
3625  017e b30c          	cpw	x,_second
3626  0180 2222          	jrugt	L3142
3628  0182 b601          	ld	a,_read_Flash
3629  0184 5f            	clrw	x
3630  0185 bb03          	add	a,_read_Flash+2
3631  0187 2401          	jrnc	L63
3632  0189 5c            	incw	x
3633  018a               L63:
3634  018a bb05          	add	a,_read_Flash+4
3635  018c 2401          	jrnc	L04
3636  018e 5c            	incw	x
3637  018f               L04:
3638  018f bb07          	add	a,_read_Flash+6
3639  0191 2401          	jrnc	L24
3640  0193 5c            	incw	x
3641  0194               L24:
3642  0194 bb09          	add	a,_read_Flash+8
3643  0196 2401          	jrnc	L44
3644  0198 5c            	incw	x
3645  0199               L44:
3646  0199 02            	rlwa	x,a
3647  019a b30c          	cpw	x,_second
3648  019c 2306          	jrule	L3142
3649                     ; 59 					state = STATE5;
3651  019e 35050000      	mov	_state,#5
3653  01a2 2004          	jra	L1232
3654  01a4               L3142:
3655                     ; 61 					state = STATE6;
3657  01a4 35060000      	mov	_state,#6
3658  01a8               L1022:
3659                     ; 64 			default:	break;
3661  01a8               L5232:
3662  01a8               L1232:
3663                     ; 68 	if(ex_state != state)
3665  01a8 b613          	ld	a,L3712_ex_state
3666  01aa b100          	cp	a,_state
3667  01ac 2603          	jrne	L25
3668  01ae cc02f7        	jp	L5442
3669  01b1               L25:
3670                     ; 70 		if(mode == MODE5)
3672  01b1 7b05          	ld	a,(OFST+1,sp)
3673  01b3 a105          	cp	a,#5
3674  01b5 2678          	jrne	L1242
3675                     ; 72 			switch (state)
3677  01b7 b600          	ld	a,_state
3679                     ; 80 				default: break;
3680  01b9 4d            	tnz	a
3681  01ba 2713          	jreq	L3022
3682  01bc 4a            	dec	a
3683  01bd 271d          	jreq	L5022
3684  01bf 4a            	dec	a
3685  01c0 2729          	jreq	L7022
3686  01c2 4a            	dec	a
3687  01c3 2735          	jreq	L1122
3688  01c5 4a            	dec	a
3689  01c6 2741          	jreq	L3122
3690  01c8 4a            	dec	a
3691  01c9 274d          	jreq	L5122
3692  01cb acf702f7      	jpf	L5442
3693  01cf               L3022:
3694                     ; 74 				case STATE0:	PWM_Config(100, 0);	break;//never run to STATE0
3696  01cf 5f            	clrw	x
3697  01d0 89            	pushw	x
3698  01d1 ae0064        	ldw	x,#100
3699  01d4 cd0000        	call	_PWM_Config
3701  01d7 85            	popw	x
3704  01d8 acf702f7      	jpf	L5442
3705  01dc               L5022:
3706                     ; 75 				case STATE1:	PWM_Config(100, 100);	break;
3708  01dc ae0064        	ldw	x,#100
3709  01df 89            	pushw	x
3710  01e0 ae0064        	ldw	x,#100
3711  01e3 cd0000        	call	_PWM_Config
3713  01e6 85            	popw	x
3716  01e7 acf702f7      	jpf	L5442
3717  01eb               L7022:
3718                     ; 76 				case STATE2:	PWM_Config(100, 75);	break;			
3720  01eb ae004b        	ldw	x,#75
3721  01ee 89            	pushw	x
3722  01ef ae0064        	ldw	x,#100
3723  01f2 cd0000        	call	_PWM_Config
3725  01f5 85            	popw	x
3728  01f6 acf702f7      	jpf	L5442
3729  01fa               L1122:
3730                     ; 77 				case STATE3:	PWM_Config(100, 50);	break;
3732  01fa ae0032        	ldw	x,#50
3733  01fd 89            	pushw	x
3734  01fe ae0064        	ldw	x,#100
3735  0201 cd0000        	call	_PWM_Config
3737  0204 85            	popw	x
3740  0205 acf702f7      	jpf	L5442
3741  0209               L3122:
3742                     ; 78 				case STATE4:	PWM_Config(100, 60);	break;
3744  0209 ae003c        	ldw	x,#60
3745  020c 89            	pushw	x
3746  020d ae0064        	ldw	x,#100
3747  0210 cd0000        	call	_PWM_Config
3749  0213 85            	popw	x
3752  0214 acf702f7      	jpf	L5442
3753  0218               L5122:
3754                     ; 79 				case STATE5:	PWM_Config(100, 60);	break;
3756  0218 ae003c        	ldw	x,#60
3757  021b 89            	pushw	x
3758  021c ae0064        	ldw	x,#100
3759  021f cd0000        	call	_PWM_Config
3761  0222 85            	popw	x
3764  0223 acf702f7      	jpf	L5442
3765  0227               L7122:
3766                     ; 80 				default: break;
3768  0227 acf702f7      	jpf	L5442
3769  022b               L5242:
3771  022b acf702f7      	jpf	L5442
3772  022f               L1242:
3773                     ; 83 		else if(mode == MODE2)
3775  022f 7b05          	ld	a,(OFST+1,sp)
3776  0231 a102          	cp	a,#2
3777  0233 2703cc02b6    	jrne	L1342
3778                     ; 85 			switch (state)
3780  0238 b600          	ld	a,_state
3782                     ; 94 				default: break;
3783  023a 4d            	tnz	a
3784  023b 2716          	jreq	L1222
3785  023d 4a            	dec	a
3786  023e 2720          	jreq	L3222
3787  0240 4a            	dec	a
3788  0241 272c          	jreq	L5222
3789  0243 4a            	dec	a
3790  0244 2737          	jreq	L7222
3791  0246 4a            	dec	a
3792  0247 2742          	jreq	L1322
3793  0249 4a            	dec	a
3794  024a 274d          	jreq	L3322
3795  024c 4a            	dec	a
3796  024d 2758          	jreq	L5322
3797  024f acf702f7      	jpf	L5442
3798  0253               L1222:
3799                     ; 87 				case STATE0:	PWM_Config(100, 0);	break;//never run to STATE0
3801  0253 5f            	clrw	x
3802  0254 89            	pushw	x
3803  0255 ae0064        	ldw	x,#100
3804  0258 cd0000        	call	_PWM_Config
3806  025b 85            	popw	x
3809  025c acf702f7      	jpf	L5442
3810  0260               L3222:
3811                     ; 88 				case STATE1:	PWM_Config(100, read_Flash[1]);	break;
3813  0260 b602          	ld	a,_read_Flash+1
3814  0262 5f            	clrw	x
3815  0263 97            	ld	xl,a
3816  0264 89            	pushw	x
3817  0265 ae0064        	ldw	x,#100
3818  0268 cd0000        	call	_PWM_Config
3820  026b 85            	popw	x
3823  026c cc02f7        	jra	L5442
3824  026f               L5222:
3825                     ; 89 				case STATE2:	PWM_Config(100, read_Flash[3]);	break;			
3827  026f b604          	ld	a,_read_Flash+3
3828  0271 5f            	clrw	x
3829  0272 97            	ld	xl,a
3830  0273 89            	pushw	x
3831  0274 ae0064        	ldw	x,#100
3832  0277 cd0000        	call	_PWM_Config
3834  027a 85            	popw	x
3837  027b 207a          	jra	L5442
3838  027d               L7222:
3839                     ; 90 				case STATE3:	PWM_Config(100, read_Flash[5]);	break;
3841  027d b606          	ld	a,_read_Flash+5
3842  027f 5f            	clrw	x
3843  0280 97            	ld	xl,a
3844  0281 89            	pushw	x
3845  0282 ae0064        	ldw	x,#100
3846  0285 cd0000        	call	_PWM_Config
3848  0288 85            	popw	x
3851  0289 206c          	jra	L5442
3852  028b               L1322:
3853                     ; 91 				case STATE4:	PWM_Config(100, read_Flash[7]);	break;
3855  028b b608          	ld	a,_read_Flash+7
3856  028d 5f            	clrw	x
3857  028e 97            	ld	xl,a
3858  028f 89            	pushw	x
3859  0290 ae0064        	ldw	x,#100
3860  0293 cd0000        	call	_PWM_Config
3862  0296 85            	popw	x
3865  0297 205e          	jra	L5442
3866  0299               L3322:
3867                     ; 92 				case STATE5:	PWM_Config(100, read_Flash[9]);	break;			
3869  0299 b60a          	ld	a,_read_Flash+9
3870  029b 5f            	clrw	x
3871  029c 97            	ld	xl,a
3872  029d 89            	pushw	x
3873  029e ae0064        	ldw	x,#100
3874  02a1 cd0000        	call	_PWM_Config
3876  02a4 85            	popw	x
3879  02a5 2050          	jra	L5442
3880  02a7               L5322:
3881                     ; 93 				case STATE6:	PWM_Config(100, 0);	break;
3883  02a7 5f            	clrw	x
3884  02a8 89            	pushw	x
3885  02a9 ae0064        	ldw	x,#100
3886  02ac cd0000        	call	_PWM_Config
3888  02af 85            	popw	x
3891  02b0 2045          	jra	L5442
3892  02b2               L7322:
3893                     ; 94 				default: break;
3895  02b2 2043          	jra	L5442
3896  02b4               L5342:
3898  02b4 2041          	jra	L5442
3899  02b6               L1342:
3900                     ; 99 			switch (state)
3902  02b6 b600          	ld	a,_state
3904                     ; 105 				default: break;
3905  02b8 4d            	tnz	a
3906  02b9 270b          	jreq	L1422
3907  02bb 4a            	dec	a
3908  02bc 2713          	jreq	L3422
3909  02be 4a            	dec	a
3910  02bf 271d          	jreq	L5422
3911  02c1 4a            	dec	a
3912  02c2 2728          	jreq	L7422
3913  02c4 2031          	jra	L5442
3914  02c6               L1422:
3915                     ; 101 				case STATE0:	PWM_Config(100, 0);	break;//never run to STATE0
3917  02c6 5f            	clrw	x
3918  02c7 89            	pushw	x
3919  02c8 ae0064        	ldw	x,#100
3920  02cb cd0000        	call	_PWM_Config
3922  02ce 85            	popw	x
3925  02cf 2026          	jra	L5442
3926  02d1               L3422:
3927                     ; 102 				case STATE1:	PWM_Config(100, 100);	break;
3929  02d1 ae0064        	ldw	x,#100
3930  02d4 89            	pushw	x
3931  02d5 ae0064        	ldw	x,#100
3932  02d8 cd0000        	call	_PWM_Config
3934  02db 85            	popw	x
3937  02dc 2019          	jra	L5442
3938  02de               L5422:
3939                     ; 103 				case STATE2:	PWM_Config(100, brightness);	break;			
3941  02de b600          	ld	a,_brightness
3942  02e0 5f            	clrw	x
3943  02e1 97            	ld	xl,a
3944  02e2 89            	pushw	x
3945  02e3 ae0064        	ldw	x,#100
3946  02e6 cd0000        	call	_PWM_Config
3948  02e9 85            	popw	x
3951  02ea 200b          	jra	L5442
3952  02ec               L7422:
3953                     ; 104 				case STATE3:	PWM_Config(100, 80);	break;			
3955  02ec ae0050        	ldw	x,#80
3956  02ef 89            	pushw	x
3957  02f0 ae0064        	ldw	x,#100
3958  02f3 cd0000        	call	_PWM_Config
3960  02f6 85            	popw	x
3963  02f7               L1522:
3964                     ; 105 				default: break;
3966  02f7               L3442:
3967  02f7               L5442:
3968                     ; 109 	ex_state = state;
3970  02f7 450013        	mov	L3712_ex_state,_state
3971                     ; 110 }
3974  02fa 5b05          	addw	sp,#5
3975  02fc 81            	ret
3978                     	bsct
3979  0014               L7442_adcCount:
3980  0014 00            	dc.b	0
3981  0015               L1542_adcData:
3982  0015 0000          	dc.w	0
3983  0017 000000000000  	ds.b	6
4132                     .const:	section	.text
4133  0000               L65:
4134  0000 00005460      	dc.l	21600
4135  0004               L06:
4136  0004 0000fd21      	dc.l	64801
4137  0008               L26:
4138  0008 0000000a      	dc.l	10
4139                     ; 113 main()
4139                     ; 114 {
4140                     	switch	.text
4141  02fd               _main:
4143  02fd 520a          	subw	sp,#10
4144       0000000a      OFST:	set	10
4147                     ; 115 	volatile unsigned char i = 0;
4149  02ff 0f0a          	clr	(OFST+0,sp)
4150                     ; 117 	volatile unsigned char offCount = 0;
4152  0301 0f02          	clr	(OFST-8,sp)
4153                     ; 118 	volatile unsigned char onCount = 0;
4155  0303 0f03          	clr	(OFST-7,sp)
4156                     ; 120 	volatile unsigned long int temp = 0;
4158  0305 ae0000        	ldw	x,#0
4159  0308 1f08          	ldw	(OFST-2,sp),x
4160  030a ae0000        	ldw	x,#0
4161  030d 1f06          	ldw	(OFST-4,sp),x
4162                     ; 121 	volatile unsigned char index_on_time = 0;
4164  030f 0f04          	clr	(OFST-6,sp)
4165                     ; 122 	unsigned char threshold_count = ONOFF_TIME_DELAY*2;//on/off lux continues threshold
4167  0311 a604          	ld	a,#4
4168  0313 6b05          	ld	(OFST-5,sp),a
4169                     ; 124 	bool exRelayStat = OFF;
4171  0315 a601          	ld	a,#1
4172  0317 6b01          	ld	(OFST-9,sp),a
4173                     ; 127 	CLK_CKDIVR = 0x08;//f = f HSI RCÊä³ö/2=8MHz
4175  0319 350850c6      	mov	_CLK_CKDIVR,#8
4176                     ; 128 	TIM4_Init();//use for delay, high
4178  031d cd0000        	call	_TIM4_Init
4180                     ; 131 	for(i=0;i<10;i++)
4182  0320 0f0a          	clr	(OFST+0,sp)
4184  0322 205b          	jra	L5452
4185  0324               L1452:
4186                     ; 133 		temp = FLASH_ReadByte(0x4000+i);
4188  0324 7b0a          	ld	a,(OFST+0,sp)
4189  0326 5f            	clrw	x
4190  0327 97            	ld	xl,a
4191  0328 1c4000        	addw	x,#16384
4192  032b cd0000        	call	c_itolx
4194  032e be02          	ldw	x,c_lreg+2
4195  0330 89            	pushw	x
4196  0331 be00          	ldw	x,c_lreg
4197  0333 89            	pushw	x
4198  0334 cd0000        	call	_FLASH_ReadByte
4200  0337 5b04          	addw	sp,#4
4201  0339 6b09          	ld	(OFST-1,sp),a
4202  033b 4f            	clr	a
4203  033c 6b08          	ld	(OFST-2,sp),a
4204  033e 6b07          	ld	(OFST-3,sp),a
4205  0340 6b06          	ld	(OFST-4,sp),a
4206                     ; 134 		if((temp<TIME_LOWER_LIMIT)||(temp>TIME_UPPER_LIMIT))
4208  0342 96            	ldw	x,sp
4209  0343 1c0006        	addw	x,#OFST-4
4210  0346 cd0000        	call	c_ltor
4212  0349 ae0000        	ldw	x,#L65
4213  034c cd0000        	call	c_lcmp
4215  034f 250f          	jrult	L3552
4217  0351 96            	ldw	x,sp
4218  0352 1c0006        	addw	x,#OFST-4
4219  0355 cd0000        	call	c_ltor
4221  0358 ae0004        	ldw	x,#L06
4222  035b cd0000        	call	c_lcmp
4224  035e 251d          	jrult	L1552
4225  0360               L3552:
4226                     ; 136 			UnlockEEPROM();
4228  0360 cd0000        	call	_UnlockEEPROM
4230                     ; 137 			FLASH_ProgramByte(0x4000+i, DEFAULT_TIME);
4232  0363 4bc0          	push	#192
4233  0365 7b0b          	ld	a,(OFST+1,sp)
4234  0367 5f            	clrw	x
4235  0368 97            	ld	xl,a
4236  0369 1c4000        	addw	x,#16384
4237  036c cd0000        	call	c_itolx
4239  036f be02          	ldw	x,c_lreg+2
4240  0371 89            	pushw	x
4241  0372 be00          	ldw	x,c_lreg
4242  0374 89            	pushw	x
4243  0375 cd0000        	call	_FLASH_ProgramByte
4245  0378 5b05          	addw	sp,#5
4246                     ; 138 			LockEEPROM();
4248  037a cd0000        	call	_LockEEPROM
4250  037d               L1552:
4251                     ; 131 	for(i=0;i<10;i++)
4253  037d 0c0a          	inc	(OFST+0,sp)
4254  037f               L5452:
4257  037f 7b0a          	ld	a,(OFST+0,sp)
4258  0381 a10a          	cp	a,#10
4259  0383 259f          	jrult	L1452
4260                     ; 141 	index_on_time = FLASH_ReadByte(0x400A);
4262  0385 ae400a        	ldw	x,#16394
4263  0388 89            	pushw	x
4264  0389 ae0000        	ldw	x,#0
4265  038c 89            	pushw	x
4266  038d cd0000        	call	_FLASH_ReadByte
4268  0390 5b04          	addw	sp,#4
4269  0392 6b04          	ld	(OFST-6,sp),a
4270                     ; 142 	index_on_time %= 10;//in case index_on_time lager than 9
4272  0394 7b04          	ld	a,(OFST-6,sp)
4273  0396 ae000a        	ldw	x,#10
4274  0399 51            	exgw	x,y
4275  039a 5f            	clrw	x
4276  039b 97            	ld	xl,a
4277  039c 65            	divw	x,y
4278  039d 909f          	ld	a,yl
4279  039f 6b04          	ld	(OFST-6,sp),a
4280                     ; 145 	for(i=0;i<10;i++)
4282  03a1 0f0a          	clr	(OFST+0,sp)
4284  03a3 2020          	jra	L1652
4285  03a5               L5552:
4286                     ; 147 		temp += FLASH_ReadByte(0x4000+i);
4288  03a5 7b0a          	ld	a,(OFST+0,sp)
4289  03a7 5f            	clrw	x
4290  03a8 97            	ld	xl,a
4291  03a9 1c4000        	addw	x,#16384
4292  03ac cd0000        	call	c_itolx
4294  03af be02          	ldw	x,c_lreg+2
4295  03b1 89            	pushw	x
4296  03b2 be00          	ldw	x,c_lreg
4297  03b4 89            	pushw	x
4298  03b5 cd0000        	call	_FLASH_ReadByte
4300  03b8 5b04          	addw	sp,#4
4301  03ba 96            	ldw	x,sp
4302  03bb 1c0006        	addw	x,#OFST-4
4303  03be 88            	push	a
4304  03bf cd0000        	call	c_lgadc
4306  03c2 84            	pop	a
4307                     ; 145 	for(i=0;i<10;i++)
4309  03c3 0c0a          	inc	(OFST+0,sp)
4310  03c5               L1652:
4313  03c5 7b0a          	ld	a,(OFST+0,sp)
4314  03c7 a10a          	cp	a,#10
4315  03c9 25da          	jrult	L5552
4316                     ; 149 	night_Time = temp / 10;
4318  03cb 96            	ldw	x,sp
4319  03cc 1c0006        	addw	x,#OFST-4
4320  03cf cd0000        	call	c_ltor
4322  03d2 ae0008        	ldw	x,#L26
4323  03d5 cd0000        	call	c_ludv
4325  03d8 be02          	ldw	x,c_lreg+2
4326  03da bf0e          	ldw	_night_Time,x
4327                     ; 152 	Delay1s(); Delay1s(); //Delay1s(); Delay1s(); Delay1s(); //about 5s
4329  03dc cd0000        	call	_Delay1s
4333  03df cd0000        	call	_Delay1s
4335                     ; 154 	PWM_GPIO_Config();//Dimming IO config, use TIM2
4337  03e2 cd0000        	call	_PWM_GPIO_Config
4339                     ; 156 	InitADC();	
4341  03e5 cd0000        	call	_InitADC
4343                     ; 157 	for(i=0;i<threshold_count;i++)
4345  03e8 0f0a          	clr	(OFST+0,sp)
4347  03ea 2010          	jra	L1752
4348  03ec               L5652:
4349                     ; 158 		adcData[i] = GetADC();
4351  03ec cd0000        	call	_GetADC
4353  03ef 7b0a          	ld	a,(OFST+0,sp)
4354  03f1 905f          	clrw	y
4355  03f3 9097          	ld	yl,a
4356  03f5 9058          	sllw	y
4357  03f7 90ef15        	ldw	(L1542_adcData,y),x
4358                     ; 157 	for(i=0;i<threshold_count;i++)
4360  03fa 0c0a          	inc	(OFST+0,sp)
4361  03fc               L1752:
4364  03fc 7b0a          	ld	a,(OFST+0,sp)
4365  03fe 1105          	cp	a,(OFST-5,sp)
4366  0400 25ea          	jrult	L5652
4367                     ; 160 	Rly_GPIO_Config();
4369  0402 cd0000        	call	_Rly_GPIO_Config
4371                     ; 162 	if(adcData[0] < OFF_LUX)//initial LIGHT IO
4373  0405 be15          	ldw	x,L1542_adcData
4374  0407 a31162        	cpw	x,#4450
4375  040a 240f          	jruge	L5752
4376                     ; 164 		LIGHT = OFF;
4378  040c 721a500a      	bset	_PC_ODR_5
4379                     ; 165 		PWM_Config(100, 0);//PWM off
4381  0410 5f            	clrw	x
4382  0411 89            	pushw	x
4383  0412 ae0064        	ldw	x,#100
4384  0415 cd0000        	call	_PWM_Config
4386  0418 85            	popw	x
4388  0419 200f          	jra	L7752
4389  041b               L5752:
4390                     ; 169 		LIGHT = ON;
4392  041b 721b500a      	bres	_PC_ODR_5
4393                     ; 170 		PWM_Config(100, 100);//PWM off
4395  041f ae0064        	ldw	x,#100
4396  0422 89            	pushw	x
4397  0423 ae0064        	ldw	x,#100
4398  0426 cd0000        	call	_PWM_Config
4400  0429 85            	popw	x
4401  042a               L7752:
4402                     ; 174 	TIM1_Init();
4404  042a cd0000        	call	_TIM1_Init
4406                     ; 175 	_asm("rim"); //Enable interrupt
4409  042d 9a            rim
4411  042e               L1062:
4412                     ; 179 		adcData[adcCount++] = GetADC();
4414  042e cd0000        	call	_GetADC
4416  0431 b614          	ld	a,L7442_adcCount
4417  0433 9097          	ld	yl,a
4418  0435 3c14          	inc	L7442_adcCount
4419  0437 909f          	ld	a,yl
4420  0439 905f          	clrw	y
4421  043b 9097          	ld	yl,a
4422  043d 9058          	sllw	y
4423  043f 90ef15        	ldw	(L1542_adcData,y),x
4424                     ; 180 		if(adcCount >= threshold_count)	
4426  0442 b614          	ld	a,L7442_adcCount
4427  0444 1105          	cp	a,(OFST-5,sp)
4428  0446 2502          	jrult	L5062
4429                     ; 181 			adcCount = 0;
4431  0448 3f14          	clr	L7442_adcCount
4432  044a               L5062:
4433                     ; 182 		for(i=0;i<threshold_count;i++)
4435  044a 0f0a          	clr	(OFST+0,sp)
4437  044c 2028          	jra	L3162
4438  044e               L7062:
4439                     ; 184 			if(adcData[i] < OFF_LUX)
4441  044e 7b0a          	ld	a,(OFST+0,sp)
4442  0450 5f            	clrw	x
4443  0451 97            	ld	xl,a
4444  0452 58            	sllw	x
4445  0453 9093          	ldw	y,x
4446  0455 90ee15        	ldw	y,(L1542_adcData,y)
4447  0458 90a31162      	cpw	y,#4450
4448  045c 2404          	jruge	L7162
4449                     ; 185 				offCount += 1;
4451  045e 0c02          	inc	(OFST-8,sp)
4453  0460 2012          	jra	L1262
4454  0462               L7162:
4455                     ; 186 			else if(adcData[i] > ON_LUX)
4457  0462 7b0a          	ld	a,(OFST+0,sp)
4458  0464 5f            	clrw	x
4459  0465 97            	ld	xl,a
4460  0466 58            	sllw	x
4461  0467 9093          	ldw	y,x
4462  0469 90ee15        	ldw	y,(L1542_adcData,y)
4463  046c 90a3128f      	cpw	y,#4751
4464  0470 2502          	jrult	L1262
4465                     ; 187 				onCount += 1;
4467  0472 0c03          	inc	(OFST-7,sp)
4469  0474               L1262:
4470                     ; 182 		for(i=0;i<threshold_count;i++)
4472  0474 0c0a          	inc	(OFST+0,sp)
4473  0476               L3162:
4476  0476 7b0a          	ld	a,(OFST+0,sp)
4477  0478 1105          	cp	a,(OFST-5,sp)
4478  047a 25d2          	jrult	L7062
4479                     ; 192 		if(offCount >= threshold_count)
4481  047c 7b02          	ld	a,(OFST-8,sp)
4482  047e 1105          	cp	a,(OFST-5,sp)
4483  0480 2403          	jruge	L46
4484  0482 cc053d        	jp	L7262
4485  0485               L46:
4486                     ; 194 			if(LIGHT == ON)//only when light on/off change 
4488                     	btst	_PC_ODR_5
4489  048a 2403          	jruge	L66
4490  048c cc0530        	jp	L1362
4491  048f               L66:
4492                     ; 196 				LIGHT = OFF;//Relay_IO = 1
4494  048f 721a500a      	bset	_PC_ODR_5
4495                     ; 197 				PWM_Config(100, 0);//PWM off
4497  0493 5f            	clrw	x
4498  0494 89            	pushw	x
4499  0495 ae0064        	ldw	x,#100
4500  0498 cd0000        	call	_PWM_Config
4502  049b 85            	popw	x
4503                     ; 198 				TIM1_CR1 &= 0xFE;//stop time counter
4505  049c 72115250      	bres	_TIM1_CR1,#0
4506                     ; 201 				if((second >= TIME_LOWER_LIMIT) && (second <= TIME_UPPER_LIMIT))
4508  04a0 be0c          	ldw	x,_second
4509  04a2 a35460        	cpw	x,#21600
4510  04a5 2403          	jruge	L07
4511  04a7 cc0530        	jp	L1362
4512  04aa               L07:
4514  04aa 9c            	rvf
4515  04ab be0c          	ldw	x,_second
4516  04ad cd0000        	call	c_uitolx
4518  04b0 ae0004        	ldw	x,#L06
4519  04b3 cd0000        	call	c_lcmp
4521  04b6 2e78          	jrsge	L1362
4522                     ; 203 					UnlockEEPROM();
4524  04b8 cd0000        	call	_UnlockEEPROM
4526                     ; 204 					FLASH_ProgramByte(0x4000+index_on_time, second);
4528  04bb 3b000d        	push	_second+1
4529  04be 7b05          	ld	a,(OFST-5,sp)
4530  04c0 5f            	clrw	x
4531  04c1 97            	ld	xl,a
4532  04c2 1c4000        	addw	x,#16384
4533  04c5 cd0000        	call	c_itolx
4535  04c8 be02          	ldw	x,c_lreg+2
4536  04ca 89            	pushw	x
4537  04cb be00          	ldw	x,c_lreg
4538  04cd 89            	pushw	x
4539  04ce cd0000        	call	_FLASH_ProgramByte
4541  04d1 5b05          	addw	sp,#5
4542                     ; 205 					index_on_time++;
4544  04d3 0c04          	inc	(OFST-6,sp)
4545                     ; 206 					index_on_time %= 10;
4547  04d5 7b04          	ld	a,(OFST-6,sp)
4548  04d7 ae000a        	ldw	x,#10
4549  04da 51            	exgw	x,y
4550  04db 5f            	clrw	x
4551  04dc 97            	ld	xl,a
4552  04dd 65            	divw	x,y
4553  04de 909f          	ld	a,yl
4554  04e0 6b04          	ld	(OFST-6,sp),a
4555                     ; 207 					FLASH_ProgramByte(0x400A, index_on_time);
4557  04e2 7b04          	ld	a,(OFST-6,sp)
4558  04e4 88            	push	a
4559  04e5 ae400a        	ldw	x,#16394
4560  04e8 89            	pushw	x
4561  04e9 ae0000        	ldw	x,#0
4562  04ec 89            	pushw	x
4563  04ed cd0000        	call	_FLASH_ProgramByte
4565  04f0 5b05          	addw	sp,#5
4566                     ; 208 					for(i=0;i<10;i++)
4568  04f2 0f0a          	clr	(OFST+0,sp)
4570  04f4 2020          	jra	L1462
4571  04f6               L5362:
4572                     ; 210 						temp += FLASH_ReadByte(0x4000+i);
4574  04f6 7b0a          	ld	a,(OFST+0,sp)
4575  04f8 5f            	clrw	x
4576  04f9 97            	ld	xl,a
4577  04fa 1c4000        	addw	x,#16384
4578  04fd cd0000        	call	c_itolx
4580  0500 be02          	ldw	x,c_lreg+2
4581  0502 89            	pushw	x
4582  0503 be00          	ldw	x,c_lreg
4583  0505 89            	pushw	x
4584  0506 cd0000        	call	_FLASH_ReadByte
4586  0509 5b04          	addw	sp,#4
4587  050b 96            	ldw	x,sp
4588  050c 1c0006        	addw	x,#OFST-4
4589  050f 88            	push	a
4590  0510 cd0000        	call	c_lgadc
4592  0513 84            	pop	a
4593                     ; 208 					for(i=0;i<10;i++)
4595  0514 0c0a          	inc	(OFST+0,sp)
4596  0516               L1462:
4599  0516 7b0a          	ld	a,(OFST+0,sp)
4600  0518 a10a          	cp	a,#10
4601  051a 25da          	jrult	L5362
4602                     ; 212 					night_Time = temp / 10;
4604  051c 96            	ldw	x,sp
4605  051d 1c0006        	addw	x,#OFST-4
4606  0520 cd0000        	call	c_ltor
4608  0523 ae0008        	ldw	x,#L26
4609  0526 cd0000        	call	c_ludv
4611  0529 be02          	ldw	x,c_lreg+2
4612  052b bf0e          	ldw	_night_Time,x
4613                     ; 213 					LockEEPROM();
4615  052d cd0000        	call	_LockEEPROM
4617  0530               L1362:
4618                     ; 216 			if(state != STATE0)
4620  0530 3d00          	tnz	_state
4621  0532 2704          	jreq	L5462
4622                     ; 217 				ex_state = state = STATE0;
4624  0534 3f00          	clr	_state
4625  0536 3f13          	clr	L3712_ex_state
4626  0538               L5462:
4627                     ; 218 			second = 0;
4629  0538 5f            	clrw	x
4630  0539 bf0c          	ldw	_second,x
4632  053b 2032          	jra	L7462
4633  053d               L7262:
4634                     ; 222 		else if(onCount >= threshold_count)
4636  053d 7b03          	ld	a,(OFST-7,sp)
4637  053f 1105          	cp	a,(OFST-5,sp)
4638  0541 252c          	jrult	L7462
4639                     ; 224 			if(LIGHT == OFF)//only when light on/off change 
4641                     	btst	_PC_ODR_5
4642  0548 2404          	jruge	L3562
4643                     ; 226 				LIGHT = ON;//Relay_IO = 0
4645  054a 721b500a      	bres	_PC_ODR_5
4646  054e               L3562:
4647                     ; 228 			if((TIM1_CR1 & 0x01) == 0)//if time1 counter not started, start counting
4649  054e c65250        	ld	a,_TIM1_CR1
4650  0551 a501          	bcp	a,#1
4651  0553 260b          	jrne	L5562
4652                     ; 230 				second = 0;
4654  0555 5f            	clrw	x
4655  0556 bf0c          	ldw	_second,x
4656                     ; 232 				TIM1_CR1 |= 0x01;//start time counter
4658  0558 72105250      	bset	_TIM1_CR1,#0
4659                     ; 233 				TIM1_IER |= 0x01;				
4661  055c 72105254      	bset	_TIM1_IER,#0
4662  0560               L5562:
4663                     ; 235 			if(state == STATE0)
4665  0560 3d00          	tnz	_state
4666  0562 260b          	jrne	L7462
4667                     ; 237 				PWM_Config(100, 100);
4669  0564 ae0064        	ldw	x,#100
4670  0567 89            	pushw	x
4671  0568 ae0064        	ldw	x,#100
4672  056b cd0000        	call	_PWM_Config
4674  056e 85            	popw	x
4675  056f               L7462:
4676                     ; 242 		DimmingMode(userMode);		
4678  056f 4f            	clr	a
4679  0570 cd0000        	call	_DimmingMode
4681                     ; 243 		offCount = 0;
4683  0573 0f02          	clr	(OFST-8,sp)
4684                     ; 244 		onCount  = 0;
4686  0575 0f03          	clr	(OFST-7,sp)
4687                     ; 245 		Delay500ms();
4689  0577 cd0000        	call	_Delay500ms
4692  057a ac2e042e      	jpf	L1062
4730                     	switch	.const
4731  000c               L47:
4732  000c 0000fd20      	dc.l	64800
4733                     ; 250 @far @interrupt void TIM1_UPD_IRQHandler(void)
4733                     ; 251 {
4734                     	scross	on
4735                     	switch	.text
4736  057e               f_TIM1_UPD_IRQHandler:
4739       00000001      OFST:	set	1
4740  057e be02          	ldw	x,c_lreg+2
4741  0580 89            	pushw	x
4742  0581 be00          	ldw	x,c_lreg
4743  0583 89            	pushw	x
4744  0584 88            	push	a
4747                     ; 252 	unsigned char i = 0;
4749  0585 0f01          	clr	(OFST+0,sp)
4750                     ; 253 	TIM1_SR1 &= 0xFE;//clear interrupt label
4752  0587 72115255      	bres	_TIM1_SR1,#0
4753                     ; 254 	second++;
4755  058b be0c          	ldw	x,_second
4756  058d 1c0001        	addw	x,#1
4757  0590 bf0c          	ldw	_second,x
4758                     ; 255 	if(second >= TIME_UPPER_LIMIT)
4760  0592 9c            	rvf
4761  0593 be0c          	ldw	x,_second
4762  0595 cd0000        	call	c_uitolx
4764  0598 ae000c        	ldw	x,#L47
4765  059b cd0000        	call	c_lcmp
4767  059e 2f09          	jrslt	L1072
4768                     ; 257 		second = TIME_UPPER_LIMIT;
4770  05a0 aefd20        	ldw	x,#64800
4771  05a3 bf0c          	ldw	_second,x
4772                     ; 258 		TIM1_CR1 &= 0xFE;//stop time counter
4774  05a5 72115250      	bres	_TIM1_CR1,#0
4775  05a9               L1072:
4776                     ; 260 }
4779  05a9 84            	pop	a
4780  05aa 85            	popw	x
4781  05ab bf00          	ldw	c_lreg,x
4782  05ad 85            	popw	x
4783  05ae bf02          	ldw	c_lreg+2,x
4784  05b0 80            	iret
4940                     	xdef	f_TIM1_UPD_IRQHandler
4941                     	xdef	_main
4942                     	xdef	_DimmingMode
4943                     	switch	.ubsct
4944  0000               _state:
4945  0000 00            	ds.b	1
4946                     	xdef	_state
4947                     	xdef	_night_Time
4948                     	xdef	_read_Flash
4949                     	xref	_FLASH_ReadByte
4950                     	xref	_FLASH_ProgramByte
4951                     	xref	_LockEEPROM
4952                     	xref	_UnlockEEPROM
4953                     	xref.b	_RX_Buf
4954                     	xdef	_relayStat
4955                     	xdef	_timeChanged
4956                     	xdef	_isDimmingConfiged
4957                     	xdef	_brightness
4958                     	xdef	_second
4959                     	xref	_TIM4_Init
4960                     	xref	_TIM1_Init
4961                     	xref	_Delay1s
4962                     	xref	_Delay500ms
4963                     	xref	_GetADC
4964                     	xref	_InitADC
4965                     	xref	_PWM_GPIO_Config
4966                     	xref	_PWM_Config
4967                     	xref	_Rly_GPIO_Config
4968                     	switch	.const
4969  0010               L5632:
4970  0010 3f4ccccc      	dc.w	16204,-13108
4971  0014               L1532:
4972  0014 3f199999      	dc.w	16153,-26215
4973  0018               L5332:
4974  0018 3ecccccc      	dc.w	16076,-13108
4975                     	xref.b	c_lreg
4976                     	xref.b	c_x
4996                     	xref	c_uitolx
4997                     	xref	c_ludv
4998                     	xref	c_lgadc
4999                     	xref	c_lcmp
5000                     	xref	c_ltor
5001                     	xref	c_itolx
5002                     	xref	c_fcmp
5003                     	xref	c_rtol
5004                     	xref	c_fmul
5005                     	xref	c_uitof
5006                     	end
