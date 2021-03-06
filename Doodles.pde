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
boolean outputDNAAndFitness = true;
boolean saveDoodle = true;
boolean showHelp = false;
boolean drawAxis = false;

Theme lightTheme = new Theme(color(255, 255, 255), color(0, 0, 0), color(0, 0, 0));
Theme darkTheme = new Theme(color(0, 0, 0), color(255, 64, 8, 128), color(255, 255, 255));
Theme currentTheme = darkTheme;

int memberToDraw = 0;

// Test mode options
boolean runOnTestMode = false;
int numberOfTests = 25;
int testsRan = 0;
String[] testCases = {
  "1_1_1",
  "2_1_1",
  "1_2_1",
  "1_1_2",
  "2_2_1",
  "2_1_2",
  "1_2_2",
  "1_2_3"
};
int currentTestCase = 0;

boolean runOnManualMode = false;
Object[] manualModeDNASequence = {'A', 'A', 'A', 'A', 'A', 'B', 'A', 'F', 'A', 'B', 'B', 'A', 'A', 'A', 'F', 'F', 'F', '-', 'B', 4, 14, 19.0, 1.43117};
DNA manualModeDNA = new DNA(manualModeDNASequence);
Doodle manualModeDoodle;

void setup() {
  size(800, 600);
  frameRate(12);
}

void draw() {
  if (frameCount % 6 == 0) {
    background(currentTheme.getFillColor());

    if (currentTheme == darkTheme) {
      blendMode(ADD);
      noFill();
    }

    stroke(currentTheme.getStrokeColor());
    translate(width/2, height/2);

    if (!runOnTestMode && !runOnManualMode) {
      drawHelp();
    }
    
    if (drawAxis) {
      stroke(190);
      line(0, -height/2, 0, height/2);
      line(-width/2, 0, width/2, 0);
      stroke(currentTheme.getStrokeColor());
    }

    if (runOnManualMode) {
      if (manualModeDoodle == null) {
        manualModeDoodle = new Doodle(manualModeDNA);
        manualModeDoodle.calculateFitness();
      }

      drawDoodleWithDNAInfo(manualModeDoodle);
    }

    if (population != null) {
      if (drawFitestOnly) {
        Doodle fittest = population.getFitest();
        drawDoodleWithDNAInfo(fittest);

        if (saveDoodle) {
          String frameFilename = savesPrefix + population.getId() + "/fittest.png";
          if (runOnTestMode) {
            frameFilename = getTestsPrefix() + zeroPadded(testsRan) + "/fittest_" + fittest.getFitness().getRating() + ".png";
          }

          saveFrame(frameFilename);
        }
      } else {
        Doodle member = population.getMember(memberToDraw);
        drawDoodleWithDNAInfo(member);
        memberToDraw = (memberToDraw + 1) % population.getPopulationSize();

        if (saveDoodle) {
          String frameFilename = savesPrefix + population.getId() + "/member_" + zeroPadded(memberToDraw) + "_" + member.getFitness().getRating() + ".png";
          if (runOnTestMode) {
            frameFilename = getTestsPrefix() + zeroPadded(testsRan) + "/member_" + zeroPadded(memberToDraw) + "_" + member.getFitness().getRating() + ".png";
          }

          saveFrame(frameFilename);
        }
      }

      if (runOnTestMode && testsRan < numberOfTests) {
        run();
        testsRan++;
      } else if (runOnTestMode && currentTestCase < testCases.length - 1) {
        currentTestCase++;
        testsRan = 0;

        String[] params = testCases[currentTestCase].split("_");
        symmetryImportanceFactor = Integer.parseInt(params[0]);
        distributionImportanceFactor = Integer.parseInt(params[1]);
        growthImportanceFactor = Integer.parseInt(params[2]);
      } else if (runOnTestMode && currentTestCase >= testCases.length - 1) {
        exit();
      }
    } else if (!runOnManualMode) {
      drawStartInstructions();
    }
  }
}

void drawHelp() {
  String helpMessage  = "Click or press enter to generate a new image.\n" +
    "Press 's' to save.\n" +
    "Press 'a' to print analysis.\n" +
    "Press 'x' to toggle the axis.\n" +
    "Press 'f' to toggle between fittest and all.\n" +
    "Press 'i' to toggle DNA and fitness information.\n" +
    "Press 't' to change the color theme.\n" +
    "Press 'h' to close help.";

  if (!showHelp) {
    helpMessage = "Press 'h' for help.";
  }

  textSize(12);
  textAlign(LEFT);
  fill(currentTheme.getTextColor());
  text(helpMessage, -width/2, -height/2 + 12);
  fill(currentTheme.getFillColor());
}

void drawDoodleWithDNAInfo(Doodle doodle) {
  if (doodle.getFitness().getRating() > 0 || runOnManualMode) {
    pushMatrix();
    doodle.drawDoodle();
    popMatrix();
  }

  if (outputDNAAndFitness) {
    textSize(12);
    textAlign(CENTER);
    fill(currentTheme.getTextColor());
    text(String.format("DNA: %s\nFitness: %f",
      doodle.getDNA().toString(), doodle.getFitness().getRating()), 0, height/2 - 36);
    fill(currentTheme.getFillColor());
  }
}

void drawStartInstructions() {
  textSize(12);
  textAlign(CENTER);
  fill(currentTheme.getTextColor());
  text("Click or press enter to generate a new image.", 0, 0);
  fill(currentTheme.getFillColor());
}

void mousePressed() {
  if (runOnManualMode) return;

  run();
}

void run() {
  population = new Population(timestamp(), populationSize, mutationRate);
  int revivePopulationConsecutiveTries = 0;

  do {
    population.select();
    population.reproduce();

    tryDumpingPopulationDNAToDisk(population);

    if (population.getMaxFitness() <= 0) {
      // A max fitness of zero means a failed population.
      // Start over with a new random population.
      population = new Population(timestamp(), populationSize, mutationRate);

      revivePopulationConsecutiveTries++;
      if (revivePopulationConsecutiveTries >= maxGenerations) {
        population = null;
        break;
      }
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

void tryDumpingPopulationDNAToDisk(Population population) {
  if (dumpPopulationDNA) {
    String filename = savesPrefix + population.getId() + "/gen_" + zeroPadded(population.getGenerations()) + ".txt";
    if (runOnTestMode) {
      filename = getTestsPrefix() + zeroPadded(testsRan) + "/gen_" + zeroPadded(population.getGenerations()) + ".txt";
    }

    dumpPopulationDNAToDisk(population, filename);
  }
}

void dumpPopulationDNAToDisk(Population population, String filename) {
  Doodle fittest = population.getFitest();
  PrintWriter writer = createWriter(filename);
  Doodle[] populationMembers = population.getMembers();
  for (int j = 0; j != populationMembers.length; j++) {
    Doodle member = populationMembers[j];
    writer.println(j + " | " + 
      member.getDNA().toString() + "  |  " + 
      member.getFitness().getRating() + "  |  " + 
      (member == fittest ? "x" : "_"));
  }
  writer.flush();
  writer.close();
}

void keyPressed() {
  if (runOnManualMode) return;

  if (key == ENTER) {
    run();
  } else if (key == 'a') {
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
  } else if (key == 't') {
    if (currentTheme == lightTheme) {
      currentTheme = darkTheme;
    } else {
      currentTheme = lightTheme;
    }
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

String getTestsPrefix() {
  return "tests_" + testCases[currentTestCase] + "/test_";
}