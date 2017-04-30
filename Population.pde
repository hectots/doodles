// Population
// Controls the selection and reproduction of doodles.

class Population {
  String id;
  Doodle[] population;
  int generations;

  ArrayList<Doodle> matingPool;
  float mutationRate;

  Doodle fitest;

  Population(String id, int populationSize, float mutationRate) {
    this.id = id;

    population = new Doodle[populationSize];
    generations = 0;

    matingPool = new ArrayList<Doodle>();
    this.mutationRate = mutationRate;

    // Start with a random population of doodles.
    for (int i = 0; i != population.length; i++) {
      population[i] = new Doodle();
    }
  }

  void select() {
    matingPool.clear();

    float maxFitness = getMaxFitness();

    // Based on the normalized value of fitness, each member will
    // be added a number of times to the mating pool. Higher
    // fitness values will mean better chances when random members
    // of the population get picked up from the mating pool.
    if (maxFitness > 0) {
      for (int i = 0; i != population.length; i++) {
        float fitnessNormal = map(population[i].getFitness().getRating(), 0, maxFitness, 0, 1);
        int n = (int) (fitnessNormal * 100);
        for (int j = 0; j < n; j++) {
          matingPool.add(population[i]);
        }
      }
    }
  }

  void reproduce() {
    if (matingPool.size() > 0) {
      for (int i = 0; i < population.length; i++) {
        int randomMom = (int) random(matingPool.size());
        int randomDad = (int) random(matingPool.size());

        Doodle mom = matingPool.get(randomMom);
        Doodle dad = matingPool.get(randomDad);

        DNA momGenes = mom.getDNA();
        DNA dadGenes = dad.getDNA();

        DNA childDNA = momGenes.crossover(dadGenes);
        childDNA.mutate(mutationRate);

        population[i] = new Doodle(childDNA);
      }
    }

    // Reset fitest value for the new generation
    // so that it will be calculated again.
    fitest = null;

    generations++;
  }

  float getMaxFitness() {
    float max = 0;
    float maxSymmetry = getMaxSymmetry();
    float maxExactSymmetry = getMaxExactSymmetry();
    float maxGrowth = getMaxGrowth();

    for (int i = 0; i != population.length; i++) {
      float fitness = population[i].getFitness().calculate(maxSymmetry, maxExactSymmetry, maxGrowth);
      if (fitness > max) {
        max = fitness;
      }
    }

    return max;
  }

  float getMaxSymmetry() {
    float max = 0;

    for (int i = 0; i != population.length; i++) {
      Fitness fitness = population[i].getFitness();
      if (fitness.getSymmetryRating() > max) {
        max = fitness.getSymmetryRating();
      }
    }

    return max;
  }
  
  float getMaxExactSymmetry() {
    float max = 0;

    for (int i = 0; i != population.length; i++) {
      Fitness fitness = population[i].getFitness();
      if (fitness.getExactSymmetryRating() > max) {
        max = fitness.getExactSymmetryRating();
      }
    }

    return max;
  }

  float getMaxGrowth() {
    float max = 0;

    for (int i = 0; i != population.length; i++) {
      Fitness fitness = population[i].getFitness();
      if (fitness.getGrowthRating() > max) {
        max = fitness.getGrowthRating();
      }
    }

    return max;
  }

  Doodle getFitest() {
    if (fitest == null) {
      float maxFitness = getMaxFitness();
      for (int i = 0; i != population.length; i++) {
        if (population[i].getFitness().getRating() == maxFitness) {
          fitest = population[i];
        }
      }
    }

    return fitest;
  }

  Doodle[] getMembers() {
    return population;
  }

  Doodle getMember(int memberIndex) {
    return population[memberIndex];
  }

  int getPopulationSize() {
    return population.length;
  }

  int getGenerations() {
    return generations;
  }

  String getId() {
    return id;
  }
}