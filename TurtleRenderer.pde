// TurtleRenderer

class TurtleRenderer {
  float len;
  float theta;
  
  TurtleRenderer(float len, float theta) {
    this.len = len;
    this.theta = theta;
  }
  
  void render(String sequence) {
    rotate(-PI/2);
    for (int i = 0; i < sequence.length(); i++) {
      char symbol = sequence.charAt(i);
      switch (symbol) {
        case 'F':
          line(0, 0, len, 0);
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