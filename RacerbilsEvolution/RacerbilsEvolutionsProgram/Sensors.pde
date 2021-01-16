class SensorSystem {
  //SensorSystem: Alle bilens sensorer - også dem, der ikke bruges af "hjernen".

  //Wall detectors.
  float sensorMag = 50;
  float sensorAngle = PI*2/8;

  int amountOfLaps = 0;
  int carCrash = 0;

  PVector anchorPos = new PVector();

  PVector sensorVectorFront = new PVector(0, sensorMag);
  PVector sensorVectorLeft = new PVector(0, sensorMag);
  PVector sensorVectorRight = new PVector(0, sensorMag);

  boolean frontSensorSignal = false;
  boolean leftSensorSignal = false;
  boolean rightSensorSignal = false;

  //"Outside the track" detection.
  int whiteSensorFrameCount = 0; //udenfor banen

  //Clockwise rotation detection.
  PVector centerToCarVector = new PVector();
  float lastRotationAngle = -1;
  float clockWiseRotationFrameCounter = 0;

  //lapTime calculation.
  boolean lastGreenDetection;
  int lastTimeInFrames = 0;
  int lapTimeInFrames = 10000;

  //Variables to calculate speed (speed = range over the last x steps).
  PVector speedStart = new PVector(190, 332); //The car always starts in this position (see file: Car).
  float speed = 0;

  void displaySensors() {
    strokeWeight(0.5);
    if (frontSensorSignal) { 
      fill(255, 0, 0);
      ellipse(anchorPos.x + sensorVectorFront.x, anchorPos.y + sensorVectorFront.y, 8, 8);
    }
    if (leftSensorSignal) { 
      fill(255, 0, 0);
      ellipse( anchorPos.x + sensorVectorLeft.x, anchorPos.y + sensorVectorLeft.y, 8, 8);
    }
    if (rightSensorSignal) { 
      fill(255, 0, 0);
      ellipse( anchorPos.x + sensorVectorRight.x, anchorPos.y + sensorVectorRight.y, 8, 8);
    }
    line(anchorPos.x, anchorPos.y, anchorPos.x+sensorVectorFront.x, anchorPos.y+sensorVectorFront.y);
    line(anchorPos.x, anchorPos.y, anchorPos.x+sensorVectorLeft.x, anchorPos.y+sensorVectorLeft.y);
    line(anchorPos.x, anchorPos.y, anchorPos.x+sensorVectorRight.x, anchorPos.y+sensorVectorRight.y);

    strokeWeight(2);
    if (whiteSensorFrameCount>0) {
      fill(whiteSensorFrameCount*10, 0, 0);
    } else {
      fill(0, clockWiseRotationFrameCounter, 0);
    }
    ellipse(anchorPos.x, anchorPos.y, 10, 10);
  }

  void updateSensorsignals(PVector pos, PVector vel) {
    //Collision detector.
    frontSensorSignal = get(int(pos.x + sensorVectorFront.x), int(pos.y + sensorVectorFront.y)) == -1?true:false;
    leftSensorSignal = get(int(pos.x + sensorVectorLeft.x), int(pos.y + sensorVectorLeft.y)) == -1?true:false;
    rightSensorSignal = get(int(pos.x + sensorVectorRight.x), int(pos.y + sensorVectorRight.y)) == -1?true:false;  

    //"Outside the track" detector.
    color color_car_position = get(int(pos.x), int(pos.y));
    if (color_car_position == -1) {
      whiteSensorFrameCount = whiteSensorFrameCount + 1;
    }

    //Laptime calculation
    boolean currentGreenDetection = false;
    if (red(color_car_position) < 100 && blue(color_car_position) < 100 && green(color_car_position) > 200) { //Den grønne målstreg er detekteret.
      currentGreenDetection = true;
    }

    if (lastGreenDetection && !currentGreenDetection) {  //Sidst grønt, nu ikke = vi har passeret målstregen.
      lapTimeInFrames = frameCount - lastTimeInFrames; //Laptime beregnes: frames nu - frames sidst.
      lastTimeInFrames = frameCount;
      amountOfLaps = amountOfLaps + 1;
    }   
    lastGreenDetection = currentGreenDetection; //Husker, om der var grønt sidst.
    //Count clockWiseRotationFrameCounter.
    centerToCarVector.set((height/2) - pos.x, (width/2) - pos.y);    
    float currentRotationAngle = centerToCarVector.heading();
    float deltaHeading = lastRotationAngle - centerToCarVector.heading();
    clockWiseRotationFrameCounter = deltaHeading > 0 ? clockWiseRotationFrameCounter + 1 : clockWiseRotationFrameCounter -1;
    lastRotationAngle = currentRotationAngle;

    //To avoid that the clockWiseRotationFrameCounter will overrule lapTimeInFrames in the fitness-function.
    if (clockWiseRotationFrameCounter > 1000 ) {
      clockWiseRotationFrameCounter = clockWiseRotationFrameCounter - 100;
    }

    updateSensorVectors(vel);

    anchorPos.set(pos.x, pos.y);

    /*
    //Calculates the time for to drive a lap.
     if (lastGreenDetection == true && red(color_car_position) < 100 && blue(color_car_position) > 200 && green(color_car_position) < 100) {
     //println("Laptime for racecar " + lastTimeInFrames/60 + " sekunder");
     }
     //Calculates the amount of laps passed by a racecar.
     if (lastGreenDetection == true && red(color_car_position) < 100 && blue(color_car_position) > 200 && green(color_car_position) < 100) {
     lastTimeInFrames = 0;
     amountOfLaps = amountOfLaps + 1; 
     //println("Racecar laps: " + amountOfLaps);
     }
     
     //Calculates the amount of cars driven over the finishline.
     if (lastGreenDetection == true) {
     //println("Amount of cars over the finishline: " + amountOfLaps);
     }
     */

    //Calculation of speed (we use Pythagoras to calculate this). Speed is calculated every 50 framecounts.
    if (frameCount%50 == 0) {
      speed = sqrt(pow(pos.x - speedStart.x, 2) + pow(pos.y - speedStart.y, 2));
      //Set "speedStart" to new last position.
      speedStart.x = pos.x;
      speedStart.y = pos.y;
    }
  }

  void updateSensorVectors(PVector vel) {
    if (vel.mag() != 0) {
      sensorVectorFront.set(vel);
      sensorVectorFront.normalize();
      sensorVectorFront.mult(sensorMag);
    }
    sensorVectorLeft.set(sensorVectorFront);
    sensorVectorLeft.rotate(-sensorAngle);
    sensorVectorRight.set(sensorVectorFront);
    sensorVectorRight.rotate(sensorAngle);
  }
}
