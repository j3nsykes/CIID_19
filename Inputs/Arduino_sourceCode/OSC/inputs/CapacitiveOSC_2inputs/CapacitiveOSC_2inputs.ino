
/* Send OSC direct to Wekinator on port 6448 using the Huzzah32 and Wifi

using touch pin T8 and T9 (potential to add up to 10)
*/


//Wifi and OSC stuff
#include <WiFi.h>
#include <WiFiUdp.h>
#include <OSCMessage.h>

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
}

void loop() {


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

void sendViaOSC() {

  OSCMessage msg("/wek/inputs"); //must be message /wek/inputs for Wekinator
  msg.add((float)touchRead(T8)); //must be floats for Wekinator!
  msg.add((float)touchRead(T9));
  Udp.beginPacket(outIp, outPort);
  msg.send(Udp);
  Udp.endPacket();
  msg.empty();
  sendCount = 0;
}
