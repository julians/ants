class AntHill
{
  QVector2D position;
  int food;
  Ant[] ants = new Ant[99];
  int numberOfAnts = 0;
  
  AntHill (QVector2D _position)
  {
    this.position = _position;
    this.food = 6000;
  }
  
  void addFood (int _food)
  {
    this.food += _food;
  }
  
  int takeFood (int _food)
  {
    if (this.food > _food) {
      this.food -= _food;
      return _food;
    } else {
      return 0;
    }
  }
  
  void addAnt ()
  {
    this.ants[this.numberOfAnts] = new Ant(this);
    this.numberOfAnts++;
  }
  
  void draw ()
  {
    noStroke();
    fill(0);
    ellipse(this.position.x, this.position.y, 10, 10);
    
    for (int i = 0; i < this.numberOfAnts; i++) {
      this.ants[i].draw();
    }
  }
  
  QVector2D getPosition ()
  {
    return this.position.get();
  }
}