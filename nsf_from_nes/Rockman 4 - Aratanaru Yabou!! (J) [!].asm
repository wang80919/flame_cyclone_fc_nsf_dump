;Rockman 4
;Dump By FlameCyclone
;2025.8.5
    .INSFVERSION        1                   ;版本
    .INSFTOTALSONGS     71                  ;总曲目
    .INSFSTARTSONG      1                   ;起始曲目
    .INSFLOAD           $8000               ;数据载入地址
    .INSFINIT           $8003               ;初始化地址
    .INSFPLAY           $8000               ;播放地址
    .INSFNAME           "Rockman 4"           ;专辑名
    .INSFARTIST         ""                  ;作者
    .INSFCOPYRIGHT      ""                  ;版权
    .INSFSPEEDNTSC      16666               ;NTSC播放速度
    .INSFBANKSWITCH     0,1,2,3,4,5,6,7     ;4KB数据块布局
    .INSFSPEEDPAL       16666               ;PAL播放速度
    .INSFSTANDARD       0                   ;制式标准
    .INSFEXTRASOUND     0                   ;扩展音源

;ROM 16KB PRG 数量
ROM_16KB_PRG_COUNT = $20

;定义宏嵌入二进制数据宏, 参数: Bank号, 起始地址, 长度
    .MACRO MACRO_PRG_DATA_16KB
        INCBIN "Rockman 4 - Aratanaru Yabou!! (J) [!].nes", $10 + (((\1 & (ROM_16KB_PRG_COUNT - 1)) * $4000)) + (\2 & ($4000 - 1)), \3
    .ENDM

    .MACRO MACRO_PRG_DATA_8KB
        INCBIN "Rockman 4 - Aratanaru Yabou!! (J) [!].nes", $10 + (((\1 & ((ROM_16KB_PRG_COUNT * 2) - 1)) * $2000)) + (\2 & ($2000 - 1)), \3
    .ENDM
    
;音乐数据
    .BANK8 0
    .ORG $8000
    MACRO_PRG_DATA_8KB $1E, $8000, $4000
    MACRO_PRG_DATA_8KB $1D, $A000, $2000

;切页逻辑修改
    .BANK8 0
    .ORG $804C
    LDA #$04
    STA $5FFA
    ORA #$01
    STA $5FFB
    LDA ($C1),Y
    PHA
    LDA #$02
    STA $5FFA
    ORA #$01
    STA $5FFB
    LDA #$20
    CLC
    ADC $C2
    STA $C2
    PLA
    RTS
    