import 'package:pokedex/models/Model.dart';
import 'package:pokedex/providers/Provider.dart';

import 'PokemonEvolutionChain.dart';

import 'Pokemon.dart';

class PokemonSpecies extends Model{
  int id;
  int order;
  Map<String, String> names;
  Map<String, String> descriptionEntries;
  Map<String, String> genra;
  List<Provider<Pokemon>> pokemon;
  Provider<PokemonEvolutionChain> evolutionChain;

  PokemonSpecies.fromJSON(Map<String, dynamic> json) : super.fromJSON(json) {
    
  }

}

