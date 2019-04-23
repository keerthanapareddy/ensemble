class Line {

  float xPos1;
  float yPos1;
  float xPos2;
  float yPos2;
  float velocity;
  float mass;
  color c;


  Line( float tempXPos1, float tempYPos1, float tempXPos2, float tempYPos2, float tempVelocity, color tempColor) {
    xPos1 = tempXPos1;
    yPos1 = tempYPos1;
    xPos2 = tempXPos2;
    yPos2 = tempYPos2;
    velocity = tempVelocity;
    mass = 2;
    c = tempColor;
  }

  void display() {
    stroke(c);
    strokeWeight(3);
    line(xPos1, yPos1, xPos2, yPos2);
  }

  void moveRight() {
    velocity = velocity-1; //can remove this if velocity gets mapped to springlength
    if (velocity > 0) {
      xPos1 = xPos1+velocity;
      xPos2 = xPos2+velocity;
    }
    xPos1 = constrain(xPos1, 0, width);
    xPos2 = constrain(xPos2, 0, width);   
    velocity = constrain(velocity, 0, 45);
  }

  void moveDown() {
    velocity = velocity-1;//can remove this if velocity gets mapped to springlength
    if (velocity > 0) {
      yPos1 = yPos1+velocity;
      yPos2 = yPos2+velocity;
    }
    yPos1 = constrain(yPos1, 0, height);
    yPos2 = constrain(yPos2, 0, height);
    velocity = constrain(velocity, 0, 45);
  }

  void moveLeft() {
    velocity = velocity-1;//can remove this if velocity gets mapped to springlength

    if (velocity > 0) {
      xPos1 = xPos1-velocity;
      xPos2 = xPos2-velocity;
    }
    xPos1 = constrain(xPos1, 0, width);
    xPos2 = constrain(xPos2, 0, width);
    velocity = constrain(velocity, 0, 45);
  }

  void moveUp() {
    velocity = velocity-1;//can remove this if velocity gets mapped to springlength

    //println(velocity);

    if (velocity > 0) {
      yPos1 = yPos1-velocity;
      yPos2 = yPos2-velocity;
      
    }
    
    yPos1 = constrain(yPos1, 0, height);
    yPos2 = constrain(yPos2, 0, height);
    velocity = constrain(velocity, 0, 45);
  }

  void resetLeft() {
    velocity = 0;
    stroke(c);
    strokeWeight(3);
    xPos1 =  0;
    yPos1 =0;
    xPos2 = 0;
    yPos2 =height;
  }

  void resetRight() {
    velocity = 0;
    stroke(c);
    strokeWeight(3);
    xPos1 =  width;
    yPos1 =0;
    xPos2 = width;
    yPos2 =height;
  }

  void resetTop() {
    velocity = 0;
    stroke(c);
    strokeWeight(3);
    xPos1 =  0;
    yPos1 =0;
    xPos2 = width;
    yPos2 =0;
  }

  void resetBottom() {
    velocity = 0;
    stroke(c);
    strokeWeight(3);
    xPos1 =  0;
    yPos1 =height;
    xPos2 = width;
    yPos2 =height;
  }

  void setVelocity(float v) {
    velocity = v;
    //v = constrain(velocity, 0, 25);
  }
}
