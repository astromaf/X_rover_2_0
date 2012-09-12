/*
 MIGUEL ANGEL DE FRUTOS CARRO
 AEROBOT Club de Robotica de Aeronauticos_UPM
 18/10/2010_Madrid
 
 */

#include <Wire.h>
#include "nunchuck_funcs.h"
#include <Servo.h> 

#include <CompactQik2s9v1.h>
#include <NewSoftSerial.h>

#define rxPin 3
#define txPin 4
#define rstPin 5

NewSoftSerial mySerial =  NewSoftSerial(rxPin, txPin);
CompactQik2s9v1 motor = CompactQik2s9v1(&mySerial,rstPin);
Servo myservo; 
byte fwVersion = -1;

int a = 90; //Velocidad de Avance-Retroceso (0-100)
int g = 80;//Velocidad de Giro (0-100)

int loop_cnt=0;

byte accx,accy,zbut,cbut;
int ledPin = 13;


void setup()
{
    Serial.begin(19200);
    mySerial.begin(9600);
  motor.begin();
  motor.stopBothMotors();
    //nunchuck_setpowerpins();
    nunchuck_init(); // send the initilization handshake
     myservo.attach(7);
     myservo.write(90);
            delay(15);
    
    Serial.print("WiiChuckDemo ready\n");
}

void loop()
{
    if( loop_cnt > 100 ) { // every 100 msecs get new data
        loop_cnt = 0;
  myservo.write(90);
  delay(15);
        nunchuck_get_data();

        accx  = nunchuck_accelx(); // ranges from approx 70 - 182
        accy  = nunchuck_accely(); // ranges from approx 65 - 173
        zbut = nunchuck_zbutton();
        cbut = nunchuck_cbutton(); 
        int joyY= nunchuck_joyy();
        int joyX= nunchuck_joyx();
        
      Serial.print("accx: "); Serial.print((byte)accx,DEC);
        Serial.print("\taccy: "); Serial.print((byte)accy,DEC);
        Serial.print("\tjY: "); Serial.print((byte)joyX,DEC);
        Serial.print("\tjX: "); Serial.println((byte)joyY,DEC);
        
     
        
              if(zbut==false & cbut==true){
                   Serial.println("C");   
               
                   if((accy>100)&(accy<170 )&(accx<200 )&(accy>145 )){
                       motor.stopBothMotors();
                       delay(200); 
                    }
                    
                     if((accy>185 )&(accx<200 )&(accy>145 )){
                       motor.motor0Reverse(a-20); 
                       motor.motor1Reverse(a-20);
                       delay(200); 
                    }
                   if((accy<100)&(accx<200 )){
                       motor.motor0Forward(a-20); 
                       motor.motor1Forward(a-20);
                       delay(200); 
                    }
                   
                    if((accx>200 )&(accy>170)){ //DERECHA
                       motor.motor1Reverse(g-20); 
                       motor.motor0Forward(g-20);
                       
                    }
                    
                    if((accx<145 )&(accy>160)){ //IZQ
                       motor.motor0Reverse(g-20); 
                       motor.motor1Forward(g-20);
                      
                    }
               
               
               
              }
              
              else if(zbut==true & cbut==true){ 
           Serial.println("Z");
            motor.stopBothMotors();
         delay(50); 
              if(joyX<174){
              myservo.write(92);
              delay(400);
              }
               if(joyX>174){
              myservo.write(88);
              delay(400);
              }
                myservo.write(90);
                delay(15);
               }
         
          
              
        else if(joyY==174 & joyX==174 & zbut==false & cbut==false ){
        motor.stopBothMotors();
         delay(50); 
        }
         
        
        else if(joyY<174 & joyX==174 & zbut==false & cbut==false){
          
        motor.motor0Forward(a); 
        motor.motor1Forward(a);
        delay(50);
        }
         if(joyY>174 & joyX==174 & zbut==false & cbut==false){
       motor.motor0Reverse(a); 
       motor.motor1Reverse(a);
         delay(50); 
        }
        else if(joyX>174 & joyY==174 & zbut==false & cbut==false){
        motor.motor0Forward(g);
         motor.motor1Reverse(g);
         delay(50); 
        }
        
        else if(joyX<174 & joyY==174 & zbut==false & cbut==false){
       motor.motor0Reverse(g);
        motor.motor1Forward(g);
         delay(50); 
        }
      
    }
     
    loop_cnt++;
    delay(1);
}

