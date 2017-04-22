// Fitness
// Analize a set of locations.

class Fitness {
  ArrayList<PVector> locations;

  float symmetryRating;
  int onLeft;
  int onRight;
  int onTop;
  int onBottom;

  float growthRating;
  int expansionPoints;

  float fitnessRating;
  boolean wasCalculated;

  Fitness(ArrayList<PVector> locations) {
    this.locations = locations;
    fitnessRating = 0;
    wasCalculated = false;
  }

  Fitness(float fitnessRating) {
    fitnessRating = 0;
    wasCalculated = true;
  }

  float getSymmetryRating() {
    return symmetryRating;
  }

  float getGrowthRating() {
    return growthRating;
  }

  float getFitnessRating() {
    return fitnessRating;
  }

  float calculate(float maxSymmetryRating, float maxGrowthRating) {
    if (!wasCalculated) {
      float normalSymmetry = norm(symmetryRating, 0, maxSymmetryRating);
      float normalGrowthRating = norm(growthRating, 0, maxGrowthRating);
      float combinedRatings = normalSymmetry + normalGrowthRating;

      fitnessRating = norm(combinedRatings, 0, 2);
      wasCalculated = true;
    }

    return fitnessRating;
  }

  void rate() {
    symmetryRating = rateSymmetry();
    growthRating = rateGrowth();
  }

  float rateSymmetry() {
    // Count object on the left and righ side.
    onLeft = 0;
    onRight = 0;
    onTop = 0;
    onBottom = 0;
    for (int i = 0; i != locations.size(); i++) {
      PVector location = locations.get(i);
      if (location.x > 0) {
        onLeft++;
      } else if (location.x < 0) {
        onRight++;
      }

      if (location.y > 0) {
        onBottom++;
      } else if (location.y < 0) {
        onTop++;
      }
    }

    // A perfect symmetry will have a delta of 0, which means
    // there is the same number of elements on each side.
    int verticalDelta = abs(onLeft - onRight);
    int horizontalDelta = abs(onTop - onBottom);

    // Transform delta so that bigger values are the ones closer to 0.
    float rating = (1.0 / (verticalDelta + 1) * 100) + (1.0 / (horizontalDelta + 1) * 100);
    float normalizeRating = map(rating, 0, 200, 0, 100);

    return normalizeRating;
  }

  float rateGrowth() {
    expansionPoints = 0;
    for (int i = 0; i != locations.size(); i++) {
      PVector location = locations.get(i);
      if ((location.x > 0 && location.x < width/2) ||
          (location.x < 0 && location.x > -width/2)) {
        expansionPoints++;
      } else {
        expansionPoints--;
      }
    }

    if (expansionPoints < 0) {
      expansionPoints = 0;
    }

    return expansionPoints;
  }

  String toString() {
    return String.format("Fitness Rating: %f\n\tSymmetry: %f\n\t\tOn left: %d\n\t\tOn right: %d\n\t\tOn top: %d\n\t\tOn bottom: %d\n\tGrowth: %f\n\t\tExpantion point: %d",
        fitnessRating,
          symmetryRating,
            onLeft,
            onRight,
            onTop,
            onBottom,
          growthRating,
            expansionPoints);
  }
}