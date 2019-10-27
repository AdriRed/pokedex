import 'package:pokedex/models/Model.dart';

class Provider<T> {
  String uri;
  Model info;

  void getInfo() {
    Map<String, dynamic> foo = new Map()..putIfAbsent("key", () => "aldskj");
  
    info = Model.fromJSON(T, foo);
  }

  Provider(String uri) {
    this.uri = uri;
  }
}
