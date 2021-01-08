class CarSystem { //<>//
  //CarSystem.
  //Her kan man lave en generisk algoritme, der skaber en optimal "hjerne" til de forhåndenværende betingelser.

  ArrayList<CarController> CarControllerList = new ArrayList<CarController>();

  CarSystem(int populationSize) {
    for (int i = 0; i < populationSize; i++) { 
      CarController controller = new CarController();
      CarControllerList.add(controller);
    }
  }

  void updateAndDisplay() {
    //1. Opdaterer sensorer og bilpositioner.
    for (CarController controller : CarControllerList) {
      controller.update();
    }

    //2. Tegner til sidst - så sensorer kun ser banen og ikke andre biler!
    for (CarController controller : CarControllerList) {
      controller.display();
    }
  }
}
