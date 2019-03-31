import netP5.*;
import oscP5.*;

OscP5 oscP5;
NetAddress dest;
int bg = 0;

void setup() {
  serialSetup();
  size(500, 500);
  oscP5 = new OscP5(this, 9000);
  dest = new NetAddress("127.0.0.1", 6448); //weki destination port
}

void draw() {
  background(bg); 
  if (frameCount % 2 == 0) {
    sendOsc();
  }
  //visualise the data
  noStroke();
  fill(200);
  for (int i = 0; i<data.length; i++) {
    rect(50+(i*100), 50, 50, data[i]);//capacitive data dispaly 
  }
}

void sendOsc() {
  OscMessage msg = new OscMessage("/wek/inputs");
  for (int i = 0; i<inputs.length; i++) {
    msg.add(inputs[i]); //send all inputs to Weki
  }

  oscP5.send(msg, dest);
}
