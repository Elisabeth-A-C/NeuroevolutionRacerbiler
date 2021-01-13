import java.util.ArrayList; //<>// //<>//
import java.util.Collections;
import java.util.Comparator;

class CarSystem {
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

  //Crossover-function.
  void crossover() {
    //Sort cars by fitness (by the use of the sorting algorithm underneath).
    Collections.sort(CarControllerList, new CarControllerComparator());

    for (int g = populationSize/5; g < populationSize; g++) {
      //We will utilize the x^4 function to prioritize the cars with the highest fitness.
      float r;
      int p1;
      int p2;

      r = random(1);
      p1 = floor(populationSize*pow(r, 4));
      do {
        r = random(1);
        p2 =  floor(populationSize*pow(r, 4));
      } while (p1 == p2);

      //Make the crossover.
      CarController c1 = CarControllerList.get(p1);
      CarController c2 = CarControllerList.get(p2);
      CarController child = CarControllerList.get(g);
      child.hjerne.weights[0] = c1.hjerne.weights[0];
      child.hjerne.weights[1] = c2.hjerne.weights[1];
      child.hjerne.weights[2] = c1.hjerne.weights[2];
      child.hjerne.weights[3] = c2.hjerne.weights[3];
      child.hjerne.weights[4] = c1.hjerne.weights[4];
      child.hjerne.weights[5] = c2.hjerne.weights[5];
      child.hjerne.weights[6] = c1.hjerne.weights[6];
      child.hjerne.weights[7] = c2.hjerne.weights[7];
      child.hjerne.biases[0] = c1.hjerne.biases[0];
      child.hjerne.biases[1] = c2.hjerne.biases[1];
      child.hjerne.biases[2] = c1.hjerne.biases[2];
    }
  }
}

//Create sorting algorithm found on the internet: https://www.javacodeexamples.com/java-sort-arraylist-using-comparator-example/449
class CarControllerComparator implements Comparator<CarController> {
  public int compare(CarController car1, CarController car2) {
    if (car1.fitness() > car2.fitness() ) {
      return 1;
    } else if ( car1.fitness() < car2.fitness()) {
      return -1;
    } else {
      return 0;
    }
  }
}
