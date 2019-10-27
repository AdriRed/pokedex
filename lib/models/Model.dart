import 'package:pokedex/models/Pokemon.dart';
import 'package:pokedex/models/PokemonBaseAbility.dart';
import 'package:pokedex/models/PokemonEvolutionChain.dart';
import 'package:pokedex/models/PokemonSpecies.dart';
import 'package:pokedex/models/PokemonBaseStat.dart';
import 'package:pokedex/models/PokemonBaseType.dart';

abstract class Model {
  factory Model.fromJSON(Type type, Map<String, dynamic> json) {
    
    switch (type) {
      case Pokemon:
        return Pokemon.fromJSON(json);
        break;
      case PokemonBaseAbility:
        return PokemonBaseAbility.fromJSON(json);
        break;
      case PokemonEvolutionChain:
        return PokemonEvolutionChain.fromJSON(json);
        break;
      case PokemonSpecies:
        return PokemonSpecies.fromJSON(json);
        break;
      case PokemonBaseStat:
        return PokemonBaseStat.fromJSON(json);
        break;
      case PokemonBaseType:
        return PokemonBaseType.fromJSON(json);
        break;
    }

    throw Exception("Not valid type");
  }
}
