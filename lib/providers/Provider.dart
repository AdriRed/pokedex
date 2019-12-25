import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:pokedex/models/Model.dart';
import 'package:pokedex/providers/Locker.dart';
import 'package:pokedex/search/PokeSearch.dart';

class Provider<T extends Model> {
  static const String domain = "pokeapi.co"; 
  Uri url;
  T info;
  Locker _locker = LockManager.getLocker();
  static Repository repo = new Repository();

  bool get hasInfo {
    return info != null;
  }

  Future<T> getInfo() async {
    _recall() {
      return getInfo();
    }

    if (_locker.locked) return await _locker.waitLock();
    _locker.setFunction(_recall);
    _locker.lock();

    if (hasInfo) {
      _locker.unlock();
      return info;
    }

    if (repo.exists(url.toString())) {
      info = await repo.pop(url.toString()) as T;
      _locker.unlock();
      return info;
    }
    

    try {
      HttpClient http = new HttpClient();
      final resp = await http.getUrl(url);
      final respbody = await resp.close();
      
      log(respbody.statusCode.toString() + " -- " + url.toString());

      if (respbody.statusCode != 200) {
        _locker.unlock();
        return await getInfo();
      }

      final converted = await respbody.transform(utf8.decoder).join();
      final decoded = json.decode(converted);

      T object = new Model.fromJSON(T, decoded);
      info = object;
    } catch (e) {
      log(e.toString());
    }
    repo.add(url.toString(), info);
    _locker.unlock();
    return info;
  }

  Provider(String struri) {
    String route = struri.split(domain+"/")[1];
    url = new Uri.https(domain, route);
  }

  Provider.uri(Uri uri) {
    url = uri;
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
