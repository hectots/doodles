// RulesFactory
// Generates random rules for the L-System.

class RulesFactory {
  String createRandomAxiom() {
    char[] vars = getVars();
    return String.valueOf(vars[0]);
  }

  Rule[] createRandomRules() {
    return createRandomRules(1);
  }

  Rule[] createRandomRules(int rulesCount) {
    Rule[] productionRules = new Rule[rulesCount];
    char[] vars = getVars();

    for (int i = 0; i != productionRules.length; i++) {
      // TODO: Make each rule be a different var.
      productionRules[i] = createRandomRule(vars[0]);
    }

    return productionRules;
  }

  char[] getVars() {
    // All cap letters except F and G who are part of our alphabet.
    String validCapLetters = "ABCDEHIJKLMNOPQRSTUVWXYZ";
    return validCapLetters.toCharArray();
  }

  Rule createRandomRule(char var) {
    char[] alphabet = getAlphabet(var);

    char[] transformation = new char[8];

    do {
      for (int i = 0; i != transformation.length; i++) {
        transformation[i] = alphabet[(int)random(alphabet.length)];
      }
    } while (!isRuleNormalized(transformation) || !isRuleRecursive(transformation, var) || !isRuleDrawable(transformation));

    return new Rule(var, new String(transformation));
  }

  char[] getAlphabet(char var) {
    String alphabetStr = "FG+-[]" + String.valueOf(var);
    return alphabetStr.toCharArray();
  }

  // True if push symbols ('[') always have matching pop symbols (']'); false otherwise.
  boolean isRuleNormalized(char[] transformation) {
    // Simulates a stack of push symbols.
    ArrayList<Character> pushSymbolsStack = new ArrayList<Character>();

    // A sentinel symbol is added to the stack.
    char sentinel = '$';
    pushSymbolsStack.add(sentinel);

    for (int i = 0; i != transformation.length; i++) {
      if (transformation[i] == '[') {
        // Add the symbol to the stack.
        pushSymbolsStack.add('[');
      } else if (transformation[i] == ']') {
        // Check the top of the stack.
        char topOfStack = pushSymbolsStack.get(pushSymbolsStack.size() - 1);
        if (topOfStack == sentinel) {
          // If the top of the stack is the sentinel then
          // there is not a matching symbol. Therefore the
          // transformation is not normalized.
          return false;
        }

        // Remove matching symbol from the top of the stack.
        pushSymbolsStack.remove(pushSymbolsStack.size() - 1);
      }
    }

    // A stack with only the sentinel means all the push/pop symbols are in pairs.
    return pushSymbolsStack.size() == 1;
  }

  // True if the transformation contains at least one instance of variable; false otherwise.
  boolean isRuleRecursive(char[] transformation, char variable) {
    for (int i = 0; i != transformation.length; i++) {
      if (transformation[i] == variable) {
        return true;
      }
    }

    return false;
  }

  // True if the transformation contains at least one instance of
  // a drawable character; false otherwise.
  boolean isRuleDrawable(char[] transformation) {
    for (int i = 0; i != transformation.length; i++) {
      if (transformation[i] == 'F') {
        return true;
      }
    }

    return false;
  }
}