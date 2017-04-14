// RandomRuleGenerator
// Generates random rules for the L-System.

class RandomRulesGenerator {
  Rule[] generate(int rulesCount) {
    Rule[] productionRules = new Rule[rulesCount];

    for (int i = 0; i != productionRules.length; i++) {
      productionRules[i] = randomRule();
    }

    return productionRules;
  }

  Rule randomRule() {
    String alphabetStr = "FG+-[]XY";
    char[] alphabet = alphabetStr.toCharArray();
    char symbol = 'X';

    char[] transformation = new char[8];

    do {
      for (int i = 0; i != transformation.length; i++) {
        transformation[i] = alphabet[(int)random(alphabet.length)];
      }
    } while (!isRuleNormalized(transformation) || !isRuleRecursive(transformation, symbol) || !isRuleDrawable(transformation));

    return new Rule(symbol, new String(transformation));
  }

  boolean isRuleNormalized(char[] transformation) {
    // Normalize push/pop symbols
    ArrayList<Character> pushPopSymbols = new ArrayList<Character>();
    boolean havePush = false;

    for (int i = 0; i != transformation.length; i++) {
      if (transformation[i] == '[') {
        havePush = true;
        pushPopSymbols.add('[');
      } else if (transformation[i] == ']' && pushPopSymbols.size() > 0) {
        pushPopSymbols.remove(pushPopSymbols.size() - 1);
      } else if (transformation[i] == ']' && pushPopSymbols.size() == 0) {
        return false;
      }
    }

    return havePush && pushPopSymbols.size() == 0;
  }

  boolean isRuleRecursive(char[] transformation, char variable) {
    for (int i = 0; i != transformation.length; i++) {
      if (transformation[i] == variable) {
        return true;
      }
    }

    return false;
  }

  boolean isRuleDrawable(char[] transformation) {
    for (int i = 0; i != transformation.length; i++) {
      if (transformation[i] == 'F') {
        return true;
      }
    }

    return false;
  }
}