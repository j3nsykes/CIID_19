/**
 *Drawing tool Etcha-Sketch like. 
 * References Andreas Refsgaard 5 input code methods. 
 * Modified by Jen Sykes to recive 4 continious values between 0.0-1.0 from Wekinator
 */

import oscP5.*;
OscP5 oscP5;

float left, rawLeft = 150;
float right, rawRight = 150;
float size = 20;

float lerpFactor = 0.15; //Set between 0.0 (full smoothing) and 0.99 (no smoothing)

void setup() {
  size(1024, 768, P3D);
  oscP5 = new OscP5(this, 12000);

  fill(255);
}

void draw() {
  background(0);
  drawLine();
}

void drawLine() {


  //Lerp the values

  left = lerp(left, rawLeft, lerpFactor);
  right = lerp(right, rawRight, lerpFactor);

  rect(left, right, size, size);
}


void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs")==true) {
    if (theOscMessage.checkTypetag("fff")) { // looking for 4 parameters
      rawLeft = map(theOscMessage.get(0).floatValue(), 0, 1, 0, width);
      rawRight = map(theOscMessage.get(1).floatValue(), 0, 1, 0, height);
      size=map(theOscMessage.get(2).floatValue(), 0, 1, 20, 100);
      
    } else {
      println("Error: unexpected OSC message received by Processing: ");
      theOscMessage.print();
    }
  }
}
