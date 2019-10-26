import 'package:pokedex/models/Model.dart';

import 'PokemonChainLink.dart';

class PokemonEvolutionChain extends Model {
  int id;
  PokemonChainLink chain;

  PokemonEvolutionChain.fromJSON(Map<String, dynamic> json) : super.fromJSON(json) {

  }
}
