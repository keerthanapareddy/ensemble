#include <Wire.h>
#include "Adafruit_VL6180X.h"
#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
#include <avr/power.h>
#endif

Adafruit_VL6180X vl = Adafruit_VL6180X();

#define neoPixelPin 8
#define numNeoPixels 8

Adafruit_NeoPixel pixels = Adafruit_NeoPixel(numNeoPixels, neoPixelPin, NEO_GRB + NEO_KHZ800);

uint32_t green = pixels.Color(0, 255, 0);
uint32_t black = pixels.Color(0, 0, 0);
uint32_t blue = pixels.Color(0, 0, 255);
uint32_t red = pixels.Color(255, 0, 0);

int lastReading = 43; //last reading
int restReading = 52; //Reading when spring is at rest
int maxReading = 103; //maximum Reading the spring can go until

char pixelColorKeys[] = {'Q', 'W', 'E', 'R'};
uint32_t pixelColor[] = {green, black, blue, red};

int furthestReading = 34; //Reading the user has pulled until. When no one touches it is 34.

uint8_t currentReading;

boolean inRestRange = true;

unsigned long lastDebounceTime = 0;  // the last time the output pin was toggled
unsigned long debounceDelay = 60;
char inByte;

void setup() {
  Serial.begin(9600);
  pixels.begin();
  setNeoPixelColor(0, 0, 0);
  // wait for serial port to open on native usb devices
  while (!Serial) {
    delay(1);
  }

  if (! vl.begin()) {
    //    Serial.println("Failed to find sensor");
    while (1);
  }

  setNeoPixelColor(250, 250, 250);
  //  Serial.println('Q');

}

void loop() {

  currentReading = vl.readRange();
  uint8_t status = vl.readRangeStatus();
  if (status == VL6180X_ERROR_NONE) { //if no errors
    getReadingValues();
  } else {
  }



  if (Serial.available() > 0) {
    inByte = Serial.read();
    //    Serial.print("inByte: ");
    //    Serial.print(inByte);

    if (inByte == 'A') {
      setNeoPixelColor(253, 180, 21);
      //blink neopixels
    }

    else if (inByte == 'Q') {
      setNeoPixelColor(0, 208, 75);
      // set pixel color green
    }
    else if (inByte == 'W') {
      setNeoPixelColor(253, 180, 21);
      // set pixel color black
    }
    else if (inByte == 'E') {
      setNeoPixelColor(25, 138, 236);
      // set pixel color blue
    }
    else if (inByte == 'R') {
      setNeoPixelColor(243, 69, 74);
      // set pixel color red
    }
  }
   delay(100);
    }

  /*
    if (Serial.available() > 0) {
      inChar = (char)Serial.read();

      if (inChar == 'Q') { //reading that bottom line velocity is 0
        setNeoPixelColor(253, 180, 21); //set the next neopixel(yellow)
        Serial.println('W'); //send that it is yellow's
      }

      else if (inChar == 'W') {
        setNeoPixelColor(25, 138, 236);
        Serial.println('E');
      }

      else if (inChar == 'E') {
        setNeoPixelColor(243, 69, 74);
        Serial.println('R');
      }

      else if (inChar == 'R') {
        setNeoPixelColor(0, 148, 75);
        Serial.println('Q');
      }

    }

    delay(100);
    }
  */
  void getReadingValues() {
    //find out the range of rest values ` 32 to 41

    //  if ( 45 <= currentReading <= 53) {
    //    inRestRange = true;
    //  }
    //  if (currentReading > 43) {
    //    inRestRange = false;
    //  }

    if (currentReading != lastReading) { //if there is a change in reading
      if (currentReading <= restReading && furthestReading >= 55) {
        Serial.println(furthestReading);
        delay(500);
        furthestReading = 48;
      }

      if (furthestReading < currentReading) {
        furthestReading = currentReading;
      }
    }
    delay(100);
    lastReading = currentReading;
  }

  void setNeoPixelColor(int r, int g, int b) {
    for (int i = 0; i < numNeoPixels; i++) {
      pixels.setPixelColor(i, pixels.Color(r, g, b));
      pixels.setBrightness(50);
    }
    pixels.show();
    delay(10);
  }

  //check example sketch for additional error code
