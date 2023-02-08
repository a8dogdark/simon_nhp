paginaloader_init = $CC00

.proc paginaloader, paginaloader_init
    .by $55,$55
    ldx #$00
    txs
    stx COLDST
    inx
    stx BOOT
    inx
    stx GRACTL
    jsr L1200
    jmp START
NBYTES
    .by $FC
FLAGY
    .byte $00
FINISH
    .byte $00,$00
TABLASIO
    .by $60,$00,$52,$40
    .wo $0700
    .by $23,$00
    .wo $0100
    .by $00,$80
DLIST:      .byte $70,$70,$70,$70,$70,$70,$70,$70
            .byte $70,$70,$70,$70,$47
            .word $CC46
            .byte $70,$70,$70,$70,$70,$70,$70,$70
            .byte $70,$70,$70,$70,$42
DLERR:      .word $CC5A
            .byte $41
            .word $CC25
TITLE:      SBYTE "       dogdark      "
NAME:       SBYTE "     CARGARA DENTRO "
            SBYTE "DE "
BLQ:        SBYTE "017 BLOQUES      "
MERR:       SBYTE " RETROCEDA 3 VUELTAS"
            SBYTE " Y PRESIONE  ÓÔÁÒÔ  "
LNEW:       ldx #$04
XNEW:       lda COLOR0,X
            sta PFIN+1,X
            dex
            bpl XNEW
            lda SDLSTL
            sta PFIN+6
            lda SDLSTH
            sta PFIN+7
            lda SDMCTL
            sta PFIN+8
            lda CHBAS
            sta PFIN+9
            lda CHACT
            sta PFIN+10
            rts
NEWL:       ldx #$04
YNEW:       lda PFIN+1,X
            sta COLOR0,X
            dex
            bpl YNEW
            lda PFIN+6
            sta SDLSTL
            lda PFIN+7
            sta SDLSTH
            lda PFIN+8
            sta SDMCTL
            lda PFIN+9
            sta CHBAS
            lda PFIN+10
            sta CHACT
            rts
NEWDL:      ldx #<DLIST
            lda #>DLIST
            stx SDLSTL
            stx DLISTL
            sta SDLSTH
            sta DLISTH
            lda #$3A
            sta SDMCTL
            sta DMACLT
            lda #$E0
            sta CHBAS
            sta CHBASE
            lda #$02
            sta CHACT
            sta CHACTL
            ldx #$04
COLORLOOP:  lda TABLA,X
            sta COLOR0,X
            sta COLPF0,X
            dex
            bpl COLORLOOP
            lda #<NAME
            ldx #>NAME
            sta DLERR
            stx DLERR+1
            rts
TABLA:      .byte $28,$CA,$00,$46,$00
CONCHAT:    lda #<MERR
            ldx #>MERR
            sta DLERR
            stx DLERR+1
            rts
ERROR:      jsr CONCHAT
            lda #$3C
            sta PACTL
            lda #$FD
            jsr LF2B0
VUELTA:     lda CONSOL
            cmp #$06
            bne VUELTA
            jsr SEARCH
            jmp GRAB
SEARCH:     lda #$34
            sta PACTL
            ldx #$10
            stx CDTMV3
SPEED:      ldx CDTMV3
            bne SPEED
SIGUE:      ldx #$FD
            stx RTCLOK+2
BUSCA:      lda SKSTAT
            and #$10
            beq SIGUE
            ldx RTCLOK+2
            bne BUSCA
            jmp NEWDL
GBYTE:      cpy NBYTES
            beq GRAB
            tya
            eor BAFER+3,Y
            iny
            rts
GRAB:       lda VCOUNT
            bne GRAB
            lda PFIN
            beq BYE
            jsr LNEW
            jsr NEWDL
?GRAB:      ldx #$0B
MSIO:       lda TABLASIO,X
            sta DDEVIC,X
            dex
            bpl MSIO
            jsr SIOV
            bmi ERROR
            lda BAFER+2
            cmp PFIN
            bcc ERROR
            beq RETURN
            jmp ?GRAB
RETURN:     lda BAFER+255
            sta NBYTES
            ldx #$02
C01:        lda BLQ,X
            cmp #$10
            bne C02
            lda #$19
            sta BLQ,X
            dex
            bpl C01
C02:        dec BLQ,X
            jsr NEWL
            dec PFIN
            ldy #$00
            sty ATRACT
            jmp GBYTE
BYE:        ldx #$E4
            ldy #$5F
            lda #$06
            jsr SETVBV
            lda #$00
            sta GRACTL
            ldx #$03
P01:        sta SIZEP0,X
            dex
            bpl P01
            tay
            ldx #$0E
P02:        sta BUFFER,Y
            iny
            bne P02
            inc LCE04
            dex
            bpl P02
            lda #$22
            sta SDMCTL
            lda #$3C
            ldx #$00
            sta PACTL
            txs
            ldx #$00
            ldy #$07
            stx APPMHI
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
    sta LFFFF
    lda MEMORY+1
    cmp FINISH
    bne OK
    lda MEMORY+2
    cmp FINISH+1
    beq VERFIN
OK:         inc MEMORY+1
            bne NIM
            inc MEMORY+2
NIM:        jmp MBTM
VERFIN:     lda INITAD
            ora INITAD+1
            beq LOOP
            ldx #$F0
            txs
            sty FLAGY
            jsr NEWL
            jsr RINIT
            jsr LNEW
            jsr SEARCH
            ldy FLAGY
            ldx #$00
            txs
            stx INITAD
            stx INITAD+1
            jmp LOOP
RINIT:      ldx #$10
MVRUT:      lda RUTINA,X
            sta BUFAUX,X
            dex
            bpl MVRUT
            jmp BUFAUX
RUTINA:     lda #$3C
            sta PACTL
            jsr ?RUTINA
            lda #$FE
            sta PORTB
            rts
            jmp (INITAD)
PFIN:       .byte $00
.endp