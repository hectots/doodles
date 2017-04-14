// Rule

class Rule {
  char symbol;
  String transformation;
  
  Rule(char symbol, String transformation) {
    this.symbol = symbol;
    this.transformation = transformation;
  }
  
  boolean matchSymbol(char symbol) {
    return this.symbol == symbol;
  }
  
  String getTransformation() {
    return transformation;
  }

  String toString() {
    return String.valueOf(symbol) + " -> " + transformation;
  }
}