import 'package:pokedex/models/Model.dart';

import 'PokemonChainLink.dart';

class PokemonEvolutionChain implements Model {
  int id;
  PokemonChainLink chain;

  PokemonEvolutionChain.fromJSON(Map<String, dynamic> json) {
    id = json["id"];
    chain = PokemonChainLink.fromJSON(json["chain"]);
  }
}
