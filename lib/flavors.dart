enum Flavor {
  DEV,
  QC,
  UAT,
  PROD,
}

class F {
  static Flavor appFlavor;

  static String get title {
    switch (appFlavor) {
      case Flavor.DEV:
        return 'DEV App';
      case Flavor.QC:
        return 'QC App';
      case Flavor.UAT:
        return 'UAT App';
      case Flavor.PROD:
        return 'PROD App';
      default:
        return 'title';
    }
  }
}
