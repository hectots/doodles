// Analizer
// Analize a set of locations.

class Analizer {
  ArrayList<PVector> locations;

  Analizer(ArrayList<PVector> locations) {
    this.locations = locations;
  }

  float rateSymmetry() {
    // Count object on the left and righ side.
    int leftSize = 0;
    int rightSize = 0;
    for (int i = 0; i != locations.size(); i++) {
      PVector location = locations.get(i);
      if (location.x > width/2) {
        rightSize++;
      } else if (location.x < width/2) {
        leftSize++;
      }
    }

    // A perfect symmetry will have a delta of 0, which means
    // there is the same number of elements on each side.
    int delta = abs(leftSize - rightSize);

    // Transform delta so that bigger values are the ones closer to 0.
    return 1.0 / (delta + 1) * 100;
  }

  float rateGrowth() {
    float expansionPoints = 0;
    for (int i = 0; i != locations.size(); i++) {
      PVector location = locations.get(i);
      if (abs(location.x) > 0 && abs(location.x) < width/2) {
        expansionPoints++;
      } else {
        expansionPoints--;
      }
    }

    if (expansionPoints < 0) {
      expansionPoints = 0;
    }

    return expansionPoints / locations.size() * 100;
    // return norm(locations.size(), 0, 100);
  }
}