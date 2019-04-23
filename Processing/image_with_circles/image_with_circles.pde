import processing.serial.*;

Serial myPort;


PImage img; // Declare a variable of type PImage
//int circleSize = 5; //size of the circles
int cellSize;

float circleSize = 6;
float rightVelocityConstrained, leftVelocityConstrained, topVelocityConstrained, bottomVelocityConstrained;

float initialLineVelocity;

//int springDisplacement = (int)random(0, 140) ;

int inByte; //value from arduino with initial value as rest position

boolean isCirclePresent[];

boolean velocityIsZero = false;

int lineNumber = 0;

int loc;

int cols, rows;
int x0, x1, y0, y1 = 0;

float xLeft, xRight, yTop, yBottom;
float xLeftFinal, xRightFinal, yTopFinal, yBottomFinal;

Line lineLeft;
Line lineRight;
Line lineTop;
Line lineBottom;
int lineCounter=1;
Circle pixelCircle;


void setup() {
  //fullScreen();
  size(1000, 1000);

  String portName = "/dev/cu.usbmodem1421";
  myPort = new Serial(this, portName, 9600);

  img = loadImage("minion.jpg");  // Make a new instance of a PImage by loading an image file
  background(255);
  smooth();
  cellSize = 5; //radius of the circle
  cols = img.width/cellSize;  // Number of columns
  rows = img.height/cellSize; 

  for (int i=0; i<cols; i++) {
    for (int j=0; j<rows; j++) {
      int x = i*cellSize;
      int y = j*cellSize;
      loc = x + y*img.width; //standard formula to determine location of a pixel in the array
    }
  }

  //create a 2D boolean array with all false initially  
  isCirclePresent = new boolean[cols*rows]; //initializes everything to false
  //println(isCirclePresent.length);
  for (int i = 0; i < isCirclePresent.length; i++) {
    isCirclePresent[i] = false;
  }

  colorMode(RGB, 100);

  yBottom = height-10;
  xRight = width-10;
  yTop = 10; 
  xLeft = 10;


  //initialLineVelocity = map(springDisplacement, 20, 160, 0, 42.85); //20 ~ the distance it travels 
  lineLeft = new Line(xLeft, 0, xLeft, height, initialLineVelocity, color(0, 0, 0));
  lineRight = new Line(xRight, 0, xRight, height, initialLineVelocity, color(255, 0, 0));
  lineTop = new Line(0, yTop, width, yTop, initialLineVelocity, color(0, 0, 255));
  lineBottom = new Line(0, yBottom, width, yBottom, initialLineVelocity, color(0, 255, 0));
}

void draw() {
  //background(255, 255, 255);
  constrainVelocities();
  displayLines();
  moveLines();
  
  if (lineNumber == 4 && lineRight.velocity == 0 ) {
    drawCircles(yTopFinal, yBottomFinal, xRightFinal, xLeftFinal);
    resetLines();
  }
  
  delay(10);
}

void displayLines() {
  if (lineBottom.velocity == 0) 
    lineBottom.display();
  if (lineLeft.velocity == 0)
    lineLeft.display();
  if (lineTop.velocity == 0)
    lineTop.display();
  if (lineRight.velocity == 0)
    lineRight.display();
}

//drawing circles
void drawCircles(float topY, float bottomY, float rightX, float leftX) {
  img.loadPixels();
  for (int i=0; i<rows; i++) {
    for (int j=0; j<cols; j++) {

      int x = i*cellSize;
      int y = j*cellSize;
      int pixelLoc = x + y*img.width; //standard formula to determine location of a pixel in the array
      int circleLocation = i + j*cols; //array for number of circles is different from the pixel array

      float r = 255;
      float g = 255;
      float b = 255;
      //println("leftX:" + leftX+ " right x"+ rightX +  " topY"+ topY + "bottom Y" + bottomY);
      if ((x >= leftX && x < rightX && y>= topY && y < bottomY) || isCirclePresent[circleLocation] == true) {
        //println("i am drawing bro");
        r = red(img.pixels[pixelLoc]); //looking up rgb values of the image
        g = green(img.pixels[pixelLoc]);
        b = blue(img.pixels[pixelLoc]);
        isCirclePresent[circleLocation] = true;
      }
      pixelCircle = new Circle(r, g, b, x+cellSize/2, y+cellSize/2);
      pixelCircle.display();
    }
  }
}
//}

void resetLines() {
  lineLeft.resetLeft();
  lineRight.resetRight();
  lineTop.resetTop();
  lineBottom.resetBottom();
}

void constrainVelocities() {
  rightVelocityConstrained = constrain(lineRight.velocity, 0, 45);
  leftVelocityConstrained = constrain(lineLeft.velocity, 0, 45);
  topVelocityConstrained = constrain(lineTop.velocity, 0, 45);
  bottomVelocityConstrained = constrain(lineBottom.velocity, 0, 45);
}


void moveLines() {
  //when neo pixels change color decide which line is moving
  if (lineNumber == 1) {
    lineBottom.moveUp();
    if (lineBottom.velocity == 0) {
      yBottomFinal = lineBottom.yPos1;
      // println(yBottomFinal);
    }
  } 

  if (lineNumber == 2) {
    //println(lineLeft.velocity);
    lineLeft.moveRight();
    if (lineLeft.velocity == 0) {
      xLeftFinal = lineLeft.xPos2;
    }
  } 

  if (lineNumber == 3) {
    lineTop.moveDown();
    if (lineTop.velocity == 0) {
      yTopFinal = lineTop.yPos2;
    }
  } 
  
  if (lineNumber == 4) {
    lineRight.moveLeft();
    if (lineRight.velocity == 0) {
      xRightFinal = lineRight.xPos2;
    }
  } else {
  }
}


void triggerLineMove() {
  print("initialLineVelocity:"); 
  println(initialLineVelocity);
  if (lineNumber == 1) {
    lineBottom.setVelocity(initialLineVelocity);
  }

  if (lineNumber == 2) {
    lineLeft.setVelocity(initialLineVelocity);
  }

  if (lineNumber == 3) {
    lineTop.setVelocity(initialLineVelocity);
  }

  if (lineNumber == 4) {
    lineRight.setVelocity(initialLineVelocity);
  }
  if(lineNumber > 4){
    lineNumber = 0;
  }
}


void serialEvent (Serial myPort) {

  while (myPort.available()>0) {
    inByte = myPort.read();
    //print("inByte:");
    //println(inByte);
    lineNumber++; 
    print("Line Number:"); 
    println(lineNumber);
    initialLineVelocity = map(inByte, 42, 103, 0, 45);
    triggerLineMove() ;
  }
}


////key presses
//void keyPressed() {
//  switch(key) {
//  case '1':
//    lineNumber = 5;
//    resetLines();
//    //resetAllLines();
//    break;
//  }
//}
