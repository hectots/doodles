// Doodle
// Phenotype of a doodle.

class Doodle {
  // Starting point for the L-System.
  String axiom;

  // Rules to be fed into the L-System to produce the doodle.
  Rule[] productionRules;

  // Number of generations to grow the L-System.
  int lifeSpan;
  final int MIN_GENERATIONS = 5;
  final int MAX_GENERATIONS = 10;

  // Renderer configuration.
  Config config;
  int shapeSize;

  // DNA of the doodle.
  DNA dna;
  final int AXIOM_GENE = 0;
  final int RULE_SYMBOL_GENE = 1;
  final int RULE_GENES_START = 2;
  final int RULE_GENES_END = 9;
  final int LIFE_SPAN_GENE = 10;
  final int SHAPE_SIZE_GENE = 11;
  final int STEP_GENE = 12;
  final int ANGLE_GENE = 13;

  // Fitness of the doodle.
  float fitness;

  // Whether or not the fitness was calculated for the current dna.
  boolean wasFitnessCalculated;

  Doodle() {
    // New doodles are random.
    RulesFactory rulesFactory = new RulesFactory();
    axiom = rulesFactory.createRandomAxiom();
    productionRules = rulesFactory.createRandomRules();

    lifeSpan = (int) random(MIN_GENERATIONS, MAX_GENERATIONS);

    config = generateRandomConfig();

    configDNA();
  }

  Doodle(DNA dna) {
    this.dna = dna;
    interpretDNA();
  }

  float getFitness() {
    if (wasFitnessCalculated) {
      return fitness;
    }

    calculateFitness();
    return fitness;
  }

  float calculateFitness() {
    RulesFactory rulesFactory = new RulesFactory();
    char symbol = productionRules[0].getSymbol();
    char[] transformation = productionRules[0].getTransformation().toCharArray();

    // Make sure to eliminate invalid rules.
    if (!rulesFactory.isRuleNormalized(transformation)        ||
        !rulesFactory.isRuleRecursive(transformation, symbol) ||
        !rulesFactory.isRuleDrawable(transformation)) {
      fitness = 0;
      wasFitnessCalculated = true;
      return fitness;
    }

    LSystem lSystem = new LSystem(axiom, productionRules);
    lSystem.grow(lifeSpan);

    Simulator simulator = new Simulator(config);
    simulator.simulate(lSystem.getSequence());

    Analizer analizer = new Analizer(simulator.getLocations());
    float symmetryRating = analizer.rateSymmetry();
    float growthRating = analizer.rateGrowth();

    fitness = symmetryRating + growthRating;
    // fitness = growthRating;
    wasFitnessCalculated = true;

    return fitness;
  }

  void configDNA() {
    Object[] genes = new Object[14];

    genes[AXIOM_GENE] = axiom.charAt(0);

    Rule rule = productionRules[0];
    genes[RULE_SYMBOL_GENE] = rule.getSymbol();

    char[] ruleTransformation = rule.getTransformation().toCharArray();
    for (int i = RULE_GENES_START; i <= RULE_GENES_END; i++) {
      genes[i] = ruleTransformation[i - RULE_GENES_START];
    }

    genes[LIFE_SPAN_GENE] = lifeSpan;

    genes[SHAPE_SIZE_GENE] = shapeSize;
    genes[STEP_GENE] = config.getStep();
    genes[ANGLE_GENE] = config.getAngle();

    dna = new DNA(genes);
  }

  void interpretDNA() {
    Object[] genes = dna.getGenes();

    axiom = String.valueOf((char) genes[AXIOM_GENE]);

    char[] ruleTransformation = new char[8];
    for (int i = RULE_GENES_START; i <= RULE_GENES_END; i++) {
      ruleTransformation[i - RULE_GENES_START] = (char) genes[i];
    }

    productionRules = new Rule[1];
    productionRules[0] = new Rule((char) genes[RULE_SYMBOL_GENE], new String(ruleTransformation));

    lifeSpan = (int) genes[LIFE_SPAN_GENE];

    PShape pShape = createDoodleShape((int) genes[SHAPE_SIZE_GENE]);
    config = new Config((float) genes[STEP_GENE], (float) genes[ANGLE_GENE], pShape);
  }

  DNA getDNA() {
    return dna;
  }

  void drawDoodle() {
    LSystem lSystem = new LSystem(axiom, productionRules);
    lSystem.grow(lifeSpan);

    Renderer renderer = new Renderer(config);
    renderer.render(lSystem.getSequence());
  }

  Config generateRandomConfig() {
    int minSize = 10;
    int maxSize = 50;
    int stepMultiplier = 2;
    int randomSize = (int) random(minSize, maxSize);
    float randomStep = (int) random(randomSize/2, randomSize * stepMultiplier);
    float randomAngle = radians((int) random(360));

    // TODO: Make it more random.
    PShape randomShape = createDoodleShape(randomSize);
    shapeSize = randomSize;

    return new Config(randomStep, randomAngle, randomShape);
  }

  PShape createDoodleShape(int size) {
    return createShape(RECT, -size/2, -size/2, size, size);
  }
}