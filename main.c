/* MAIN.C file
 * 
 * Copyright (c) 2002-2005 STMicroelectronics
 */
#include "STM8S001J3.h"
#include "stm8s_bit.h"
//#include "stdio.h"
#include "relay.h"
#include "pwm.h"
#include "adc.h"
#include "delay.h"
#include "global.h"
#include "uart.h"
#include "eeprom.h"
#include <string.h>

typedef enum {MODE0 = 0, MODE1 = 1, MODE2 = 2, MODE3 = 3, MODE4 = 4, MODE5 = 5, MODE6 = 6} Mode;
typedef enum {STATE0 = 0, STATE1 = 1, STATE2 = 2, STATE3 = 3, STATE4 = 4, STATE5 = 5, STATE6 = 6} State;


unsigned char brightness = BRIGHTNESS; //brightness(0~100),brightness should be add about 3 is correct
unsigned char read_Flash[11] = {0};
unsigned int second = 0;
unsigned int night_Time = DEFAULT_TIME;//43200;

bool relayStat = ON;
bool isDimmingConfiged = FALSE;
bool timeChanged = FALSE;
State state;
static State ex_state = STATE0;

void DimmingMode(Mode mode)
{
	if(LIGHT == ON)
	{
		switch (mode)
		{
			case MODE0:
				if((second >= 0) && (second < 0.4*night_Time))//50% Night Time, about 6 hours
					state = STATE1;
				else if((second >= 0.4*night_Time) && (second < 0.6*night_Time))//35% Night Time, about 4 hours
					state = STATE2;
				else if((second >= 0.6*night_Time) && (second < 0.8*night_Time)) //15% Night Time, about 2 hours
					state = STATE3;
				else
					state = STATE4;
			break;		
	
			case MODE2:
				if(second >= 0 && second < RX_Buf[0])
					state = STATE1;
				else if(second>=read_Flash[0] && second<(read_Flash[0]+read_Flash[2]))
					state = STATE2;
				else if(second>=(read_Flash[0]+read_Flash[2]) && second<(read_Flash[0]+read_Flash[2]+read_Flash[4]))
					state = STATE3;					
				else if(second>=(read_Flash[0]+read_Flash[2]+read_Flash[4]) && second<(read_Flash[0]+read_Flash[2]+read_Flash[4]+read_Flash[6]))
					state = STATE4;
				else if(second>=(read_Flash[0]+read_Flash[2]+read_Flash[4]+read_Flash[6]) && second<(read_Flash[0]+read_Flash[2]+read_Flash[4]+read_Flash[6]+read_Flash[8]))
					state = STATE5;
				else
					state = STATE6;
			break;
			
			default:	break;
		}
	}
	//when state changed
	if(ex_state != state)
	{
		if(mode == MODE5)
		{
			switch (state)
			{
				case STATE0:	PWM_Config(100, 0);	break;//never run to STATE0
				case STATE1:	PWM_Config(100, 100);	break;
				case STATE2:	PWM_Config(100, 75);	break;			
				case STATE3:	PWM_Config(100, 50);	break;
				case STATE4:	PWM_Config(100, 60);	break;
				case STATE5:	PWM_Config(100, 60);	break;
				default: break;
			}		
		}
		else if(mode == MODE2)
		{
			switch (state)
			{
				case STATE0:	PWM_Config(100, 0);	break;//never run to STATE0
				case STATE1:	PWM_Config(100, read_Flash[1]);	break;
				case STATE2:	PWM_Config(100, read_Flash[3]);	break;			
				case STATE3:	PWM_Config(100, read_Flash[5]);	break;
				case STATE4:	PWM_Config(100, read_Flash[7]);	break;
				case STATE5:	PWM_Config(100, read_Flash[9]);	break;			
				case STATE6:	PWM_Config(100, 0);	break;
				default: break;
			}		
		}		
		else
		{
			switch (state)
			{
				case STATE0:	PWM_Config(100, 0);	break;//never run to STATE0
				case STATE1:	PWM_Config(100, 100);	break;
				case STATE2:	PWM_Config(100, brightness);	break;			
				case STATE3:	PWM_Config(100, 80);	break;			
				default: break;
			}
		}
	}	else;//when state no change, do nothing
	ex_state = state;
}
		

main()
{
	volatile unsigned char i = 0;
	volatile static unsigned char adcCount = 0;
	volatile unsigned char offCount = 0;
	volatile unsigned char onCount = 0;
	volatile unsigned int on_time;
	volatile unsigned long int temp = 0;
	volatile unsigned char index_on_time = 0;
	unsigned char threshold_count = ONOFF_TIME_DELAY*2;//on/off lux continues threshold

	bool exRelayStat = OFF;
	static unsigned int adcData[ONOFF_TIME_DELAY*2] = {0};
	//CFG_GCR = 0x00;//PD1 default SWIM
	CLK_CKDIVR = 0x08;//f = f HSI RCÊä³ö/2=8MHz
	TIM4_Init();//use for delay, high
	
	//if there is no data in Flash, set to default time
	for(i=0;i<10;i++)
	{
		temp = FLASH_ReadByte(0x4000+i);
		if((temp<TIME_LOWER_LIMIT)||(temp>TIME_UPPER_LIMIT))
		{
			UnlockEEPROM();
			FLASH_ProgramByte(0x4000+i, DEFAULT_TIME);
			LockEEPROM();
		}
	}
	index_on_time = FLASH_ReadByte(0x400A);
	index_on_time %= 10;//in case index_on_time lager than 9
	
	//Read from Flash to get night_time
	for(i=0;i<10;i++)
	{
		temp += FLASH_ReadByte(0x4000+i);
	}
	night_Time = temp / 10;
	
	//delay a while in cace ADC get the wrong voltage
	Delay1s(); Delay1s(); //Delay1s(); Delay1s(); Delay1s(); //about 5s

	PWM_GPIO_Config();//Dimming IO config, use TIM2
	//Get ADC initial data and check the light ON/OFF state
	InitADC();	
	for(i=0;i<threshold_count;i++)
		adcData[i] = GetADC();

	Rly_GPIO_Config();

	if(adcData[0] < OFF_LUX)//initial LIGHT IO
	{
		LIGHT = OFF;
		PWM_Config(100, 0);//PWM off
	}
	else
	{
		LIGHT = ON;
		PWM_Config(100, 100);//PWM off
	}

	//Time1 use for time counter, 1S/interrupt service
	TIM1_Init();
	_asm("rim"); //Enable interrupt

	while(1)
	{
		adcData[adcCount++] = GetADC();
		if(adcCount >= threshold_count)	
			adcCount = 0;
		for(i=0;i<threshold_count;i++)
		{
			if(adcData[i] < OFF_LUX)
				offCount += 1;
			else if(adcData[i] > ON_LUX)
				onCount += 1;
			else;//do nothing
		}
		//only when the lux continue more than threshold_count time
		//if it's daytime, turn the light off
		if(offCount >= threshold_count)
		{
			if(LIGHT == ON)//only when light on/off change 
			{
				LIGHT = OFF;//Relay_IO = 1
				PWM_Config(100, 0);//PWM off
				TIM1_CR1 &= 0xFE;//stop time counter
				
				//save time of night to Flash, Prevent daytime power-on and abnormal switch conditions
				if((second >= TIME_LOWER_LIMIT) && (second <= TIME_UPPER_LIMIT))
				{
					UnlockEEPROM();
					FLASH_ProgramByte(0x4000+index_on_time, second);
					index_on_time++;
					index_on_time %= 10;
					FLASH_ProgramByte(0x400A, index_on_time);
					for(i=0;i<10;i++)
					{
						temp += FLASH_ReadByte(0x4000+i);
					}
					night_Time = temp / 10;
					LockEEPROM();
				}				
			}
			if(state != STATE0)
				ex_state = state = STATE0;
			second = 0;
			//hour = 0;
		}
		//if it's nighttime, turn the light on
		else if(onCount >= threshold_count)
		{
			if(LIGHT == OFF)//only when light on/off change 
			{
				LIGHT = ON;//Relay_IO = 0
			}
			if((TIM1_CR1 & 0x01) == 0)//if time1 counter not started, start counting
			{
				second = 0;
				//hour = 0;
				TIM1_CR1 |= 0x01;//start time counter
				TIM1_IER |= 0x01;				
			}
			if(state == STATE0)
			{
				PWM_Config(100, 100);
			}
		}
		else;//when the the lux is between ON/OFF, do nothing		
		
		DimmingMode(userMode);		
		offCount = 0;
		onCount  = 0;
		Delay500ms();
	}
}

/****************************************************/
@far @interrupt void TIM1_UPD_IRQHandler(void)
{
	unsigned char i = 0;
	TIM1_SR1 &= 0xFE;//clear interrupt label
	second++;
	if(second >= TIME_UPPER_LIMIT)
	{
		second = TIME_UPPER_LIMIT;
		TIM1_CR1 &= 0xFE;//stop time counter
	}
}

