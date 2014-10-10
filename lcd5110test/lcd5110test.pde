#include <LCD5110.h>
#include <stdio.h>
#include <string.h>
#include <DS1302.h>

LCD5110 lcd(3,4,5,6,7,8);

/* DS1302接口定义
CE(DS1302 pin5) -> Arduino D5
IO(DS1302 pin6) -> Arduino D6
SCLK(DS1302 pin7) -> Arduino D7
*/
uint8_t CE_PIN   = 9;
uint8_t IO_PIN   = 10;
uint8_t SCLK_PIN = 11;
/* 日期变量缓存 */
char buf[50];
char day[10];
/* 串口数据缓存 */
String comdata = "";
int numdata[7] ={0}, j = 0, mark = 0;
/* 创建 DS1302 对象 */
DS1302 rtc(CE_PIN, IO_PIN, SCLK_PIN);

void print_time()
{
    /* 从 DS1302 获取当前时间 */
    Time t = rtc.time();
    /* 将星期从数字转换为名称 */
    memset(day, 0, sizeof(day));
    switch (t.day)
    {
    case 1: strcpy(day, "Sunday"); break;
    case 2: strcpy(day, "Monday"); break;
    case 3: strcpy(day, "Tuesday"); break;
    case 4: strcpy(day, "Wednesday"); break;
    case 5: strcpy(day, "Thursday"); break;
    case 6: strcpy(day, "Friday"); break;
    case 7: strcpy(day, "Saturday"); break;
    }
    /* 将日期代码格式化凑成buf等待输出 */
    snprintf(buf, sizeof(buf), "%s %04d-%02d-%02d %02d:%02d:%02d", day, t.yr, t.mon, t.date, t.hr, t.min, t.sec);
    /* 输出日期到串口 */
    Serial.println(buf);
    /*LCD 5110*/
     lcd.clearScreenOrigin();
     lcd.sendStr(buf);
}
void setup(){
  rtc.write_protect(false);
  rtc.halt(false);
  
  lcd.init();
  lcd.setBacklight(true);
  Serial.begin(9600);
}

void loop(){
  /* 打印当前时间 */
    print_time();
    delay(1000);
//  if (Serial.available() > 0){
//    lcd.clearScreenOrigin();
//    while (Serial.available() > 0)
//      lcd.sendChar(Serial.read());
//  }
//  else {
//    delay(500); 
//  }
}
