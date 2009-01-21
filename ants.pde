boolean[][] food;
int[][] scent;
QVector2D antHill;
Ant[] ants = new Ant[99];
int numberOfAnts = 0;
Rectangle boundingBox;

void setup ()
{
  //frameRate(1);
  size(400, 400);
  smooth();
  background(255);
  fill(0);
  food = new boolean[height][width];
  scent = new int[height][width];
  antHill = new QVector2D(random(40, height-40), random(40, width-40));
  boundingBox = new Rectangle(0, 0, height, width);
  
  growFood();
}

void draw ()
{
  if (mousePressed) food[mouseX][mouseY] = (mouseButton == LEFT);
  
  background(255);
  
  noStroke();
  fill(0);
  ellipse(antHill.x, antHill.y, 10, 10);
  
  stroke(128, 255, 128);
  for (int i = 0; i < food.length; i++) {
    boolean[] foodcol = food[i];
    for (int j = 0; j < foodcol.length; j++) {
      if (foodcol[j]) point(i, j);
    }
  }
  
  for (int i = 0; i < numberOfAnts; i++) {
    ants[i].draw();
  }
}

void keyPressed ()
{
  ants[numberOfAnts] = new Ant(antHill);
  numberOfAnts++;
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