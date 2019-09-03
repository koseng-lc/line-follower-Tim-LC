import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class LF_LC extends PApplet {

//===============================================================
// Setting GUI LF LC
// Tanggal : 22 Juli 2017
// Oleh : Lintang
//===============================================================



Serial myPort;
PImage bg,bg2;
int submenu; 
int kP=0;
int kI=0;
int kD=0;
int t_kP=0;
int t_kI=0;
int t_kD=0;
int maks_PWM=0;
int min_PWM=0;
int kelajuan=0;
int t_maks_PWM=0;
int t_min_PWM=0;
int t_kelajuan=0;
int pwm_kanan=0;
int pwm_kiri=0;
int motor_kanan=0;
int motor_kiri=0;
boolean sekali=false;
boolean menu_PID=false;
boolean menu_PWM=false;
boolean menu_cek_motor=false;
boolean aktifasi_serial=false;
String txt;
String buffer;
public void setup() {
  
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');
  bg = loadImage("E:\\ISENG\\bg2.jpg");
  bg2 = loadImage("E:\\ISENG\\sementara.jpg");
}
public void serialEvent(Serial myPort){
  /*if(!menu_PID&&!menu_PWM&&!menu_cek_motor){
    if(myPort.available()>0){
      buffer = myPort.readStringUntil('\n');
      if(buffer.equals("A")==true){
        if(!aktifasi_serial)aktifasi_serial=true;
        else aktifasi_serial = false;
      }
    }  
  }*/
  if(menu_PID){
    if(myPort.available()>0){
      buffer = myPort.readStringUntil('\r').trim();
      if(buffer.equals("c")){
        if(myPort.available()>0){
          kP = Integer.parseInt(myPort.readStringUntil('\n').trim());
          if(sekali)t_kP=kP;
          println(kP);
        }
      }else if(buffer.equals("d")==true){
        if(myPort.available()>0){
          kI = Integer.parseInt(myPort.readStringUntil('\n').trim());
          if(sekali)t_kI=kI;
          println(kI); 
        }
      }else if(buffer.equals("e")==true){
        if(myPort.available()>0){
          kD = Integer.parseInt(myPort.readStringUntil('\n').trim());
          if(sekali){t_kD = kD;sekali=false;}
          println(kD);
        }
      }
    }
  }else if(menu_PWM){
    if(myPort.available()>0){
      buffer = myPort.readStringUntil('\r').trim();
      if(buffer.equals("c")==true){
        if(myPort.available()>0){
          maks_PWM = Integer.parseInt(myPort.readStringUntil('\n').trim());
          if(sekali)t_maks_PWM=maks_PWM;
          println(maks_PWM);
        }
      }else if(buffer.equals("d")==true){
        if(myPort.available()>0){
          min_PWM = Integer.parseInt(myPort.readStringUntil('\n').trim());
          if(sekali)t_min_PWM=min_PWM;
          println(min_PWM); 
        }
      }else if(buffer.equals("e")==true){
        if(myPort.available()>0){
          kelajuan = Integer.parseInt(myPort.readStringUntil('\n').trim());
          if(sekali){t_kelajuan = kelajuan;sekali=false;}
          println(kelajuan);
        }
      }
    }
  }else if(menu_cek_motor){
    if(myPort.available()>0){
      buffer = myPort.readStringUntil('\r').trim();
      if(buffer.equals("b")==true){
        if(myPort.available()>0)pwm_kiri = Integer.parseInt(myPort.readStringUntil('\n').trim());
        if(myPort.available()>0)motor_kiri = Integer.parseInt(myPort.readStringUntil('\n').trim());
        if(myPort.available()>0)pwm_kanan = Integer.parseInt(myPort.readStringUntil('\n').trim());
        if(myPort.available()>0)motor_kanan = Integer.parseInt(myPort.readStringUntil('\n').trim());
      /*}else if(buffer.equals("c")==true){
        if(myPort.available()>0)motor_kiri = Integer.parseInt(myPort.readStringUntil('\n').trim());
      }else if(buffer.equals("d")==true){
        if(myPort.available()>0)pwm_kanan = Integer.parseInt(myPort.readStringUntil('\n').trim());
      }else if(buffer.equals("e")==true){
        if(myPort.available()>0)motor_kanan = Integer.parseInt(myPort.readStringUntil('\n').trim());*/
      }
    }
  }
}

int trans1=0;
int trans2=0;
public void draw(){
  if(trans1<256||trans2<256){
    if(trans1<=255){background(0);tint(255,trans1);trans1+=5;image(bg2,0,0);}
    else {image(bg2,0,0);tint(255,trans2);trans2+=15;image(bg,0,0);}
    //if(trans2==250)delay(1000); 
    delay(50);
  }else{
    tint(255,255);
    image(bg,0,0);
    //if(menu_PID){atur_PID();batang_PID();}
    //else if(menu_PWM){atur_PWM();batang_PWM();}
    //else if(menu_cek_motor){cek_motor();batang_cek_motor();}
    atur_PID();batang_PID();
    atur_PWM();batang_PWM();
    cek_motor();batang_cek_motor();
  }
}

public void atur_PID(){
  fill(0,0,0);
  text("PID",40,20);
  txt = String.format("kP  %d",kP);
  fill(0,0,0);
  text(txt,20,40);
  txt = String.format("kI   %d",kI);
  fill(0,0,0);
  text(txt,20,65);
  txt = String.format("kD  %d",kD);
  fill(0,0,0);
  text(txt,20,90);
  fill(0,0,0);
  text("Batal",40,120);  
}

public void atur_PWM(){
  fill(0,0,0);
  text("PWM",350,20);
  txt = String.format("Maks  %d",maks_PWM);
  fill(0,0,0);
  text(txt,330,40);
  if(min_PWM==0)txt = String.format("Min    %d",min_PWM);
  else txt = String.format("Min   -%d",min_PWM);
  fill(0,0,0);
  text(txt,330,65);
  txt = String.format("Laju   %d",kelajuan);
  fill(0,0,0);
  text(txt,330,90);
  fill(0,0,0);
  text("Batal",350,120);  
}

public void cek_motor(){
  fill(0,0,0);
  text("Cek Motor",675,20);
  text("Maks", 675,290-maks_PWM);
  text("Maks", 800,290-maks_PWM);
  text("Min",760,290-min_PWM);
  text("Min",885,290-min_PWM);
  text("255", 710,35);
  text("255", 835,35);
  text("-255", 735,35);
  text("-255", 860,35);
  //==================
  text("0",717,310);
  text("0",742,310);
  //=================
  text("0",842,310);
  text("0",867,310);
  line(690,295-maks_PWM,710,295-maks_PWM);
  line(815,295-maks_PWM,835,295-maks_PWM);
  line(755,295-min_PWM,775,295-min_PWM);
  line(880,295-min_PWM,905,295-min_PWM);
}

public void batang_PID(){
  if(menu_PID)
    fill(0,255,0);
  else fill(255,0,0);
  rect(20,10,10,10);
  
  fill(50);
  rect(20,110,10,10);
  
  
  fill(23,57,112,20);
  rect(65,25,255,20);
  fill(8,22,45,60);
  rect(65,25,kP,20);
  
  fill(23,57,112,20);
  rect(65,50,255,20);
  fill(8,22,45,60);
  rect(65,50,kI,20);
  
  fill(23,57,112,20);
  rect(65,75,255,20);
  fill(8,22,45,60);
  rect(65,75,kD,20);
}
public void batang_PWM(){
  if(menu_PWM)fill(0,255,0);
  else fill(255,0,0);
  rect(330,10,10,10);
  
  fill(50);
  rect(330,110,10,10);
  
  fill(23,57,112,20);
  rect(390,25,255,20);
  fill(8,22,45,60);
  rect(390,25,maks_PWM,20);
  
  fill(8,22,45,20);
  rect(390,50,255,20);
  fill(23,57,112,60);
  rect(390,50,255-min_PWM,20);
  
  fill(23,57,112,20);
  rect(390,75,255,20);
  fill(8,22,45,60);
  rect(390,75,kelajuan,20);
}

public void batang_cek_motor(){
  if(menu_cek_motor)fill(0,255,0);
  else fill(255,0,0);
  rect(655,10,10,10);
  
  fill(23,57,112,20);
  rect(710,40,20,255);
  fill(23,57,112,20);
  rect(735,40,20,255);
  
  fill(23,57,112,20);
  rect(835,40,20,255);
  fill(23,57,112,20);
  rect(860,40,20,255);
  
  if(menu_cek_motor){ 
    if(motor_kiri==0){
      fill(8,22,45,60);
      rect(710,295-pwm_kiri,20,pwm_kiri);
      fill(8,22,45,60);
      rect(735,40,20,0);
    }else{
      fill(8,22,45,60);
      rect(710,40,20,0);
      fill(8,22,45,60);
      rect(735,295-(255-pwm_kiri),20,255-pwm_kiri);
    }
    if(motor_kanan==0){
      fill(8,22,45,60);
      rect(835,295-pwm_kanan,20,pwm_kanan);
      fill(8,22,45,60);
      rect(860,40,20,0);
    }else{
      fill(8,22,45,60);
      rect(835,40,20,0);
      fill(8,22,45,60);
      rect(860,295-(255-pwm_kanan),20,255-pwm_kanan);
    }
  }
}

public void mouseClicked(){
  //PID
  if(mouseX>=20&&mouseX<30&&mouseY>=10&&mouseY<20&&!menu_PWM&&!menu_cek_motor){
    sekali=true;
    if(menu_PID)menu_PID=false;
    else menu_PID=true;
    myPort.write("a\n");
  }
  else if(mouseX>=20&&mouseX<30&&mouseY>=110&&mouseY<120&&menu_PID){
    menu_PID=false;
    myPort.write("b\n");
    kP=t_kP;
    kI=t_kI;
    kD=t_kD;
   }
   //PWM
  else if(mouseX>=330&&mouseX<340&&mouseY>=10&&mouseY<20&&!menu_PID&&!menu_cek_motor){
    sekali=true;
    if(menu_PWM){
       menu_PWM=false;
       myPort.write("a\n");
    }else{
      menu_PWM=true;
      myPort.write("b\n");
    }
  }
  else if(mouseX>=330&&mouseX<340&&mouseY>=110&&mouseY<120&&menu_PWM){
    menu_PWM=false;
    myPort.write("b\n");
    maks_PWM = t_maks_PWM;
    min_PWM = t_min_PWM;
    kelajuan = t_kelajuan;
  }
  else if(mouseX>=655&&mouseX<665&&mouseY>=10&&mouseY<20&&!menu_PID&&!menu_PWM){
    if(menu_cek_motor){
      myPort.write("a\n");
      menu_cek_motor=false;
    }else{
      myPort.write("c\n");
      pwm_kiri=kelajuan;
      motor_kiri=0;
      pwm_kanan=kelajuan;
      motor_kanan=0;
      menu_cek_motor=true;
    }
  }
}

public void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(e>0){
    //======================PID=====================
    if(menu_PID){
      if(mouseX>=65&&mouseX<315&&mouseY>=25&&mouseY<45){kP--;buffer=String.format("%d\n",kP);myPort.write("c\n");myPort.write(buffer);delay(15);}
      else if(mouseX>=65&&mouseX<315&&mouseY>=50&&mouseY<70){kI--;buffer=String.format("%d\n",kI);myPort.write("d\n");myPort.write(buffer);}
      else if(mouseX>=65&&mouseX<315&&mouseY>=75&&mouseY<95){kD--;buffer=String.format("%d\n",kD);myPort.write("e\n");myPort.write(buffer);}
    }
    //======================PWM=====================
    else if(menu_PWM){
      if(mouseX>=385&&mouseX<635&&mouseY>=25&&mouseY<45){maks_PWM--;buffer=String.format("%d\n",maks_PWM);myPort.write("c\n");myPort.write(buffer);delay(15);}
      else if(mouseX>=385&&mouseX<635&&mouseY>=50&&mouseY<70){min_PWM--;buffer=String.format("%d\n",min_PWM);myPort.write("d\n");myPort.write(buffer);delay(15);}
      else if(mouseX>=385&&mouseX<635&&mouseY>=75&&mouseY<95){kelajuan--;buffer=String.format("%d\n",kelajuan);myPort.write("e\n");myPort.write(buffer);delay(15);}
    }
  }else if(e<0){
    //======================PID=====================
    if(menu_PID){
      if(mouseX>=65&&mouseX<315&&mouseY>=25&&mouseY<45){kP++;buffer=String.format("%d\n",kP);myPort.write("c\n");myPort.write(buffer);delay(15);}
      else if(mouseX>=65&&mouseX<315&&mouseY>=50&&mouseY<70){kI++;buffer=String.format("%d\n",kI);myPort.write("d\n");myPort.write(buffer);}
      else if(mouseX>=65&&mouseX<315&&mouseY>=75&&mouseY<95){kD++;buffer=String.format("%d\n",kD);myPort.write("e\n");myPort.write(buffer);}
    }
    //======================PWM=====================
    else if(menu_PWM){
      if(mouseX>=385&&mouseX<635&&mouseY>=25&&mouseY<45){maks_PWM++;buffer=String.format("%d\n",maks_PWM);myPort.write("c\n");myPort.write(buffer);delay(15);}
      else if(mouseX>=385&&mouseX<635&&mouseY>=50&&mouseY<70){min_PWM++;buffer=String.format("%d\n",min_PWM);myPort.write("d\n");myPort.write(buffer);delay(15);}
      else if(mouseX>=385&&mouseX<635&&mouseY>=75&&mouseY<95){kelajuan++;buffer=String.format("%d\n",kelajuan);myPort.write("e\n");myPort.write(buffer);delay(15);}
    }
  }
}

public void kondisi_PWM(){
  if(pwm_kiri>maks_PWM){pwm_kiri=maks_PWM;motor_kiri=0;}
   else if(pwm_kiri<-(min_PWM)){pwm_kiri=255-min_PWM;motor_kiri=1;}
   else if(pwm_kiri>=0){motor_kiri=0;}
   else if(pwm_kiri<0){pwm_kiri=255+pwm_kiri;motor_kiri=1;}
    
   if(pwm_kanan>maks_PWM){pwm_kanan=maks_PWM;motor_kanan=0;}
   else if(pwm_kanan<-(min_PWM)){pwm_kanan=255-min_PWM;motor_kanan=1;}
   else if(pwm_kanan>=0){motor_kanan=0;}
   else if(pwm_kanan<0){pwm_kanan=255+pwm_kanan;motor_kanan=1;}  
}

public void keyPressed(){
  if(key=='w'){
    buffer = String.format("%d\n",69);
    myPort.write(buffer);
    buffer = String.format("%d\n",1919);
    myPort.write(buffer);
  }
  
  if(key==CODED){
    if(keyCode==UP&&menu_cek_motor){
      //exec("C:\\avrdude\\LF_LC_MODE_BOOTLOADER.bat");
      pwm_kiri+=5;
      pwm_kanan+=5;
      println(pwm_kiri);
      println(pwm_kanan);
      kondisi_PWM();
      myPort.write("b\n");
      buffer = String.format("%d\n",pwm_kiri);
      myPort.write(buffer);
      //myPort.write("c\n");
      buffer = String.format("%d\n",motor_kiri);
      myPort.write(buffer);
      //myPort.write("d\n");
      buffer = String.format("%d\n",pwm_kanan);
      myPort.write(buffer);
      //myPort.write("e\n");
      buffer = String.format("%d\n",motor_kanan);
      myPort.write(buffer);
      delay(15);
    }else if(keyCode==DOWN&&menu_cek_motor){
      pwm_kiri-=5;
      pwm_kanan-=5;
      kondisi_PWM();
      myPort.write("b\n");
      buffer = String.format("%d\n",pwm_kiri);
      myPort.write(buffer);
      //myPort.write("c\n");
      buffer = String.format("%d\n",motor_kiri);
      myPort.write(buffer);
      //myPort.write("d\n");
      buffer = String.format("%d\n",pwm_kanan);
      myPort.write(buffer);
      //myPort.write("e\n");
      buffer = String.format("%d\n",motor_kanan);
      myPort.write(buffer);
      delay(15);
    }
    if(keyCode==RIGHT&&menu_cek_motor){
      pwm_kiri+=5;
      pwm_kanan-=5;
      kondisi_PWM();
      myPort.write("b\n");
      buffer = String.format("%d\n",pwm_kiri);
      myPort.write(buffer);
      //myPort.write("c\n");
      buffer = String.format("%d\n",motor_kiri);
      myPort.write(buffer);
      //myPort.write("d\n");
      buffer = String.format("%d\n",pwm_kanan);
      myPort.write(buffer);
      //myPort.write("e\n");
      buffer = String.format("%d\n",motor_kanan);
      myPort.write(buffer);
      delay(15);
    }else if(keyCode==LEFT&&menu_cek_motor){
      pwm_kanan+=5;
      pwm_kiri-=5;
      kondisi_PWM();
      myPort.write("b\n");
      buffer = String.format("%d\n",pwm_kiri);
      myPort.write(buffer);
      //myPort.write("c\n");
      buffer = String.format("%d\n",motor_kiri);
      myPort.write(buffer);
      //myPort.write("d\n");
      buffer = String.format("%d\n",pwm_kanan);
      myPort.write(buffer);
      //myPort.write("e\n");
      buffer = String.format("%d\n",motor_kanan);
      myPort.write(buffer);
      delay(15);
    }
  }
}
  public void settings() {  size(1000, 666); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "LF_LC" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
