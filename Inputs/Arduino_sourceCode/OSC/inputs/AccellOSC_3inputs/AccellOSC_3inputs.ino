
/* Send OSC direct to Wekinator on port 6448 using the Huzzah8266 and Wifi

  using Adafruit BNO055 accelerometer sensor
*/
#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <utility/imumaths.h>
/* Set the delay between fresh samples */
#define BNO055_SAMPLERATE_DELAY_MS (100)

Adafruit_BNO055 bno = Adafruit_BNO055();


//Wifi and OSC stuff
#include <ESP8266WiFi.h>
//#include <WiFi.h>
#include <WiFiUdp.h>
#include <OSCMessage.h> /// https://github.com/CNMAT/OSC


char ssid[] = "*******";          // your network SSID (name)
char pass[] = "*******";                    // your network password

WiFiUDP Udp;                                // A UDP instance to let us send and receive packets over UDP
const IPAddress outIp(10, 172, 29, 103);     // remote IP of your computer
const unsigned int outPort = 6448;          // remote port to receive OSC (must be 6448 for Wekinator)
const unsigned int localPort = 9000;        // local port to listen for OSC packets (actually not used for sending)

#define LEDpin 13
long sendCount = 0;
long frameCount = 0;

void setup() {

  pinMode(LEDpin, OUTPUT);

  Serial.begin(115200);
  // Connect to WiFi network
  Serial.println();
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, pass);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");

  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());

  Serial.println("Starting UDP");
  Udp.begin(localPort);
  Serial.print("Local port: ");
  //Serial.println(Udp.localPort());
  sendCount = 0;

  /* Initialise the sensor */
  if (!bno.begin())
  {
    /* There was a problem detecting the BNO055 ... check your connections */
    Serial.print("Ooops, no BNO055 detected ... Check your wiring or I2C ADDR!");
    while (1);
  }
  bno.setExtCrystalUse(true);
}

void loop() {

  //readSensor(); //comment in for debugging
  frameCount++;

  //send data every 2nd frame
  if (frameCount < 2) {
    //visual turn light on when sending
    digitalWrite(LEDpin, LOW); //blue LED on
  } else {
    digitalWrite(LEDpin, HIGH);
  }

  if (frameCount > 500) {
    frameCount = 0;
  }
  sendCount ++;
  //if sendCount is over 1000 (1 second) send OSC info
  if (sendCount > 1000)
  {

    sendViaOSC();//send messages
    //Serial.println("sendingdata"); //debug

  }


}
//debug 
void readSensor() {

  imu::Vector<3> euler = bno.getVector(Adafruit_BNO055::VECTOR_EULER);

  /* Display the floating point data */
  Serial.print("X: ");
  Serial.print(euler.x());
  Serial.print(" Y: ");
  Serial.print(euler.y());
  Serial.print(" Z: ");
  Serial.print(euler.z());
  Serial.print("\t\t");
}

void sendViaOSC() {
  imu::Vector<3> euler = bno.getVector(Adafruit_BNO055::VECTOR_EULER);
  OSCMessage msg("/wek/inputs"); //must be message /wek/inputs for Wekinator
  //msg.add("hello");
  msg.add((float)euler.x()); //must be floats for Wekinator!
  msg.add((float)euler.y());
  msg.add((float)euler.z());
  Udp.beginPacket(outIp, outPort);
  msg.send(Udp);
  Udp.endPacket();
  msg.empty();
  sendCount = 0;
}
