class Circle {
  float radius;
  float r;
  float g;
  float b;
  float translateX;
  float translateY;

  Circle(float tempR, float tempG, float tempB, float tempTranslateX, float tempTranslateY) {
    r = tempR;
    g = tempG;
    b = tempB;
    translateX = tempTranslateX;
    translateY = tempTranslateY;
  }

  void display() {
    pushMatrix(); //draw ellipse      
    translate(translateX, translateY);
    noStroke();
    //ellipseMode(CENTER);
    colorMode(RGB);
    fill(r, g, b);
    ellipse(0, 0, cellSize, cellSize);
    popMatrix();
  }
}
