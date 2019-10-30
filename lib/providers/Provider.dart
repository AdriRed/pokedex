import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:pokedex/models/Model.dart';

class Provider<T extends Model> {
  String url;
  T info;
  static Repository repo = new Repository();

  Future<T> getInfo() async {
    if (info != null) return info;
    
    {
      T repoitem = await repo.pop(url) as T;
      if (repoitem != null) {
        info = repoitem;
        return repoitem;
      }
    }

    HttpClient http = new HttpClient();

    String route = url.split("pokeapi.co/")[1];
    log(route);
    try {
      var uri = new Uri.https("pokeapi.co", route);
      //log("GET JSON: " + uri.toString());
      var request = await http.getUrl(uri);
      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).join();
      //log(responseBody);
      var decoded = json.decode(responseBody);

      T object = new Model.fromJSON(T, decoded);
      //log(object.runtimeType.toString());
      info = object;
    } catch (e) {}

    //log("info returned " + info.runtimeType.toString());
    repo.add(url, info);
    return info;
  }

  Provider(String uri) {
    this.url = uri;
  }
}

class Repository {
  Map<String, dynamic> _repo = new Map();

  void add(String k, dynamic v) {
    _repo.putIfAbsent(k, () => v);
  }

  Future<dynamic> pop(String k) async {
    if (!_repo.containsKey(k)) return null;
    return _repo[k];
  }
}
