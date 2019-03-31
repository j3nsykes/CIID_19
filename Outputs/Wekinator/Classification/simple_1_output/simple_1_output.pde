import oscP5.*;
OscP5 oscP5;
int currentClass; 
PFont font;
String word="OBJECT";
void setup() {
  size(640, 480);
  oscP5 = new OscP5(this, 12000);
  font = loadFont("SourceCodePro-Bold-72.vlw");
  textFont(font, 72);
  textAlign(CENTER);
  
}

void draw() {
  background(0);
  textSize(64);
  text(word, width/2, height/2);

  if (currentClass == 1) {
    //Do something on class 1
    word="PERSON";
  } else if (currentClass == 2) {
    //Do something else on class 2
    word="CHAIR";
  } else {
    //Else do this
    word="OBJECT";
  }
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    currentClass = (int) theOscMessage.get(0).floatValue();
  }
}
