// RUNWAY
// www.runwayapp.ai

// Facelandmarks Demo:
// Receive OSC messages from Runway
// Running face landmarks model
//example taken from https://github.com/b2renger/workshop_ml_PCD2019
//and simplified. 

// Import OSC
import oscP5.*;
import netP5.*;

// Runway parameters
String runwayHost = "127.0.0.1";
int runwayPort = 57106; //make sure yours matches!

int camWidth;
int camHeight;

OscP5 oscP5;
NetAddress myBroadcastLocation;

// This array will hold all the humans detected
JSONObject data;
JSONArray face;

// This are the pair of body connections we want to form. 
// Try creating new ones!
String[] elements = {
  "bottom_lip", "chin", "left_eye", "left_eyebrow", "nose_bridge", "nose_tip", 
  "right_eye", "right_eyebrow", "top_lip"
};

void setup() {
  size(800, 600);
  frameRate(25);


  OscProperties properties = new OscProperties();
  properties.setRemoteAddress("127.0.0.1", 57200);
  properties.setListeningPort(57200);
  properties.setDatagramSize(99999999);
  properties.setSRSP(OscProperties.ON);
  oscP5 = new OscP5(this, properties);
  // Use the localhost and the port 57100 that we define in Runway
  myBroadcastLocation = new NetAddress(runwayHost, runwayPort);

  connect();

  fill(255);
  stroke(255);
}

void draw() {
  background(0);
  fill(255);
  if (data != null) {
    //if a face is detected!

    JSONArray faceElements = data.getJSONArray("landmarks"); //get face landmarks
    JSONObject camResolution = data.getJSONObject("size"); //get camera resolution

    camWidth = camResolution.getInt("width");
    camHeight = camResolution.getInt("height");

    printArray(faceElements);

    try {
      //get one face
      //get one element . 
      //Try get different elements depending on the number in the array box. 
      JSONArray coordinates = faceElements.getJSONObject(0).getJSONArray(elements[2]);
      //printArray(coordinates);
      
      //draw all co-ordinates       
      float prevX=0;
      float prevY=0;
      
      for (int j = 0; j < coordinates.size(); j++) { //some landmarks have multiple points. Get them all

        JSONArray array = coordinates.getJSONArray(j);
        float x = map(array.getFloat(0), 0, camWidth, 0, width); //get the x co-ordinate
        float y = map(array.getFloat(1), 0, camHeight, 0, height); //get the y co-ordinate
        ellipse(x, y, 5, 5);

        if (j!=0) {
          line(x, y, prevX, prevY); //draw a line between the co-ordinates 
        }
        prevX = x;
        prevY = y;

      }
    }
    catch (Exception e) {
    }
  }
}


void connect() {
  OscMessage m = new OscMessage("/server/connect");
  oscP5.send(m, myBroadcastLocation);
}

void disconnect() {
  OscMessage m = new OscMessage("/server/disconnect");
  oscP5.send(m, myBroadcastLocation);
}

void keyPressed() {
  switch(key) {
    case('c'):
    /* connect to Runway */
    connect();
    break;
    case('d'):
    /* disconnect from Runway */
    disconnect();
    break;
  }
}

// OSC Event: listens to data coming from Runway
void oscEvent(OscMessage theOscMessage) {

  // The data is in a JSON string, so first we get the string value
  String dataString = theOscMessage.get(0).stringValue();

  // We then parse it as a JSONObject
  data = parseJSONObject(dataString);
  // println(data);
}
