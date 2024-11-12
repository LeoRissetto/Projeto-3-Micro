#line 1 "Z:/Users/leorissetto/Documents/GitHub/Projeto-3-Micro/MikroC/termometro.c"






sbit LCD_RS at LATB4_bit;
sbit LCD_EN at LATB5_bit;
sbit LCD_D4 at LATB0_bit;
sbit LCD_D5 at LATB1_bit;
sbit LCD_D6 at LATB2_bit;
sbit LCD_D7 at LATB3_bit;
sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;



void main()
{

 unsigned int Valor_ADC = 0;
 float temperatura;
 unsigned char temp_str[10];


 TRISA.RA5 = 1;


 ADCON1 = 0B00001110;


 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1, 1, "Temp:");

 ADC_Init();

 while ( 1 )
 {

 Valor_ADC = ADC_Read(4);



 temperatura = (Valor_ADC * 100.0) / 1023.0;

 if (temperatura >= 100)
 {

 temp_str[0] = '1';
 temp_str[1] = '0';
 temp_str[2] = '0';
 temp_str[3] = '.';
 temp_str[4] = '0';
 temp_str[5] = 0;
 }
 else
 {

 temp_str[0] = (int)(temperatura / 10) + '0';
 temp_str[1] = (int)(temperatura) % 10 + '0';
 temp_str[2] = '.';
 temp_str[3] = (int)(temperatura * 10) % 10 + '0';
 temp_str[4] = ' ';
 temp_str[5] = 0;
 }


 Lcd_Out(1, 7, temp_str);
 Lcd_Chr(1, 12, 223);
 Lcd_Out(1, 13, "C");

 Delay_ms(200);
 }
}
