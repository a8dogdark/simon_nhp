; GRABADOR SISTEMA NHP VER 3.6 CON SIMON
; CREADO POR PARCHE NEGRO 1992
; DESAMBLADO POR DOGDARK 2023
;
@LEN =  LEN+2
@LBAF = LEN+4
PPILA = LEN+5
PCRSR = $CB
ORG =   PCRSR
SVMSC = $58
POSXY = $54
LENGHT = $4000
BAFER = $4000
FR0 =   $D4
CIX =   $F2
AFP =   $D800
IFP =   $D9AA
FPI =   $D9D2
FASC =  $D8E6
ZFR0 =  $DA44
FDIV =  $DB28
FMUL =  $DADB
FMOVE = $DDB6
INBUFF = $F3
LBUFF = $0580
LLOAD = PAG7-LOAD
LVBLANK = LOADER-VBLANK
LAUTO = PAG4-PAG7
BL4 =   LAUTO/128
LAST =  LAUTO-128*BL4
;
    ORG $2000
    ICL 'kem2.asm'
RY
    .BYTE 0,0
LEN
    .BYTE 0,0,0,0,0,0
CONT
    .BYTE 0,0
STARTF
    .BYTE 0,0
FINISH
    .BYTE 0,0
@BL4
    .BYTE 0
?FILE
    .BYTE "D:"
??FILE
    .BYTE "                    "
BBLQS
    .BYTE "000",$9B
ALL
    .BYTE "D:*.*",$9B
DNHP
    .BYTE $60,$00,$50,$80
    .WORD ??DIR
    .BYTE $35,$00,$00,$01,$00,$80
BAKBYT
    .SB "00000"
BAKBLQ
    .SB "000"
TURBO
    .SB "TURBO"
FTURBO
    .BYTE $FF
TON
    .SB "ON "
RESTORE
    LDY #19
?RESTORE
    LDA #$20
    STA ??FILE,Y
    LDA #$00
    STA NAME,Y
    STA FILE,Y
    DEY 
    BPL ?RESTORE
    LDY #23
??RESTORE
    LDA #$00
    STA CRSR,Y
    DEY 
    BPL ??RESTORE
    LDY #34
???RESTORE
    LDA #$00
    STA FILE,Y
    DEY 
    BPL ???RESTORE
    LDA #63
    STA CRSR
    STA FILE
    LDA #$10
    LDY #$04
RESNUM
    STA BYTES,Y
    DEY 
    BPL RESNUM
    STA BLOQUES
    STA BLOQUES+1
    STA BLOQUES+2
    LDA #$FF
    STA $D301
    RTS 
ASCINT
    CMP #32
    BCC ADD64
    CMP #96
    BCC SUB32
    CMP #128
    BCC REMAIN
    CMP #160
    BCC ADD64
    CMP #224
    BCC SUB32
    BCS REMAIN
ADD64
    CLC 
    ADC #64
    BCC REMAIN
SUB32
    SEC 
    SBC #32
REMAIN
    RTS 
SETUR
    LDX #$04
LOSTR
    LDA TURBO,X
    CMP CRSR,X
    BNE EXSTUR
    DEX 
    BPL LOSTR
    LDA FTURBO
    EOR #$01
    STA FTURBO
    LDX #$02
LOMVTR
    LDA TON,X
    PHA 
    LDA TOF,X
    STA TON,X
    PLA 
    STA TOF,X
    DEX 
    BPL LOMVTR
    LDX #$00
    TXS 
    JMP START
EXSTUR
    RTS 
CLS
    LDX # <??DIR
    LDY # >??DIR
    STX PCRSR
    STY PCRSR+1
    LDY #$00
    LDX #$00
?CLS
    LDA #$00
    STA (PCRSR),Y
    INY 
    BNE ??CLS
    INX 
    INC PCRSR+1
??CLS
    CPY #104
    BNE ?CLS
    CPX #$01
    BNE ?CLS
    RTS 
OPEN
    LDX #$10
    LDA #$03
    STA $0342,X
    LDA # <?FILE
    STA $0344,X
    LDA # >?FILE
    STA $0345,X
    LDA #$04
    STA $034A,X
    LDA #$80
    STA $034B,X
    JSR $E456
    DEY 
    BNE DIR
    RTS 
CLOSE
    LDX #$10
    LDA #$0C
    STA $0342,X
    JMP $E456
DIR
    JSR CLOSE
    JSR CLS
    LDX # <?DIR
    LDY # >?DIR
    STX $0230
    STY $0231
    LDX # <??DIR
    LDY # >??DIR
    STX PCRSR
    STY PCRSR+1
    LDX #$10
    LDA #$03
    STA $0342,X
    LDA # <ALL
    STA $0344,X
    LDA # >ALL
    STA $0345,X
    LDA #$06
    STA $034A,X
    LDA #$00
    STA $034B,X
    JSR $E456
    LDA #$07
    STA $0342,X
    LDA #$00
    STA $0348,X
    STA $0349,X
    STA RY
    STA RY+1
LEDIR
    JSR $E456
    BMI ?EXIT
    CMP #155
    BEQ EXIT
    JSR ASCINT
    LDY RY
    STA (PCRSR),Y
    INC RY
    BNE F0
    INC PCRSR+1
    INC RY+1
F0
    LDY RY+1
    CPY #$01
    BNE F1
    LDY RY
    CPY #104
    BCC F1
    JSR PAUSE
    INC RY
F1
    JMP LEDIR
EXIT
    INC RY
    INC RY
    INC RY
    JMP LEDIR
?EXIT
    JSR CLOSE
    JSR PAUSE
    JSR CLS
    PLA 
    PLA 
    JMP START
PAUSE
    LDA 53279
    CMP #$06
    BNE PAUSE
    JSR CLS
    LDA #$00
    STA RY
    STA RY+1
    LDA # <??DIR
    STA PCRSR
    LDA # >??DIR
    STA PCRSR+1
    LDX #$10
    RTS 
FLSH
    LDY RY
    LDA (PCRSR),Y
    EOR #63
    STA (PCRSR),Y
    LDA #$10
    STA $021A
    RTS 
OPENK
    LDA #255
    STA 764
    LDX #$10
    LDA #$03
    STA $0342,X
    STA $0345,X
    LDA #$26
    STA $0344,X
    LDA #$04
    STA $034A,X
    JSR $E456
    LDA #$07
    STA $0342,X
    LDA #$00
    STA $0348,X
    STA $0349,X
    STA RY
    RTS 
RUTLEE
    LDX # <FLSH
    LDY # >FLSH
    LDA #$10
    STX $0228
    STY $0229
    STA $021A
    JSR OPENK
GETEC
    JSR $E456
    CMP #'~'
    BNE C0
    LDY RY
    BEQ GETEC
    LDA #$00
    STA (PCRSR),Y
    LDA #63
    DEY 
    STA (PCRSR),Y
    DEC RY
    JMP GETEC
C0
    CMP #155
    BEQ C2
    JSR ASCINT
    LDY RY
    STA (PCRSR),Y
    CPY #20
    BEQ C1
    INC RY
C1
    JMP GETEC
C2
    JSR CLOSE
    LDA #$00
    STA $021A
    LDY RY
    STA (PCRSR),Y
    RTS 
FGET
    LDA #$DF
    STA $D301
    LDA #$00
    STA LEN
    STA LEN+1
LOPFGET
    LDX #$10
    LDA #$07
    STA $0342,X
    LDA # <BAFER
    STA $0344,X
    LDA # >BAFER
    STA $0345,X
    LDA # <LENGHT
    STA $0348,X
    LDA # >LENGHT
    STA $0349,X
??FGET
    JSR $E456
    CLC 
    LDA LEN
    ADC $0348,X
    STA LEN
    LDA LEN+1
    ADC $0349,X
    STA LEN+1
    CLC 
    LDA $D301
    ADC #$04
    STA $D301
    LDA $0349,X
    CMP # >LENGHT
    BEQ LOPFGET
    CPY #136
    BEQ ?FGET
    JSR CLOSE
    JSR CLS
    LDX #$00
    TXS 
    JMP START
?FGET
    JSR ZFR0
    LDA #252
    STA FR0
    JSR IFP
    JSR FMOVE
    LDA LEN
    STA FR0
    LDA LEN+1
    STA FR0+1
    JSR IFP
    JSR PONBYTES
    JSR FDIV
    JSR PONBLOQUES
    JSR FPI
    LDA FR0
    PHA 
    DEC FR0
    JSR IFP
    JSR FMOVE
    LDA #252
    STA FR0
    LDA #$00
    STA FR0+1
    JSR IFP
    JSR FMUL
    JSR FPI
    SEC 
    LDA LEN
    SBC FR0
    STA CONT+1
    INC CONT+1
    PLA 
    STA CONT
    LDX #$10
    RTS 
PONBYTES
    JSR NBYTES
    STY RY
    LDY #$04
?PONBYTES
    LDA LBUFF,X
    AND #$5F
    STA BYTES,Y
    DEY 
    DEX 
    DEC RY
    BPL ?PONBYTES
    RTS 
PONBLOQUES
    JSR NBYTES
    STY RY
    LDY #$02
?PONBLOQUES
    LDA LBUFF,X
    AND #$5F
    STA BLOQUES,Y
    DEY 
    DEX 
    DEC RY
    BPL ?PONBLOQUES
    LDA BLOQUES+2
    CMP #$19
    BEQ ??PP0
    INC BLOQUES+2
PP0
    LDY #$02
MVBLQ
    LDA BLOQUES,Y
    ORA #$20
    STA BBLQS,Y
    DEY 
    BPL MVBLQ
    LDX # <BBLQS
    LDY # >BBLQS
    LDA #$00
    STX INBUFF
    STY INBUFF+1
    STA CIX
    JMP AFP
??PP0
    LDA #$10
    STA BLOQUES+2
    LDA BLOQUES+1
    CMP #$19
    BEQ ???PP0
    INC BLOQUES+1
    JMP PP0
???PP0
    LDA #$10
    STA BLOQUES+1
    INC BLOQUES
    JMP PP0
NBYTES
    JSR FASC
    LDX #$00
    LDY #$00
    LDA LBUFF
    CMP #'0'
    BNE PL0
    INX 
PL0
    LDA LBUFF,X
    CMP #$80
    BCS PL1
    CMP #'.'
    BEQ PL2
    INX 
    INY 
    JMP PL0
PL1
    RTS 
PL2
    DEX 
    LDA LBUFF,X
    ORA #$80
    STA LBUFF,X
    DEY 
    RTS 
LOAD
    ICL 'loader.asm'
    ;.BYTE "UU",162,"???D?h??h??P ??L&N|???`?R@??#?????ppppppppppppGFLppppppppppppBZLA%L???????dogdark?"
    ;.BYTE "??????????#!2'!2!?$%.42/?$%?"
BLQ
    .BYTE "000?",34,",/15%3???????2%42/#%$!???65%,4!3?9?02%3)/.%??34!24??"
    .BYTE 162,"?=D??2NJ?w-0??7N-1??8N-/??9N-t??:N-s??;N`",162,"?=2N?D?J?w-7N?0?-8N?1?-9N?/?-:N?t?-;N?s"
    .BYTE "?`",162,"%)L?0???T?1???T):?/???T)`?t???T)??s???T",162,"?=?M?D???PJ?t)Z",162,"L?AL?BL`(J?F?)?",162,"L"
    .BYTE "?AL?BL` DM)<??S)} 0r-?PI?Py iML?M)4??S",162,"????.??P{",162,"}??-?R)?pu&?PuL~LL?Lp??Y??H`-?T"
    .BYTE "P{-1NpJ *L ~L",162,"?=?L???J?w Yd0?-??M1N??p?L%M-???L",162,"?=qLI?P?)??qLJ?q^qL TLN1N ??ML?"
    .BYTE "M",162,"d _)? \d)???P",162,"???PJ?z(",162,"????HPzn?NJ?t)",34,"?/?)<",162,"???S?",162,"? ?????l"
    .BYTE "`?,?L ?M?LN ?M?MN-LNIpm ?M??L ?M??L ?M?-LNM?LP?-MNM?Lp?nLNP?nMNLHN-b??c?p8",162,"p???L T"
    .BYTE "L ?N *L iM,?L",162,"???b??c?L)N",162,"?= N???J?wL??)<??S ??)~??S`lb?"
PFIN
    .BYTE 0
PAG7
    ICL 'pagina7.asm'
    ;.BYTE "UU ?? k?",162,"?=???@???P)???P=????P??(?9???K9??m???L @)?K??y ?)~?K??y 8)~?KH@APwJ?;",162,"?"
    ;.BYTE "=_????J?w Yd?``?R@}?#?????",162,"? ???T????K?L",162,"???KHP{fLJ?v`?xTB????O?O??pp%<",162,"@ ?"
    ;.BYTE "x-?TH??T?L?K1KN?S?Kn?SHPsfLp?%LIPPi)X?LPcN?S",162,"? L)???n??m?gm",162,"? ??#k?(k ?)j??m??z "
    ;.BYTE "79}??ol??wh??TX?`)}&bp?)d?}?n??y?m??8id????? ?",162,"?)Om????H?JPv?n??o?L?mL=m"
PAG4
    ICL 'pagina4.asm'
    ;LLOAD	= [[PAGINA4.PLLOAD - pagina4] + PAG4]
    ;LVBLANK	= [[PAGINA4.PLVBLANK - pagina4] + PAG4]
    ;.BYTE "UU~-?S)?p?",162,"?=p????J?w Yd0?L5?)",34,"?/???T ?9U??XH@?Pv)<??SP~.|?,}??t??u?.~?,??x??y?"
    ;.BYTE ")`???L??%22/2?????#!2'5%?.5%6!-%.4%`?R@?L#?"
    ;.WORD LLOAD
    ;.BYTE "????"
    ;.WORD LVBLANK
VBLANK
    .BYTE "UULX??W?9@??i?)??@???P9e???R)o??R)??d?",162,"? 5)? \dnc?L_dNd???)???R,W?-i??@???P",162,"? ?)"
    .BYTE "? \dL_d?",162,"? b)? \d`)??b?-?PP?",162,"? x)? \dL_d-?R)?.b??j?)??c?nb?",162,"? ?)? \dL_d.c?l"
    .BYTE "b?P?)??c?",162,"? j)? \dL_d=j?H",162,"? ??L??N?h(L??",162,"? ^?L??N?) ?d?",162,"? 5)? \dL_d",162,"?"
    .BYTE " x)? \dL_d-c?Mb?pQ-?S)?I?p? ?I?pHHI?pCHI?p>HI?p9L_d",162,"( /??R??R)??d?",162,"? 8?L??N?",162,"?"
    .BYTE " 5)? \dL_d)???R",162,"? b)? \dL_d?.c?]j?PAH",162,"? j?L??N?h(L?????pd< ?"
LOADER
    .BYTE "UUz????Vd",162,"/-?S?)J??S=?P]'?HJ?vh?A?/???T?`D?/1yS3Z!UYY??S'?8 ??R*I?xryteW m??b?2PW?;"
    .BYTE " Q^.??????????????????????????????????????????"
OPENC
    LDA $D40B
    BNE OPENC
    LDA #$FF
    STA 764
?OPENC
    LDA 764
    CMP #$FF
    BEQ ?OPENC
    LDA #$FF
    STA 764
    JMP $FD40
PONDATA
    LDX #$02
?PONDATA
    LDA BLOQUES,X
    STA BLQ,X
    DEX 
    BPL ?PONDATA
    RTS 
INITSIOV
    LDY #$0B
?INITSIOV
    LDA DNHP,Y
    STA $0300,Y
    DEY 
    BPL ?INITSIOV
    LDA #$00
    STA 77
    RTS 
AUTORUN
    JSR INITSIOV
    LDX # <LOADER
    LDY # >LOADER
    STX $0304
    STY $0305
    LDX #131
    LDY #$00
    STX $0308
    STY $0309
    JSR $E459
    JSR INITSIOV
    LDX # <PAG7
    LDY # >PAG7
    STX $0304
    STY $0305
    LDX # <LAUTO
    LDY # >LAUTO
    STX $0308
    STY $0309
    JSR $E459
    JMP PAUSA
GAUTO
    LDA #$FF
    STA $D301
    JSR AUTORUN
    JSR INITSIOV
    LDX # <131
    LDY # >131
    STX $0308
    STY $0309
    LDX # <PAG4
    LDY # >PAG4
    STX $0304
    STY $0305
    JSR $E459
    LDA $D301
    AND FTURBO
    STA $D301
    JSR INITSIOV
    LDX # <LLOAD
    LDY # >LLOAD
    STX $0308
    STY $0309
    LDX # <LOAD
    LDY # >LOAD
    STX $0304
    STY $0305
    JSR $E459
    JSR INITSIOV
    LDX # <LVBLANK
    LDY # >LVBLANK
    STX $0308
    STY $0309
    LDX # <VBLANK
    LDY # >VBLANK
    STX $0304
    STY $0305
    JMP $E459
PAUSA
    LDX #$20
    STX $021C
ONROM
    LDX $021C
    BNE ONROM
    RTS 
REST
    LDY #$04
??REST
    LDA BYTES,Y
    STA BAKBYT,Y
    DEY 
    BPL ??REST
    LDY #$02
???REST
    LDA BLOQUES,Y
    STA BAKBLQ,Y
    DEY 
    BPL ???REST
    RTS 
?REST
    LDY #$04
????REST
    LDA BAKBYT,Y
    STA BYTES,Y
    DEY 
    BPL ????REST
    LDY #$02
?????REST
    LDA BAKBLQ,Y
    STA BLOQUES,Y
    DEY 
    BPL ?????REST
    LDA CONT
    STA PFIN
    RTS 
NHPUT
    LDX LEN
    LDY LEN+1
    STX @LEN
    STY @LEN+1
    TSX 
    STX PPILA
    LDA #$00
    STA @LBAF
    LDA #$55
    STA ??DIR
    STA ??DIR+1
    LDA #252
    STA ??DIR+255
    LDA FTURBO
    AND #$DF
    STA $D301
    LDX # <BAFER
    LDY # >BAFER
    STX M+1
    STY M+2
    LDX #$00
    LDY #$00
    STY $02E2
    JSR GRABACION
    JMP ?MVBF
GRABACION
    LDA PFIN
    STA ??DIR+2
    RTS 
?MVBF
    JSR GBYTE
    STA STARTF
    JSR GBYTE
    STA STARTF+1
    AND STARTF
    CMP #$FF
    BEQ ?MVBF
    JSR GBYTE
    STA FINISH
    JSR GBYTE
    STA FINISH+1
NHLOP
    JSR GBYTE
    LDA STARTF
    CMP #$E3
    BNE ?NHLOP
    LDA STARTF+1
    CMP #$02
    BNE ?NHLOP
    STA $02E2
?NHLOP
    LDA STARTF
    CMP FINISH
    BNE NHCONT
    LDA STARTF+1
    CMP FINISH+1
    BEQ ?MVBF
NHCONT
    INC STARTF
    BNE NOHI
    INC STARTF+1
NOHI
    JMP NHLOP
GBYTE
    LDA @LEN
    ORA @LEN+1
    BEQ EGRAB
    CPY #252    ;   ??DIR+255
    BEQ EGRAB
    INC @LBAF
    DEC @LEN
    LDA @LEN
    CMP #$FF
    BNE @NODLEN
    DEC @LEN+1
@NODLEN
    TYA 
M
    EOR BAFER,X
    STA ??DIR+3,Y
    TYA 
    EOR ??DIR+3,Y
    INY 
    INX 
    BNE EXNHPIT
    INC M+2
    BPL EXNHPIT
    PHA 
    CLC 
    LDA $D301
    ADC #$04
    STA $D301
    LDA # >BAFER
    STA M+2
    PLA 
EXNHPIT
    RTS 
EXNHPUT
    LDA #$80
    STA 77
    LDX PPILA
    TXS 
    RTS 
EGRAB
    DEC PFIN
    LDA @LBAF
    STA ??DIR+255
    TXA 
    PHA 
    JSR INITSIOV
    JSR $E459
    LDA @LEN
    ORA @LEN+1
    BEQ EXNHPUT
    LDX #$02
DECBL01
    LDA BLOQUES,X
    CMP #$10
    BNE DECBL02
    LDA #$19
    STA BLOQUES,X
    DEX 
    BPL DECBL01
DECBL02
    DEC BLOQUES,X
    PLA 
    TAX 
    LDA $02E2
    BNE SLOWB
SIGUE
    JSR GRABACION
    LDY #$00
    STY @LBAF
    JMP GBYTE
SLOWB
    TXA 
    PHA 
    LDX # <350
    LDY # >350
    STX $021C
    STY $021D
IRG
    LDA $021D
    BNE IRG
    LDA $021C
    BNE IRG
    LDA #$00
    STA $02E2
    PLA 
    TAX 
    JMP SIGUE
DLS
    .BYTE $70,$70,$70,$46
    .WORD SHOW
    .BYTE $70,$70,$02
    .BYTE "ppp",$02
    .BYTE "ppp",$06,"ppp",$02
    .BYTE "ppp",$06,"ppp",$02,$41
    .WORD DLS
; -------------------------
; DEFINICION DEL DISPLAY
; PARA DIRECTORIO
; -------------------------
?DIR
    .BYTE "pppppppp",$46
    .WORD ???DIR
    .BYTE $70,$02,$02,$02,$02
    .BYTE $02,$02,$02,$02,$02,$41
    .WORD ?DIR
SHOW
    .SB " NHP CON SIMON 1991 "
    .SB "   NHP TURBO SOLO ROM POR PARCHE NEGRO  "
    .SB "NOMBRE CARATULA:"
CRSR
    .SB "_                       "
NAME
    .SB "                    "
    .SB "FILE:"
FILE
    .SB "_                                  "
    .SB "     TURBO "
TOF
    .SB "OFF      "
    .SB "BYTES LEIDOS: "
BYTES
    .SB "*****        BLOQUES: "
BLOQUES
    .SB "*** "
???DIR
    .SB "     DIRECTORIO     "
??DIR
:10    .SB "                                        "
DOS
    JMP ($0C)
START
    JSR DOS
    LDX # <DLS
    LDY # >DLS
    STX $0230
    STY $0231
    LDA #$90
    STA $02C8
    STA $02C6
    LDA #$CA
    STA $02C5
    JSR RESTORE
    LDX # <CRSR
    LDY # >CRSR
    STX PCRSR
    STY PCRSR+1
    JSR RUTLEE
    JSR SETUR
    TYA 
    BEQ NOTITLE
    LSR
    STA RY+1
    LDA #10
    SEC 
    SBC RY+1
    STA RY+1
    LDX #$00
    LDY RY+1
WRITE
    LDA CRSR,X
    STA NAME,Y
    INY 
    INX 
    CPX RY
    BNE WRITE
NOTITLE
    LDX # <FILE
    LDY # >FILE
    STX PCRSR
    STY PCRSR+1
    JSR RUTLEE
    LDY #19
CONV
    LDA FILE,Y
    BEQ ?REMAIN
    AND #$7F
    CMP #64
    BCC ADD32
    CMP #96
    BCC SUB64
    BCS ?REMAIN
ADD32
    CLC 
    ADC #32
    BCC OKLET
SUB64
    SEC 
    SBC #64
?REMAIN
    LDA #$9B
OKLET
    STA ??FILE,Y
    DEY 
    BPL CONV
    JSR OPEN
    JSR FGET
    JSR CLOSE
    JSR PONDATA
    JSR REST
OTRACOPIA
    JSR ?REST
    JSR OPENC
    JSR GAUTO
    JSR NHPUT
    LDX #$3C
    LDA #$03
    STA 53775
    STX $D302
WAIT
    LDA 53279
    CMP #$07
    BEQ WAIT
    CMP #$06
    BEQ OTRACOPIA
    CMP #$03
    BNE WAIT
    JMP START
PIRATAS
    JSR CLOSE
    LDX # <OPENK
    LDY # >OPENK
    JSR CLOSE
    JSR KEM
    LDX #$00
    STX 580
    DEX 
    STX $08
    LDX # <START
    LDY # >START
    LDA #$03
    STX $02
    STY $03
    STA $09
    JMP START
    ;*=  $02E0
    ;.WORD PIRATAS
    RUN PIRATAS