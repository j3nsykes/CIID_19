import codeanticode.eliza.*;

Eliza eliza;
PFont font;
String elizaResponse, humanResponse;
String [] info;
String [] splitText;

void elizaSetup() {
  eliza = new Eliza(this);
  //eliza.readScript("editedScriptexample.txt");
  eliza.readDefaultScript();

  info = loadStrings("bowieLyrics.txt");//load the file 
  //try David Bowie lyrics. 
  //printArray(data);//see the contents

  humanResponse = "Its me david";
  println(humanResponse);
  elizaResponse = eliza.processInput(humanResponse);
  println(">> " + elizaResponse);

  //join it up
  String joinedText=join(info, " "); //join the spaces 
  //println(joinedText);

  //split it back up
  splitText=splitTokens(joinedText, ".!?");
  //printArray(trim(splitText)); //use trim to remove white spaces.
  textSize(14);
  textAlign(CENTER);
}

void displayEliza() {
  background(102);

  fill(255);

  text(humanResponse, 10, 50, width - 40, height);
  text(elizaResponse, 10, 150, width - 40, height);
}

void mousePressed() {

  int max=splitText.length; //max is the total length of the string array
  int index=int(random(0, max)); //randomise the line of text

  humanResponse = trim(splitText[index]);
  elizaResponse = eliza.processInput(humanResponse);
  words=elizaResponse; //send Eliza response to Runway

//send on mouseClick
  OscMessage myMessage = new OscMessage("/query");
  JSONObject  json = new JSONObject();
  json.setString("caption", words);
  myMessage.add(json.toString());
  println(json);
  oscP5.send(myMessage, myBroadcastLocation);
}
