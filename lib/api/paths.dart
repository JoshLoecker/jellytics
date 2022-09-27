// This is a library that contains the paths to the different pages of the app.
import 'package:jellytics/api/async_requests.dart';
import "package:jellytics/api/base_paths.dart";
import 'package:jellytics/api/end_points.dart';
import "package:jellytics/api/utils.dart";

class GETUser {
  static const GET allUsers = GET(User.basePath);
  static const GET meUser = GET("${User.basePath}/Me");
}

class POSTUser {
  static const POST authenticateByName =
      POST("${User.basePath}/AuthenticateByName");
  static const POST publicUsers = POST("${User.basePath}/Public");

  POST authenticateByID({required String id}) {
    return POST("${User.basePath}/$id/Authenticate");
  }
}

class GETPlugins extends Plugins {
  GETPlugins() : super();

  void getPlugins(LoginObject loginObject) async {
    var pluginRequest = CreateRequest(
        baseUrl: loginObject.serverURL,
        method: RequestType.get,
        mediaToken: loginObject.mediaBrowser);

    var data = await pluginRequest.get(Plugins.basePath);
    prettyPrintJSONList(data.data);
  }
}
