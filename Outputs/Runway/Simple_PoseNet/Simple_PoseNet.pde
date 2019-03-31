// Copyright (C) 2018 Runway AI Examples
// 
// This file is part of Runway AI Examples.
// 
// RUNWAY
// www.runwayapp.ai

// PoseNet Demo:
// Receive OSC messages from Runway
// Running PoseNet model
//Example taken from PoseNet example and simplified for one feature connection

// Import OSC
import oscP5.*;
import netP5.*;

// Runway Host
String runwayHost = "127.0.0.1";

// Runway Port
int runwayPort = 57112;  //make sure yours matches!!!

OscP5 oscP5;
NetAddress myBroadcastLocation;

// This array will hold all the humans detected
JSONObject data;
JSONArray humans;

// This are the pair of body connections we want to form. 
// Try creating new ones!
String[][] connections = {
  {"nose", "leftEye"}, 
  {"leftEye", "leftEar"}, 
  {"nose", "rightEye"}, 
  {"rightEye", "rightEar"}, 
  {"rightShoulder", "rightElbow"}, 
  {"rightElbow", "rightWrist"}, 
  {"leftShoulder", "leftElbow"}, 
  {"leftElbow", "leftWrist"}, 
  {"rightHip", "rightKnee"}, 
  {"rightKnee", "rightAnkle"}, 
  {"leftHip", "leftKnee"}, 
  {"leftKnee", "leftAnkle"}
};

void setup() {
  size(600, 400);
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

  // Only if there are any humans detected
  if (data != null) {
    humans = data.getJSONArray("poses"); //get the poses
    println(humans);

    JSONObject human = humans.getJSONObject(0); //get one human 
    JSONArray keypoints = human.getJSONArray("keypoints"); //get the keypoints of the pose
    //printArray(keypoints);
    // Now that we have one human, let's draw its body parts

    //isolate a body part / keypoint
    JSONObject part = keypoints.getJSONObject(3);//left wrist //try other body parts other numbers 
    //printArray(part);

    JSONObject partPositions = part.getJSONObject("position");
    float x=partPositions.getFloat("x"); //get x co-ordinate
    float y=partPositions.getFloat("y");//get y co-ordinate
    printArray(partPositions);

    //visualise the body part
    pushMatrix();
    noStroke();
    fill(255, 0, 0);
    ellipse(x, y, 10, 10);
    popMatrix();
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
}
