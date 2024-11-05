// Device: PIC18F4550 - Clock = 8 MHz
// Simulação de sensor LM35 com potenciômetro, leitura ADC, e exibição no display LCD

/* Include */

/* Diretivas de pré-compilação */
#define TRUE 1 // assim: while(TRUE) = while(1)

// Configuração dos pinos para o LCD
sbit LCD_RS at LATB4_bit;            // pino 4 do PORTB interligado ao RS do display
sbit LCD_EN at LATB5_bit;            // pino 5 do PORTB ao EN do display
sbit LCD_D4 at LATB0_bit;            // pino 0 do PORTB ao D4
sbit LCD_D5 at LATB1_bit;            // "
sbit LCD_D6 at LATB2_bit;            // "
sbit LCD_D7 at LATB3_bit;            // "
sbit LCD_RS_Direction at TRISB4_bit; // direção do fluxo de dados do pino RB4
sbit LCD_EN_Direction at TRISB5_bit; // "
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;

/* Programa Principal */

void main()
{

    unsigned int Valor_ADC = 0; // var. para leitura do ADC
    float temperatura;          // variável para armazenar a temperatura
    unsigned char temp_str[10]; // arranjo textual para exibir no display

    // Configurar os pinos como analógicos
    TRISA.RA5 = 1; // Pino RA5 (AN4) como entrada analógica

    // Configuração do ADC com Vref externa (AN2 = Vref- e AN3 = Vref+)
    ADCON1 = 0B00001110; // Configura Vref externa e RA5 como entrada analógica (AN4)

    // Configuração do módulo LCD
    Lcd_Init();               // Inicializa a lib. Lcd
    Lcd_Cmd(_LCD_CLEAR);      // Limpa o display
    Lcd_Cmd(_LCD_CURSOR_OFF); // Cursor off
    Lcd_Out(1, 1, "Temp:");   // Escreve "Temp:" no LCD na primeira linha

    ADC_Init(); // Inicializa o módulo ADC

    while (TRUE)
    {
        // Leitura do ADC no canal AN4 (RA5)
        Valor_ADC = ADC_Read(4); // Lê o valor do ADC (0 a 1023)

        // Conversão do valor do ADC para temperatura (0 a 100 °C)
        // 1023 corresponde a 1V (100°C), então a relação é linear
        temperatura = (Valor_ADC * 100.0) / 1023.0; // Conversão proporcional

        // Formatar a temperatura para exibição no display LCD (com 1 casa decimal)
        temp_str[0] = (int)(temperatura / 10) + '0';      // Dezena
        temp_str[1] = (int)(temperatura) % 10 + '0';      // Unidade
        temp_str[2] = '.';                                // Ponto decimal
        temp_str[3] = (int)(temperatura * 10) % 10 + '0'; // Primeira casa decimal
        temp_str[4] = 0;                                  // Terminador NULL para finalizar a string

        // Exibir a temperatura no display LCD
        Lcd_Out(1, 7, temp_str); // Mostra a temperatura na primeira linha, posição 7
        Lcd_Out(1, 11, "C");     // Exibe o símbolo de grau Celsius "C"

        Delay_ms(200); // Pequeno atraso para a próxima leitura
    }
}
