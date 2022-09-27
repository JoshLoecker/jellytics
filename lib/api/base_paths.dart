// This library contains the base paths for the different pages of the app.

enum RequestType {
  get,
  post;
}

class GET {
  final String path;
  const GET(this.path);
}

class POST {
  final String path;
  const POST(this.path);
}

class User {
  static const String basePath = "/Users";
}

class Plugins {
  static const GET basePath = GET("/Plugins");
}

class System {
  static const String _basePath = "/System";
  static const GET endpoint = GET("$_basePath/EndPoint");
  static const GET info = GET("$_basePath/Info");
  static const GET allLogs = GET("$_basePath/Logs");
  static const GET ping = GET("$_basePath/Ping");
  static final GET log = GET("$allLogs/Log");
  static final GET infoPublic = GET("$info/Public");
}
