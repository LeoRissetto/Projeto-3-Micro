
_main:

;termometro.c,22 :: 		void main()
;termometro.c,25 :: 		unsigned int Valor_ADC = 0; // var. para leitura do ADC
;termometro.c,30 :: 		TRISA.RA5 = 1; // Pino RA5 (AN4) como entrada analógica
	BSF         TRISA+0, 5 
;termometro.c,33 :: 		ADCON1 = 0B00001110; // Configura Vref externa e RA5 como entrada analógica (AN4)
	MOVLW       14
	MOVWF       ADCON1+0 
;termometro.c,36 :: 		Lcd_Init();               // Inicializa a lib. Lcd
	CALL        _Lcd_Init+0, 0
;termometro.c,37 :: 		Lcd_Cmd(_LCD_CLEAR);      // Limpa o display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;termometro.c,38 :: 		Lcd_Cmd(_LCD_CURSOR_OFF); // Cursor off
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;termometro.c,39 :: 		Lcd_Out(1, 1, "Temp:");   // Escreve "Temp:" no LCD na primeira linha
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_termometro+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_termometro+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;termometro.c,41 :: 		ADC_Init(); // Inicializa o módulo ADC
	CALL        _ADC_Init+0, 0
;termometro.c,43 :: 		while (TRUE)
L_main0:
;termometro.c,46 :: 		Valor_ADC = ADC_Read(4); // Lê o valor do ADC (0 a 1023)
	MOVLW       4
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
;termometro.c,50 :: 		temperatura = (Valor_ADC * 100.0) / 1023.0; // Conversão proporcional
	CALL        _word2double+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       72
	MOVWF       R6 
	MOVLW       133
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       192
	MOVWF       R5 
	MOVLW       127
	MOVWF       R6 
	MOVLW       136
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       main_temperatura_L0+0 
	MOVF        R1, 0 
	MOVWF       main_temperatura_L0+1 
	MOVF        R2, 0 
	MOVWF       main_temperatura_L0+2 
	MOVF        R3, 0 
	MOVWF       main_temperatura_L0+3 
;termometro.c,52 :: 		if (temperatura >= 100)
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       72
	MOVWF       R6 
	MOVLW       133
	MOVWF       R7 
	CALL        _Compare_Double+0, 0
	MOVLW       0
	BTFSC       STATUS+0, 0 
	MOVLW       1
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main2
;termometro.c,55 :: 		temp_str[0] = '1';
	MOVLW       49
	MOVWF       main_temp_str_L0+0 
;termometro.c,56 :: 		temp_str[1] = '0';
	MOVLW       48
	MOVWF       main_temp_str_L0+1 
;termometro.c,57 :: 		temp_str[2] = '0';
	MOVLW       48
	MOVWF       main_temp_str_L0+2 
;termometro.c,58 :: 		temp_str[3] = '.';
	MOVLW       46
	MOVWF       main_temp_str_L0+3 
;termometro.c,59 :: 		temp_str[4] = '0';
	MOVLW       48
	MOVWF       main_temp_str_L0+4 
;termometro.c,60 :: 		temp_str[5] = 0; // Terminador NULL para finalizar a string
	CLRF        main_temp_str_L0+5 
;termometro.c,61 :: 		}
	GOTO        L_main3
L_main2:
;termometro.c,65 :: 		temp_str[0] = (int)(temperatura / 10) + '0';      // Dezena
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       130
	MOVWF       R7 
	MOVF        main_temperatura_L0+0, 0 
	MOVWF       R0 
	MOVF        main_temperatura_L0+1, 0 
	MOVWF       R1 
	MOVF        main_temperatura_L0+2, 0 
	MOVWF       R2 
	MOVF        main_temperatura_L0+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
	CALL        _double2int+0, 0
	MOVLW       48
	ADDWF       R0, 1 
	MOVF        R0, 0 
	MOVWF       main_temp_str_L0+0 
;termometro.c,66 :: 		temp_str[1] = (int)(temperatura) % 10 + '0';      // Unidade
	MOVF        main_temperatura_L0+0, 0 
	MOVWF       R0 
	MOVF        main_temperatura_L0+1, 0 
	MOVWF       R1 
	MOVF        main_temperatura_L0+2, 0 
	MOVWF       R2 
	MOVF        main_temperatura_L0+3, 0 
	MOVWF       R3 
	CALL        _double2int+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       main_temp_str_L0+1 
;termometro.c,67 :: 		temp_str[2] = '.';                                // Ponto decimal
	MOVLW       46
	MOVWF       main_temp_str_L0+2 
;termometro.c,68 :: 		temp_str[3] = (int)(temperatura * 10) % 10 + '0'; // Primeira casa decimal
	MOVF        main_temperatura_L0+0, 0 
	MOVWF       R0 
	MOVF        main_temperatura_L0+1, 0 
	MOVWF       R1 
	MOVF        main_temperatura_L0+2, 0 
	MOVWF       R2 
	MOVF        main_temperatura_L0+3, 0 
	MOVWF       R3 
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       130
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _double2int+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       main_temp_str_L0+3 
;termometro.c,69 :: 		temp_str[4] = ' ';
	MOVLW       32
	MOVWF       main_temp_str_L0+4 
;termometro.c,70 :: 		temp_str[5] = 0; // Terminador NULL para finalizar a string
	CLRF        main_temp_str_L0+5 
;termometro.c,71 :: 		}
L_main3:
;termometro.c,74 :: 		Lcd_Out(1, 7, temp_str); // Mostra a temperatura na primeira linha, posição 7
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       7
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_temp_str_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_temp_str_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;termometro.c,75 :: 		Lcd_Chr(1, 12, 223);     // Exibe o símbolo de grau usando código ASCII 223
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       12
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       223
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;termometro.c,76 :: 		Lcd_Out(1, 13, "C");     // Exibe a letra 'C'
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       13
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_termometro+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_termometro+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;termometro.c,78 :: 		Delay_ms(200); // Pequeno atraso para a próxima leitura
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_main4:
	DECFSZ      R13, 1, 1
	BRA         L_main4
	DECFSZ      R12, 1, 1
	BRA         L_main4
	DECFSZ      R11, 1, 1
	BRA         L_main4
;termometro.c,79 :: 		}
	GOTO        L_main0
;termometro.c,80 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
