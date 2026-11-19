;Kage (载入地址: A000)
;Dump By FlameCyclone
;2025.8.5
    .INSFVERSION        1                   ;版本
    .INSFTOTALSONGS     49                  ;总曲目
    .INSFSTARTSONG      1                   ;起始曲目
    .INSFLOAD           $A000               ;数据载入地址
    .INSFINIT           Init_Addr           ;初始化地址
    .INSFPLAY           Play_Addr           ;播放地址
    .INSFNAME           "Kage"              ;专辑名
    .INSFARTIST         ""                  ;作者
    .INSFCOPYRIGHT      ""                  ;版权
    .INSFSPEEDNTSC      16666               ;NTSC播放速度
    .INSFBANKSWITCH     0,1,2,3,4,5,6,7     ;4KB数据块布局
    .INSFSPEEDPAL       16666               ;PAL播放速度
    .INSFSTANDARD       0                   ;制式标准
    .INSFEXTRASOUND     0                   ;扩展音源

;ROM 16KB PRG 数量
ROM_16KB_PRG_COUNT = $08

;定义宏嵌入二进制数据宏, 参数: Bank号, 起始地址, 长度
    .MACRO MACRO_PRG_DATA_16KB
        INCBIN "Kage (J) [!].nes", $10 + (((\1 & (ROM_16KB_PRG_COUNT - 1)) * $4000)) + (\2 & ($4000 - 1)), \3
    .ENDM

    .MACRO MACRO_PRG_DATA_8KB
        INCBIN "Kage (J) [!].nes", $10 + (((\1 & ((ROM_16KB_PRG_COUNT * 2) - 1)) * $2000)) + (\2 & ($2000 - 1)), \3
    .ENDM
    
;定义宏用于替换修改DMC起始地址数据
    .MACRO MACRO_DMC_ADDR
        .ORG \1
        .DB \2 - (($D200 - $C000) / $40)
    .ENDM
    
;音乐数据
    .BANK8 1
    .ORG $A000
    MACRO_PRG_DATA_8KB $02, $A000, $2000
    
    .BANK8 1
    MACRO_DMC_ADDR $AE1C, $48
    MACRO_DMC_ADDR $AE1F, $4F
    MACRO_DMC_ADDR $AE22, $54
    MACRO_DMC_ADDR $AE25, $60
    MACRO_DMC_ADDR $AE28, $68
    MACRO_DMC_ADDR $AE2B, $72
    MACRO_DMC_ADDR $AE2E, $72
    
    .BANK8 1
    .ORG $A00B
Label_A00B
    LDA #$00
    NOP
    
    .BANK8 2
    .ORG $C000
SOUND_DATA_C000
    MACRO_PRG_DATA_8KB $03, $C000, $2000

    .BANK8 3
    .ORG $C000
DMC_DATA_C000
    MACRO_PRG_DATA_8KB $0A, $D200, $0E00
    
    .BANK8 0
    .ORG $8000

Init_Addr
    CMP #14
    BCC Init_Addr_Begin
    CLC
    ADC #$01
Init_Addr_Begin
    CMP #43
    BCS Sound052C
    
    CMP #12
    BCS Sound052A

Sound052B
    TAX
    LDA Sound052BData,X
    STA $052B
    RTS

Sound052C
    SEC
    SBC #43
    TAX
    LDA Sound052CData,X
    STA $052C
    RTS

Sound052A ;sound effect $01 - $1F (Not contain: $03)
    SEC
    SBC #11
    STA $052A
    RTS
    
Sound052BData ;bgm 01 02 04 05 06 08 09 0B 0D 0E 0F 10
    .HEX 01 02 04 05 06 08 09 0B 0D 0E 0F 10
    
Sound052CData ;dmc 02 04 07 09 0B 0C 0D
    .HEX 02 04 07 09 0B 0C 0D
    
Play_Addr
    LDA #BANK(SOUND_DATA_C000) << 1
    STA $5FFC
    ORA #$01
    STA $5FFD
    JSR $A000
    LDA #BANK(DMC_DATA_C000) << 1
    STA $5FFC
    ORA #$01
    STA $5FFD
    RTS
