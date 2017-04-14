// Doodles
// Use an LSystem to draw doodles.

RandomRulesGenerator randomRulesGenerator;
LSystem lSystem;
Renderer renderer;

void setup() {
  size(480, 320);
}

void draw() {
  //
}

void mousePressed() {
  background(255);

  translate(width/2, height/2);

  randomRulesGenerator = new RandomRulesGenerator();
  
  lSystem = new LSystem("X", randomRulesGenerator.generate(2));
  lSystem.setVerbose(true);
  lSystem.grow(4);

  int stepSize = 10;
  float rotationAngle = radians(30);
  PShape doodleShape = createShape(RECT, -5, -5, 10, 10);
  
  renderer = new Renderer(stepSize, rotationAngle, doodleShape);
  renderer.render(lSystem.getSequence());
}