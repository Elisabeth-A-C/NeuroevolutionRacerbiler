//populationSize: Hvor mange "controllere" der genereres, controller = bil & hjerne & sensorer //<>//
int populationSize  = 100;     

//CarSystem: Indholder en population af "controllere" 
CarSystem carSystem       = new CarSystem(populationSize);

//trackImage: RacerBanen , Vejen = sort, Udenfor = hvid, Målstreg = 100%grøn.
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

  //Frastortering af dårlige biler, for hver gang der går 200 frame - f.eks. dem der kører uden for banen.
  if (frameCount%100 == 0) {
    println("FJERN DEM DER KØRER UDENFOR BANEN frameCount: " + frameCount);
    for (int i = carSystem.CarControllerList.size()-1; i >= 0; i--) {
      CarController c = carSystem.CarControllerList.get(i);
      if (c.sensorSystem.fitness() == 0) {
        carSystem.CarControllerList.remove(c);
      }
    }
    for (int i = carSystem.CarControllerList.size(); i < populationSize; i++) { 
      CarController controller = new CarController();
      carSystem.CarControllerList.add(controller);
    }
  }
}
