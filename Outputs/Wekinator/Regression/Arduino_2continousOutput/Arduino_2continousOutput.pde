//This demo allows Wekinator to control size, increment, rotation and hue of an object
//All recieved values shoulb be continuous values between 0 and 1
//Visual sketch is modified from http://btk.tillnagel.com/tutorials/rotation-translation-matrix.html

import oscP5.*;
OscP5 oscP5;
import processing.serial.*;
Serial myPort;  // Create object from Serial class

float newVal1, newVal2;
float value1, value2;
float l1, l2;

void setup() {  
  size(600, 600);
  background(0);
  oscP5 = new OscP5(this, 12000);

  //to arduino
  printArray(Serial.list());
  String portName = Serial.list()[1];
  myPort = new Serial(this, portName, 9600); //must be 9600 speed
}

void draw () {

  newVal1=map(value1, 0, 1, 0, 180);//map to whatever range your physical device needs. 
  newVal2=map(value2, 0, 1, 0, 180);//eg: 180º for servo motor

  l1=lerp(l1, newVal1, 0.1);
  l2=lerp(l2, newVal2, 0.1);
  background(255/l1, 255/l2, 0); //visualise the change. 


  //visual of recieved data
  pushMatrix();
  noStroke();
  fill(255, 0, 0);  
  rect(100, 100, 60, l1);
  rect(400, 100, 60, l2);
  popMatrix();

  //draw and send info
  drawText();


  if (frameCount%10==0) {
    serialSend();
  }
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs")==true) {
    if (theOscMessage.checkTypetag("ff")) { // looking for 2 parameters
      value1 = theOscMessage.get(0).floatValue();
      value2 = theOscMessage.get(1).floatValue();



      //println("newVal1: "+newVal1+" newVal2: "+newVal2);
    } else {
      println("Error: unexpected OSC message received by Processing: ");
      theOscMessage.print();
    }
  }
}

void drawText() {
  stroke(0);
  textAlign(LEFT, TOP); 
  textSize(14);
  fill(255);

  text("Listening for message /wek/inputs on port 12000", 10, 10);
  text("Expecting 2 continuous numeric outputs, all in range 0 to 1:", 10, 25);
  text("values are then mapped between 0-180 and sent to arduino", 10, 40);
}

void serialSend() {

  myPort.write(int(newVal1)+","+int(newVal2)+";"); //make it 2 outputs

}
