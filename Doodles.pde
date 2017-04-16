// Doodles
// Use an LSystem to draw doodles.

Doodle doodle;

void setup() {
  size(480, 320);

  Object[] genes = {'A', 'A', 'F', 'G', 'A', 'A', '-', 'F', 'G', '+',
                     2, 20, 4.0, 1.9373155};

  doodle = new Doodle(new DNA(genes));
}

void draw() {
  background(255);
  translate(width/2, height/2);

  doodle.drawDoodle();
}

void mousePressed() {
  DNA previousDNA = doodle.getDNA();
  println(previousDNA);

  doodle = new Doodle();
}