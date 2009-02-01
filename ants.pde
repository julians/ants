boolean[][] food;
float[][] scent;
float[][] paths;
ArrayList antHills;
int foodValue = 600;
boolean drawObjects = true;
boolean drawPaths = false;
int lasttime = 0;

boolean drawP = false;
boolean drawS = false;

float r;
float g;
float b;

void setup ()
{
  frameRate(200);
  size(400, 400, P2D);
  //smooth();
  background(255);
  fill(0);
  food = new boolean[height][width];
  scent = new float[height][width];
  paths = new float[height][width];
  antHills = new ArrayList();
  antHills.add(new AntHill(new QVector2D(random(40, height-40), random(40, width-40))));
  
  growFood();
  
  for (int i = 0; i < scent.length; i++) {
    for (int j = 0; j < scent[i].length; j++) {
      scent[i][j] = 0;
      paths[i][j] = 0;
    }
  }
  lasttime = millis();
}

void draw ()
{
  println(millis() - lasttime);
  lasttime = millis();
  if (mousePressed && mouseButton == RIGHT) food[mouseX][mouseY] = true;
  
  background(255);
  
  for (int i = 0; i < scent.length; i++) {
    for (int j = 0; j < scent[i].length; j++) {
      
      if (paths[i][j] > 0.25) {
        paths[i][j] *= 0.995;
        drawP = true;
      } else {
        drawP = false;
        paths[i][j] = 0;
      }
      
      if (scent[i][j] > 0.25) {
        scent[i][j] *= 0.995;
        drawS = true;
      } else {
        drawS = false;
        scent[i][j] = 0;
      }
      
      if (drawPaths && (drawP || drawS)) {
        if (!drawP) {
          r = map(scent[i][j], 0, 30, 255, 0);
          g = 255;
          b = map(scent[i][j], 0, 30, 255, 0);
        } else if (!drawS) {
          r = 255;
          g = map(paths[i][j], 0, 30, 255, 0);
          b = map(paths[i][j], 0, 30, 255, 0);
        } else {
          r = 255;
          g = 255;
          b = map(paths[i][j] + scent[i][j], 0, 30, 255, 0);
        }
        
        stroke(r, g, b);
        point(i, j);
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
  for (int i = 0; i < antHills.size(); i++) {
    antHill = (AntHill) antHills.get(i);
    antHill.draw();
  }
}

void mouseReleased ()
{
  if (mouseButton == LEFT) antHills.add(new AntHill(new QVector2D(mouseX, mouseY)));
}

void keyReleased ()
{
  if (key == ' ') {
    AntHill antHill;
    for (int i = 0; i < antHills.size(); i++) {
      antHill = (AntHill) antHills.get(i);
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
  } else if (key == 'f') {
    growFood();
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