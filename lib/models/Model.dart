import 'dart:developer';

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
        return new Pokemon.fromJSON(json);
        break;
      case PokemonBaseAbility:
        return new PokemonBaseAbility.fromJSON(json);
        break;
      case PokemonEvolutionChain:
        return new PokemonEvolutionChain.fromJSON(json);
        break;
      case PokemonSpecies:
        PokemonSpecies a = new PokemonSpecies.fromJSON(json);
        log("factory: " + a.runtimeType.toString());
        return a;
        break;
      case PokemonBaseStat:
        return new PokemonBaseStat.fromJSON(json);
        break;
      case PokemonBaseType:
        return new PokemonBaseType.fromJSON(json);
        break;
    }

    throw Exception("Not valid type");
  }
}
