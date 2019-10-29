import 'package:pokedex/providers/Provider.dart';

import 'PokemonSpecies.dart';

class PokemonChainLink {
  Provider<PokemonSpecies> specie;
  List<PokemonChainLink> evolutions;

  PokemonChainLink.fromJSON(Map<String, dynamic> json) {
    specie = new Provider(json["species"]["url"]);
    evolutions = new List();
    for (var evolution in json["evolves_to"]) {
      evolutions.add(new PokemonChainLink.fromJSON(evolution));
    }
  }

  Future getAllInfo() async {
    await specie.getInfo();
    for (var evolution in evolutions) {
      await evolution.getAllInfo();
    }
  }
}
