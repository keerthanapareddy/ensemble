#include <Wire.h>
#include "Adafruit_VL6180X.h"

Adafruit_VL6180X vl = Adafruit_VL6180X();

int lastReading = 32; //last reading
int restReading = 41; //Reading when spring is at rest
int maxReading = 103; //maximum Reading the spring can go until

int furthestReading = 34; //Reading the user has pulled until. When no one touches it is 34.

uint8_t currentReading;

boolean inRestRange = true;

unsigned long lastDebounceTime = 0;  // the last time the output pin was toggled
unsigned long debounceDelay = 60;

void setup() {
  Serial.begin(9600);

  // wait for serial port to open on native usb devices
  while (!Serial) {
    delay(1);
  }

  if (! vl.begin()) {
//    Serial.println("Failed to find sensor");
    while (1);
  }
//  Serial.println("Sensor found!");
  //
  //
  //  // calibrate during the first five seconds
  //  while (millis() < 5000) {
  //    currentReading = vl.readReading();
  //
  //    // record the maximum sensor value
  //    if (currentReading > maxReading) {
  //      maxReading = currentReading;
  //    }
  //
  //    // record the minimum sensor value
  //    if (currentReading < restReading) {
  //      restReading = currentReading;
  //    }
  //
  //  }
  //  Serial.println("Calibration done!");

}

void loop() {
  currentReading = vl.readRange();
  uint8_t status = vl.readRangeStatus();

  if (status == VL6180X_ERROR_NONE) { //if no errors
    getReadingValues();
    //    sendReadingValues(); //send to processing
  }

  delay(100);
}

void getReadingValues() {
  // Serial.println(currentReading);
  //find out the range of rest values ` 32 to 41

  if ( 32 <= currentReading <= 43) {
    inRestRange = true;
  }
  if (currentReading > 43) {
    inRestRange = false;
  }

if(currentReading != lastReading){ //if there is a change in reading
  if(currentReading <= restReading && furthestReading != 43){
    Serial.write(furthestReading);
    delay(500);
    furthestReading = 43;
  }
  
    if (furthestReading < currentReading) {
      furthestReading = currentReading;
    }
}
  delay(100);

  //if the current reading is not the same as last reading
  // and if the last reading > current, meaning the spring is bouncing back
  //log that current reading
  //send that reading when the current reading is in the range of rest values.

  lastReading = currentReading;
}


void sendReadingValues() {
  currentReading = map(currentReading, restReading, maxReading, 0, 45);
  //  Serial.write(currentReading);
}








// Some error occurred, print it out!
/*
  if  ((status >= VL6180X_ERROR_SYSERR_1) && (status <= VL6180X_ERROR_SYSERR_5)) {
  Serial.println("System error");
  }
  else if (status == VL6180X_ERROR_ECEFAIL) {
  Serial.println("ECE failure");
  }
  else if (status == VL6180X_ERROR_NOCONVERGE) {
  Serial.println("No convergence");
  }
  else if (status == VL6180X_ERROR_RangeIGNORE) {
  Serial.println("Ignoring Range");
  }
  else if (status == VL6180X_ERROR_SNR) {
  Serial.println("Signal/Noise error");
  }
  else if (status == VL6180X_ERROR_RAWUFLOW) {
  Serial.println("Raw reading underflow");
  }
  else if (status == VL6180X_ERROR_RAWOFLOW) {
  Serial.println("Raw reading overflow");
  }
  else if (status == VL6180X_ERROR_RangeUFLOW) {
  Serial.println("Reading reading underflow");
  }
  else if (status == VL6180X_ERROR_RangeOFLOW) {
  Serial.println("Reading reading overflow");
  }
*/
