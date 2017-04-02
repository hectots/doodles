// LSystem

class LSystem {
  String axiom;
  Rule[] productionRules;
  
  String sequence;
  int generation;
  
  boolean verbose;
  
  LSystem(String axiom, Rule[] productionRules) {
    this.axiom = axiom;
    this.productionRules = productionRules;
    
    sequence = axiom;
    generation = 0;
    
    verbose = false;
  }
  
  void grow(int generations) {
    for (int i = 0; i < generations; i++) {
      log(i);
      next();
    }
    
    log(generations);
  }
  
  void next() {
    StringBuffer nextGen = new StringBuffer();
    
    for (int i = 0; i < sequence.length(); i++) {
      char symbol = sequence.charAt(i);
      String transformation = String.valueOf(symbol);
      
      for (Rule rule : productionRules) {
        if (rule.matchSymbol(symbol)) {
          transformation = rule.getTransformation();
        }
      }
      
      nextGen.append(transformation);
    }
    
    sequence = nextGen.toString();
    generation++;
  }
  
  void reset() {
    sequence = axiom;
    generation++;
  }
  
  String getSequence() {
    return sequence;
  }
  
  int getGeneration() {
    return generation;
  }
  
  void setVerbose(boolean verbose) {
    this.verbose = verbose;
  }
  
  void log(int n) {
    if (verbose) {
      print("n = " + n + ": ");
      println(sequence);
    }
  }
}