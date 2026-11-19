;Ninja Gaiden 2
;Dump By FlameCyclone
;2025.8.5
    .INSFVERSION        1                   ;版本
    .INSFTOTALSONGS     78                  ;总曲目
    .INSFSTARTSONG      1                   ;起始曲目
    .INSFLOAD           $8000               ;数据载入地址
    .INSFINIT           Init_Addr           ;初始化地址
    .INSFPLAY           Play_Addr           ;播放地址
    .INSFNAME           "Ninja Gaiden 2"        ;专辑名
    .INSFARTIST         "S. Kajiya, Mayu, Miya"    ;作者
    .INSFCOPYRIGHT      "1990 Tecmo"        ;版权
    .INSFSPEEDNTSC      16666               ;NTSC播放速度
    .INSFBANKSWITCH     0,1,2,3,6,7,6,7     ;4KB数据块布局
    .INSFSPEEDPAL       16666               ;PAL播放速度
    .INSFSTANDARD       0                   ;制式标准
    .INSFEXTRASOUND     0                   ;扩展音源

;ROM 16KB PRG 数量
ROM_16KB_PRG_COUNT = $08

;定义宏嵌入二进制数据宏, 参数: Bank号, 起始地址, 长度
    .MACRO MACRO_PRG_DATA_16KB
        INCBIN "Ninja Ryukenden II - Ankoku no Jashin Ken (J) [!].nes", $10 + (((\1 & (ROM_16KB_PRG_COUNT - 1)) * $4000)) + (\2 & ($4000 - 1)), \3
    .ENDM

    .MACRO MACRO_PRG_DATA_8KB
        INCBIN "Ninja Ryukenden II - Ankoku no Jashin Ken (J) [!].nes", $10 + (((\1 & ((ROM_16KB_PRG_COUNT * 2) - 1)) * $2000)) + (\2 & ($2000 - 1)), \3
    .ENDM
    
;音乐数据
    .BANK8 0
    .ORG $8000
    MACRO_PRG_DATA_8KB $0B, $8000, $2000

    .BANK8 1
    .ORG $A000
    MACRO_PRG_DATA_8KB $0C, $A000, $2000
    
    .BANK8 2
    .ORG $A000
    MACRO_PRG_DATA_8KB $0D, $A000, $2000

;DMC地址修改
    .BANK8 0
    .ORG $8646
    LDA #$F0 - (($FC00 - $C000) / $40)
    
    .ORG $8666
    LDA #$F8 - (($FC00 - $C000) / $40)
    
;DMC数据
    .BANK8 3
    .ORG $C000
    MACRO_PRG_DATA_8KB $3F, $FC00, $0400

;初始化处理
Init_Addr
    TAX
    LDA Track_Bank,X
    STA $26
    LDA Track_Data,X
    STA $0700
    RTS

;播放处理
Play_Addr
    LDA $26
    SEC
    SBC #$0B
    ASL
    TAY
    STY $5FFA
    INY
    STY $5FFB
    JMP $8000

;曲目Bank数据
Track_Bank
    MACRO_PRG_DATA_16KB $07, $DFBC + 00, 16
    MACRO_PRG_DATA_16KB $07, $DFBC + 19, 13
    MACRO_PRG_DATA_16KB $07, $DFBC + 40, 49
    
;曲目号数据
Track_Data
    MACRO_PRG_DATA_16KB $07, $E015 + 00, 16
    MACRO_PRG_DATA_16KB $07, $E015 + 19, 13
    MACRO_PRG_DATA_16KB $07, $E015 + 40, 49

