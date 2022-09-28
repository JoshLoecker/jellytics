// This is a library that contains the paths to the different pages of the app.
import 'package:dio/dio.dart';
import 'package:jellytics/api/async_requests.dart';
import 'package:jellytics/api/print.dart';
import 'package:jellytics/utils/secure_storage.dart';
import 'package:jellytics/views/library/query.dart';

enum RequestType {
  get,
  post;
}

class GET {
  final String path;
  GET(this.path);
}

class POST {
  final String path;
  POST(this.path);
}

class _User {
  static const String basePath = "/Users";
}

class GETUser {
  static GET allUsers = GET(_User.basePath);
  static GET meUser = GET("${_User.basePath}/Me");
}

class POSTUser {
  static POST authenticateByName = POST("${_User.basePath}/AuthenticateByName");
  static POST publicUsers = POST("${_User.basePath}/Public");

  POST authenticateByID({required String id}) {
    return POST("${_User.basePath}/$id/Authenticate");
  }
}

class _Plugins {
  const _Plugins();
  static const String _basePath = "/Plugins";
}

class GETPlugins extends _Plugins {
  GETPlugins() : super();

  static GET allPlugins = GET(_Plugins._basePath);

  void getPlugins() async {
    CreateRequest request = await CreateRequest.construct();

    var data = await request.get(allPlugins);
    prettyPrintJSONList(data.data);
  }
}

class _System {
  static const String _basePath = "/System";
  static GET endpoint = GET("$_basePath/EndPoint");
  static GET info = GET("$_basePath/Info");
  static GET allLogs = GET("$_basePath/Logs");
  static GET ping = GET("$_basePath/Ping");
  static final GET log = GET("$allLogs/Log");
  static final GET infoPublic = GET("$info/Public");
}

class GETSystem extends _System {
  GETSystem() : super();

  Future<Response<dynamic>> getEndpointData() async {
    /*
    This function can be used to ensure the user is logged in properly, as it returns information that requires a Token to access
    */
    CreateRequest request = await CreateRequest.construct();
    return await request.get(_System.endpoint);
  }

  Future<bool> isLoggedIn() async {
    Response response = await getEndpointData();
    return (response.statusMessage == "OK");
  }
}

class _Session {
  _Session();

  static const String _basePath = "/Sessions";
  static GET allSessions = GET(_basePath);
}

class GETSession extends _Session {
  GETSession() : super();

  Future<List<dynamic>> getActiveStreams() async {
    CreateRequest request = await CreateRequest.construct();

    Response streams = await request.get(
      _Session.allSessions,
      queryParameters: {
        "ActiveWithinSeconds": 1,
      },
    );
    return await streams.data;
  }
}

class GETImage {
  static Future<String> getItemImageURL({required String id}) async {
    SecureStorage storage = SecureStorage();
    await storage.isLoginSetup();

    return "${await storage.getServerURL()}/Items/$id/Images/Primary";
  }
}

class GETLibrary {
  final SecureStorage _storage = SecureStorage();
  Response? _response;

  Future<void> getLibraries() async {
    CreateRequest request = await CreateRequest.construct();
    final GET getItems = GET("/Items");

    _response = await request.get(getItems, queryParameters: {
      "userId": await _storage.getUserID(),
    });
    prettyPrintJSON(_response?.data);
  }

  Future<void> getItems({
    required List<BaseItemKind> includeKind,
    required List<Field> fields,
    List<BaseItemKind> excludeKind = const <BaseItemKind>[],
    int limit = 1,
  }) async {
    CreateRequest request = await CreateRequest.construct();

    // Construct the query parameters
    String fieldString = "";
    String includeKindString = "";
    String excludeKindString = "";
    for (Field element in fields) {
      fieldString += "${element.name},";
    }
    for (BaseItemKind element in includeKind) {
      includeKindString += "${element.name},";
    }
    for (BaseItemKind element in excludeKind) {
      excludeKindString += "${element.name},";
    }

    final GET items = GET(
      "/Users/${await _storage.getUserID()}/Items?IncludeItemTypes=$includeKindString&$excludeKindString&Recursive=True&startIndex=0&limit=$limit&Fields=$fieldString",
    );
    Response response = await request.get(items);
    prettyPrintJSON(response.data);
  }

  Future<void> getUserMovies() async {
    CreateRequest request = await CreateRequest.construct();
    final GET userMovies = GET(
      "/Users/${await _storage.getUserID()}/Items?IncludeItemTypes=movie&Recursive=True&startIndex=0&limit=1&Fields=MediaStreams,Path",
    );

    // Response realResponse = await request.get(userMovies);
    _response = await request.get(userMovies);
    prettyPrintJSON(await _response?.data);
  }
}
