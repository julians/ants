class Ant
{
  AntHill antHill;
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
  float rangeOfSight = 10;
  QVector2D nearestFood = null;
  float rangeOfSmell = 10;
  QVector2D nearestSmell = null;
  
  QVector2D tempVector1 = new QVector2D(0, 0);
  QVector2D tempVector2 = new QVector2D(0, 0);
  
  Ant (AntHill _antHill)
  {
    this.antHill = _antHill;
    this.position = this.antHill.getPosition();
    this.hitBox = new Rectangle((int) this.position.x-(this.size/2), (int) this.position.y-(this.size/2), this.size, this.size);
  }
  
  float getAngle ()
  {
    return (float) Math.toDegrees(this.direction.heading2D());
  }
  
  float getIdealAngle ()
  {
    return (float) Math.toDegrees(this.idealDirection.heading2D());
  }
  
  float getDeviation ()
  {
    return this.getAngle() - this.getIdealAngle();
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
    if (this.isHome() && this.hasFood) {
      this.antHill.addFood(foodValue);
      this.hasFood = false;
    } else if (this.appetite > 0 && this.isHome()) {
      this.appetite -= this.antHill.takeFood(2);
    } else {
      if (this.appetite <= 0) this.leaveAntHill();
      this.go();
    }
  }
  
  boolean isHome ()
  {
    QVector2D temp = this.antHill.getPosition();
    temp.sub(this.position);
    return (temp.mag() < 2);
  }
  
  void go ()
  {
    if (!this.hasFood && this.appetite < this.maxAppetite) {
      this.updateNearestFood();
      if (this.nearestFood != null) {
        this.finalDestination.set(this.nearestFood.get());
      } else {
        this.smell();
        if (this.nearestSmell != null) {
          this.finalDestination.set(this.nearestSmell.get());
        }
      }
    }
        
    this.updateIdealDirection();
    
    if (this.idealDirection.mag() < this.speed) {
      if (this.nearestFood != null) {
        // yay, we have the food!
        this.hasFood = true;
        this.exploring = false;
        this.finalDestination.set(this.antHill.getPosition());
        food[(int) this.nearestFood.x][(int) this.nearestFood.y] = false;
      } else {
        // reached our random destination, now go look somewhere else
        this.newFinalDestination();
      }
      this.updateIdealDirection();
    } else if (this.appetite > this.maxAppetite) {
      // go home if we are too hungry
      this.exploring = false;
      this.finalDestination.set(this.antHill.getPosition());
    }
    
    // stray off course if we’re looking for stuff
    int randomness = this.exploring ? 20 : 5;
    
    // figure out actual direction
    this.direction.rotate(random(randomness*-1, randomness));
    if (abs(this.getDeviation()) > (randomness * 2)) {
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
    
    // draw the ant
    if (drawObjects) {
      if (this.hasFood) {
        fill(128, 255, 128);
      } else {
        // set colour based on appetite
        this.whiteness = (int) map(this.appetite, 0, this.maxAppetite, 0, 128);
        fill(255, whiteness, whiteness);
      }
      noStroke();
      ellipse(this.position.x, this.position.y, this.size, this.size);   
    }

    // all this walking around is making us hungry
    this.appetite++;
    
    // leave some pheromones if we have food
    if (this.hasFood) {
      scent[(int) constrain(this.position.x, 0, width-1)][(int) constrain(this.position.y, 0, height-1)] += 10;
    } else {
      if (scent[(int) constrain(this.position.x, 0, width-1)][(int) constrain(this.position.y, 0, height-1)] > 0.5) {
        scent[(int) constrain(this.position.x, 0, width-1)][(int) constrain(this.position.y, 0, height-1)] *= 5;
      }
      paths[(int) constrain(this.position.x, 0, width-1)][(int) constrain(this.position.y, 0, height-1)] += 10;
    }
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
    
    this.tempVector2 = null;
    float lowestDistance = this.rangeOfSight;
    
    float distance = this.rangeOfSight + 1;
    
    for (int i = xLow; i < xHigh; i++) {
      for (int j = yLow; j < yHigh; j++) {
        if (food[i][j]) {
          this.tempVector1.set(i, j);
          this.tempVector1.sub(this.position);
          distance = this.tempVector1.mag();
          if (distance < this.rangeOfSight && distance < lowestDistance) {
            lowestDistance = distance;
            this.tempVector2 = new QVector2D(i, j);
          }
        }
      }
    }
    
    this.nearestFood = this.tempVector2 == null ? null : this.tempVector2.get();
  }
  
  void smell ()
  {
    float angle = this.getAngle();
    int xLow = 0;
    int xHigh = 0;
    int yLow = 0;
    int yHigh = 0;
    
    // this is where paying attention in math classes would have really helped…
    if (angle > -45 && angle < 45) {
      xLow = (int) (this.position.x + 1);
      xHigh = (int) (this.position.x + this.rangeOfSmell);
      yLow = (int) (this.position.y - this.rangeOfSmell);
      yHigh = (int) (this.position.y + this.rangeOfSmell);
    } else if (angle > 45 && angle < 135) {
      xLow = (int) (this.position.x - this.rangeOfSmell);
      xHigh = (int) (this.position.x + this.rangeOfSmell);
      yLow = (int) (this.position.y + 1);
      yHigh = (int) (this.position.y + this.rangeOfSmell);
    } else if (angle < -45 && angle > -135) {
      xLow = (int) (this.position.x - this.rangeOfSmell);
      xHigh = (int) (this.position.x + this.rangeOfSmell);
      yLow = (int) (this.position.y - this.rangeOfSmell);
      yHigh = (int) (this.position.y - 1);
    } else {
      xLow = (int) (this.position.x - this.rangeOfSmell);
      xHigh = (int) (this.position.x - 1);
      yLow = (int) (this.position.y - this.rangeOfSmell);
      yHigh = (int) (this.position.y + this.rangeOfSmell);
    }
    
    if (xLow < 0) xLow = 0;
    if (yLow < 0) yLow = 0;
    if (xHigh > width) xHigh = width;
    if (yHigh > height) yHigh = height;
    
    this.tempVector2 = null;
    float lowestDistance = this.rangeOfSmell;
    
    float distance = this.rangeOfSmell + 1;
    
    for (int i = xLow; i < xHigh; i++) {
      for (int j = yLow; j < yHigh; j++) {
        if (scent[i][j] > 0.5) {
          this.tempVector1.set(i, j);
          this.tempVector1.sub(this.position);
          distance = this.tempVector1.mag();
          if (distance < this.rangeOfSmell && distance < lowestDistance) {
            lowestDistance = distance;
            this.tempVector2 = new QVector2D(i, j);
          }
        }
      }
    }
    
    this.nearestSmell = this.tempVector2 == null ? null : this.tempVector2.get();
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