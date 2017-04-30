// Doodles
// Use an LSystem to draw doodles.

import java.util.Calendar;

Population population;

// Population options
int populationSize = 100;
float mutationRate = 0.01;
int generations = 25;

// Output options
String savesPrefix = "populations/population_";
String starredSavesPrefix = "starred/";
boolean printRulesForFittest = false;
boolean dumpPopulationDNA = true;
boolean drawFitestOnly = true;
boolean outputDNAAndFitness = false;
int memberToDraw = 0;
boolean saveDoodle = false;
boolean showHelp = false;
boolean drawAxis = false;

void setup() {
  size(800, 600);
  frameRate(12);
}

void draw() {
  background(255);
  translate(width/2, height/2);

  drawHelp();
  
  if (drawAxis) {
    stroke(190);
    line(0, -height/2, 0, height/2);
    line(-width/2, 0, width/2, 0);
    stroke(0);
  }

  if (population != null) {
    if (drawFitestOnly) {
      drawDoodleWithDNAInfo(population.getFitest());

      if (saveDoodle) {
        saveFrame(savesPrefix + population.getId() + "/member_fittest.png");
      }
    } else {
      drawDoodleWithDNAInfo(population.getMember(memberToDraw));
      memberToDraw = (memberToDraw + 1) % population.getPopulationSize();

      if (saveDoodle) {
        saveFrame(savesPrefix + population.getId() + "/member_" + zeroPadded(memberToDraw) + ".png");
      }
    }
  } else {
    drawStartInstructions();
  }
}

void drawHelp() {
  String helpMessage  = "Click to generate a new image.\n" +
    "Press 's' to save.\n" +
    "Press 'a' to print analysis.\n" +
    "Press 'x' to toggle the axis.\n" +
    "Press 'f' to toggle between fittest and all.\n" +
    "Press 'h' to close help.";

  if (!showHelp) {
    helpMessage = "Press 'h' for help.";
  }

  textSize(12);
  textAlign(LEFT);
  fill(0, 0, 0);
  text(helpMessage, -width/2, -height/2 + 12);
  fill(255, 255, 255);
}

void drawDoodleWithDNAInfo(Doodle doodle) {
  if (doodle.getFitness().getFitnessRating() > 0) {
    pushMatrix();
    doodle.drawDoodle();
    popMatrix();
  }

  if (outputDNAAndFitness) {
    textSize(12);
    textAlign(CENTER);
    fill(0, 0, 0);
    text(String.format("DNA: %s, Fitness: %f",
      doodle.getDNA().toString(), doodle.getFitness().getFitnessRating()), 0, height/2 - 36);
    fill(255, 255, 255);
  }
}

void drawStartInstructions() {
  textSize(12);
  textAlign(CENTER);
  fill(0, 0, 0);
  text("Click to generate a new image.", 0, 0);
  fill(255, 255, 255);
}

void mousePressed() {
  run();
}

void run() {
  population = new Population(timestamp(), populationSize, mutationRate);

  for (int i = 0; i != generations; i++) {
    if (dumpPopulationDNA) {
      dumpPopulationDNAToDisk(population);
    }

    population.select();
    population.reproduce();
  }

  if (printRulesForFittest) {
    Doodle fitest = population.getFitest();
    Rule[] rules = fitest.getRules();
    for (int i = 0; i != rules.length; i++) {
      println(rules[i]);
    }
  }
}

void dumpPopulationDNAToDisk(Population population) {
  PrintWriter writer =  createWriter(savesPrefix + population.getId() + "/gen_" + zeroPadded(population.getGenerations()) + "_.txt");
  Doodle[] populationMembers = population.getMembers();
  for (int j = 0; j != populationMembers.length; j++) {
    Doodle member = populationMembers[j];
    writer.println(j + " | " + member.getDNA().toString() + "  |  " + member.getFitness().getFitnessRating());
  }
  writer.flush();
  writer.close();
}

void keyPressed() {
  if (key == 'a') {
    println(population.getFitest().getFitness());
  } else if (key == 's') {
    saveFrame(starredSavesPrefix + population.getFitest().getDNA().encode() + ".png");
  } else if (key == 'x') {
    drawAxis = !drawAxis;
  } else if (key == 'f') {
    memberToDraw = 0;
    drawFitestOnly = !drawFitestOnly;
  } else if (key == 'h') {
    showHelp = !showHelp;
  }
}

String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

String zeroPadded(int i) {
  return String.format("%02d", i);
}