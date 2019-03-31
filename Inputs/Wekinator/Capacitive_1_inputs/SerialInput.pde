import processing.serial.*;
Serial myPort;
String inString;
float[] inputs = new float [2]; //change to how many you send. 
float [] data      = new float[2];

void serialSetup() {
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[3], 9600);
  myPort.bufferUntil('\n');
}

void serialEvent(Serial p) {
  inString = p.readStringUntil('\n');
  inString = trim(inString); //get rid of any white space

  // split the input string at the commas
  // and convert the sections into floats:
  inputs = float(split(inString, ','));

  printArray(inputs);
  for (int i = 0; i<inputs.length; i++) {
    data[i]= map(inputs[i], 0, 55, 10, height-50);//map for visual display
  }
}
