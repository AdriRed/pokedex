import 'package:pokedex/providers/Provider.dart';

import 'Model.dart';
import 'PokemonSpecies.dart';

class PokemonGeneration implements Model {
  int id;
  String initials;
  String name;
  Map<String, String> names;
  List<Provider<PokemonSpecies>> pokemonSpecies;

  PokemonGeneration.fromJSON(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    initials = name.substring(name.indexOf("-") + 1);
    for (var lan in json["names"]) {
      names.putIfAbsent(lan["language"]["name"], () => lan["name"]);
    }

    for (var poke in json["pokemon_species"]) {
      pokemonSpecies.add(new Provider(poke["url"]));
    }

    pokemonSpecies.sort((a, b) =>
        (a.url.split("/")[6] as int).compareTo(b.url.split("/")[6] as int));
  }
}
