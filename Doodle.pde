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

  Doodle() {
    // New doodles are random.
    RulesFactory rulesFactory = new RulesFactory();
    axiom = rulesFactory.createRandomAxiom();
    productionRules = rulesFactory.createRandomRules();

    lifeSpan = (int) random(MAX_GENERATIONS);

    config = generateRandomConfig();
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
    PShape randomShape = createShape(RECT, -randomSize/2, -randomSize/2, randomSize, randomSize);

    return new RendererConfig(randomStep, randomAngle, randomShape);
  }
}