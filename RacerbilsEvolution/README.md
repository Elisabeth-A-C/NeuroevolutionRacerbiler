# Racerbils Neuro Evolution
Dette repo indeholder kode og materiale til forløbet "Racerbils Evolution". </br>
Formålet med forløbet er at bygge en genetisk algoritme, der kan udvikle den hurtigst mulige racerbil. </br> 
Dvs. den bil, der kan gennemføre en omgang på den virtuelle 2D-racerbane hurtigst muligt uden at køre galt.</br>
Racerbilerne styres af et såkaldt neuralt netværk.

## Bekrivelse af programmet 
### Racerbils Evolutions Programmet
Mappen "RacerBilsEvolutionsProgram" indeholder et program til at generere "tilfældige", simple autonome racerbiler i en 2D verden. 
Med tilfældige menes, at deres hjerner - et simpelt neuralt netværk - endnu ikke er indstillet/optimeret, da dette skal gøres med en genetisk algoritme. 
De autonome bilers sensorsystem kan genkende tre forskellige farver: "hvid", som er udenfor banen, og "grøn" og "blå", som er målstregen.
Genkendelse af farven grøn og blå kan bruges til at beregne, hvor hurtigt bilen gennemfører en omgang. Der er både valgt en blå og en grøn målstreg, da det på denne måde sikres, at bilen rent faktisk kører over målstregen og ikke bare "snyder" ved at køre den forkerte vej over målstregen. Det to målstreget (den grønne og den blå) er placeret på hver deres side af banen, hvilket sikrer, at bilerne kører en hel gang rundt om banen og ikke finder en kortere vej gennem banen. 
Bilerne bevæger sig med en konstant hastighed på 5 pixels pr. frame, og de ændrer retning ved at rotere om egen akse. Nedenfor ses et screenshot af programmet:</br>
![Programmet køres](billeder/WorldOfRacerbiler.png)

### Racerbilens grafiske visning
Nedenfor ses en racerbil, som den ser ud i programmet. Den højre sensor har detekteret den hvide farve og lyser rødt:
![Den Autonome Racerbil Grafiske repræsentation](billeder/CarAndSensors.png)

## Beksrivelse af bilens hjerne: Det neurale netværk
Bilernes hjerner styrer bilen ved at reagere på input fra de sensorer, der registerer farven "hvid", da alt udenfor banen er hvidt.
Hjernen fortæller baseret på sine input, om bilen skal rotere til venstre eller højre.
Hjernen er et simpelt fuldt forbundet feedforward neuralt netværk. Nedenfor ses et diagram over bilens neurale netværk:</br>
![Den Autonome Racerbils hjerne](billeder/NN1.png)

Et neuralt netværk er opbygget af neuroner (vist med cirkler), som modtager et vilkårligt antal input, som hver bliver multipliceret med et tal kaldet en "vægt" (vist som w). Reultatet bliver adderet med et andet tal kaldet "bias" (ikke vist) og sendes igennem en matematisk funktion kaldet en "aktiverings funktion" (ikke vist). Vi arbejder med meget simple neuroner, hvis aktivitetsfunktion bare er f(x) = x eller y = x.</br>
Man tegner normalt input til hele det neurale netværk, som neuroner markeret med x (de grønne cirkler), selvom de i virkeligheden bare er input.</br>
Nedenfor ses et eksempel på en neuron:</br>
![Eksempel på en neuron](billeder/NeuronExample.png)

Styrken ved det neurale netværk ligger i muligheden for at justere "vægte" og "bias", indtil det giver os det ønskede svar, dvs. styrer bilen uden at køre udenfor banen.</br>
Blandt andet indenfor billedgenkendelse er væsenligt mere komplicerede neurale netværk populære. Til disse typer opgaver anvendes træningsmetoder kategoriseret som "Deep Learning". 

## Beskrivelse af koden: De vigtigste klasser
### Klassediagram over den autonome racerbil
Nedenfor ses et klassediagram for vigtigste dele af "den autonome racerbil", i koden kaldet "CarController":</br></br>
![Den Autonome Racerbil klasse komposition, kaldet CarController](billeder/CarControllerDiagram.png)
### CarController: Den autonome bil. Indeholder et SensorSystem, et NeuraltNetwork og en Car.
CarControlleren fodrer NeuraltNetwork  med signaler fra SensorSystem’s left/right/front/sensor. </br>
Det neurale netværks output styrer bilen.</br>
### Car: Bilen. 
Hastigheden er konstant 5 pixels/frame. Bilen kan kun dreje/rotere enten til venstre eller højre. </br>
### SensorSystem: Sensorer. Til at styre en bil og udregne fitness. Indeholder følgende vigtige målinger:
**whiteSensorFrameCount:**  Antal frames bilen er i det hvide område uden for banen</br>
**frontSensorSignal & leftSensorSignal & rightSensorSignal:** Detektion af hvidt, 50 pixels foran bilen.</br>
**clockWiseRotationFrameCounter:** Antal frames kørt  “i urets retning”.</br>
**lapTimeInFrames:** Antal frames bilen bruger inden den kører over den grønne streg.</br>
**amountOfLaps:** Antal runder, som bilerne har kørt rundt i banen.</br>

### NeuralNetwork: Hjernen. 
Et simpelt netværk: 3 input-, 2 mellem-lags- og 1 output-neuroner.</br>

# Den genetiske algoritme
## Udregning af laps og tid
"amountOfLaps" og "lapTimeInFrames" bruges for at beregne antal af runder, racerbilerne kører, og hvor lang tid runderne tager i frames. For at beregne "amountOfLaps", kigger vi på de 2 forskellige målstreger på banen (den grønne og den blå). Der bruges to målstreger med forskellige farver for at sikre, at bilen kører den rigtige vej rundt i banen, og målstregerne er spredt ud over banen, så det sikres, at en bil ikke kan "snyde" sig til en hurtigere tid ved at finde en kortere vej gennem banen.
Der er en grøn målstreg og en blå målstreg. Vi kan se, at en bil har kørt rundt om banen ved at kigge på, at hvis racerbilen sidst har rørt den grønne, og den så rør den blå målstreg, men ikke rør den grønne og så den grønne igen (da den så vil have kørt over den samme målstreg som før). Vi tager brug af de 2 målstreger, da der opstod et problem med, at racerbilerne blev ved med at køre frem og tilbage over den grønne målstreg. Dette betød, at tallene ikke viste "amountOfLaps" og dermed heller ikke "lapTimeInFrames" ordenligt.</br>
For at vise "amountOfLaps" og "lapTimeInFrames" for kun den bedste bil (alias bilen med højest fitness) er variablen "bestCar" oprettet og defineret ud fra bilen sorteret til at have den højeste fitness, og derefter er "bestAmountOfLaps" og "bestLapTimeInFrames" defineret ud fra "bestCar", så vi får amountOfLaps og lapTimeInFrames for kun den bil med højest fitness, som vil svare til den hurtigste bil. Det er dermed kun den bedste bil (med højest fitness), som vi viser i selve programmets interface (ikke i konsollen; her vises blot "amountOfLaps" og "lapTimesInFrames" (for alle bilerne)). 
