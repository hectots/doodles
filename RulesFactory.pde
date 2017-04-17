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
    char[] varInUse = new char[rulesCount];

    int varsIndex = 0;
    for (int i = 0; i != rulesCount; i++) {
      varInUse[i] = vars[i];
      varsIndex++;

      // Prevent overflow.
      if (varsIndex >= vars.length) {
        varsIndex = 0;
      }
    }

    for (int i = 0; i != productionRules.length; i++) {
      productionRules[i] = createRandomRule(varInUse, i);
    }

    return productionRules;
  }

  char[] getVars() {
    // All cap letters except F and G who are part of our alphabet.
    String validCapLetters = "ABCDEHIJKLMNOPQRSTUVWXYZ";
    return validCapLetters.toCharArray();
  }

  Rule createRandomRule(char[] vars, int varIndex) {
    char[] alphabet = getAlphabet(vars);
    char[] transformation = new char[8];

    do {
      for (int i = 0; i != transformation.length; i++) {
        transformation[i] = alphabet[(int)random(alphabet.length)];
      }
    } while (!isRuleNormalized(transformation) || !isRuleRecursive(transformation, vars) || !isRuleDrawable(transformation));

    return new Rule(vars[varIndex], new String(transformation));
  }

  char[] getAlphabet(char[] vars) {
    String alphabetStr = "FG+-[]" + new String(vars);
    return alphabetStr.toCharArray();
  }

  // True if push symbols ('[') always have matching pop symbols (']'); false otherwise.
  boolean isRuleNormalized(char[] transformation) {
    // Stack of push symbols.
    Stack<Character> pushSymbolsStack = new Stack<Character>();

    // A sentinel symbol is added to the stack.
    char sentinel = '$';
    pushSymbolsStack.push(sentinel);

    for (int i = 0; i != transformation.length; i++) {
      if (transformation[i] == '[') {
        // Add the symbol to the stack.
        pushSymbolsStack.push('[');
      } else if (transformation[i] == ']') {
        // Check the top of the stack.
        char topOfStack = pushSymbolsStack.pop();
        if (topOfStack == sentinel) {
          // If the top of the stack is the sentinel then
          // there is not a matching symbol. Therefore the
          // transformation is not normalized.
          return false;
        }
      }
    }

    // A stack with only the sentinel means all the push/pop symbols are in pairs.
    return pushSymbolsStack.size() == 1;
  }

  // True if the transformation contains at least one instance of variable; false otherwise.
  boolean isRuleRecursive(char[] transformation, char[] variables) {
    for (int i = 0; i != transformation.length; i++) {
      for (int j = 0; j != variables.length; j++) {
        if (transformation[i] == variables[j]) {
          return true;
        }
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