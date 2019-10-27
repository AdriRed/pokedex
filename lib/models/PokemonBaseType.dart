import 'package:pokedex/models/Model.dart';

class PokemonBaseType implements Model {
  int id;
  Map<String, String> names;

  PokemonBaseType.fromJSON(Map<String, dynamic> json) {
    id = json["id"];
    names = new Map<String, String>();
    for (var item in json["names"])
      names.putIfAbsent(item["language"]["name"], item["name"]);
  }
}
