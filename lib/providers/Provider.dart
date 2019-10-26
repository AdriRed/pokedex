import 'package:pokedex/models/Model.dart';

abstract class Provider<T extends Model> {
  String uri;
  T info;

  void getInfo() {
    Map<String, dynamic> foo = new Map()..putIfAbsent("key", () => "ñldskj");

    info = new T.fromJSON();
  }

  Provider(String uri) {
    this.uri = uri;
  }
}
