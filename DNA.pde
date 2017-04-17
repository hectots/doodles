// DNA
// Genotype for the GA.

class DNA {
  Object[] genes;

  final int[] TYPE1_GENES = { 0 };
  final int[] TYPE2_GENES = { 1, 10 };
  final int[] TYPE3_GENES = { 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 15, 16, 17, 18 };
  final int[] TYPE4_GENES = { 19 };
  final int[] TYPE5_GENES = { 20 };
  final int[] TYPE6_GENES = { 21 };
  final int[] TYPE7_GENES = { 22 };

  final char[] TYPE3_EXPRESSIONS = "FG+-[]".toCharArray();
  final int TYPE4_MIN_EXPRESSION = 3;
  final int TYPE4_MAX_EXPRESSION = 5;
  final float TYPE5_MIN_EXPRESSION = 10;
  final float TYPE5_MAX_EXPRESSION = 50;
  final int TYPE6_MIN_EXPRESSION = 1;
  final int TYPE6_MAX_EXPRESSION = 2;
  final float TYPE7_MAX_EXPRESSION = 360;

  DNA(Object[] genes) {
    this.genes = genes;
  }

  Object[] getGenes() {
    return genes;
  }

  DNA crossover(DNA partner) {
    Object[] childGenes = new Object[genes.length];

    int crossover = (int) random(genes.length);
    for (int i = 0; i < genes.length; i++) {
      if (i > crossover) {
        childGenes[i] = genes[i];
      } else {
        childGenes[i] = partner.genes[i];
      }
    }

    return new DNA(childGenes);
  }

  void mutate(float mutationRate) {
    // Gene 1 and 2 will never mutate.
    for (int i = 2; i != genes.length; i++) {
      if (random(1) < mutationRate) { // Mutate randomly based on rate.
        if (isOfType(i, TYPE3_GENES)) {
          genes[i] = TYPE3_EXPRESSIONS[(int) random(TYPE3_EXPRESSIONS.length)];
        } else if (isOfType(i, TYPE4_GENES)) {
          genes[i] = (int) random(TYPE4_MIN_EXPRESSION, TYPE4_MAX_EXPRESSION);
        } else if (isOfType(i, TYPE5_GENES)) {
          genes[i] = (int) random(TYPE5_MIN_EXPRESSION, TYPE5_MAX_EXPRESSION);
        } else if (isOfType(i, TYPE6_GENES)) {
          // int multiplier = (int) random(TYPE6_MIN_EXPRESSION, TYPE6_MAX_EXPRESSION);
          // genes[i] = ((float) genes[11]) * multiplier;
        } else if (isOfType(i, TYPE7_GENES)) {
          genes[i] = radians((int) random(TYPE7_MAX_EXPRESSION));
        }
      }
    } 
  }

  boolean isOfType(int genePosition, int[] type) {
    for (int i = 0; i != type.length; i++) {
      if (genePosition == type[i]) {
        return true;
      }
    }

    return false;
  }

  String toString() {
    StringBuffer buffer = new StringBuffer();
    for (int i = 0; i != genes.length; i++) {
      buffer.append(genes[i].toString());

      if (i != genes.length - 1) {
        buffer.append(", ");
      }
    }

    return buffer.toString();
  }
}