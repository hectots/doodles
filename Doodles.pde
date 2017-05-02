// Doodles
// Use an LSystem to draw doodles.

import java.util.Calendar;

Population population;

// Population options
int populationSize = 100;
float mutationRate = 0.01;
int maxGenerations = 25;

// Fitness factors
float symmetryImportanceFactor = 1;
float distributionImportanceFactor = 2;
float growthImportanceFactor = 3;
float minimumFitness = 0.9;

// Output options
String savesPrefix = "populations/population_";
String starredSavesPrefix = "starred/";
boolean printRulesForFittest = false;
boolean dumpPopulationDNA = true;
boolean drawFitestOnly = true;
boolean outputDNAAndFitness = false;
boolean saveDoodle = false;
boolean showHelp = false;
boolean drawAxis = false;

int memberToDraw = 0;

void setup() {
  size(800, 600);
  frameRate(12);
}

void draw() {
  if (frameCount % 6 == 0) {
    background(0);
    blendMode(ADD);
    noFill();
    stroke(0);
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
}

void drawHelp() {
  String helpMessage  = "Click to generate a new image.\n" +
    "Press 's' to save.\n" +
    "Press 'a' to print analysis.\n" +
    "Press 'x' to toggle the axis.\n" +
    "Press 'f' to toggle between fittest and all.\n" +
    "Press 'i' to toggle DNA and fitness information.\n" +
    "Press 'h' to close help.";

  if (!showHelp) {
    helpMessage = "Press 'h' for help.";
  }

  textSize(12);
  textAlign(LEFT);
  fill(255, 255, 255);
  text(helpMessage, -width/2, -height/2 + 12);
  fill(0, 0, 0);
}

void drawDoodleWithDNAInfo(Doodle doodle) {
  if (doodle.getFitness().getRating() > 0) {
    pushMatrix();
    doodle.drawDoodle();
    popMatrix();
  }

  if (outputDNAAndFitness) {
    textSize(12);
    textAlign(CENTER);
    fill(255, 255, 255);
    text(String.format("DNA: %s\nFitness: %f",
      doodle.getDNA().toString(), doodle.getFitness().getRating()), 0, height/2 - 36);
    fill(0, 0, 0);
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

  do {
    if (dumpPopulationDNA) {
      dumpPopulationDNAToDisk(population);
    }

    population.select();
    population.reproduce();

    if (population.getMaxFitness() <= 0) {
      // A max fitness of zero means a failed population.
      // Start over with a new random population.
      population = new Population(timestamp(), populationSize, mutationRate);
    }
  } while (population.getMaxFitness() <= minimumFitness && population.getGenerations() <= maxGenerations);

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
    writer.println(j + " | " + member.getDNA().toString() + "  |  " + member.getFitness().getRating());
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
  } else if (key == 'i') {
    outputDNAAndFitness = !outputDNAAndFitness;
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