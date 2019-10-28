import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:pokedex/models/Model.dart';

class Provider<T extends Model> {
  String url;
  T info;

  Future<T> getInfo() async {
    if (info != null) return null;

    HttpClient http = new HttpClient();

    String route = url.split("pokeapi.co/")[1];
    log(route);
    try {
      var uri = new Uri.https("pokeapi.co", route);
      log("GET JSON: " + uri.toString());
      var request = await http.getUrl(uri);
      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).join();
      log(responseBody);
      var decoded = json.decode(responseBody);

      info = new Model.fromJSON(T, decoded);
    } catch (e) {
    }

    log("info returned " + info.runtimeType.toString());
    return info;
  }

  Provider(String uri) {
    this.url = uri;
  }
}
