; First load block and check for error on this one.
;
pagina4_init = $037D
;
.proc pagina4, pagina4_init
    .BY $55,$55,$FE
INIPAGINA4
    LDA $D301
    AND #$02
    BEQ ??PAGINA4
    LDX #$0B 
?PAGINA4 
    LDA $0470,X 
    STA $0300,X 
    DEX 
    BPL ?PAGINA4
    JSR $E459
    BMI ??PAGINA4
    JMP $0435
??PAGINA4
    LDA #$22
    STA $022F
    STA $D400
    LDY #$00
???PAGINA4
    LDA $0455,Y 
    STA ($58),Y
    INY 
    CPY #$1B
    BNE ???PAGINA4
    LDA #$3C
    STA $D302 
????PAGINA4
    BNE ????PAGINA4
    LDX $047C
    LDY $047D
    STX $0474
    STY $0475
    LDX $047E
    LDY $047F
    STX $0478
    STY $0479
    LDA #$60
    STA $0417
    JMP $0407
    .SB +128,"ERROR "
    .SB +128,"!!!"
    .SB " CARGU"
    .SB "E NUEV"
    .SB "AMENTE"
    .BY $60,$00,$52,$40
    .WO $CC00
    .BY $23,$00
    .WO PLLOAD
    .BY $00,$80,$00,$12
    .WO PLVBLANK
.endp