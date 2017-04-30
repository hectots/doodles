// Doodle
// Phenotype of a doodle.

class Doodle {
  // Starting point for the L-System.
  String axiom;

  // Rules to be fed into the L-System to produce the doodle.
  Rule[] productionRules;

  // Number of generations to grow the L-System.
  int lifeSpan;
  final int MIN_GENERATIONS = 3;
  final int MAX_GENERATIONS = 5;

  // Renderer configuration.
  Config config;
  int shapeSize;

  // DNA of the doodle.
  DNA dna;
  final int AXIOM_GENE = 0;
  final int RULE1_SYMBOL_GENE = 1;
  final int RULE1_GENES_START = 2;
  final int RULE1_GENES_END = 9;
  final int RULE2_SYMBOL_GENE = 10;
  final int RULE2_GENES_START = 11;
  final int RULE2_GENES_END = 18;
  final int LIFE_SPAN_GENE = 19;
  final int SHAPE_SIZE_GENE = 20;
  final int STEP_GENE = 21;
  final int ANGLE_GENE = 22;

  // Fitness of the doodle.
  Fitness fitness;

  // Whether or not the fitness was calculated for the current dna.
  boolean wasFitnessCalculated;

  Doodle() {
    // New doodles are random.
    RulesFactory rulesFactory = new RulesFactory();
    axiom = rulesFactory.createRandomAxiom();
    productionRules = rulesFactory.createRandomRules(2);

    lifeSpan = (int) random(MIN_GENERATIONS, MAX_GENERATIONS);

    config = generateRandomConfig();

    configDNA();
  }

  Doodle(DNA dna) {
    this.dna = dna;
    interpretDNA();
  }

  Fitness getFitness() {
    if (!wasFitnessCalculated) {
      calculateFitness();
    }
    
    return fitness;
  }

  Fitness calculateFitness() {
    RulesFactory rulesFactory = new RulesFactory();

    char[] vars = new char[2];
    vars[0] = productionRules[0].getSymbol();
    vars[1] = productionRules[1].getSymbol();

    for (int i = 0; i != productionRules.length; i++) {
      char symbol = productionRules[i].getSymbol();
      char[] transformation = productionRules[i].getTransformation().toCharArray();

      // Make sure to eliminate invalid rules.
      if (!rulesFactory.isRuleNormalized(transformation)        ||
          !rulesFactory.isRuleRecursive(transformation, vars)   ||
          !rulesFactory.isRuleDrawable(transformation)) {
        fitness = new Fitness(0);
        wasFitnessCalculated = true;
        return fitness;
      }
    }

    LSystem lSystem = new LSystem(axiom, productionRules);
    lSystem.grow(lifeSpan);

    Simulator simulator = new Simulator(config);
    simulator.simulate(lSystem.getSequence());

    fitness = new Fitness(simulator.getLocations());
    fitness.rate();

    wasFitnessCalculated = true;

    return fitness;
  }

  void configDNA() {
    Object[] genes = new Object[23];

    genes[AXIOM_GENE] = axiom.charAt(0);

    Rule rule = productionRules[0];
    genes[RULE1_SYMBOL_GENE] = rule.getSymbol();

    char[] ruleTransformation = rule.getTransformation().toCharArray();
    for (int i = RULE1_GENES_START; i <= RULE1_GENES_END; i++) {
      genes[i] = ruleTransformation[i - RULE1_GENES_START];
    }

    rule = productionRules[1];
    genes[RULE2_SYMBOL_GENE] = rule.getSymbol();

    ruleTransformation = rule.getTransformation().toCharArray();
    for (int i = RULE2_GENES_START; i <= RULE2_GENES_END; i++) {
      genes[i] = ruleTransformation[i - RULE2_GENES_START];
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

    productionRules = new Rule[2];

    char[] ruleTransformation = new char[8];
    for (int i = RULE1_GENES_START; i <= RULE1_GENES_END; i++) {
      ruleTransformation[i - RULE1_GENES_START] = (char) genes[i];
    }

    productionRules[0] = new Rule((char) genes[RULE1_SYMBOL_GENE], new String(ruleTransformation));

    ruleTransformation = new char[8];
    for (int i = RULE2_GENES_START; i <= RULE2_GENES_END; i++) {
      ruleTransformation[i - RULE2_GENES_START] = (char) genes[i];
    }

    productionRules[1] = new Rule((char) genes[RULE2_SYMBOL_GENE], new String(ruleTransformation));

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

  Rule[] getRules() {
    return productionRules;
  }
}