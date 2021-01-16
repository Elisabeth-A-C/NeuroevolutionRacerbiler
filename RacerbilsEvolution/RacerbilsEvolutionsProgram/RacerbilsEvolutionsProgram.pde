//populationSize: Hvor mange "controllere", der genereres. Controller = bil, hjerne & sensorer.  //<>//
int populationSize = 100;     

//CarSystem: Indholder en population af "controllere".
CarSystem carSystem = new CarSystem(populationSize);

//trackImage: RacerBanen. Vejen = sort; udenfor banen = hvid; målstreg = 100% grøn.
PImage trackImage;

float bestAmountOfLaps = 0;
float bestLapTimeInFrames = 0;

void setup() {
  size(690, 638);
  trackImage = loadImage("track.png");
}

void draw() {
  clear();
  fill(255);
  rect(0, 0, 1000, 1000);
  image(trackImage, 100, 100);  

  carSystem.updateAndDisplay();

  //Frastortering af dårlige biler, for hver gang der går 100 frames. Dårlige biler = de biler, der er udenfor banen, og biler, der kører rundt om sig selv.
  if (frameCount%100 == 0) {
    for (int i = carSystem.CarControllerList.size()-1; i >= 0; i--) {
      CarController c = carSystem.CarControllerList.get(i);
      if (c.sensorSystem.whiteSensorFrameCount > 0 || c.sensorSystem.speed < 40) {
        carSystem.CarControllerList.remove(c);
      }
    }
    for (int i = carSystem.CarControllerList.size(); i < populationSize; i++) { 
      CarController controller = new CarController();
      carSystem.CarControllerList.add(controller);
    }
    carSystem.crossover();
    carSystem.mutation();

    //Get the best car and set that car to bestAmountOfLaps and bestLapTimeInFrames.
    CarController bestCar = carSystem.CarControllerList.get(0);
    bestAmountOfLaps = bestCar.sensorSystem.amountOfLaps;
    bestLapTimeInFrames = bestCar.sensorSystem.lapTimeInFrames;
  }

  //Draw statics.
  fill(0);
  textSize(17);
  text("Statistics for the car with the highest fitness:", width*0.05, height*0.85);
  if (bestLapTimeInFrames == 10000) {
    bestLapTimeInFrames = 0;
  }
  textSize(13);
  text("Racecar laps: " + bestAmountOfLaps, width*0.05, height*0.88);
  text("Racecar lap time: " + bestLapTimeInFrames, width*0.05, height*0.91);
}

/*
//Test the color of the finish lines.
 void mouseClicked() {
 color c = get(mouseX, mouseY);
 println(" " + red(c) + " " + green(c) + " " + blue(c));
 }
 */
