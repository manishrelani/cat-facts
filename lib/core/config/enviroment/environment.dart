enum EnvironmentType { dev, stage, production }

class Environment {
  static EnvironmentType _currentEnvironment = EnvironmentType.dev;

  static String get baseUrl {
    return switch (_currentEnvironment) {
      EnvironmentType.dev => 'https://catfact.ninja',
      EnvironmentType.stage => 'https://catfact.ninja',
      EnvironmentType.production => 'https://catfact.ninja',
    };
  }

  static EnvironmentType get currentEnvironment => _currentEnvironment;

  static void init([EnvironmentType? type]) {
    if (type != null) {
      _currentEnvironment = type;
    }
  }
}
