import 'package:pokedex/HelperMethods.dart';
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

  List<Future<void>> getAllInfo() {
    
    List<Future<void>> allgets = [specie.getInfo()];

    for (var item in evolutions) {
      allgets.addAll(item.getAllInfo());
    }

    return allgets;
  }

  // List<List<Provider<PokemonSpecies>>> orderedEvos(PokemonChainLink chain) {
  //   List<List<Provider<PokemonSpecies>>> ordered = [];
  //   ordered.add([specie]);
  //   List<Provider<PokemonSpecies>> zone = evolutions.map((evolution) => orderedEvos(evolution).toList();
  //   ordered.add([].addAll().toList()));
  // }
  // Future<void> getInfo() {
  //   specie.getInfo()
  // }
}
