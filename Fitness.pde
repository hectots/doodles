// Fitness
// Analize a set of locations.

class Fitness {
  ArrayList<PVector> locations;

  float distributionRating;
  int onLeft;
  int onRight;
  int onTop;
  int onBottom;
  
  float symmetryRating;

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
    this.fitnessRating = fitnessRating;
    wasCalculated = true;
  }

  float getDistributionRating() {
    return distributionRating;
  }
  
  float getSymmetryRating() {
    return symmetryRating;
  }

  float getGrowthRating() {
    return growthRating;
  }

  float getRating() {
    return fitnessRating;
  }

  float calculate(float maxDistributionRating, float maxSymmetryRating, float maxGrowthRating) {
    if (!wasCalculated) {
      float normaDistribution = norm(distributionRating, 0, maxDistributionRating);
      float normalSymmetry = norm(symmetryRating, 0, maxSymmetryRating);
      float normalGrowthRating = norm(growthRating, 0, maxGrowthRating);
      float combinedRatings = distributionImportanceFactor * normaDistribution +
        symmetryImportanceFactor * normalSymmetry +
        growthImportanceFactor * normalGrowthRating;

      float maxRating = distributionImportanceFactor + symmetryImportanceFactor + growthImportanceFactor;

      fitnessRating = norm(combinedRatings, 0, maxRating);
      wasCalculated = true;
    }

    return fitnessRating;
  }

  void rate() {
    distributionRating = rateDistribution();
    symmetryRating = rateSymmetry();
    growthRating = rateGrowth();
  }

  float rateDistribution() {
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
  
  float rateSymmetry() {
    int totalPoints = 0;
    for (int i = 0; i != locations.size(); i++) {
      PVector location = locations.get(i);
      PVector locationOppositeInX = new PVector(-location.x, location.y);
      PVector locationOppositeInY = new PVector(location.x, -location.y);
      PVector locationOpposite = new PVector(-location.x, -location.y);
      int points = 0;
      
      for (int j = 0; j != locations.size(); j++) {
        PVector testLocation = locations.get(j);
        if (testLocation.equals(locationOppositeInX) ||
            testLocation.equals(locationOppositeInY) ||
            testLocation.equals(locationOpposite)) {
          points++;
        }
      }
      
      // Max out at three points since it may be that multiple collisions
      // match the symmetry and we don't want to make that better.
      totalPoints += (points % 3);
    }
    
    return totalPoints;
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
    return String.format("Fitness Rating: %f\n\tDistribution: %f\n\t\tOn left: %d\n\t\tOn right: %d\n\t\tOn top: %d\n\t\tOn bottom: %d\n\tSymmetry: %f\n\t\tLocations: %d\n\tGrowth: %f\n\t\tExpansion point: %d",
        fitnessRating,
          distributionRating,
            onLeft,
            onRight,
            onTop,
            onBottom,
          symmetryRating,
            locations.size(),
          growthRating,
            expansionPoints);
  }
}