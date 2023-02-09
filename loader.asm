paginaloader_init = $CC00
BUFFER = $0700
BUFAUX = $1100

.proc paginaloader, paginaloader_init
    .BY $55,$55
    LDX #$00
    TXS
    STX COLDST
    inx
    STX BOOT
    inx
    STX GRACTL
    jsr $1200
    jmp START
NBYTES
    .BY $FC
FLAGY
    .BY $00
FINISH
    .BY $00,$00
TABLASIO
    .BY $60,$00,$52,$40
    .WO $0700
    .BY $23,$00
    .WO $0100
    .BY $00,$80
DLIST
    .BY $70,$70,$70,$70,$70,$70,$70,$70
    .BY $70,$70,$70,$70,$47
    .WO $CC46
    .BY $70,$70,$70,$70,$70,$70,$70,$70
    .BY $70,$70,$70,$70,$42
DLERR
    .WO $CC5A
    .BY $41
    .WO $CC25
TITLE
    .SB "       dogdark      "
NAME
    .SB "     CARGARA DENTRO "
    .SB "DE "
BLQ
    .BY "000"
    .SB " BLOQUES      "
MERR
    .SB " RETROCEDA 3 VUELTAS"
    .SB " Y PRESIONE "
    .SB +128," START "
    .SB " "
LNEW
    LDX #$04
XNEW
    LDA COLOR0,X
            sta PFIN+1,X
            dex
            bpl XNEW
            LDA SDLSTL
            sta PFIN+6
            LDA SDLSTH
            sta PFIN+7
            LDA SDMCTL
            sta PFIN+8
            LDA CHBAS
            sta PFIN+9
            LDA CHACT
            sta PFIN+10
            rts
NEWL:       LDX #$04
YNEW:       LDA PFIN+1,X
            sta COLOR0,X
            dex
            bpl YNEW
            LDA PFIN+6
            sta SDLSTL
            LDA PFIN+7
            sta SDLSTH
            LDA PFIN+8
            sta SDMCTL
            LDA PFIN+9
            sta CHBAS
            LDA PFIN+10
            sta CHACT
            rts
NEWDL:      LDX #<DLIST
            LDA #>DLIST
            STX SDLSTL
            STX DLISTL
            sta SDLSTH
            sta DLISTH
            LDA #$3A
            sta SDMCTL
            sta DMACLT
            LDA #$E0
            sta CHBAS
            sta CHBASE
            LDA #$02
            sta CHACT
            sta CHACTL
            LDX #$04
COLORLOOP:  LDA TABLA,X
            sta COLOR0,X
            sta COLPF0,X
            dex
            bpl COLORLOOP
            LDA #<NAME
            LDX #>NAME
            sta DLERR
            STX DLERR+1
            rts
TABLA:      .BY $28,$CA,$00,$46,$00
CONCHAT:    LDA #<MERR
            LDX #>MERR
            sta DLERR
            STX DLERR+1
            rts
ERROR:      jsr CONCHAT
            LDA #$3C
            sta PACTL
            LDA #$FD
            jsr $F2B0
VUELTA:     LDA CONSOL
            cmp #$06
            bne VUELTA
            jsr SEARCH
            jmp GRAB
SEARCH:     LDA #$34
            sta PACTL
            LDX #$10
            STX CDTMV3
SPEED:      LDX CDTMV3
            bne SPEED
SIGUE:      LDX #$FD
            STX RTCLOK+2
BUSCA:      LDA SKSTAT
            and #$10
            beq SIGUE
            LDX RTCLOK+2
            bne BUSCA
            jmp NEWDL
GBYTE:      cpy NBYTES
            beq GRAB
            tya
            eor BAFER+3,Y
            iny
            rts
GRAB:       LDA VCOUNT
            bne GRAB
            LDA PFIN
            beq BYE
            jsr LNEW
            jsr NEWDL
?GRAB:      LDX #$0B
MSIO:       LDA TABLASIO,X
            sta DDEVIC,X
            dex
            bpl MSIO
            jsr SIOV
            bmi ERROR
            LDA BAFER+2
            cmp PFIN
            bcc ERROR
            beq RETURN
            jmp ?GRAB
RETURN:     LDA BAFER+255
            sta NBYTES
            LDX #$02
C01:        LDA BLQ,X
            cmp #$10
            bne C02
            LDA #$19
            sta BLQ,X
            dex
            bpl C01
C02:        dec BLQ,X
            jsr NEWL
            dec PFIN
            ldy #$00
            sty ATRACT
            jmp GBYTE
BYE:        LDX #$E4
            ldy #$5F
            LDA #$06
            jsr SETVBV
            LDA #$00
            sta GRACTL
            LDX #$03
P01:        sta SIZEP0,X
            dex
            bpl P01
            tay
            LDX #$0E
P02:        sta BUFFER,Y
            iny
            bne P02
            ;inc LCE04
            INC P02+1
            dex
            bpl P02
            LDA #$22
            sta SDMCTL
            LDA #$3C
            LDX #$00
            sta PACTL
            TXS
            LDX #$00
            ldy #$07
            STX APPMHI
            sty APPMHI+1
            jmp (RUNAD)
START:      ldy NBYTES
LOOP:       jsr GBYTE
            sta MEMORY+1
            jsr GBYTE
            sta MEMORY+2
            and MEMORY+1
            cmp #$FF
            beq LOOP
            jsr GBYTE
            sta FINISH
            jsr GBYTE
            sta FINISH+1
MBTM
    jsr GBYTE
MEMORY
    sta $FFFF
    LDA MEMORY+1
    cmp FINISH
    bne OK
    LDA MEMORY+2
    cmp FINISH+1
    beq VERFIN
OK:         inc MEMORY+1
            bne NIM
            inc MEMORY+2
NIM:        jmp MBTM
VERFIN:     LDA INITAD
            ora INITAD+1
            beq LOOP
            LDX #$F0
            TXS
            sty FLAGY
            jsr NEWL
            jsr RINIT
            jsr LNEW
            jsr SEARCH
            ldy FLAGY
            LDX #$00
            TXS
            STX INITAD
            STX INITAD+1
            jmp LOOP
RINIT:      LDX #$10
MVRUT:      LDA RUTINA,X
            sta BUFAUX,X
            dex
            bpl MVRUT
            jmp BUFAUX
RUTINA:     LDA #$3C
            sta PACTL
            jsr $110E    ;?RUTINA
            LDA #$FE
            sta PORTB
            rts
            jmp (INITAD)
PFIN:       .BY $00
.endp