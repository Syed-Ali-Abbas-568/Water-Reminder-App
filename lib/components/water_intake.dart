//The formula used is weight *0.033 *1000
////also ensure that the resulting answer is divisble by 250 completely
//the water Goal  is returned in ml

int calculatetIntake(weight) {
  double sum = weight * (0.033) * (1000);
  int water = sum.toInt();

  while (water % 250 != 0) {
    water = water + 1;
  }

  return water;
}

double calculatePercent(int drunk, int goal) {
  if (goal != 0) {
    double percent = drunk / goal * 100;

    return percent;
  }
  return 0;
}
