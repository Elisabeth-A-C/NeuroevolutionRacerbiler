class Car {  
  //Bil - indeholder position, hastighed & "visning af bil".
  PVector pos = new PVector(190, 332);
  PVector vel = new PVector(0, 5);

  void turnCar(float turnAngle) {
    vel.rotate(turnAngle);
  }

  void displayCar() {
    stroke(100);
    fill(100);
    ellipse(pos.x, pos.y, 10, 10);
  }

  void update() {
    pos.add(vel);
  }
}
