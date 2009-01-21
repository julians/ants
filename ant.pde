class Ant
{
  QVector2D antHill;
  QVector2D position;
  QVector2D direction;
  QVector2D idealDirection;
  QVector2D finalDestination = new QVector2D(0, 0);
  boolean hasFood = false;
  int speed = 2;
  int size = 4;
  int appetite = 0;
  int maxAppetite = width*2;
  Rectangle hitBox;
  boolean exploring = true;
  int whiteness = 0;
  float rangeOfSight = 5;
  QVector2D nearestFood = null;
  
  Ant (QVector2D _position)
  {
    this.antHill = _position;
    this.position = _position.get();
    this.hitBox = new Rectangle((int) this.position.x-(this.size/2), (int) this.position.y-(this.size/2), this.size, this.size);
  }
  
  float getAngle()
  {
    return (float) Math.toDegrees(this.direction.heading2D()) - (float) Math.toDegrees(this.idealDirection.heading2D());
  }
  
  void leaveAntHill ()
  {
    this.newFinalDestination();
    this.direction = this.finalDestination.get();
    this.direction.sub(this.position);
    this.exploring = true;
    this.hasFood = false;
  }
  
  void draw ()
  {
    if (this.appetite > 0 && this.isHome()) {
      this.appetite -= 2;
    } else {
      if (this.appetite <= 0) this.leaveAntHill();
      this.go();
    }
  }
  
  boolean isHome ()
  {
    QVector2D temp = this.antHill.get();
    temp.sub(this.position);
    return (temp.mag() < 2);
  }
  
  void go ()
  {
    this.updateNearestFood();
    if (this.nearestFood != null) {
      this.finalDestination.set(this.nearestFood.get());
    }
    
    this.updateIdealDirection();
    
     if (this.idealDirection.mag() < this.speed) {
       if (this.nearestFood != null) {
         // yay, we have the food!
         this.hasFood = true;
         this.exploring = false;
         this.finalDestination.set(this.antHill.get());
         food[(int) this.nearestFood.x][(int) this.nearestFood.y] = false;
       } else {
         // reached our random destination, now go look somewhere else
         this.newFinalDestination();
       }
       this.updateIdealDirection();
    } else if (this.appetite > this.maxAppetite) {
      // go home if we are too hungry
      this.exploring = false;
      this.finalDestination.set(this.antHill.get());
    }
    
    // stray off course if we’re looking for stuff
    int randomness = this.exploring ? 20 : 10;
    
    // figure out actual direction
    this.direction.rotate(random(randomness*-1, randomness));
    if (abs(this.getAngle()) > 45) {
      this.direction.set(this.idealDirection.get());
      this.direction.rotate(random(randomness*-1/2, randomness/2));
    }
    
    // set distance
    this.direction.normalize();
    float multiplier = this.idealDirection.mag() > this.speed ? this.speed : this.idealDirection.mag();
    this.direction.mult(this.speed);

    // update position, hitbox
    this.position.add(this.direction);
    this.updateHitBox();


    if (this.hasFood) {
      fill(128, 255, 128);
    } else {
      // set colour based on appetite
      this.whiteness = (int) map(this.appetite, 0, this.maxAppetite, 0, 128);
      // draw ant
      fill(255, whiteness, whiteness);
    }
    noStroke();
    ellipse(this.position.x, this.position.y, this.size, this.size);   

    // all this walking around is making us hungry
    this.appetite++;
  }
  
  void updateNearestFood ()
  {
    int xLow = (int) (this.position.x - this.rangeOfSight);
    int xHigh = (int) (this.position.x + this.rangeOfSight);
    int yLow = (int) (this.position.y - this.rangeOfSight);
    int yHigh = (int) (this.position.y + this.rangeOfSight);
    
    if (xLow < 0) xLow = 0;
    if (yLow < 0) yLow = 0;
    if (xHigh > width) xHigh = width;
    if (yHigh > height) yHigh = height;
    
    QVector2D temp = new QVector2D();
    QVector2D foodPosition = null;
    float lowestDistance = this.rangeOfSight;
    
    float distance = this.rangeOfSight + 1;
    
    for (int i = xLow; i < xHigh; i++) {
      for (int j = yLow; j < yHigh; j++) {
        if (food[i][j]) {
          temp.set(i, j);
          temp.sub(this.position);
          distance = temp.mag();
          if (distance < this.rangeOfSight && distance < lowestDistance) {
            lowestDistance = distance;
            foodPosition = new QVector2D(i, j);
          }
        }
      }
    }
    
    this.nearestFood = foodPosition;
  }
  
  void updateIdealDirection ()
  {
    this.idealDirection = this.finalDestination.get();
    this.idealDirection.sub(this.position);
  }
  
  void newFinalDestination ()
  {
    this.finalDestination.set(random(0, height), random(0, width));
  }
  
  void updateHitBox ()
  {
    this.hitBox.setLocation((int) this.position.x-(this.size/2), (int) this.position.y-(this.size/2));
  }
}