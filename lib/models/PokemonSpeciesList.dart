import 'dart:developer';

import 'package:pokedex/models/Model.dart';
import 'package:pokedex/models/Pokemon.dart';
import 'package:pokedex/models/PokemonSpecies.dart';
import 'package:pokedex/providers/Provider.dart';
import 'dart:async';

class PokemonSpeciesList implements Model  {
  List<Provider<PokemonSpecies>> species;

  PokemonSpeciesList.fromJSON(Map<String, dynamic> json, String field) {
    species = new List();
    for (var pokemonSpecie in json[field]) {
      species.add(new Provider(pokemonSpecie["url"]));
    }
  }
}
