import rita.*;
RiMarkov rm;
String [] sentences;
String [] info;
String sentence;

void ritaSetup() {
  rm = new RiMarkov(3);
  //String sample ="hello there how are you today. I'm ok how are you? what do you wnat to do today?";
  //rm.loadText(sample); //loadText

  //load own file but join up all lines
  info = loadStrings("bowieLyrics.txt");
  String joinedText=join(info, " ");


  rm.loadText(joinedText); //loadText
  sentences=rm.generateSentences(3); //generate 3 sentences 

  for (int i=0; i<sentences.length; i++) {
    printArray(sentences);
  }

  sentence=rm.generateSentence(); //single instance
  println(sentence);
  textSize(24);
  textAlign(CENTER);
}

void displayRita() {
  background(102);

  fill(255);
  text(sentence, 10, 150, width - 40, height);

  //for(int i=0; i<sentences.length;i++){
  //text(sentences[i], 10, 250+(i*30), width - 40, height);

  //}
}

void mousePressed() {
  sentence=rm.generateSentence(); //single instance
  words=sentence; //send Eliza response to Runway

  //send on mouseClick
  OscMessage myMessage = new OscMessage("/query");
  JSONObject  json = new JSONObject();
  json.setString("caption", words);
  myMessage.add(json.toString());
  println(json);
  oscP5.send(myMessage, myBroadcastLocation);
}
