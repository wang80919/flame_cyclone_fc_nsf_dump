;Contra
;Dump By FlameCyclone
;2025.8.5
    .INSFVERSION        1                   ;版本
    .INSFTOTALSONGS     43                  ;总曲目 Contra (J) [!] track.bin 43字节
    .INSFSTARTSONG      1                   ;起始曲目
    .INSFLOAD           $8000               ;数据载入地址
    .INSFINIT           Init_Addr           ;初始化地址
    .INSFPLAY           $80D5               ;播放地址
    .INSFNAME           "Contra"            ;专辑名
    .INSFARTIST         "H. Maezawa, K. Sada"    ;作者
    .INSFCOPYRIGHT      "1988 Konami"       ;版权
    .INSFSPEEDNTSC      16666               ;NTSC播放速度
    .INSFBANKSWITCH     0,1,2,3,4,5,6,7     ;4KB数据块布局
    .INSFSPEEDPAL       16666               ;PAL播放速度
    .INSFSTANDARD       0                   ;制式标准
    .INSFEXTRASOUND     0                   ;扩展音源

;ROM 16KB PRG 数量
ROM_16KB_PRG_COUNT = $08

;定义宏嵌入二进制数据宏, 参数: Bank号, 起始地址, 长度
    .MACRO MACRO_PRG_DATA_16KB
        INCBIN "Contra (J) [!].nes", $10 + (((\1 & (ROM_16KB_PRG_COUNT - 1)) * $4000)) + (\2 & ($4000 - 1)), \3
    .ENDM
    
    .MACRO MACRO_PRG_DATA_8KB
        INCBIN "Contra (J) [!].nes", $10 + (((\1 & ((ROM_16KB_PRG_COUNT * 2) - 1)) * $2000)) + (\2 & ($2000 - 1)), \3
    .ENDM

;音乐数据
    .BANK16 0
    .ORG $8000
    MACRO_PRG_DATA_8KB $12, $8000, $4000

;修正DMC起始地址
    .BANK16 0
    .ORG $8915
    .DB $F0 - (($FC00 - $C000) / $40)

    .ORG $8919
    .DB $F3 - (($FC00 - $C000) / $40)

    .ORG $891D
    .DB $F3 - (($FC00 - $C000) / $40)

    .ORG $8921
    .DB $F3 - (($FC00 - $C000) / $40)

;DMC数据
    .BANK16 1
    .ORG $C000
    MACRO_PRG_DATA_8KB $1F, $FC00, $0400

;初始化处理
Init_Addr
    TAX
    LDA Track_Data,X
    JMP $87A2;跳转到初始化入口

;曲目号数据
Track_Data
    MACRO_PRG_DATA_16KB $04, $AA2A, 43

