/*
 * LF_LC.c
 *
 * Created: 6/9/2017 5:33:09 AM Pembaharuan dari LF _NEWBIE 11/23/2016 11:37:15 AM -> LF Newbie buat INTERNAL TC2016
 * Author: Lintang
 */

#include <stdio.h>
#include <mega32.h>
#include <alcd.h>
#include <delay.h>
#include <stdlib.h>
#include <string.h>

#define motor_kiri PORTD.3
#define motor_kanan PORTD.6
#define OK PINC.0
#define BATAL PINC.1
#define MENU_ATAS PINC.2
#define MENU_BAWAH PINC.3
#define TAMBAH_NILAI PINC.4
#define KURANG_NILAI PINC.5
#define TR_1 PORTC.6
#define TR_2 PORTC.7
#define LCD PORTB.3

#define sensor_mati TR_1 = 0;TR_2 = 0
#define klap_klip TR_1 = 1;TR_2 = 0;LCD = 0;delay_ms(100);TR_1 = 0;TR_2 = 1;LCD = 1;delay_ms(100)

#define NORMAL 0
#define COUNTER 1

#define JML_INDEKS 90

#define lurus 0
#define kanan 1
#define kiri 2
#define stop 3

//urutan password
#define kunci_1 OK
#define kunci_2 TAMBAH_NILAI
#define kunci_3 TAMBAH_NILAI
#define kunci_4 BATAL
#define kunci_5 OK
#define kunci_6 KURANG_NILAI
#define kunci_7 TAMBAH_NILAI

#define ADC_VREF_TYPE 0x20 //saya pake referensi AREF

#define USART_BAUDRATE 9600
#define BAUD_PRESCALE ((((16000000/16) + (USART_BAUDRATE / 2)) / (USART_BAUDRATE)) - 1)//103.6666667
//=====================================================================================
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)

// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index=0,rx_rd_index=0;
#else
unsigned int rx_wr_index=0,rx_rd_index=0;
#endif

#if RX_BUFFER_SIZE < 256
unsigned char rx_counter=0;
#else
unsigned int rx_counter=0;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void){
    char status,data;
    status=UCSRA;
    data=UDR;
    if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0){
        rx_buffer[rx_wr_index++]=data;
#if RX_BUFFER_SIZE == 256
        // special case for receiver buffer size=256
        if (++rx_counter == 0) rx_buffer_overflow=1;
#else
        if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
        if (++rx_counter == RX_BUFFER_SIZE){
            rx_counter=0;
            rx_buffer_overflow=1;
        }
#endif
    }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void){
    char data;
    while (rx_counter==0);
    data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
    if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
    --rx_counter;
#asm("sei")
    return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE <= 256
unsigned char tx_wr_index=0,tx_rd_index=0;
#else
unsigned int tx_wr_index=0,tx_rd_index=0;
#endif

#if TX_BUFFER_SIZE < 256
unsigned char tx_counter=0;
#else
unsigned int tx_counter=0;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void){
    if (tx_counter){
        --tx_counter;
        UDR=tx_buffer[tx_rd_index++];
#if TX_BUFFER_SIZE != 256
        if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
#endif
    }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c){
    while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
    if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0)){
        tx_buffer[tx_wr_index++]=c;
#if TX_BUFFER_SIZE != 256
        if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
#endif
        ++tx_counter;
    }else
        UDR=c;
#asm("sei")
}
#pragma used-
#endif
//=====================================================================================
//===Var. untuk tuning PID=====
eeprom unsigned char e_kP;
eeprom unsigned char e_kI;
eeprom unsigned char e_kD;
//=======Settingan LF==========
eeprom unsigned char e_maks_PWM;
eeprom unsigned char e_min_PWM;
eeprom unsigned char e_kelajuan;
eeprom unsigned char e_n_tengah[14];
eeprom unsigned char e_ambang_atas[14],e_ambang_bawah[14];
eeprom int e_k_stabilisator;
eeprom unsigned char e_delay_awal;
eeprom unsigned char e_reset_setting=1;
//===========Variabel counter=============
eeprom unsigned char e_c_delay[JML_INDEKS];
eeprom unsigned char e_c_timer[JML_INDEKS];
eeprom unsigned char e_c_aksi[JML_INDEKS];
eeprom unsigned char e_c_sensor_ka[JML_INDEKS];
eeprom unsigned char e_c_sensor_ki[JML_INDEKS];
eeprom unsigned char e_c_cp[JML_INDEKS];
eeprom unsigned char e_c_invert[JML_INDEKS];
eeprom unsigned char e_c_laju[JML_INDEKS];
eeprom unsigned char e_c_laju_ki[JML_INDEKS];
eeprom unsigned char e_c_laju_ka[JML_INDEKS];
//=====================================================================================
int kP;
int kI;
int kD;
int maks_PWM;
int min_PWM;
int kelajuan;
int k_stabilisator;
unsigned char delay_awal;
unsigned char nilai_adc[14];
unsigned char ambang_atas[14], ambang_bawah[14];
unsigned char n_tengah[14];
unsigned char c_delay[JML_INDEKS];
unsigned char c_timer[JML_INDEKS];
unsigned char c_aksi[JML_INDEKS];
unsigned char c_sensor_ka[JML_INDEKS];
unsigned char c_sensor_ki[JML_INDEKS];
unsigned char c_cp[JML_INDEKS];
unsigned char c_invert[JML_INDEKS];
unsigned char c_laju[JML_INDEKS];
unsigned char c_laju_ki[JML_INDEKS];
unsigned char c_laju_ka[JML_INDEKS];

char tampil[16];
char buffer[18];
unsigned int cacah=0;
unsigned int detik=0;
unsigned int target_timer=0;

//Deteksi kombinasi sensor
int sensor_ka[6] = {
0b00000000000000,
0b00000000010000,
0b00000000001000,
0b00000000000100,
0b00000000000010,
0b00000000000001};
int sensor_ki[6] = {
0b00000000000000,
0b00001000000000,
0b00010000000000,
0b00100000000000,
0b01000000000000,
0b10000000000000};

//varibel buat kendali PID
int /*SP = 0*/ /*PV = 0*/ PID, P, /*I = 0,*/ D, error=0, error_terakhir=0, pesat_error;
int pwm_kiri, pwm_kanan;

unsigned char c_i=0;
unsigned char kelajuan_normal;
unsigned char mode = 0;
unsigned char aktifasi_serial=0;

int sensor;
bit timer_aktif=0;
bit flag_berhenti=0;
bit flag_invert=0;
int sen_dep;
int sen_ki;
int sen_ka;
//Buat grafik batang kepekaan sensor
flash unsigned char c[7][8] = {{0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x1F},
{0x00,0x00,0x00,0x00,0x00,0x00,0x1F,0x1F},
{0x00,0x00,0x00,0x00,0x00,0x1F,0x1F,0x1F},
{0x00,0x00,0x00,0x00,0x1F,0x1F,0x1F,0x1F},
{0x00,0x00,0x00,0x1F,0x1F,0x1F,0x1F,0x1F},
{0x00,0x00,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F},
{0x00,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F}};
//=====================================================================================
interrupt [TIM0_OVF] void timer0_ovf_isr(void){
    TCNT0 = 0xF0;
    cacah++;
    if(cacah>=1000){
        cacah=0;
        detik++;
    }
}
//=====================================================================================
unsigned char read_adc(unsigned char adc_input){
    ADMUX=adc_input | ADC_VREF_TYPE;
    // Delay needed for the stabilization of the ADC input voltage
    delay_us(10);
    // Start the AD conversion
    ADCSRA|=(1<<ADSC);
    // Wait for the AD conversion to complete
    while (!(ADCSRA & (1<<ADIF)));
    ADCSRA|=(1<<ADIF);
    return ADCH;
}
//=====================================================================================
void define_char(flash unsigned char *pc, unsigned char code){
    unsigned char i,a;
    a = (code << 3) | 0x40;
    for(i = 0;i < 8;i++)lcd_write_byte(a++, *pc++);
}
//===========UART=============
/*void kirim_data(char data){
    //Gak optimal karena ketika data telah dikirim masih ada delay siap atau tidaknya pengiriman data selanjutnya
    //sebagai gantinya pake UDRE karena siap atau tidaknya sebelum data dikirim
    //UDR = data;
    //while((UCSRA & (1 << TXC))==0);
    while(!(UCSRA & (1 << UDRE)));
    UDR = data;
}
unsigned char ambil_data(){
    while(!(UCSRA & (1 << RXC)));
    return UDR;
}*/
void kirim_string(char *s){
    while(*s!=0x00){
        putchar(*s);
        s++;
    }
}
void ambil_string(char *s){
    char ch;
    do{
        ch=getchar();
        if(ch!='\n')
            *s++ = ch;
    }while(ch!='\n');
    *s=0;
}
//=====================================================================================
void baca_eeprom(){
    unsigned char i;
    kP = e_kP; kI = e_kI; kD = e_kD; maks_PWM = e_maks_PWM; min_PWM = e_min_PWM;
    kelajuan = e_kelajuan;k_stabilisator = e_k_stabilisator;delay_awal = e_delay_awal;
    for(i = 0;i < JML_INDEKS;i++){
        c_delay[i] = e_c_delay[i];
        c_timer[i] = e_c_timer[i];
        c_aksi[i] = e_c_aksi[i];
        c_sensor_ka[i] = e_c_sensor_ka[i];
        c_sensor_ki[i] = e_c_sensor_ki[i];
        c_cp[i] = e_c_cp[i];
        c_invert[i] = e_c_invert[i];
        c_laju[i] = e_c_laju[i];
        c_laju_ki[i] = e_c_laju_ki[i];
        c_laju_ka[i] = e_c_laju_ka[i];
    }
    for(i = 0;i < 14;i++){
        n_tengah[i] = e_n_tengah[i];
        ambang_atas[i] = e_ambang_atas[i];
        ambang_bawah[i] = e_ambang_bawah[i];
    }
}
//=====================================================================================
void atur_pwm(int pwm_ki, int pwm_ka){
    if(pwm_ki > maks_PWM){OCR1B = maks_PWM; motor_kiri = 0;}
    else if(pwm_ki < -(min_PWM)){OCR1B = 255 - min_PWM; motor_kiri = 1;}
    else if(pwm_ki >= 0){OCR1B = pwm_ki; motor_kiri = 0;}
    else if(pwm_ki < 0){OCR1B = 255 + pwm_ki; motor_kiri = 1;}
    
    if(pwm_ka > maks_PWM){OCR1A = maks_PWM; motor_kanan = 0;}
    else if(pwm_ka < -(min_PWM)){OCR1A = 255 - min_PWM; motor_kanan = 1;}
    else if(pwm_ka >= 0){OCR1A = pwm_ka; motor_kanan = 0;}
    else if(pwm_ka < 0){OCR1A = 255 + pwm_ka; motor_kanan = 1;}
}
//=====================================================================================
void grafik(){
    unsigned char i;
    unsigned char j;
    TR_1 = 1; TR_2 = 0;
    delay_us(150);
    for(i = 0;i < 7;i++){
        nilai_adc[i] = read_adc(7-i);
        lcd_gotoxy(14-i,0);
        for(j = 0;j < 7;j++){
            if(nilai_adc[i] >= ambang_atas[i]-((ambang_atas[i]-n_tengah[i])/8)*(j+1) &&
                nilai_adc[i] < ambang_atas[i]-((ambang_atas[i]-n_tengah[i])/8)*j || nilai_adc[i] > ambang_atas[i]){
                lcd_putchar((j)?7-j:0xFF);break;
            }else if(nilai_adc[i] < n_tengah[i]){
                lcd_putchar(32);break;
            }
        }
    }

    TR_1 = 0; TR_2 = 1;
    delay_us(150);
    for(i = 7;i < 14;i++){
        nilai_adc[i] = read_adc(i-6);
        lcd_gotoxy(14-i,0);
        for(j = 0;j < 7;j++){
            if(nilai_adc[i] >= ambang_atas[i]-((ambang_atas[i]-n_tengah[i])/8)*(j+1) &&
                nilai_adc[i] < ambang_atas[i]-((ambang_atas[i]-n_tengah[i])/8)*j || nilai_adc[i] > ambang_atas[i]){
                lcd_putchar((j)?7-j:0xFF);break;
            }else if(nilai_adc[i] < n_tengah[i]){
                lcd_putchar(32);break;
            }
        }
    }
    //sensor_mati;
    //delay_us(10);
}
//=====================================================================================
//cacahan tombol yang ditekan sama tombol yg sesuai ditekan
unsigned char hitung_tekan;
unsigned char hitung_password;

void logika_password(){
    hitung_tekan=0;
    hitung_password=0;
    lcd_gotoxy(0,0);
    lcd_putsf("    Masukkan    ");
    lcd_gotoxy(0,1);
    lcd_putsf("Password:.......");
    lcd_gotoxy(9,1);
    while(1){
        if(!OK||!BATAL||!MENU_ATAS||!MENU_BAWAH||!TAMBAH_NILAI||!KURANG_NILAI){
            lcd_putsf("*");
            while(!OK||!BATAL||!MENU_ATAS||!MENU_BAWAH||!TAMBAH_NILAI||!KURANG_NILAI){
                if(!kunci_1&&(hitung_password==0)){
                    hitung_password++;;
                    while(!kunci_1)delay_ms(20);
                }
                if(!kunci_2&&(hitung_password==1)){
                    hitung_password++;
                    while(!kunci_2)delay_ms(20);
                }
                if(!kunci_3&&(hitung_password==2)){
                    hitung_password++;
                    while(!kunci_3)delay_ms(20);
                }
                if(!kunci_4&&(hitung_password==3)){
                    hitung_password++;
                    while(!kunci_4)delay_ms(20);
                }
                if(!kunci_5&&(hitung_password==4)){
                    hitung_password++;
                    while(!kunci_5)delay_ms(20);
                }
                if(!kunci_6&&(hitung_password==5)){
                    hitung_password++;
                    while(!kunci_6)delay_ms(20);
                }
                if(!kunci_7&&(hitung_password==6)){
                    hitung_password++;
                    while(!kunci_7)delay_ms(20);
                }
                delay_ms(20);
            }
            hitung_tekan++;   
        } 
        if(hitung_password==7){
            break;
        }
        if(hitung_tekan==7){
            lcd_gotoxy(0,0);
            lcd_putsf(" Maaf Password  ");
            lcd_gotoxy(0,1);
            lcd_putsf("    Salah !!    ");
            delay_ms(1000);
            break;
        }
        delay_ms(100);
    }      
}

//=====================================================================================
void menu(){
    unsigned char jumlah_cp;
    unsigned char i;
    unsigned char j;
    unsigned char indeks;
    int indeks_cp;
    float tegangan = 0;
    siaga:
    lcd_clear();
    lcd_gotoxy(0,0);
    switch(mode){
        case NORMAL : lcd_putsf("N");break;
        case COUNTER : lcd_putsf("C");break;
    }
    indeks=mode;
    jumlah_cp=0;
    for(i=0;i<JML_INDEKS;i++){
        if(c_cp[i])jumlah_cp++;
    }
    indeks_cp=-1;
    if(c_i)c_i--;
    for(i=0;i<=c_i;i++){
        if(c_cp[i])indeks_cp++;
    }
    //if(indeks_cp==-1)indeks_cp=0;
    lcd_gotoxy(0,1);
    sprintf(tampil,"CP:%d ",indeks_cp+1);
    lcd_puts(tampil);
    while(1){
        if(aktifasi_serial){
            if(rx_counter){
                ambil_string(buffer);
                if(!strcmp(buffer,"a")){
                    sensor_mati;
                    baca_eeprom();    
                    goto atur_PID;
                }else if(!strcmp(buffer,"b")){
                    sensor_mati;
                    baca_eeprom();
                    goto atur_kelajuan;
                }else if(!strcmp(buffer,"c")){
                    sensor_mati;
                    //baca_eeprom();
                    goto cek_motor;
                }
            }
        }
        if(!OK){
            sensor_mati;
            while(!OK){
                if(!BATAL){
					pertama:
                    if(e_reset_setting){
                        lcd_gotoxy(0,0);
                        lcd_putsf("   Anda Telah   ");
                        lcd_gotoxy(0,1);
                        lcd_putsf(" Aktifasi Reset ");
                        delay_ms(1500);
                        lcd_gotoxy(0,0);
                        lcd_putsf(" Silahkan Untuk ");
                        lcd_gotoxy(0,1);
                        lcd_putsf("    Restart     ");
                        delay_ms(1500);
                        while(!OK||!BATAL)delay_ms(20);
                        goto siaga; 
                    }else{
                        lcd_gotoxy(0,0);
                        lcd_putsf("Reset Setting ? ");
                        lcd_gotoxy(0,1);
                        lcd_putsf("+ Ya ");
                        lcd_gotoxy(5,1);
                        lcd_putsf("- Tidak    ");
                        while(!OK||!BATAL)delay_ms(20);
                    }
                    while(1){
                        if(!TAMBAH_NILAI){
                            while(!TAMBAH_NILAI)delay_ms(20);
                            logika_password();
                            if(hitung_password<7)goto pertama;
                            lcd_gotoxy(0,0);
                            lcd_putsf("Silahkan Restart");
                            lcd_gotoxy(0,1);
                            lcd_putsf("  Untuk Reset   ");
                            goto siaga;
                        }
                        if(!KURANG_NILAI){
                            while(!KURANG_NILAI)delay_ms(20);
                            goto siaga;
                        }
                    }
                }
                else if(!MENU_ATAS){
                    if(!aktifasi_serial){
                        while(rx_counter){ambil_string(buffer);}
                        //kirim_string("A\n");
                        aktifasi_serial=1;
                        lcd_gotoxy(0,0);
                        lcd_putsf("   Komunikasi   ");
                        lcd_gotoxy(0,1); 
                        lcd_putsf("  Serial Aktif  ");
                        delay_ms(1500);
                        goto siaga;
                    }else{
                        while(rx_counter){ambil_string(buffer);}
                        //kirim_string("A\n");
                        aktifasi_serial=0;
                        lcd_gotoxy(0,0);
                        lcd_putsf("   Komunikasi   ");
                        lcd_gotoxy(0,1); 
                        lcd_putsf("Serial Non-Aktif");
                        delay_ms(1500);
                        goto siaga;
                    }
                    
                }
                delay_ms(20);
            }
            indeks=0;
            goto menu;
        }
        if(!KURANG_NILAI){//&&(tegangan>=11.10)){
            sensor_mati;
            while(!KURANG_NILAI)delay_ms(20);
            goto keluar;
        }
        if(!MENU_ATAS){
            sensor_mati;
            lcd_gotoxy(0,0);
            while(!MENU_ATAS)delay_ms(20);
            mode = (mode)?NORMAL:COUNTER;
            switch(mode){
                case 0:lcd_putsf("N");break;
                case 1:lcd_putsf("C");break;
            }
        }
        if(!MENU_BAWAH){
            sensor_mati; 
            delay_ms(100);
            indeks_cp++;
            if(indeks_cp>(jumlah_cp-1))indeks_cp=0;
            lcd_gotoxy(0,1);
            sprintf(tampil,"CP:%d ",indeks_cp+1);
            lcd_puts(tampil);
            
        }
        if(!TAMBAH_NILAI){
            sensor_mati;
            delay_ms(100);
            indeks_cp--;
            if(indeks_cp==-1)indeks_cp=(jumlah_cp-1);
            lcd_gotoxy(0,1);
            sprintf(tampil,"CP:%d ",indeks_cp+1);
            lcd_puts(tampil);
        }
        tegangan = (float) read_adc(0)*5.3*5.0/255.0;
        lcd_gotoxy(6,1);
        sprintf(tampil, "%0.2fV  >>", tegangan);
        lcd_puts(tampil);
        /*if(tegangan<11.10){//Tegangan kerja minimal batre lipo yang 3sel
            lcd_gotoxy(1,0);
            lcd_putsf("Baterai Lemah!");
            TR_1=0;
            TR_2=0;
            LCD=0;
            delay_ms(500);
            LCD=1;
            delay_ms(500);*/
        //}else{
            grafik();            
        //}
    }

    menu:
    //indeks=0;
    //Ambil data dari EEPROM buat ditampilin di menu
    baca_eeprom();
    while(1){
        if(!MENU_ATAS){while(!MENU_ATAS)delay_ms(20);indeks++;}
        if(!MENU_BAWAH){while(!MENU_BAWAH)delay_ms(20);indeks--;}
        if(!OK){while(!OK)delay_ms(20); goto siaga;}
        if(!BATAL){while(!BATAL)delay_ms(20); goto siaga;}
        if(!TAMBAH_NILAI){
            while(!TAMBAH_NILAI)delay_ms(20);
            switch(indeks){
                case 0 : goto atur_PID;
                case 1 : goto cek_motor;
                case 2 : goto stabilisator;
                case 3 : goto counter_1;
            }
        }
        if(!KURANG_NILAI){
            while(!KURANG_NILAI)delay_ms(20);
            switch(indeks){
                case 0 : goto atur_kelajuan;
                case 1 : goto kalibrasi;
                case 2 : goto delay_mulai;
                //case 3 : goto counter_2;
                default:break;
            }
        }
        switch(indeks){
            case 0:
                lcd_gotoxy(0,0);
                lcd_putsf("+ Atur PID      ");
                lcd_gotoxy(0,1);
                lcd_putsf("- Atur Kelajuan ");break;
            case 1:
                lcd_gotoxy(0,0);
                lcd_putsf("+ Tes Motor     ");
                lcd_gotoxy(0,1);
                lcd_putsf("- Kalibrasi     ");break;
            case 2:
                lcd_gotoxy(0,0);
                lcd_putsf("+ Stabilisator  ");
                lcd_gotoxy(0,1);
                lcd_putsf("- Delay Awal    ");break;
             case 3:
                lcd_gotoxy(0,0);
                lcd_putsf("+ Atur Counter  ");
                lcd_gotoxy(0,1);
                lcd_putsf("=====TIM LC=====");break;   
            default :
            if(indeks == 4){indeks = 0;}
            else {indeks = 3;}
        }
        delay_ms(150);
    }

    atur_PID:
    indeks = 0;
    lcd_clear();
    lcd_gotoxy(0,0);
    sprintf(tampil, "kP   kI   kD    ");
    lcd_puts(tampil);
    if(aktifasi_serial){
        kirim_string("c\r");
        sprintf(buffer,"%d\n",kP);
        kirim_string(buffer);
        kirim_string("d\r");
        sprintf(buffer,"%d\n",kI);
        kirim_string(buffer);
        kirim_string("e\r");
        sprintf(buffer,"%d\n",kD);
        kirim_string(buffer);
    }
    while(1){
        if(aktifasi_serial){
            if(rx_counter){
                ambil_string(buffer);
                if(!strcmp(buffer,"a")){
                    e_kP = kP; e_kI = kI; e_kD = kD;
                    goto simpan;            
                }else if(!strcmp(buffer,"b")){
                    goto siaga;
                }else if(!strcmp(buffer,"c")){
                    if(rx_counter){
                        indeks=0;
                        ambil_string(buffer);
                        kP = atoi(buffer);
                    }    
                }else if(!strcmp(buffer,"d")){
                    if(rx_counter){ 
                        indeks=1;
                        ambil_string(buffer);
                        kI = atoi(buffer);
                    }
                }else if(!strcmp(buffer,"e")){
                    if(rx_counter){
                        indeks=2;
                        ambil_string(buffer);
                        kD = atoi(buffer);
                    }    
                }
            }
        }
        if(!MENU_ATAS){indeks++;if(indeks==3)indeks=0;delay_ms(70);}
        if(!MENU_BAWAH){indeks--;if(indeks==255)indeks=2;delay_ms(70);}
        if(!TAMBAH_NILAI){
            switch(indeks){
                case 0 : kP++;break;
                case 1 : kI++;break;
                case 2 : kD++;break;
            }
            if(aktifasi_serial){
                if(indeks==0){
                    kirim_string("c\r");
                    sprintf(buffer,"%d\n",kP);
                    kirim_string(buffer);
                }else if(indeks==1){
                    kirim_string("d\r");
                    sprintf(buffer,"%d\n",kI);
                    kirim_string(buffer);
                }else if(indeks==2){
                    kirim_string("e\r");
                    sprintf(buffer,"%d\n",kD);
                    kirim_string(buffer);
                }
            }
            delay_ms(70);
        }
        if(!KURANG_NILAI){
            switch(indeks){
                case 0 : kP--;break;
                case 1 : kI--;break;
                case 2 : kD--;break;
            }
            if(aktifasi_serial){
                if(indeks==0){
                    kirim_string("c\r");
                    sprintf(buffer,"%d\n",kP);
                    kirim_string(buffer);
                }else if(indeks==1){
                    kirim_string("d\r");
                    sprintf(buffer,"%d\n",kI);
                    kirim_string(buffer);
                }else if(indeks==2){
                    kirim_string("e\r");
                    sprintf(buffer,"%d\n",kD);
                    kirim_string(buffer);
                }
            }
            delay_ms(70);
        }
        lcd_gotoxy(1,1);
        sprintf(tampil, "%d ", kP);
        lcd_puts(tampil);
        lcd_gotoxy(6,1);
        sprintf(tampil, "%d ", kI);
        lcd_puts(tampil);
        lcd_gotoxy(11,1);
        sprintf(tampil, "%d ", kD);
        lcd_puts(tampil);
        lcd_gotoxy(0,1);lcd_putchar((indeks==0)?0x7E:32);
        lcd_gotoxy(5,1);lcd_putchar((indeks==1)?0x7E:32);
        lcd_gotoxy(10,1);lcd_putchar((indeks==2)?0x7E:32);
        if(!OK){while(!OK)delay_ms(10);e_kP = kP; e_kI = kI; e_kD = kD; indeks = 0; goto simpan;}
        if(!BATAL){;while(!BATAL)delay_ms(10);indeks = 0; goto menu;}
        delay_ms(10);
    }

    atur_kelajuan:
    indeks = 0;
    lcd_clear();
    lcd_gotoxy(0,0);
    sprintf(tampil, "Maks Min   Laju ");
    lcd_puts(tampil);
    kirim_string("c\r");
    sprintf(buffer,"%d\n",maks_PWM);
    kirim_string(buffer);
    kirim_string("d\r");
    sprintf(buffer,"%d\n",min_PWM);
    kirim_string(buffer);
    kirim_string("e\r");
    sprintf(buffer,"%d\n",kelajuan);
    kirim_string(buffer);
    while(1){
        if(aktifasi_serial){
            if(rx_counter){
                ambil_string(buffer);
                if(!strcmp(buffer,"a")){
                    e_maks_PWM = maks_PWM; e_min_PWM = min_PWM; e_kelajuan = kelajuan;
                    goto simpan;
                }else if(!strcmp(buffer,"b")){
                    goto siaga;
                }else if(!strcmp(buffer,"c")){
                    indeks=0;
                    if(rx_counter){
                        ambil_string(buffer);
                        maks_PWM = atoi(buffer);
                    }
                }else if(!strcmp(buffer,"d")){
                    indeks = 1;
                    if(rx_counter){
                        ambil_string(buffer);
                        min_PWM = atoi(buffer);
                    }
                }else if(!strcmp(buffer,"e")){
                    indeks=2;
                    if(rx_counter){
                        ambil_string(buffer);
                        kelajuan = atoi(buffer);
                    }
                }
            }
        }
        if(kelajuan > maks_PWM){
            kelajuan = maks_PWM;
            if(aktifasi_serial){
                kirim_string("e\r");
                sprintf(buffer,"%d",kelajuan);
                kirim_string(buffer);
            }
        }
        if(maks_PWM>255)maks_PWM=0;
        else if(maks_PWM<0)maks_PWM=255;
        else if(min_PWM>255)min_PWM=0;
        else if(min_PWM<0)min_PWM=255;
        if(!MENU_ATAS){indeks++;if(indeks==3)indeks=0;delay_ms(90);}
        if(!MENU_BAWAH){indeks--;if(indeks==255)indeks=2;delay_ms(90);}
        if(!TAMBAH_NILAI){
            switch(indeks){
                case 0 : maks_PWM++;break;
                case 1 : min_PWM++;break;
                case 2 : kelajuan++;break;
            }
            if(aktifasi_serial){
                if(indeks==0){
                    kirim_string("c\r");
                    sprintf(buffer,"%d\n",maks_PWM);
                    kirim_string(buffer);
                }else if(indeks==1){
                    kirim_string("d\r");
                    sprintf(buffer,"%d\n",min_PWM);
                    kirim_string(buffer);
                }else if(indeks==2){
                    kirim_string("e\r");
                    sprintf(buffer,"%d\n",kelajuan);
                    kirim_string(buffer);;
                }
            }
            delay_ms(70);
        }
        if(!KURANG_NILAI){
            switch(indeks){
                case 0 : maks_PWM--;break;
                case 1 : min_PWM--;break;
                case 2 : kelajuan--;break;
            }
            if(aktifasi_serial){
                if(indeks==0){
                    kirim_string("c\r");
                    sprintf(buffer,"%d\n",maks_PWM);
                    kirim_string(buffer);
                }else if(indeks==1){
                    kirim_string("d\r");
                    sprintf(buffer,"%d\n",min_PWM);
                    kirim_string(buffer);
                }else if(indeks==2){
                    kirim_string("e\r");
                    sprintf(buffer,"%d\n",kelajuan);
                    kirim_string(buffer);;
                }
            }
            delay_ms(70);
        }
        lcd_gotoxy(1,1);
        sprintf(tampil, "%d ", maks_PWM);
        lcd_puts(tampil);
        lcd_gotoxy(6,1);
        if(!min_PWM) sprintf(tampil, "%d ", min_PWM);
        else sprintf(tampil, "-%d ", min_PWM);
        lcd_puts(tampil);
        lcd_gotoxy(12, 1);
        sprintf(tampil, "%d ", kelajuan);
        lcd_puts(tampil);
        lcd_gotoxy(0,1);lcd_putchar((indeks==0)?0x7E:32);
        lcd_gotoxy(5,1);lcd_putchar((indeks==1)?0x7E:32);
        lcd_gotoxy(11,1);lcd_putchar((indeks==2)?0x7E:32);
        if(!OK){while(!OK)delay_ms(10); e_maks_PWM = maks_PWM; e_min_PWM = min_PWM; e_kelajuan = kelajuan; indeks = 0; goto simpan;}
        if(!BATAL){while(!BATAL)delay_ms(10);indeks = 0; goto menu;}
        delay_ms(10);
    }
    
    cek_motor:
    pwm_kanan=kelajuan;
    pwm_kiri=kelajuan;
    atur_pwm(pwm_kiri+k_stabilisator,pwm_kanan);
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_putsf("    Cek Motor   "); 
    if(aktifasi_serial){ 
        while(1){
            /*kirim_string("b\r");
            sprintf(buffer,"%d\n",pwm_kiri);
            kirim_string(buffer);
            kirim_string("c\r");
            sprintf(buffer,"%d\n",motor_kiri);
            kirim_string(buffer);
            kirim_string("d\r");
            sprintf(buffer,"%d\n",pwm_kanan);
            kirim_string(buffer);
            kirim_string("e\r");
            sprintf(buffer,"%d\n",motor_kanan);
            kirim_string(buffer);*/
            if(rx_counter){
                ambil_string(buffer);           
                if(!(strcmp(buffer,"a"))){
                    atur_pwm(0,0);
                    pwm_kanan=0;
                    pwm_kiri=0;
                    goto siaga;
                }else if(!(strcmp(buffer,"b"))){
                    if(rx_counter){
                        ambil_string(buffer);
                        pwm_kiri = atoi(buffer);
                    }
                    if(rx_counter){
                        ambil_string(buffer);
                        motor_kiri = atoi(buffer);
                    }
                    if(rx_counter){
                        ambil_string(buffer);
                        pwm_kanan = atoi(buffer);
                    }
                    if(rx_counter){
                        ambil_string(buffer);
                        motor_kanan = atoi(buffer);
                    }
                } 
                    
                /*}else if(!(strcmp(buffer,"c"))){
                    if(rx_counter){
                        ambil_string(buffer);
                        motor_kiri = atoi(buffer);
                    }
                }else if(!(strcmp(buffer,"d"))){
                    if(rx_counter){
                        ambil_string(buffer);
                        pwm_kanan = atoi(buffer);
                    }
                }else if(!(strcmp(buffer,"e"))){
                    if(rx_counter){
                        ambil_string(buffer);
                        motor_kanan = atoi(buffer);
                    }
                    
                }*/
                if(motor_kiri)pwm_kiri-=255;
                if(motor_kanan)pwm_kanan-=255;
                atur_pwm(pwm_kiri+k_stabilisator,pwm_kanan);
            }
            delay_ms(10);
        }
    }
    TIMSK = 0x01;
    lcd_gotoxy(0,1);
    lcd_putsf("     Lurus      ");
    atur_pwm(kelajuan+k_stabilisator,kelajuan);
    delay_ms(1500);
    lcd_gotoxy(0,1);
    lcd_putsf("  Belok Kanan   ");
    atur_pwm(kelajuan+k_stabilisator,-(kelajuan));
    delay_ms(1500);
    lcd_gotoxy(0,1);
    lcd_putsf("   Belok Kiri   ");
    atur_pwm((-kelajuan)+k_stabilisator,kelajuan);
    delay_ms(1500);
    lcd_gotoxy(0,1);
    lcd_putsf("     Mundur     ");
    atur_pwm((-kelajuan)+k_stabilisator,-(kelajuan));
    delay_ms(1500);
    lcd_gotoxy(0,1);
    lcd_putsf("    Berhenti    ");
    atur_pwm(0,0);
    delay_ms(1000);
    TIMSK=0x00;
    lcd_gotoxy(0,0);
    lcd_putsf("Total Waktu     ");
    lcd_gotoxy(0,1);
    sprintf(tampil,"%ds:%dms     ",detik,cacah);
    lcd_puts(tampil);
    delay_ms(1500);
    cacah=0;
    detik=0;   
    goto menu;

    kalibrasi:
    j = 0;
    indeks=0;
    lcd_clear();
    lcd_gotoxy(0,1);
    lcd_putsf("Kalibrasi...    ");
    TIMSK=0x01;
    while(1){
        TR_1=1;TR_2=0;
        delay_us(200);
        for(i=0;i<7;i++){
            nilai_adc[i]=read_adc(7-i);
        }
        TR_1=0;TR_2=1;
        delay_us(200);
        for(i=7;i<14;i++){
            nilai_adc[i]=read_adc(i-6);
        }
        if(!j){
             for(i = 0;i < 14;i++){
                ambang_atas[i] = nilai_adc[i];
                ambang_bawah[i] = nilai_adc[i];
            }
            j++;
        }
        for(i = 0;i < 14;i++){
            if(nilai_adc[i] > ambang_atas[i]){ambang_atas[i] = nilai_adc[i];}
            if(nilai_adc[i] < ambang_bawah[i]){ambang_bawah[i] = nilai_adc[i];}
        }
        if(cacah>80){
            cacah=0;
            lcd_gotoxy(indeks,0);
            lcd_putchar((j==1)?0xff:32);
            if(indeks<15){indeks++;}
            else{indeks=0;j=(j==1)?2:1;}
        }
        if(!OK){
            TIMSK=0x00;
            cacah=0;
            detik=0;
            sensor_mati;
            while(!OK)delay_ms(20);
            for(i = 0;i < 14;i++){
                e_n_tengah[i] = (ambang_atas[i] + ambang_bawah[i])/2;
                e_ambang_atas[i] = ambang_atas[i];
                e_ambang_bawah[i] = ambang_bawah[i];
            }
            indeks=1;
            goto simpan;
        }
        if(!BATAL){TIMSK=0x00;cacah=0;detik=0;sensor_mati; while(!BATAL)delay_ms(20); indeks=1;goto menu;}
    }
    
    stabilisator:
    lcd_gotoxy(0,0);
    lcd_putsf("Stabilisator    ");
    lcd_gotoxy(0,1);
    lcd_putchar(0x7E);
    while(1){
        if(!TAMBAH_NILAI){k_stabilisator++; if(k_stabilisator > 255){k_stabilisator = -255;}}
        if(!KURANG_NILAI){k_stabilisator--; if(k_stabilisator < -255){k_stabilisator = 255;}}
        lcd_gotoxy(1,1);
        sprintf(tampil, "%d              ", k_stabilisator);
        lcd_puts(tampil);
        if(!OK){while(!OK)delay_ms(20); e_k_stabilisator = k_stabilisator; goto simpan;}
        if(!BATAL){while(!BATAL)delay_ms(20); goto menu;}
        delay_ms(100);
    }
    
    delay_mulai:
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_putsf("Delay Awal      ");
    lcd_gotoxy(0,1);
    lcd_putchar(0x7E);
    while(1){
        if(!TAMBAH_NILAI)delay_awal++;
        if(!KURANG_NILAI)delay_awal--;
        lcd_gotoxy(1,1);
        sprintf(tampil,"%d  ",delay_awal);
        lcd_puts(tampil);
        if(!OK){
            while(!OK)delay_ms(20);
            e_delay_awal = delay_awal;
            indeks=2;
            goto simpan;
        }
        if(!BATAL){
            while(!BATAL)delay_ms(20);
            indeks=2;
            goto menu;
        }
        delay_ms(100);
    }
    
    counter_1:
    while(!OK||!MENU_ATAS||!MENU_BAWAH)delay_ms(20);
    i = 0;
    indeks = 0;
    lcd_clear();
    while(1){
        if(!MENU_ATAS){indeks++;if(indeks==6)indeks=0;}
        if(!MENU_BAWAH){indeks--;if(indeks==255)indeks=5;}
        if(!TAMBAH_NILAI){
            switch(indeks){
                case 0 : i++;if(i == JML_INDEKS)i= 0;break;
                case 1 : c_delay[i]++;if(c_delay[i] == 100)c_delay[i]=0;break;
                case 2 : c_timer[i]++;if(c_timer[i] == 100)c_timer[i]=0;break;
                case 3 : c_aksi[i]++;if(c_aksi[i] == 4)c_aksi[i] = 0;delay_ms(20);break;
                case 4 : c_sensor_ki[i]++;if(c_sensor_ki[i] == 6)c_sensor_ki[i] = 0;delay_ms(20);break;
                case 5 : c_sensor_ka[i]++;if(c_sensor_ka[i] == 6)c_sensor_ka[i] = 0;delay_ms(20);break;
            }
        }
        if(!KURANG_NILAI){
            switch(indeks){
                case 0 : i--;if(i == 255){i = (JML_INDEKS-1);}break;
                case 1 : c_delay[i]--;if(c_delay[i] == 255)c_delay[i]=99;break;
                case 2 : c_timer[i]--;if(c_timer[i] == 255)c_timer[i]=99;break;
                case 3 : c_aksi[i]--;delay_ms(20);break;
                case 4 : c_sensor_ki[i]--;if(c_sensor_ki[i] == 255) c_sensor_ki[i] = 5;delay_ms(20);break;
                case 5 : c_sensor_ka[i]--;if(c_sensor_ka[i] == 255) c_sensor_ka[i] = 5;delay_ms(20);break;
            }
        }
        lcd_gotoxy(1,0);
        sprintf(tampil, "I:%d ",i+1); 
        lcd_puts(tampil);
        lcd_gotoxy(6,0);
        sprintf(tampil, "D:%d ",c_delay[i]);
        lcd_puts(tampil);
        lcd_gotoxy(12,0);
        sprintf(tampil, "T:%d ",c_timer[i]);
        lcd_puts(tampil);
        lcd_gotoxy(1,1);
        switch(c_aksi[i]){
            case 0:lcd_putsf("A:Lu");break;
            case 1:lcd_putsf("A:Ka");break;
            case 2:lcd_putsf("A:Ki");break;
            case 3:lcd_putsf("A:St");break; 
            default :
                if(c_aksi[i] == 4){c_aksi[i] = 0;}
                else{c_aksi[i] = 3;}
            break;    
        }
        lcd_gotoxy(6,1);
        sprintf(tampil, "Ki:%d ",c_sensor_ki[i]);
        lcd_puts(tampil);
        lcd_gotoxy(12,1);
        sprintf(tampil, "Ka:%d",c_sensor_ka[i]);
        lcd_puts(tampil);
        lcd_gotoxy(0,0);lcd_putchar((indeks==0)?0x7E:32);
        lcd_gotoxy(5,0);lcd_putchar((indeks==1)?0x7E:32);
        lcd_gotoxy(11,0);lcd_putchar((indeks==2)?0x7E:32);
        lcd_gotoxy(0,1);lcd_putchar((indeks==3)?0x7E:32);
        lcd_gotoxy(5,1);lcd_putchar((indeks==4)?0x7E:32);
        lcd_gotoxy(11,1);lcd_putchar((indeks==5)?0x7E:32);
        if(!OK){
            while(!OK){
                if(!MENU_ATAS){
                    goto counter_2;
                }else if(!MENU_BAWAH){
                    goto counter_3;
                }
                delay_ms(20);
            }
            for(i = 0;i < JML_INDEKS;i++){
                e_c_delay[i] = c_delay[i];
                e_c_aksi[i] = c_aksi[i];
                e_c_sensor_ki[i] = c_sensor_ki[i];
                e_c_sensor_ka[i] = c_sensor_ka[i];
                e_c_timer[i] = c_timer[i];
                e_c_cp[i] = c_cp[i];
                e_c_invert[i] = c_invert[i];
                e_c_laju_ki[i] = c_laju_ki[i];
                e_c_laju_ka[i] = c_laju_ka[i];
                e_c_laju[i]=c_laju[i];
            }
            indeks=3;
            goto simpan;
        }
        if(!BATAL){
            while(!BATAL)delay_ms(20); 
            indeks=3;
            goto menu;
        }
        delay_ms(80);
    }
    
    counter_2:
    while(!OK||!MENU_ATAS||!MENU_BAWAH)delay_ms(20);
    indeks=0;
    lcd_clear();
    while(1){
        if(!MENU_ATAS){indeks++;while(!MENU_ATAS)delay_ms(20);if(indeks==5)indeks=0;}
        if(!MENU_BAWAH){indeks--;while(!MENU_BAWAH)delay_ms(20);if(indeks==255)indeks=4;}
        if(!TAMBAH_NILAI){
            switch(indeks){
                case 0:i++;if(i==JML_INDEKS)i=0;delay_ms(30);break;
                case 1:c_cp[i]=1;break;
                case 2:c_invert[i]=1;break;
                case 3:c_laju_ki[i]++;if(c_laju_ki[i]==0)c_laju_ki[i]=255;break;
                case 4:c_laju_ka[i]++;if(c_laju_ka[i]==0)c_laju_ka[i]=255;break;
            }
        }
        if(!KURANG_NILAI){
            switch(indeks){
                case 0:i--;if(i==255)i=(JML_INDEKS-1);delay_ms(30);break;
                case 1:c_cp[i]=(!i)?1:1;break;
                case 2:c_invert[i]=0;break;
                case 3:c_laju_ki[i]--;if(c_laju_ki[i]==0)c_laju_ki[i]=1;break;
                case 4:c_laju_ka[i]--;if(c_laju_ka[i]==0)c_laju_ka[i]=1;break;
            }
        }
        if(c_laju_ki[i]>maks_PWM)c_laju_ki[i]=1;
        if(c_laju_ka[i]>maks_PWM)c_laju_ka[i]=1;       
        lcd_gotoxy(1,0);
        sprintf(tampil,"I:%d ",i+1);
        lcd_puts(tampil);
        lcd_gotoxy(6,0);
        lcd_putsf("S:");
        lcd_gotoxy(8,0);
        switch(c_cp[i]){
            case 0:lcd_putsf("--");break;
            case 1:lcd_putsf("CP");break;
        }
        lcd_gotoxy(11,0);
        switch(c_invert[i]){
            case 0:lcd_putsf("NoInv");break;
            case 1:lcd_putsf("Invrt");break;
        }
        lcd_gotoxy(1,1);
        sprintf(tampil,"LKi:%d  ",c_laju_ki[i]);
        lcd_puts(tampil);
        lcd_gotoxy(9,1); 
        sprintf(tampil,"LKa:%d  ",c_laju_ka[i]);
        lcd_puts(tampil);
        lcd_gotoxy(0,0);lcd_putchar((indeks==0)?0x7E:32);
        lcd_gotoxy(5,0);lcd_putchar((indeks==1)?0x7E:32);
        lcd_gotoxy(10,0);lcd_putchar((indeks==2)?0x7E:32);
        lcd_gotoxy(0,1);lcd_putchar((indeks==3)?0x7E:32);
        lcd_gotoxy(8,1);lcd_putchar((indeks==4)?0x7E:32);
        if(!OK){
            while(!OK){
                if(!MENU_ATAS){
                    goto counter_3;
                }else if(!MENU_BAWAH){
                    goto counter_1;
                }
                delay_ms(20);
            }
            for(i = 0;i < JML_INDEKS;i++){
                e_c_delay[i] = c_delay[i];
                e_c_aksi[i] = c_aksi[i];
                e_c_sensor_ki[i] = c_sensor_ki[i];
                e_c_sensor_ka[i] = c_sensor_ka[i];
                e_c_timer[i] = c_timer[i];
                e_c_cp[i] = c_cp[i];
                e_c_invert[i] = c_invert[i];
                e_c_laju_ki[i] = c_laju_ki[i];
                e_c_laju_ka[i] = c_laju_ka[i];
                e_c_laju[i]=c_laju[i];
            }
            indeks=3;
            goto simpan;
        }
        if(!BATAL){
            while(!BATAL)delay_ms(20);
            indeks=3;
            goto menu;
        }
        delay_ms(80);
    }
    
    counter_3:
    while(!OK||!MENU_ATAS||!MENU_BAWAH)delay_ms(20);
    indeks=0;
    lcd_clear();
    while(1){
        if(!MENU_ATAS){indeks++;while(!MENU_ATAS)delay_ms(20);if(indeks==2)indeks=0;}
        if(!MENU_BAWAH){indeks--;while(!MENU_BAWAH)delay_ms(20);if(indeks==255)indeks=1;}
        if(!TAMBAH_NILAI){
            switch(indeks){
                case 0:i++;if(i==JML_INDEKS)i=0;break;
                case 1:c_laju[i]++;if(c_laju[i]==0)c_laju[i]=255;break;
            }
        }
        if(!KURANG_NILAI){
            switch(indeks){
                case 0:i--;if(i==255)i=(JML_INDEKS-1);break;
                case 1:c_laju[i]--;if(c_laju[i]==0)c_laju[i]=1;break;
            }
        }
        if(c_laju[i]>maks_PWM)c_laju[i]=1;       
        lcd_gotoxy(1,0);
        sprintf(tampil,"I:%d ",i+1);
        lcd_puts(tampil);
        lcd_gotoxy(6,0);
        sprintf(tampil,"L:%d  ",c_laju[i]);
        lcd_puts(tampil);
        lcd_gotoxy(0,0);lcd_putchar((indeks==0)?0x7E:32);
        lcd_gotoxy(5,0);lcd_putchar((indeks==1)?0x7E:32);
        if(!OK){
            while(!OK){
                if(!MENU_ATAS){
                    goto counter_1;
                }else if(!MENU_BAWAH){
                    goto counter_2;
                }
                delay_ms(20);
            }
            for(i = 0;i < JML_INDEKS;i++){
                e_c_delay[i] = c_delay[i];
                e_c_aksi[i] = c_aksi[i];
                e_c_sensor_ki[i] = c_sensor_ki[i];
                e_c_sensor_ka[i] = c_sensor_ka[i];
                e_c_timer[i] = c_timer[i];
                e_c_cp[i] = c_cp[i];
                e_c_invert[i] = c_invert[i];
                e_c_laju_ki[i] = c_laju_ki[i];
                e_c_laju_ka[i] = c_laju_ka[i];
                e_c_laju[i]=c_laju[i];
            }
            indeks=3;
            goto simpan;
        }
        if(!BATAL){
            while(!BATAL)delay_ms(20);
            indeks=3;
            goto menu;
        }
        delay_ms(80);
    }
    
    //mastiin klau udah di simpen
    simpan:
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_putsf("Simpan...       ");
    for(i=0;i<16;i++){
        lcd_gotoxy(i,1);
        lcd_putchar(0xFF);
        delay_ms(62);
    }
    if(aktifasi_serial){if(!strcmp(buffer,"a"))goto siaga;}
    goto menu;

    keluar:
    indeks=0;
    for(i=0;i<JML_INDEKS;i++){
        if(indeks==indeks_cp)break;
        if(c_cp[i])indeks++;
    }
    c_i=i;
    kelajuan_normal = kelajuan;
    lcd_clear();
    LCD = 0;
    if(c_i)goto mulai;
    atur_pwm(kelajuan+k_stabilisator,kelajuan); 
    delay_ms((!delay_awal)?1:delay_awal*10);
    mulai:
    if(!c_i||!mode){cacah=0;detik=0;TIMSK=0x01;}//Ditaruh di akhir karena sifatnya interrupt
}
//=====================================================================================
void  baca_bit_sensor(){
    unsigned char i;
    sensor=0;
    TR_1 = 1; TR_2 = 0;
    delay_us(150);
    for(i = 0;i < 7;i++){
        if(read_adc(7-i) > n_tengah[i]){sensor |= (1<<i);}
    }
    TR_1 = 0; TR_2 = 1;
    delay_us(150);
    for(i = 7;i < 14;i++){
        if(read_adc(i-6) > n_tengah[i]){sensor |= (1<<i);}
    }
    if(flag_invert)sensor=~sensor;
}
//=====================================================================================
void kendali_PID(){
    baca_bit_sensor();
    switch(sensor){
        //=================Garis Hitam=================
        case 0b00000000000001 :                         error = 13;break;
        case 0b00000000000011 : case 0b00000000000111 : error = 12;break;
        case 0b00000000000010 :                         error = 11;break;
        case 0b00000000000110 : case 0b00000000001110 : error = 10;break;
        case 0b00000000000100 :                         error = 9;break;
        case 0b00000000001100 : case 0b00000000011100 : error = 8;break;
        case 0b00000000001000 :                         error = 7;break;
        case 0b00000000011000 : case 0b00000000111000 : error = 6;break;
        case 0b00000000010000 :                         error = 5;break;
        case 0b00000000110000 : case 0000000001110000 : error = 4;break;
        case 0b00000000100000 :                         error = 3;break;
        case 0b00000001100000 : case 0b00000011100000 : error = 2;break;
        case 0b00000001000000 :                         error = 1;break;
        case 0b00000011000000 : case 0b00000111100000 : error = 0;break;
        case 0b00000010000000 :                         error = -1;break;
        case 0b00000110000000 : case 0b00000111000000 : error = -2;break;
        case 0b00000100000000 :                         error = -3;break;
        case 0b00001100000000 : case 0b00001110000000 : error = -4;break;
        case 0b00001000000000 :                         error = -5;break;
        case 0b00011000000000 : case 0b00011100000000 : error = -6;break;
        case 0b00010000000000 :                         error = -7;break;
        case 0b00110000000000 : case 0b00111000000000 : error = -8;break;
        case 0b00100000000000 :                         error = -9;break;
        case 0b01100000000000 : case 0b01110000000000 : error = -10;break;
        case 0b01000000000000 :                         error = -11;break;
        case 0b11000000000000 : case 0b11100000000000 : error = -12;break;
        case 0b10000000000000 :                         error = -13;break;
        //================Putih Semua==================
        case 0b00000000000000 :
        if(!mode){ 
            if(error>2)error = 13;
            else if(error<-2)error = -13;
            else error = 0;
        }
        break;
        //==================Dua garis==================
        case 0b00000000110011 : case 0b00000000010011 : case 0b00000000001001 : error=5;break;
        case 0b00000001100110 : case 0b00000000100110 : case 0b00000000110010 : error=4;break;
        case 0b00000001001100 : case 0b00000001101100 : case 0b00000001100100 : error=3;break;
        case 0b00000010011000 : case 0b00000001001000 : error=2;break;
        case 0b00000100110000 : case 0b00000110110000 : case 0b00000110010000 : case 0b00000010010000 : error=1;break;
        case 0b00000100100000 : case 0b00001100110000 :  error=0;break;
        case 0b00001100100000 : case 0b00001101100000 : case 0b00001001100000 : case 0b00001001000000 : error=-1;break;
        case 0b00011001000000 : case 0b00010010000000 : error=-2;break;
        case 0b00110010000000 : case 0b00110110000000 : case 0b00100110000000 : error=-3;break;
        case 0b01100110000000 : case 0b01100100000000 : case 0b01001100000000 : error=-4;break;
        case 0b11001100000000 : case 0b11001000000000 : case 0b10010000000000 : error=-5;break;
        //=============Hitam Samping==================
        case 0b0000000000001111 : error = 4;break; 
        case 0b0000000000011111 : error = 3;break;
        case 0b0000000000111111 : error = 2;break;
        case 0b0000000001111111 : error = 1;break;
        case 0b1111111100000000 : case 0b0000000011111111 : error = 0;break;
        case 0b1111111000000000 : error = -1;break;
        case 0b1111110000000000 : error = -2;break;
        case 0b1111100000000000 : error = -3;break;
        case 0b1111000000000000 : error = -4;break;
        //============================================
        default :break;      
    }
    
    if(mode){
        if(timer_aktif&&(detik*1000+cacah)>=target_timer){
            timer_aktif=0; 
            kelajuan = kelajuan_normal; 
            c_i++;
            if(c_i>=JML_INDEKS){
                c_i=(JML_INDEKS-1);
                flag_berhenti=1;
            }
        }    
        else if(timer_aktif)goto lewat;
        sen_dep = (sensor&0b00000111100000)?1:(c_sensor_ki[c_i]&&c_sensor_ka[c_i])?1:!(c_sensor_ki[c_i]|c_sensor_ka[c_i]);
        sen_ki = (c_sensor_ki[c_i])?sensor&sensor_ki[c_sensor_ki[c_i]]:!(sensor>>9);
        sen_ka = (c_sensor_ka[c_i])?sensor&sensor_ka[c_sensor_ka[c_i]]:!(sensor<<9);
        if(sen_dep&&sen_ki&&sen_ka){
            sensor_mati;
            switch(c_aksi[c_i]){
                case 0: atur_pwm(c_laju_ki[c_i],c_laju_ka[c_i]);break;
                case 1: atur_pwm(c_laju_ki[c_i],-(c_laju_ka[c_i]));break;
                case 2: atur_pwm(-(c_laju_ki[c_i]),c_laju_ka[c_i]);break;
                case 3: atur_pwm(0,0);flag_berhenti=1;break;
            }
            LCD=1;delay_ms((c_delay[c_i])?c_delay[c_i]*10:1);LCD=0;
            if(c_invert[c_i])flag_invert=!flag_invert;
            if(c_timer[c_i]&&!timer_aktif){timer_aktif=1;kelajuan=c_laju[c_i];target_timer=detik*1000+cacah+c_timer[c_i]*100;}
            else{c_i++;if(c_i>=JML_INDEKS){c_i=JML_INDEKS-1;flag_berhenti=1;}}
        }
        lewat:
    }
    
    //error = SP - PV;
    P = (kP * error);

    // kalau mau make integrasi bisa dihapus tanda komennya
    //I = I + error;
    //I = (kI * I);

    pesat_error = error - error_terakhir;
    D = (kD * pesat_error);
    error_terakhir = error;

    PID = P + D;//+ I
    pwm_kanan = kelajuan - PID;
    pwm_kiri = kelajuan + PID;
    
    atur_pwm(pwm_kiri + k_stabilisator, pwm_kanan);
}

//=====================================================================================
void inisialisasi(){
    //yang input diaktifasiin pull up dulu
    //kaya PORT A dan C
    PORTA = 0xFF;
    DDRA = 0x00;
    PORTC = 0x3F;
    DDRC = 0xC0;
    PORTB = 0x00;
    DDRB = 0xFF;
    PORTD = 0x00;
    DDRD = 0x78;
    //setting PWM (mode fast PWM)
    TCCR1A=0xA1;
    TCCR1B=0x03;
    //Prescaler saya pake 64, Clock ADC nya 250KHz
    ADMUX = ADC_VREF_TYPE;
    ADCSRA = 0x86;
    //UART buat komunikasi serial 8bit non Interrupt
    /*UCSRB = (1 << RXEN)|(1 << TXEN);
    UCSRC = (1 << URSEL)|(1 << UCSZ0)|(1 << UCSZ1);
    UBRRH = (BAUD_PRESCALE >> 8);
    UBRRL = BAUD_PRESCALE;*/
    UCSRA = 0x00;
    UCSRB = (1 << RXCIE) | (1 << TXCIE) | (1 << RXEN) | (1 << TXEN);
    UCSRC = (1 << URSEL) | (1 << UCSZ0) | (1 << UCSZ1);
    UBRRH = (BAUD_PRESCALE >> 8);
    UBRRL = BAUD_PRESCALE;
    //timer
    TCCR0 = 0x05;
    TCNT0 = 0xF0;
    TIMSK = 0x01; 
    #asm("sei")
    TIMSK = 0x00;
}
//=====================================================================================
void main(void){
    unsigned char i;
    //char ch[17];
    if(e_reset_setting){ 
        e_kP = 20;
        e_kI = 0;
        e_kD = 45;
        e_maks_PWM = 200;
        e_min_PWM = 200;
        e_kelajuan = 150;
        e_delay_awal=0;
        e_k_stabilisator=0;
        for(i=0;i<JML_INDEKS;i++){
            e_c_delay[i]=25;
            e_c_timer[i]=0;
            e_c_aksi[i]=1;
            e_c_sensor_ka[i]=3;
            e_c_sensor_ki[i]=3;
            e_c_cp[i]=(!i)?1:0;
            e_c_invert[i]=0;
            e_c_laju[i]=e_kelajuan;
            e_c_laju_ki[i]=e_kelajuan;
            e_c_laju_ka[i]=e_kelajuan;
        }
        for(i=0;i<14;i++){
            e_ambang_atas[i]=200;
            e_ambang_bawah[i]=100;
            e_n_tengah[i]=150;
        }
        e_reset_setting=0;    
    }
    baca_eeprom();
    inisialisasi();
    atur_pwm(0,0);
    lcd_init(16);
    LCD=1;
    /*while(1){
        if(!OK){
            while(!OK)delay_ms(20);
            kirim_string("WOY\n");
            kirim_string("100\n");
        }
        if(rx_counter){
            lcd_gotoxy(0,0);
            ambil_string(ch);
            if(!strcmp(ch,"69")){
                sprintf(tampil,"%d",atoi(ch));
                lcd_puts(tampil);
            //if(UCSRA & (1 << RXC)){
                lcd_gotoxy(0,1);
                ambil_string(ch);
                sprintf(tampil,"%d",atoi(ch));
                lcd_puts(tampil);
            //}    
            }
        }
        //delay_ms(100);
    }*/
    pertama:
    logika_password();
    if(hitung_password<7)goto pertama;
    lcd_gotoxy(0,0);
    lcd_putsf("     Tim LC     ");
    lcd_gotoxy(0,1);
    lcd_putsf("      2017      ");
    for(i = 0;i < 10;i++){
        klap_klip;
    }
    for(i = 0;i < 7;i++)define_char(c[i], i);
    masuk_menu:
    menu();
    while (1){
    // Please write your application code here
        if(!OK||flag_berhenti){
            if(!mode||flag_berhenti)TIMSK=0x00;//Ditaruh paling awal karena sifatnya interrupt
            atur_pwm(0,0);
            sensor_mati;
            error=0;
            error_terakhir=0;
            flag_berhenti=0;
            timer_aktif=0;
            LCD=1;
            if(c_aksi[c_i]==3||c_i==(JML_INDEKS-1)||!mode){
                lcd_gotoxy(0,0);
                lcd_putsf("Total Waktu     ");
                lcd_gotoxy(0,1);
                sprintf(tampil,"%ds:%dms     ",detik,cacah);
                lcd_puts(tampil);
                detik=0;
                cacah=0;
                while(!OK)delay_ms(20);
                while(1){if(!OK){while(!OK)delay_ms(20);break;}}
            }else {while(!OK)delay_ms(20);}
            goto masuk_menu;
        }
        kendali_PID();
    }
}