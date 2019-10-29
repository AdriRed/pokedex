import 'package:pokedex/models/Model.dart';

class PokemonBaseAbility implements Model {
  int id;
  Map<String, String> names;

  PokemonBaseAbility.fromJSON(Map<String, dynamic> json) {
    id = json["id"];
    names = new Map();
    for (var flavorText in json["flavor_text_entries"]) {
      names.putIfAbsent(
          flavorText["language"]["name"], () => flavorText["flavor_text"]);
    }
  }
}
