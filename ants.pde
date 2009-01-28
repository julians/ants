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
  frameRate(6000);
  size(400, 400);
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
  if (mousePressed) food[mouseX][mouseY] = (mouseButton == LEFT);
  
  background(255);
  
  for (int i = 0; i < scent.length; i++) {
    for (int j = 0; j < scent[i].length; j++) {
      paths[i][j] *= 0.999;
      scent[i][j] *= 0.999;

      if (drawPaths) {
        if (paths[i][j] > 0.5) {
          stroke(255, 255 - (paths[i][j] * 20), 255 - (paths[i][j] * 20));
          point(i, j);
        }
        if (scent[i][j] > 0.5) {
          stroke(255 - (scent[i][j] * 20), 255, 255 - (scent[i][j] * 20));
          point(i, j);
        }
      }
    }
  }
  
  if (drawObjects) {
    stroke(0, 255, 0);
    for (int i = 0; i < food.length; i++) {
      boolean[] foodcol = food[i];
      for (int j = 0; j < foodcol.length; j++) {
        if (foodcol[j]) point(i, j);
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