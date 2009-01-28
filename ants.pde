boolean[][] food;
float[][] scent;
float[][] paths;
ArrayList antHills;
Rectangle boundingBox;
int foodValue = 600;
boolean drawObjects = true;
boolean drawPaths = false;

void setup ()
{
  frameRate(600);
  size(400, 400, P2D);
  //smooth();
  background(255);
  fill(0);
  food = new boolean[height][width];
  scent = new float[height][width];
  paths = new float[height][width];
  antHills = new ArrayList();
  antHills.add(new AntHill(new QVector2D(random(40, height-40), random(40, width-40))));
  boundingBox = new Rectangle(0, 0, height, width);
  
  growFood();
  
  for (int i = 0; i < scent.length; i++) {
    for (int j = 0; j < scent[i].length; j++) {
      scent[i][j] = 0;
      paths[i][j] = 0;
    }
  }
}

void draw ()
{
  if (mousePressed) {
    if (mouseButton == LEFT) antHills.add(new AntHill(new QVector2D(mouseX, mouseY)));
    if (mouseButton == RIGHT) food[mouseX][mouseY] = true;
  }
  
  background(255);
  
  for (int i = 0; i < scent.length; i++) {
    for (int j = 0; j < scent[i].length; j++) {
      
      if (paths[i][j] > 0.25) {
        paths[i][j] *= 0.999;
        if (drawPaths) {
          stroke(255, 255 - (paths[i][j] * 20), 255 - (paths[i][j] * 20));
          point(i, j);
        }
      } else {
        paths[i][j] = 0;
      }
      
      if (scent[i][j] > 0.25) {
        scent[i][j] *= 0.999;
        if (drawPaths) {
          stroke(255 - (scent[i][j] * 20), 255, 255 - (scent[i][j] * 20));
          point(i, j);
        }
      } else {
        scent[i][j] = 0;
      }
    }
  }
  
  if (drawObjects) {
    stroke(0, 255, 0);
    for (int i = 0; i < food.length; i++) {
      for (int j = 0; j < food[i].length; j++) {
        if (food[i][j]) point(i, j);
      }
    }
  }
  
  AntHill antHill;
  for (int i = 0; i < this.antHills.size(); i++) {
    antHill = (AntHill) this.antHills.get(i);
    antHill.draw();
  }
}

void keyPressed ()
{
  if (key == ' ') {
    AntHill antHill;
    for (int i = 0; i < this.antHills.size(); i++) {
      antHill = (AntHill) this.antHills.get(i);
      antHill.addAnt();
    }
  } else if (key == 'p') {
    drawPaths = drawPaths ? false : true;
  } else if (key == 'o') {
    drawObjects = drawObjects ? false : true;
  } else if (key == 'n') {
    setup();
  } else if (key == 'a') {
    antHills.add(new AntHill(new QVector2D(random(40, height-40), random(40, width-40))));
  }
}

void growFood ()
{
  int xBlob = 0;
  int yBlob = 0;
  int tall = 0;
  int wide = 0;
  int numberOfFood = 0;
  
  int xFood = 0;
  int yFood = 0;
  
  for (int i = 0; i < 10; i++) {
    xBlob = (int) random(1, width);
    yBlob = (int) random(1, height);
    tall = (int) random(30, 70);
    wide = (int) random(30, 70);
    
    numberOfFood = (int) random(40, 100);
    for (int j = 0; j < numberOfFood; j++) {
      xFood = (int) random(xBlob, (xBlob + wide));
      yFood = (int) random(yBlob, (yBlob + tall));
      if (xFood < (width - 1) && yFood < (height - 1)) food[xFood][yFood] = true;
    }
  }
}