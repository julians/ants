class AntHill
{
  QVector2D position;
  int food;
  ArrayList ants;
  
  AntHill (QVector2D _position)
  {
    this.position = _position;
    this.food = 6000;
    this.ants = new ArrayList();
  }
  
  void addFood (int _food)
  {
    this.food += _food;
  }
  
  int takeFood (int _food)
  {
    if (this.food > _food) {
      //this.food -= _food;
      return _food;
    } else {
      return 0;
    }
  }
  
  void addAnt ()
  {
    this.ants.add(new Ant(this));
  }
  
  void draw ()
  {
    if (drawObjects) {
      noStroke();
      fill(0);
      ellipse(this.position.x, this.position.y, 10, 10);
    }
    
    Ant ant;
    for (int i = 0; i < this.ants.size(); i++) {
      ant = (Ant) this.ants.get(i);
      ant.draw();
    }
  }
  
  QVector2D getPosition ()
  {
    return this.position.get();
  }
}