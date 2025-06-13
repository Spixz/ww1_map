class SingleRoute {
  const SingleRoute(this.name, this.path);

  final String name;
  final String path;

  @override
  String toString() {
    return "name: $name | path: $path";
  }
}

abstract final class Routes {
  static const home = SingleRoute('Home', '/home');

  static const review = SingleRoute('Review', '/review/:title');
  static const settings = SingleRoute('Settings', '/settings');

  static const all = [
    home,
    settings,
  ];
}
