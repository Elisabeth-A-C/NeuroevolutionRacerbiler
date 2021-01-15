//populationSize: Hvor mange "controllere", der genereres. Controller = bil, hjerne & sensorer. //<>// //<>//
int populationSize = 100;     

//CarSystem: Indholder en population af "controllere".
CarSystem carSystem = new CarSystem(populationSize);

//trackImage: RacerBanen. Vejen = sort; udenfor banen = hvid; målstreg = 100% grøn.
PImage trackImage;

void setup() {
  size(490, 438);
  trackImage = loadImage("track.png");
}

void draw() {
  clear();
  fill(255);
  rect(0, 50, 1000, 1000);
  image(trackImage, 0, 0);  

  carSystem.updateAndDisplay();

  //Frastortering af dårlige biler, for hver gang der går 50 frames. Dårlige biler = de biler, der er udenfor banen, og biler, der kører rundt om sig selv.
  if (frameCount%50 == 0) {
    for (int i = carSystem.CarControllerList.size()-1; i >= 0; i--) {
      CarController c = carSystem.CarControllerList.get(i);
      if (c.sensorSystem.whiteSensorFrameCount > 0 || c.sensorSystem.speed < 20) {
        carSystem.CarControllerList.remove(c);
      }
    }
    for (int i = carSystem.CarControllerList.size(); i < populationSize; i++) { 
      CarController controller = new CarController();
      carSystem.CarControllerList.add(controller);
    }
    carSystem.crossover();
    carSystem.mutation();
  }
}
