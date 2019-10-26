import 'package:pokedex/models/Model.dart';

class PokemonType extends Model {
  int id;
  Map<String, String> names;

  PokemonType.fromJSON(Map<String, dynamic> json) : super.fromJSON(json) {
    id = json["id"];
    names = new Map<String, String>();
    for (var item in json["names"])
      names.putIfAbsent(item["language"]["name"], item["name"]);
  }
}
