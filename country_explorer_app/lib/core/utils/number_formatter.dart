class NumberFormatter {
  static String formatPopulation(int population) {
    if (population >= 1000000000) {
      return '${(population / 1000000000).toStringAsFixed(1)} Mlrd';
    } else if (population >= 1000000) {
      return '${(population / 1000000).toStringAsFixed(1)} Milyon';
    } else if (population >= 1000) {
      return '${(population / 1000).toStringAsFixed(1)} min';
    }
    return population.toString();
  }

  static String formatArea(double area) {
    if (area >= 1000000) {
      return '${(area / 1000000).toStringAsFixed(2)}M km²';
    }
    return '${area.toStringAsFixed(0)} km²';
  }

  static String formatPopulationDiff(int a, int b) {
    final diff = (a - b).abs();
    final formatted = formatPopulation(diff);
    return a > b ? '+$formatted' : '-$formatted';
  }
}
