import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:pokedex/models/Model.dart';
import 'package:pokedex/providers/Locker.dart';

class Provider<T extends Model> {
  String url;
  T info;
  Locker locker = LockManager.getLocker();
  static Repository repo = new Repository();

  bool get hasInfo {
    return info != null;
  }

  Future<T> getInfo() async {
    
    _recall() {
      return getInfo();
    }
    
    if (locker.locked) return await locker.waitLock();
    locker.setFunction(_recall);
    locker.lock();

    if (hasInfo) {
      locker.unlock();
      return info;
    }

    {
      if (repo.exists(url)) {
        info = await repo.pop(url) as T;
        locker.unlock();
        return info;
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
      if (response.statusCode == 404) {
        locker.unlock();
        return await getInfo();
      }
      var responseBody = await response.transform(utf8.decoder).join();
      //log(responseBody);
      var decoded = json.decode(responseBody);

      T object = new Model.fromJSON(T, decoded);
      //log(object.runtimeType.toString());
      info = object;
    } catch (e) {
      log(e.toString());
    }

    //log("info returned " + info.runtimeType.toString());
    repo.add(url, info);
    locker.unlock();
    return info;
  }

  Provider(String uri) {
    this.url = uri;
  }
}

class Repository {
  Map<String, dynamic> _repo = new Map();

  bool exists(String k) {
    return _repo.containsKey(k);
  }

  void add(String k, dynamic v) {
    _repo.putIfAbsent(k, () => v);
  }

  Future<dynamic> pop(String k) async {
    if (!_repo.containsKey(k)) return null;
    return _repo[k];
  }
}
