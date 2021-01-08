class CarController {
  //Forbinder af sensorer, hjerne & bil.
  float varians = 2; //Definerer størrelsen af variansen på de tilfældige vægte og bias.
  Car bil = new Car();
  NeuralNetwork hjerne = new NeuralNetwork(varians); 
  SensorSystem sensorSystem = new SensorSystem();

  void update() {
    //1. Opdaterer bil. 
    bil.update();

    //2. Opdaterer sensorer.    
    sensorSystem.updateSensorsignals(bil.pos, bil.vel);

    //3. Hjernen beregner hvor mange grader, der skal drejes.
    float turnAngle = 0;
    float x1 = (float)int(sensorSystem.leftSensorSignal);
    float x2 = (float)int(sensorSystem.frontSensorSignal);
    float x3 = (float)int(sensorSystem.rightSensorSignal);    
    turnAngle = hjerne.getOutput(x1, x2, x3);

    //4. Bilen drejes.
    bil.turnCar(turnAngle);
  }

  void display() {
    bil.displayCar();
    sensorSystem.displaySensors();
  }

  //Calculate fitness; the longer the sensors is outside the black track, the lower the fitness.
  float fitness() {
    //This function doesn't consider if a car just turns clockwise but doesn't drive around the track - it will still give those cars a higher fitness. 
    //We will solve this issue later by making another function that consider how fast the car drive around the track.
    if (sensorSystem.whiteSensorFrameCount > 0) {
      return(0);
    } else {
      return(sensorSystem.clockWiseRotationFrameCounter + 1);
    }
  }
}
