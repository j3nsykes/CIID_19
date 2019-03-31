final int baudRate = 57600;
final int numElectrodes = 12;

Serial inPort;  // the serial port
String inString; // input string from serial port
String[] splitString; // input string array after splitting
int[] status, lastStatus;
int[] filteredData;
float[] proximity;
int lf = 10;          // ASCII linefeed
int firstElectrode=0;
int lastElectrode=4;

void updateArraySerial(int[] array) {
  if (array == null) {
    return;
  }

  for (int i = 0; i < min(array.length, splitString.length - 1); i++) {
    try {
      array[i] = Integer.parseInt(trim(splitString[i + 1]));
    } 
    catch (NumberFormatException e) {
      array[i] = 0;
    }
  }
}

void touchBoardSetup() {
  status = new int[numElectrodes];
  lastStatus = new int[numElectrodes];
  filteredData      = new int[numElectrodes];
  proximity      = new float[numElectrodes];

  printArray((Object[])Serial.list());
  // change the 1 below to the number corresponding to the output of the command above
  inPort = new Serial(this, Serial.list()[3], baudRate); 
  inPort.bufferUntil(lf);
}



void serialEvent(Serial p) {
  inString = p.readString();
  splitString = splitTokens(inString, ": ");

  if (splitString[0].equals("TOUCH")) {
    updateArraySerial(status);
  } else if (splitString[0].equals("FDAT")) {
    updateArraySerial(filteredData);
  }

  for (int i = firstElectrode; i < lastElectrode; i++) {
    //constant stream of touch data from electrode E11, E10 and E09

    printArray("filteredData"+" "+"E"+i+" :"+filteredData[i]);


    proximity[i]= map(filteredData[i], 0, 1023, 0, height);
   // printArray("proximity"+" "+"E"+i+" :"+proximity[i]);
  }

  for (int i = 0; i < numElectrodes; i++) {

    if (lastStatus[i] == 0 && status[i] == 1) {
      // touched

      println("Electrode " + i + " was touched");
      lastStatus[i] = 1;
    } else if (lastStatus[i] == 1 && status[i] == 0) {
      // released
      println("Electrode " + i + " was released");
      lastStatus[i] = 0;
    }
  }
}
