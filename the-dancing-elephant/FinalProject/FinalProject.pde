/*
*Final Project: Interactive Toy for Autistic Children
*
*Target Market: Children ages 3-10 with a main focus on ASD children.
*
*Roles Addressed: Scheduling, Entertainment, and Educational
*Corresponding Needs: Scheduling --> ASD children have a need for very 
*structrued daily schedules.  This functionality is intended to keep important
*daily alarms for the child.
*Entertainment --> The toy will have functionality of a 6 song music box, 
*selected via one of 6 inputs.  Additonal games can be uploaded later which
*employ audio prompts and 6 available inputs.  
*Educational --> The available suite of games can be stand alone educational
*programs or be a combination of education and games (i.e. educational games!)
*/
 
// The next line is needed if running in JavaScript Mode with Processing.js
/* @pjs preload="background.jpg"; */ 

import ddf.minim.*;
Minim minim;
AudioPlayer song1;
AudioPlayer song2;
AudioPlayer song3;
AudioPlayer song4;

//Variable Declaration Block
DigitalClock digitalClock;                // Clock
InputSensor LeftEar;
InputSensor RightEar;
InputSensor LeftFoot;
InputSensor RightFoot;
InputSensor Head;
Alarm Wakeup;
Alarm Breakfast;
Alarm School;
Alarm Lunch;
Alarm Nap;
Alarm Dinner;
Alarm Sleep;
TextBubble EleSpeak;
Timer timer;
Timer showTimer;

PImage bg;                      // External Background Image (base image)
PImage A1;
PImage A2;

Firework[] fs = new Firework[10];
boolean once;
boolean showGoing = false;
boolean alarmGoing = false;
int [] currentTime = new int[2];
int opMode = 0;
int userClickX;
int userClickY;
int counter = 0;
int alarmSize = 0;
String introText = "Hi! My name is Ellie! \n I'd like to play \n with you! \n \n "
                  + "Just give me a hug to \n continue! \n (click anywhere)";
String mainMenuText = "To go to Music Mode, \n press my GREEN ear \n \n " 
                  + "To go to Game Mode, \n press my RED ear \n \n"
                  + "To setup daily alarms, \n press my BLUE foot.";
String musicModeText = "Let's play some tunes! \n press an ear or a foot \n "
                  + "to hear a song. \n Tap my forehead to stop \n the song."
                  + "\n Tap my crown to return \n to the main menu";
String gameModeText = "Let's play a game! \n Press an ear or a foot \n to start"
                  + "\n \n Press my crown to return \n to the main menu";
String alarmModeText = "We can make sure all \n of our important times \n "
                  + "are up to date now. \n \n ....Unfortunately, \n we'll "
                  + "have to add this \n functionality later... \n Press Crown to return";
String surpriseFoot = "You've selected the \n SECRET FOOT \n \n If you'd like to see \n"
                  + "something special, \n press my trunk!";
String sorryReturn = "Sorry, this isn't quite \n working yet... \n \n"
                  + "Press my crown to return \n to the main menu";

String bubbleText = introText;

void setup() {
  size(570, 570);
  // The background image must be the same size as the parameters
  // into the size() method. In this program, the size of the image
  // is 570 x 570 pixels.
  smooth();
  for (int i = 0; i < fs.length; i++){
    fs[i] = new Firework();
  }
  A1 = loadImage("princeAlarmRED.jpg");
  A2 = loadImage("princeAlarmGREEN.jpg");  
  bg = loadImage("prince.jpg");            //load the image to the pointer 'bg'
  minim = new Minim(this);
  
  song1 = minim.loadFile("Pooh.mp3");
  song2 = minim.loadFile("Lullaby.mp3");
  song3 = minim.loadFile("Rockabye.mp3");
  song4 = minim.loadFile("HushBaby.mp3");
  
  digitalClock = new DigitalClock(20, 50 , 25);  //Initialize a new "digital clock"
  timer = new Timer(3000);
  showTimer = new Timer(5000);
  
  LeftEar = new InputSensor(135, 270, 40, 65);
  RightEar = new InputSensor(400, 170, 40, 65);
  LeftFoot = new InputSensor(150, 470, 50, 65);
  RightFoot = new InputSensor(395, 460, 50, 65);
  Head = new InputSensor(250, 175, 75, 35);
  
  Wakeup = new Alarm("Wakeup", 06, 00, 40);
  Breakfast = new Alarm("Breakfast", 06, 30, 50);
  School = new Alarm("School", 07, 00, 60);
  Lunch = new Alarm("Lunch", 11, 30, 70);
  Nap = new Alarm("Nap", 13, 30, 80);
  Dinner = new Alarm("Dinner", 17, 30, 90);
  Sleep = new Alarm("Sleep", 20, 30, 100);
  
  EleSpeak = new TextBubble(490, 315);
}

void draw() {
  background(bg);                          // Set Background 
  
  digitalClock.getTime();                  // Get Time  
  digitalClock.display();                  // Display Time  
          
  alarmStatus();                           // Check alarm status continuously

  componentDisplay();
  EleSpeak.display(bubbleText);

  //Alarm Test Case (to see what it looks like) --> Press 'a' to activate
  if (alarmGoing){ 
    int s = second();
    if (!timer.isFinished()){
      Wakeup.draw();
    }
    if (timer.isFinished()){
      alarmGoing =! alarmGoing;
    }
  }
  //Run the Extra Special Part
  if (showGoing){
      noStroke();
      fill(50,0,40,20);
      rect(0,0,width,height);
      for (int i = 0; i < fs.length; i++){
        fs[i].draw();
      }
  }

  fill(50);
  textAlign(LEFT); 
  textSize(12);
  text("To test the alarm response, hit the 'A' key", 25, 560);

}

////////////////////////////////////////////////////////////////////
//Display function for our sensors of interest
////////////////////////////////////////////////////////////////////
void componentDisplay(){
  //softer gray outlining points of interest
  strokeWeight(1);
  stroke(100);
  
  //Set the color of each sensor and display onscreen
  Head.colorSet(150, 150, 150);
  Head.display();  
  LeftEar.colorSet(75, 200, 75);
  LeftEar.display();
  RightEar.colorSet(200, 25, 25);
  RightEar.display();
  LeftFoot.colorSet(25, 125, 200);
  LeftFoot.display();
  RightFoot.colorSet(200, 200, 0);
  RightFoot.display();
  
  //Display Alarms onscreen for now.  
  Wakeup.display();
  Breakfast.display();
  School.display();
  Lunch.display();
  Nap.display();
  Dinner.display();
  Sleep.display();
}

void updateOpMode(int clickX, int clickY){
  //Override Return call back to main menu
  if (clickX > 184 && clickX < 275 && clickY > 75 && clickY < 145) {
     opMode = 0; 
  }
  
  //Main Menu Mode --> opMode = 0
  //Music Mode --> opMode = 1
  //Game Mode --> opMode = 2
  //Alarm Check --> opMode = 3
  //Special Show --> opMode = 4
  switch(opMode) {
    //Main Menu Mode
    case 0:
      bubbleText = mainMenuText;
      if (LeftEar.clickCheck(clickX, clickY)){
        bubbleText = musicModeText;
        opMode = 1;
      } else if (RightEar.clickCheck(clickX, clickY)){
        bubbleText = gameModeText;
        opMode = 2;
      } else if (LeftFoot.clickCheck(clickX, clickY)){
        bubbleText = alarmModeText;
        opMode = 3;
      } else if (RightFoot.clickCheck(clickX, clickY)){ 
        bubbleText = surpriseFoot;
        opMode = 4;
      } else { opMode=0;}
      break;
    //Music Mode
    case 1:  
      if (LeftEar.clickCheck(clickX, clickY)){ 
        //println("LeftEar!");
        song1.rewind();
        if (song1.isMuted()){song1.unmute();}
        song1.play();
      } else if (RightEar.clickCheck(clickX, clickY)){ 
        //println("RightEar!");
        song2.rewind();
        if (song2.isMuted()){song2.unmute();}
        song2.play();
      } else if (LeftFoot.clickCheck(clickX, clickY)){ 
        //println("LeftFoot!");
        song3.rewind();
        if (song3.isMuted()){song3.unmute();}
        song3.play();
      } else if (RightFoot.clickCheck(clickX, clickY)){ 
        //println("RightFoot!");
        song4.rewind();
        if (song4.isMuted()){song4.unmute();}
        song4.play();
      } else if (Head.clickCheck(clickX, clickY)){ 
        //println("Head!");
        song1.mute();
        song2.mute();   
        song3.mute();   
        song4.mute();
      } else {  }
      break;
    //Game Mode
    case 2:
      bubbleText = sorryReturn;
      ellieGame();
      break;
    //Alarm Set Mode
    case 3: 
      bubbleText = sorryReturn;
      alarmReset();
      break;
    //Surprise Foot Mode!
    case 4:
      if (clickX > 248 && clickX < 323 && clickY > 285 && clickY < 388) {
 
        bubbleText = "BOOM!!!! \n \n \n \n" + "Click around the screen \n "
                    + "to see what happens!";
        if (!showGoing){ 
//          specialShow = !specialShow;
          showTimer.start();
        } 
        if (!showTimer.isFinished()){
          showGoing = true;  
        }
        if (showTimer.isFinished()){
          showGoing = false;
          bubbleText = "Woohoo! \n That was fun!! \n \n " + "Press my crown to return \n"
                      + "to the main menu.";
        }
      }
      break;
  }
  
}
////////////////////////////////////////////////////////////////
//   Mouse Click Response function
////////////////////////////////////////////////////////////////
void mousePressed() {
  //Where did I click? Lets use this info to process 
  int x = mouseX;
  int y = mouseY;
  updateOpMode(x, y);
  //Debug print of opMode for decision tree
  println("x: " + x + " y: " + y);

  if (x > 0 && x < 100 && y >0 && y < 100){
    //Base function for alarm reset, to be implemented in decision tree
    alarmReset();
  }
}
///////////////////////////////////////////////////////////////////
//    MOUSE RELEASED function
///////////////////////////////////////////////////////////////////
void mouseReleased(){
  if (showGoing){
    once = false;
    for (int i = 0; i < fs.length; i++){
      if((fs[i].hidden)&&(!once)){
        fs[i].launch();
        once = true;
      }
    }
  }
}
/////////////////////////////////////////////////////////////////////
//     Key Released Function
/////////////////////////////////////////////////////////////////////
void keyReleased(){
  if (key == 'a' || key == 'A'){
    timer.start();
    alarmGoing = !alarmGoing;
  }
}
//Check Alarm against clock, if alarm needs to sound, this is where we call it.
void alarmStatus(){
  if (Wakeup.alarmCheck()){Wakeup.draw();}
  if (Breakfast.alarmCheck()){Breakfast.draw();}
  if (School.alarmCheck()) {School.draw();}
  if (Lunch.alarmCheck()) {Lunch.draw();}
  if (Nap.alarmCheck()) {Nap.draw();}
  if (Dinner.alarmCheck()) {Dinner.draw();}
  if (Sleep.alarmCheck()) {Sleep.draw();}
}

void alarmReset(){
  println("Alarm Reset Dialogue! ... To be Added");
  println(".....................................");
  
  bubbleText = "Sorry about the \n alarm setup! \n For now, you can ask \n" 
              + "Reijo to reset them for \n now.  For a demo \n press the 'A' key \n"
              + "... \n Tap my crown to return.";
}

void ellieGame(){
  println("Game play to be added at a later date.");
  println("......................................");
  bubbleText = "Sorry about the game! \n \n For now, you'll have to \n "
              + "play imagination games! \n \n Tap my crown to return \n to the menu";
}
///////////////////////////////////////////////////////////////////////////
//      INPUT SENSOR object for Toy
///////////////////////////////////////////////////////////////////////////
class InputSensor{
  float centerX;
  float centerY;
  float sensorWidth;
  float sensorHeight;
  int r, g, b;

  InputSensor(float _centerX, float _centerY, float _sensorWidth, float _sensorHeight){
    centerX = _centerX;
    centerY = _centerY;
    sensorWidth = _sensorWidth;
    sensorHeight = _sensorHeight;
  }
  void colorSet(int _r, int _g, int _b){
    r = _r;
    g = _g;
    b = _b;
  }
  void display(){
    rectMode(CENTER);
    fill(r, g, b);
    ellipse(centerX, centerY, sensorWidth, sensorHeight);  
  }
  boolean clickCheck(int x, int y) {
    if (x > centerX - sensorWidth/2 && x < centerX + sensorWidth/2
        && y > centerY - sensorHeight/2 && y < centerY + sensorHeight/2){
      return true;
    } else {
      return false;
    }
  }  
}

//////////////////////////////////////////////////////////////////////////////
//       CLOCK Object
//////////////////////////////////////////////////////////////////////////////
class DigitalClock extends Clock {
  int fontSize;
  float x, y;
   
  DigitalClock(int _fontSize, float _x, float _y) {
    fontSize = _fontSize;
    x = _x;
    y = _y;
  }
   
  void getTime() {
    super.getTime();
  }
   
  void display() {
    fill(50);
    textSize(fontSize);
    textAlign(CENTER);
    if (h>12) {
      text (h%12 + ":" + nf(m, 2) + ":" + nf(s, 2), x, y);
      text ("PM", x+60, y);
    }
    else {
      text (h + ":" + nf(m, 2) + ":" + nf(s, 2), x, y);
      text ("AM", x+60, y);
    }
    line(x-40, y+3, x+70, y+3);
    
  }
}
// Basic Clock Object
class Clock {
  int h, m, s;
  Clock() {
  }
   
  void getTime() {
    h = hour();
    currentTime[0] = h;
    m = minute();
    currentTime[1] = m;
    s = second();
  }
}
///////////////////////////////////////////////////////////////////////////////////
//    TEXTBUBBLE Object
///////////////////////////////////////////////////////////////////////////////////
class TextBubble {
  String outputString;
  int x, y;
  TextBubble (int _x, int _y){
    x = _x;
    y = _y;
  }
  
  void display(String _outputString){
    String outputString = _outputString;
        
    fill(225);
    rectMode(CENTER);
    rect(x, y, 150, 175, 10, 10 , 10, 10);
    fill(50);
    textSize(12);
    textAlign(CENTER);
    text(outputString, x, y-50);
  }
}
///////////////////////////////////////////////////////////////////////////////////
//   ALARM Object
///////////////////////////////////////////////////////////////////////////////////
class Alarm{
  String alarmID;
  int hour, minute, verticalPlace;
  
  Alarm (String name, int _hour, int _minute, int _heightY) {
    alarmID = name;
    hour = _hour;
    minute = _minute;
    verticalPlace=_heightY;
  }
  
  void display(){
    fill(50);
    textSize(10);
    text(alarmID, 25, verticalPlace);
    if (hour > 12){
      text(hour%12, 60,verticalPlace);
      if (minute == 0){text("00", 72,verticalPlace);}
      else{text(minute, 72,verticalPlace);}
      text("PM", 90, verticalPlace);  
    } else {
      text(hour, 60,verticalPlace);
      if (minute == 0){text("00", 72,verticalPlace);}
      else{text(minute, 72,verticalPlace);}
      text("AM", 90, verticalPlace);
    }
    
  }
  
  void draw(){
    int s = second();
    if (s%2 == 0){
      tint(255, 225);
      image(A1, 0, 0);
    } else {
      tint(255, 225);
      image(A2, 0, 0);
    }
    
    return;
  }
  
  String alarmID(){
    return alarmID;
  }
  
  boolean alarmCheck(){
     if (currentTime[0] == hour && currentTime[1] == minute){
       return true;
     } else {
       return false;
     }
  }
}

class Firework{
  float x, y, oldX,oldY, ySpeed, targetX, targetY, explodeTimer, flareWeight, flareAngle;
  int flareAmount, duration;
  boolean launched,exploded,hidden;
  color flare;
  Firework(){
    launched = false;
    exploded = false;
    hidden = true;
  }
  void draw(){
    if((launched)&&(!exploded)&&(!hidden)){
      launchMaths();
      strokeWeight(3);
      stroke(25, 25, 200);
      line(x,y,oldX,oldY);
    }
    if((!launched)&&(exploded)&&(!hidden)){
      explodeMaths();
      noStroke();
      strokeWeight(flareWeight);
      stroke(flare);
      for(int i = 0; i < flareAmount + 1; i++){
          pushMatrix();
          translate(x,y);
          point(sin(radians(i*flareAngle))*explodeTimer,cos(radians(i*flareAngle))*explodeTimer);
          popMatrix();
       }
    }
    if((!launched)&&(!exploded)&&(hidden)){
      //do nothing
    }
  }
  void launch(){
    x = oldX = mouseX + ((random(5)*10) - 25);
    y = oldY = height;
    targetX = mouseX;
    targetY = mouseY;
    ySpeed = random(3) + 2;
    flare = color(random(3)*50 + 100,random(3)*50 + 100,random(3)*50 + 100);
    flareAmount = ceil(random(30)) + 20;
    flareWeight = ceil(random(10));
    duration = ceil(random(4))*20 + 30;
    flareAngle = 360/flareAmount;
    launched = true;
    exploded = false;
    hidden = false;
  }
  void launchMaths(){
    oldX = x;
    oldY = y;
    if(dist(x,y,targetX,targetY) > 6){
      x += (targetX - x)/2;
      y += -ySpeed;
    }else{
      explode();
    }
  }
  void explode(){
    explodeTimer = 0;
    launched = false;
    exploded = true;
    hidden = false;
  }
  void explodeMaths(){
    if(explodeTimer < duration){
      explodeTimer+= 0.4;
    }else{
      hide();
    }
  }
  void hide(){
    launched = false;
    exploded = false;
    hidden = true;
  }
}

//////////////////////////////////////////////////////////////////////
//     TIMER
/////////////////////////////////////////////////////////////////////

class Timer {
  int savedTime;       // When Timer started
  int totalTime;       // How long Timer should last
  
  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
  }
  // Starting the timer
  void start() {
    savedTime = millis();
  }

  boolean isFinished() { // Check how much time has passed
    int passedTime = millis()-savedTime;
    if (passedTime > totalTime) {
      return true;
    }
    else {
      return false;
    }
  }
}

