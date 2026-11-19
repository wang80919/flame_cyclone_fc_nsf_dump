;Super Contra
;Dump By FlameCyclone
;2025.8.5
    .INSFVERSION        1                   ;版本
    .INSFTOTALSONGS     38                  ;总曲目 Contra (J) [!] track.bin 43字节
    .INSFSTARTSONG      1                   ;起始曲目
    .INSFLOAD           $8000               ;数据载入地址
    .INSFINIT           Init_Addr           ;初始化地址
    .INSFPLAY           $813C               ;播放地址
    .INSFNAME           "Super Contra"        ;专辑名
    .INSFARTIST         "H. Maezawa, K. Sada"    ;作者
    .INSFCOPYRIGHT      "1990 Konami"       ;版权
    .INSFSPEEDNTSC      16666               ;NTSC播放速度
    .INSFBANKSWITCH     0,1,2,3,6,7,6,7     ;4KB数据块布局
    .INSFSPEEDPAL       16666               ;PAL播放速度
    .INSFSTANDARD       0                   ;制式标准
    .INSFEXTRASOUND     0                   ;扩展音源

;音乐数据
    .BANK8 0
    .ORG $8000
    .INCBIN "Super Contra (J).nes", (($3C & $0F) * $2000) + $10, $4000
    .INCBIN "Super Contra (J).nes", (($31 & $0F) * $2000) + $10, $2000

    .BANK8 0
    .ORG $8181
    JSR Label_FD6F
    
    .ORG $853A
    JMP Label_FDBA
 
;修改Bank索引号
    .BANK8 0
    .ORG $8000
    .DB 00;3C
    
    .BANK8 1
    .ORG $BFFF
    .DB 02;3C
    
    .BANK8 2
    .ORG $BFFF
    .DB 04;31
    
;DMC数据
    .BANK8 3
    .ORG $C000
    .INCBIN "Super Contra (J).nes", (($3E & $0F) * $2000) + $10, $1F40

;跳转程序修改
Label_FD6F
    LDY #$04
    CMP #$32
    BEQ Label_FD7B
    CMP #$36
    BEQ Label_FD7B
    LDY #$02
Label_FD7B
    STY $5FFA
    INY
    STY $5FFB
    RTS
    
Label_FDBA
    STA $07E9
    LDA $BFFF
    PHA
    LDA $07E9
    JSR Label_FD6F
    LDA $07E9
    JSR $8039
    PLA
    TAY
    JMP Label_FD7B
    
;初始化处理
Init_Addr
    TAX
    LDA Track_Data,X
    JMP Label_FDBA

;曲目号数据
Track_Data
    .INCBIN "Super Contra (J).nes", (($02 & $0F) * $4000) + $10 + ($9CA4 & $1FFF), 28

