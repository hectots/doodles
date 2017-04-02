// Renderer

class Renderer {
  RendererConfig config;
  char lastTransform;
  
  Renderer(RendererConfig config) {
    this.config = config;
  }
  
  void render(String sequence) {
    noFill();
    rectMode(CENTER);
    
    for (int i = 0; i < sequence.length(); i++) {
      char symbol = sequence.charAt(i);
      interpretSymbol(symbol);
    }
  }
  
  void interpretSymbol(char symbol) {
    int size = config.getSize();
    float hSize = size/2;
    
    switch (symbol) {
      case DoodleAlphabet.DOODLE_POINT:
        rect(0,0,1,1);
        break;
      case DoodleAlphabet.DOODLE_LINE:
        line(0, -hSize, 0, hSize);
        break;
      case DoodleAlphabet.DOODLE_ANGLE:
        line(0, -hSize, hSize, hSize);
        line(0, -hSize, -hSize, hSize);
        break;
      case DoodleAlphabet.DOODLE_ARC:
        arc(0, 0, size, size, PI, TWO_PI);
        break;
      case DoodleAlphabet.DOODLE_SPIRAL:
        break;
      case DoodleAlphabet.DOODLE_LOOP:
        break;
      case DoodleAlphabet.DOODLE_OVAL:
        ellipse(0, 0, size, size);
        break;
      case DoodleAlphabet.DOODLE_EYE:
        break;
      case DoodleAlphabet.DOODLE_TRIANGLE:
        line(0, -hSize, hSize, hSize);
        line(0, -hSize, -hSize, hSize);
        line(-hSize, hSize, hSize, hSize);
        break;
      case DoodleAlphabet.DOODLE_START_TRANSLATE:
        pushMatrix();
        translate(config.getXOffset(), config.getYOffset());
        lastTransform = symbol;
        break;
      case DoodleAlphabet.DOODLE_START_ROTATE:
        pushMatrix();
        rotate(radians(config.getAngle()));
        lastTransform = symbol;
        break;
      case DoodleAlphabet.DOODLE_START_SCALE:
        // TODO: Figure out how to do the scaling.
        //lastTransform = symbol;
        break;
      case DoodleAlphabet.DOODLE_END_TRANSLATE:
      case DoodleAlphabet.DOODLE_END_ROTATE:
      case DoodleAlphabet.DOODLE_END_SCALE:
        popMatrix();
        config.reset(symbol);
        break;
      case DoodleAlphabet.DOODLE_START_SAVE:
        pushMatrix();
        break;
      case DoodleAlphabet.DOODLE_END_SAVE:
        popMatrix();
        break;
      case DoodleAlphabet.DOODLE_MODIFIER_UP:
        config.stepUp(lastTransform);
        break;
      case DoodleAlphabet.DOODLE_MODIFIER_DOWN:
        config.stepDown(lastTransform);
        break;
    }
  }
}