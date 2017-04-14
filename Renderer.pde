// TurtleRenderer

class Renderer {
  float len;
  float theta;
  PShape s;
  
  Renderer(float len, float theta, PShape s) {
    this.len = len;
    this.theta = theta;
    this.s = s;
  }
  
  void render(String sequence) {
    rotate(-PI/2);
    for (int i = 0; i < sequence.length(); i++) {
      char symbol = sequence.charAt(i);
      switch (symbol) {
        case 'F':
          shape(s);
          translate(len, 0);
          break;
        case 'G':
          translate(len, 0);
          break;
        case '+':
          rotate(theta);
          break;
        case '-':
          rotate(-theta);
          break;
        case '[':
          pushMatrix();
          break;
        case ']':
          popMatrix();
          break;
      }
    }
  }
}