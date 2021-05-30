//Singletonpattern used to set host
class Host {
  static const String localhost = "http://localhost:5000";
  static const String production = "";

  static final Host _host = Host._internal();

  factory Host() {
    return _host;
  }

  Host._internal();

  //set the active host!
  String getActiveHost() {
    return localhost; // <<<----------------------- Change backend here!
  }
}
