// Doodles
// Use an LSystem to draw doodles.

Doodle fitest;

void setup() {
  size(800, 600);
}

void draw() {
  background(255);
  translate(width/2, height/2);

  if (fitest != null) {
    fitest.drawDoodle();
  }
}

void mousePressed() {
  run();
}

void run() {
  int populationSize = 100;
  float mutationRate = 0.01;
  int generations = 25;
  Population population = new Population(populationSize, mutationRate);

  for (int i = 0; i != generations; i++) {
    population.select();
    population.reproduce();
  }

  fitest = population.getFitest();
  Rule[] rules = fitest.getRules();
  for (int i = 0; i != rules.length; i++) {
    println(rules[i]);
  }
}