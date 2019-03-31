import processing.serial.*;
Serial myPort;  // Create object from Serial class
float posX, posY;

void setupSerial() {
  //to arduino
  printArray(Serial.list());
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
}

void sendMessage() {
  posX=lerp(posX, x, 0.08);
  posY=lerp(posY, y, 0.08);
  println("posX: "+posX+" posY: " + posY);
  
  float scaleX=map(posX,300,400,0,180); //scale movements into physical motion
  float scaleY=map(posY,200,300,0,180); //scale movements into physical motion
  
  byte out[] = new byte[2];
  out[0] = byte(scaleX);
  out[1] = byte(scaleY);

  myPort.write(out);
  //myPort.write(scaleX +","+ scaleY +"\n"); //alternate method
}
