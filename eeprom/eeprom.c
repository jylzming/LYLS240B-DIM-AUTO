#include "eeprom.h"

#define FLASH_BLOCK_SIZE         128
#define FLASH_DATA_BLOCKS_NUMBER 8

unsigned char WriteBuffer[FLASH_BLOCK_SIZE] = "STM8S�ڲ�EEPROM����!\r\n";
unsigned char ReadBuffer[FLASH_BLOCK_SIZE];

unsigned char UnlockEEPROM(void)
{
  FLASH_DUKR=0xAE;
  FLASH_DUKR=0x56;
  
  if(FLASH_IAPSR&0x08)//FLASH_IAPSR_DULλ=0Ϊд����
    return 1;
  else
    return 0;
}

void LockEEPROM(void)
{
  FLASH_IAPSR&=0xFD;
}

void FLASH_EraseByte(unsigned long address)
{
  *(@near unsigned char*)(unsigned int)address=0x00;
}
/*******************************************************************************
****��������:д������ַ
****��ڲ���:
****���ڲ���:
****������ע:
*******************************************************************************/
void FLASH_ProgramByte(unsigned long address, unsigned char Data)
{
    *(@near unsigned char*)(unsigned int)address = Data;
}
/*******************************************************************************
****��������:��������ַ
****��ڲ���:
****���ڲ���:
****������ע:
*******************************************************************************/
unsigned char FLASH_ReadByte(unsigned long address)
{
   return(*(@near unsigned char*)(unsigned int)address); 
}
/*******************************************************************************
****��������:����������
****��ڲ���:
****���ڲ���:
****������ע:
*******************************************************************************/
void FLASH_EraseBlock(unsigned int address)
{
  unsigned long @near *temp;
  while(!UnlockEEPROM());
  temp=(@near unsigned long*)(unsigned int)(0x4000+address*FLASH_BLOCK_SIZE);
  
  FLASH_CR2|=0x10;
  FLASH_NCR2&=0xDF;
  
  *temp=0;

  
  while(!(FLASH_IAPSR&0x04));
}
/*******************************************************************************
****��������:д������
****��ڲ���:
****���ڲ���:
****������ע:
*******************************************************************************/
void FLASH_ProgramBlock(unsigned int address,unsigned char *buffer)
{
  unsigned long temp;
  unsigned int count;
  
  temp=0x4000+((unsigned long)address*FLASH_BLOCK_SIZE);
     
  for(count=0;count<FLASH_BLOCK_SIZE;count++)
  {
    *((@near unsigned char*)(unsigned int)temp+count)=buffer[count];
  }
}
/*******************************************************************************
****��������:��������
****��ڲ���:
****���ڲ���:
****������ע:
*******************************************************************************/

/*******************************************************************************
****��������:д������
****��ڲ���:
****���ڲ���:
****������ע:
*******************************************************************************/
void WriteData(unsigned char BlockStartAddress,unsigned char *Buffer,unsigned char BlockNum)
{
   unsigned char  BlockNum_Temp;
  /* ���� flash data eeprom memory */
  while(!UnlockEEPROM());
  
  for(BlockNum_Temp=BlockStartAddress;BlockNum_Temp<BlockNum;BlockNum_Temp++)
  {
    if(BlockNum_Temp>FLASH_DATA_BLOCKS_NUMBER)
        break;
   
    FLASH_ProgramBlock(BlockNum_Temp, Buffer+BlockNum_Temp*FLASH_BLOCK_SIZE);
     while(!(FLASH_IAPSR&0x04));
      
     
  }
  
  LockEEPROM();/*������Ҫ����*/
}
/*******************************************************************************
****��������:��������
****��ڲ���:
****���ڲ���:
****������ע:
*******************************************************************************/
void ReadData(unsigned char BlockStartAddress,unsigned char *Buffer,unsigned char BlockNum)
{
   unsigned long add, start_add, stop_add;
  start_add = 0x4000+(unsigned long)((BlockNum-1)*FLASH_BLOCK_SIZE);
  stop_add = 0x4000 + (unsigned long)(BlockNum*FLASH_BLOCK_SIZE);
 
  for (add = start_add; add < stop_add; add++)
      Buffer[add-0x4000]=FLASH_ReadByte(add);
}
