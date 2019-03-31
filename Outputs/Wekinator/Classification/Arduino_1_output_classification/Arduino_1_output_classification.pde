//this example allows Wekinator to control Arduino via Serial
//using Classification labels to set differring values a physical component receives. 

import oscP5.*;
OscP5 oscP5;
import processing.serial.*;
Serial myPort;  // Create object from Serial class

float val;
int currentClass; 


void setup() {  
  size(700, 600);
  oscP5 = new OscP5(this, 12000);

  //to arduino
  printArray(Serial.list());
  String portName = Serial.list()[3];
  myPort = new Serial(this, portName, 9600);
}

void draw () {
  background(0);

  drawText();
  //visual of recieved data
  noStroke();
  fill(255);  
  textSize(64);
  text(currentClass, width/2, height/2);
  serialSend();
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    currentClass = (int) theOscMessage.get(0).floatValue();
  }
}

void drawText() {
  stroke(0);

  textAlign(LEFT, TOP); 
  fill(255);
  pushMatrix();
  textSize(16);
  text("Listening for message /wek/inputs on port 12000", 10, 10);
  text("Classifier states 1 - 5 send controlled outputs", 10, 40);
  popMatrix();

  switch(currentClass) { //change state depending on classifier label
  case 1:
    val=0; //set control values to be sent to Arduino
    break;

  case 2:
    val=45; //set control values to be sent to Arduino
    break;

  case 3:
    val=90; //set control values to be sent to Arduino
    break;

  case 4:
    val=120; //set control values to be sent to Arduino
    break;

  case 5: 
    val=180; //set control values to be sent to Arduino
    break;
  }
}

void serialSend() {
  //send to Arduino 
  myPort.write(int(val)+";");
}
