// RendererConfig

class RendererConfig {
  int size;
  int xOffset;
  int yOffset;
  float scaleX;
  float scaleY;
  int angle;
  
  int defaultXOffset;
  int defaultYOffset;
  float defaultScaleX;
  float defaultScaleY;
  int defaultAngle;
  
  int xStep;
  int yStep;
  float scaleXStep;
  float scaleYStep;
  int angleStep;
  
  final int UP = 1;
  final int DOWN = -1;
  
  RendererConfig(int size, int xOffset, int yOffset, float scaleX, float scaleY, int angle) {
    this.size = size;
    this.xOffset = xOffset;
    this.yOffset = yOffset;
    this.scaleX = scaleX;
    this.scaleY = scaleY;
    this.angle = angle;
    
    this.defaultXOffset = xOffset;
    this.defaultYOffset = yOffset;
    this.defaultScaleX = scaleX;
    this.defaultScaleY = scaleY;
    this.defaultAngle = angle;
  }
  
  void stepUp(char transform) {
    step(transform, UP);
  }
  
  void stepDown(char transform) {
    step(transform, DOWN);
  }
  
  void step(char transform, int direction) {
    switch (transform) {
      case DoodleAlphabet.DOODLE_START_TRANSLATE:
        xOffset += direction * xStep;
        yOffset += direction * yStep;
        break;
      case DoodleAlphabet.DOODLE_START_ROTATE:
        angle += direction * angleStep;
        break;
      case DoodleAlphabet.DOODLE_START_SCALE:
        scaleX += direction * scaleXStep;
        scaleY += direction * scaleYStep;
        break;
    }
  }
  
  void reset(char transform) {
    switch (transform) {
      case DoodleAlphabet.DOODLE_END_TRANSLATE:
        xOffset = defaultXOffset;
        yOffset = defaultYOffset;
        break;
      case DoodleAlphabet.DOODLE_END_ROTATE:
        angle = defaultAngle;
        break;
      case DoodleAlphabet.DOODLE_END_SCALE:
        scaleX = defaultScaleX;
         scaleY = defaultScaleY;
        break;
    }
  }
  
  int getSize() {
    return size;
  }
  
  int getXOffset() {
    return xOffset;
  }
  
  int getYOffset() {
    return yOffset;
  }
  
  float getScaleX() {
    return scaleX;
  }
  
  float getScaleY() {
    return scaleY;
  }
  
  int getAngle() {
    return angle;
  }
  
  int getXStep() {
    return xStep;
  }
  
  void setXStep(int xStep) {
    this.xStep = xStep;
  }
  
  int getYStep() {
    return yStep;
  }
  
  void setYStep(int yStep) {
    this.yStep = yStep;
  }
  
  float getScaleXStep() {
    return scaleXStep;
  }
  
  void setScaleXStep(float scaleXStep) {
    this.scaleXStep = scaleXStep;
  }
  
  float getScaleYStep() {
    return scaleYStep;
  }
  
  void setScaleYStep(float scaleYStep) {
    this.scaleYStep = scaleYStep;
  }
  
  int getAngleStep() {
    return angleStep;
  }
  
  void setAngleStep(int angleStep) {
    this.angleStep = angleStep;
  }
}