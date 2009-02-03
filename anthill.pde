class AntHill
{
  QVector2D position;
  int food;
  ArrayList ants;
  int timer = 0;
  boolean dead = false;
  
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
      this.food -= _food;
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
      fill(50);
      ellipse(this.position.x, this.position.y, 10, 10);
    }
    
    Ant ant;
    for (int i = 0; i < this.ants.size(); i++) {
      ant = (Ant) this.ants.get(i);
      if (ant.timeWithoutFood > 600) {
        this.ants.remove(i);
      } else {
        ant.draw();        
      }
    }
    
    this.timer++;
    println(this.food);
    println(this.ants.size());
    if (this.food > 5000 && this.timer >= 600) {
      this.addAnt();
      this.timer = 0;
    }
    
    if (this.food < 500 && this.ants.size() == 0) this.dead = true;
  }
  
  QVector2D getPosition ()
  {
    return this.position.get();
  }
}