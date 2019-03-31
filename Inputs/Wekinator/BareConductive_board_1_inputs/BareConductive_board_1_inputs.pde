//simple touch board example adapted from BareConductive https://github.com/BareConductive/simple_touch_board_sketch
//modified to send values to Wekinator by Jen Sykes

import processing.serial.*;

import netP5.*;
import oscP5.*;

OscP5 oscP5;
NetAddress dest;
int xPos = 1;         // horizontal position of the graph
int wekiInputs=1;

void setup() {
  touchBoardSetup();
  size(500, 500);
  background(0);
  oscP5 = new OscP5(this, 9000);
  dest = new NetAddress("127.0.0.1", 6448);
}

void draw() {
  background(0);
  if (frameCount % 2 == 0) {
    sendOsc();
  }
  //visualise the data
  noStroke();
  fill(200);
  rect(50, 0, 50, height-proximity[0]);//electron 1
  //rect(150, 0, 50, height-proximity[1]); //electron 2
  //rect(250, 0, 50, height-proximity[2]); //electron 3
  //rect(350, 0, 50, height-proximity[3]); //electron 4
}

void sendOsc() {
  OscMessage msg = new OscMessage("/wek/inputs");
  for (int i = firstElectrode; i < wekiInputs; i++) {
    msg.add(proximity[i]);
  }

  oscP5.send(msg, dest);
}
