/*
   Nikhil.P.Lokhande
   Project: ESP32 Touch Controled LED, using PWM
   Board: ESP32 Dev Module

   Touch Sensor Pin Layout
   T0 = GPIO4
   T1 = GPIO0
   T2 = GPIO2
   T3 = GPIO15
   T4 = GPIO13
   T5 = GPIO12
   T6 = GPIO14
   T7 = GPIO27
   T8 = GPIO33
   T9 = GPIO32 */


int buff(int pin)                                       //Function to handle the touch raw sensor data
{

  int out = (50 - touchRead(pin));                         //  Scale by n, value very sensitive currently
  // change to adjust sensitivity as required
  if (out > 0 )
  {
    return (out + 1);
  }
  else
  {
    return 0;                                        //Else, return 0
  }

}

void setup()
{
                                                     // Write a test value of 100 to channel 1
  Serial.begin(9600);
  



}
void loop()
{
  //Serial.print("Touch sensor value:");
  Serial.print(buff(T9));
  Serial.print(",");
  Serial.println(buff(T8));

  delay(100);
}
