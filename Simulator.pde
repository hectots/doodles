// Simulator
// Simulates a renderer without actually rendering anything.
// It records the position of the shapes in the sequence.

class Simulator {
  Config config;
  PVector canvasOrigin;
  PVector step;
  ArrayList<PVector> locations;
  Stack<State> states;
  
  Simulator(Config config) {
    this.config = config;

    canvasOrigin = new PVector(0, 0);
    step = new PVector(config.getStep(), 0);
    locations = new ArrayList<PVector>();
    states = new Stack<State>();
  }
  
  void simulate(String sequence) {
    step.rotate(-PI/2);
    for (int i = 0; i < sequence.length(); i++) {
      char symbol = sequence.charAt(i);
      switch (symbol) {
        case 'F':
          PVector newLocation = new PVector(canvasOrigin.x, canvasOrigin.y);
          locations.add(newLocation);
          canvasOrigin.add(step);
          break;
        case 'G':
          canvasOrigin.add(step);
          break;
        case '+':
          step.rotate(config.getAngle());
          break;
        case '-':
          step.rotate(-config.getAngle());
          break;
        case '[':
          PVector savedCanvasOrigin = new PVector(canvasOrigin.x, canvasOrigin.y);
          PVector savedStep = new PVector(step.x, step.y);
          states.push(new State(savedCanvasOrigin, savedStep));
          break;
        case ']':
          State restoredState = states.pop();

          if (restoredState != null) {
            canvasOrigin = new PVector(restoredState.canvasOrigin.x, restoredState.canvasOrigin.y);
            step = new PVector(restoredState.step.x, restoredState.step.y);
          }
          break;
      }
    }
  }

  ArrayList<PVector> getLocations() {
    return locations;
  }

  class State {
    PVector canvasOrigin;
    PVector step;

    State(PVector canvasOrigin, PVector step) {
      this.canvasOrigin = canvasOrigin;
      this.step = step;
    }
  }
}