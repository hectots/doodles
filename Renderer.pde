// TurtleRenderer

class Renderer {
  RendererConfig config;
  
  Renderer(RendererConfig config) {
    this.config = config;
  }
  
  void render(String sequence) {
    rotate(-PI/2);
    for (int i = 0; i < sequence.length(); i++) {
      char symbol = sequence.charAt(i);
      switch (symbol) {
        case 'F':
          shape(config.getPShape());
          translate(config.getStep(), 0);
          break;
        case 'G':
          translate(config.getStep(), 0);
          break;
        case '+':
          rotate(config.getAngle());
          break;
        case '-':
          rotate(-config.getAngle());
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
