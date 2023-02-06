pagina7_init = $1200

.proc pagina7, pagina7_init
pagina7
    .BY $55,$55
    JSR INICIOP7
?pagina7
    JSR STARTP7
    LDX #$03

STARTP7
    LDX #$00
    LDY #$00
    STX $D407
    STX $1293

INICIOP7

.endp