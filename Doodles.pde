// Doodles
// Use an LSystem to draw doodles.

LSystem lSystem;
Renderer renderer;

// DOODLE_POINT     = '.';
// DOODLE_LINE      = '|';
// DOODLE_ANGLE     = '^';
// DOODLE_ARC       = 'u';
// DOODLE_SPIRAL    = '@';
// DOODLE_LOOP      = '&';
// DOODLE_OVAL      = 'o';
// DOODLE_EYE       = 'e';
// DOODLE_TRIANGLE  = '4';
// DOODLE_RECTANGLE = 'H';
// DOODLE_HOUSE     = 'A';
// DOODLE_CLOUD     = '*';

void setup() {
  size(480, 320);
  translate(width/2, height/2);
  
  Rule[] productionRules = new Rule[2];
  productionRules[0] = new Rule('X', "|(|(|))");
  productionRules[1] = new Rule('Y', "X(((({Y}))))");
  
  lSystem = new LSystem("Y", productionRules);
  lSystem.setVerbose(true);
  lSystem.grow(5);
  
  RendererConfig config = new RendererConfig(25, 10, 0, .25, .25, 90);
  config.setXStep(10);
  config.setYStep(0);
  config.setScaleXStep(.05);
  config.setScaleYStep(.05);
  config.setAngleStep(15);
  
  renderer = new Renderer(config);
  //renderer.render("|(|(|))(((({|(|(|))}))))");
  renderer.render(lSystem.getSequence());
  //testRenderer();
}

void draw() {
  //
}

void testRenderer() {
  for (int i = 0; i != DoodleAlphabet.SYMBOLS.length; i++) {
    char symbol = DoodleAlphabet.SYMBOLS[i];
    //translate(renderer.getSize()/2 * i, 0);
    renderer.render(String.valueOf(symbol));
  }
}