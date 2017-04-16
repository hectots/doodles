// Doodle
// Phenotype of a doodle.

class Doodle {
  // Starting point for the L-System.
  String axiom;

  // Rules to be fed into the L-System to produce the doodle.
  Rule[] productionRules;

  // Number of generations to grow the L-System.
  int lifeSpan;
  final int MAX_GENERATIONS = 5;

  // Renderer configuration.
  RendererConfig config;
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

  Doodle() {
    // New doodles are random.
    RulesFactory rulesFactory = new RulesFactory();
    axiom = rulesFactory.createRandomAxiom();
    productionRules = rulesFactory.createRandomRules();

    lifeSpan = (int) random(MAX_GENERATIONS);

    config = generateRandomConfig();

    configDNA();
  }

  Doodle(DNA dna) {
    this.dna = dna;
    interpretDNA();
  }

  float calculateFitness() {
    // TODO: Calculate fitness. Make sure to eliminate invalid doodles by returning 0.
    return 0;
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
    config = new RendererConfig((float) genes[STEP_GENE], (float) genes[ANGLE_GENE], pShape);
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

  RendererConfig generateRandomConfig() {
    int maxSize = 50;
    int stepMultiplier = 2;
    int randomSize = (int) random(maxSize);
    float randomStep = (int) random(randomSize * stepMultiplier);
    float randomAngle = radians((int) random(360));

    // TODO: Make it more random.
    PShape randomShape = createDoodleShape(randomSize);
    shapeSize = randomSize;

    return new RendererConfig(randomStep, randomAngle, randomShape);
  }

  PShape createDoodleShape(int size) {
    return createShape(RECT, -size/2, -size/2, size, size);
  }
}