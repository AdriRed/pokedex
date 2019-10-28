import 'dart:developer';

import 'package:pokedex/models/Model.dart';
import 'package:pokedex/models/PokemonSpecies.dart';
import 'package:pokedex/providers/Provider.dart';
import 'dart:async';

class PokemonSpeciesList implements Model  {
  List<Provider<PokemonSpecies>> species;

  PokemonSpeciesList.fromJSON(Map<String, dynamic> json) {
    species = new List();
    for (var pokemonSpecie in json["results"]) {
      species.add(new Provider(pokemonSpecie["url"]));
    }
  }

  Future<List<PokemonSpecies>> getPokemonSpecies() async {
    List<PokemonSpecies> list = new List();
    for (var pokemonSpecie in species) {
      //log(pokemonSpecie.url);
      var specie = await pokemonSpecie.getInfo();
      // for (var variety in specie.varieties) {
      //   await variety.pokemon.getInfo();
      // }
      //log("Id: "+ specie.id.toString());
      list.add(specie);
    }
    return list;
  }


}
