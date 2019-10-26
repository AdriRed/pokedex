import 'package:pokedex/providers/Provider.dart';

import 'PokemonSpecies.dart';

class PokemonChainLink {
  Provider<PokemonSpecies> specie;
  List<PokemonChainLink> evolutions;
}
