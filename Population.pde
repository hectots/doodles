// Population
// Controls the selection and reproduction of doodles.

class Population {
	Doodle[] population;
	int generations;

	ArrayList<Doodle> matingPool;
	float mutationRate;

	Doodle fitest;

	Population(int populationSize, float mutationRate) {
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
		for (int i = 0; i != population.length; i++) {
			float fitnessNormal = map(population[i].getFitness(), 0, maxFitness, 0, 1);
			int n = (int) (fitnessNormal * 100);
			for (int j = 0; j < n; j++) {
				matingPool.add(population[i]);
			}
		}
	}

	void reproduce() {
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

		generations++;
	}

	float getMaxFitness() {
		float max = 0;

		for (int i = 0; i != population.length; i++) {
			if (population[i].getFitness() > max) {
				max = population[i].getFitness();
				fitest = population[i];
			}
		}

		return max;
	}

	Doodle getFitest() {
		return fitest;
	}
}