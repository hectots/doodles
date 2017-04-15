// Doodles
// Use an LSystem to draw doodles.

Doodle doodle;

void setup() {
  size(480, 320);
  doodle = new Doodle();
}

void draw() {
  // Canvas setup.
  background(255);
  translate(width/2, height/2);

  doodle.drawDoodle();
}

void mousePressed() {
  // Generate a new doodle on a mouse press.
  doodle = new Doodle();
}