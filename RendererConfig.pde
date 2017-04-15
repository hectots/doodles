// RendererConfig
// Configuration for the Renderer.

class RendererConfig {
  float step;
  float angle;
  PShape pShape;

  RendererConfig(float step, float angle, PShape pShape) {
    this.step = step;
    this.angle = angle;
    this.pShape = pShape;
  }

  float getStep() {
    return step;
  }

  void setStep(float step) {
    this.step = step;
  }

  float getAngle() {
    return angle;
  }

  void setAngle(float angle) {
    this.angle = angle;
  }

  PShape getPShape() {
    return pShape;
  }

  void setPShape(PShape pShape) {
    this.pShape = pShape;
  }
}