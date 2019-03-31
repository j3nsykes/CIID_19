
import processing.serial.*; // Import Serial library to talk to Arduino 

Serial myPort; // Send value to Arduino // 

void serialSetup(){
  printArray(Serial.list()); // shows available serial ports on the system 

  // Change 0 to select the appropriate port as required. 
  String portName = Serial.list()[3]; 
  myPort = new Serial(this, portName, 9600);
}

void sendSerial(){


  myPort.write(int(servoX)+","+int(servoY)+";");
 
}
