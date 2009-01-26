boolean[][] food;
float[][] scent;
AntHill antHill;
Rectangle boundingBox;
int foodValue = 600;

void setup ()
{
  //frameRate(1);
  size(400, 400);
  smooth();
  background(255);
  fill(0);
  food = new boolean[height][width];
  scent = new float[height][width];
  antHill = new AntHill(new QVector2D(random(40, height-40), random(40, width-40)));
  boundingBox = new Rectangle(0, 0, height, width);
  
  growFood();
  
  for (int i = 0; i < scent.length; i++) {
    for (int j = 0; j < scent[i].length; j++) {
      scent[i][j] = 0;
    }
  }
}

void draw ()
{
  if (mousePressed) food[mouseX][mouseY] = (mouseButton == LEFT);
  
  background(255);
  
  for (int i = 0; i < scent.length; i++) {
    for (int j = 0; j < scent[i].length; j++) {
      scent[i][j] *= 0.999;
      
      if (scent[i][j] > 0.5) {
        stroke(255 - (scent[i][j] * 10));
        point(i, j);
      }
    }
  }
  
  stroke(0, 255, 0);
  for (int i = 0; i < food.length; i++) {
    boolean[] foodcol = food[i];
    for (int j = 0; j < foodcol.length; j++) {
      if (foodcol[j]) point(i, j);
    }
  }
  
  antHill.draw();
}

void keyPressed ()
{
  antHill.addAnt();
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