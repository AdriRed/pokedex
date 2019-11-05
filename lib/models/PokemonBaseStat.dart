import 'package:pokedex/models/Model.dart';

class PokemonBaseStat implements Model {
  int id;
  String name;
  Map<String, String> names;

  PokemonBaseStat.fromJSON(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    names = new Map();
    for (var name in json["names"]) {
      names.putIfAbsent(name["language"]["name"], () => name["name"]);
    }
  }
}
