import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/models/Pokemon.dart';
import 'package:pokedex/models/PokemonEvolutionChain.dart';
import 'package:pokedex/models/PokemonSpecies.dart';
import 'dart:async';

class PokemonSpeciesDetail extends StatelessWidget {
  static const String route = "detail";

  final PokemonSpecies species;

  PokemonSpeciesDetail(this.species);

  Future<void> getAllVarieties() async {
    log("Varieties from: " + species.names["es"]);
    for (var variety in species.varieties) {
      await variety.pokemon.getInfo();
    }
  }

  Future<void> getAllTypes() async {
    for (var variety in species.varieties) {
      log("Types from variety: " + variety.pokemon.info.id.toString());
      for (var type in variety.pokemon.info.types) {
        await type.type.getInfo();
      }
    }
    species.varieties[0].pokemon.info.types.sort((x, y) => x.slot - y.slot);
  }

  Future<void> getAllAbilities() async {
    for (var variety in species.varieties) {
      log("Abilities from variety: " + variety.pokemon.info.id.toString());
      for (var ability in variety.pokemon.info.abilities) {
        await ability.ability.getInfo();
      }
    }
  }

  Future<void> getEvolutionChain(PokemonSpecies species) async {
    log("Evolutions from species: " + species.names["es"]);
    await species.evolutionChain
        .getInfo()
        .then((x) => Future.wait(x.chain.getAllInfo()));
  }

  // List<Future<void>> getAllEvolutions(PokemonEvolutionChain evochain) async{
  //   log("chain from " + evochain.id.toString());
  //   await evochain.chain.getAllInfo();
  // }

  Future<void> getStats() async {}

  Widget get _data {
    return Column(
      children: [_types/*, _evolutions*/],
    );
  }

  Widget get _types {
    return Row(
        children:
            species.varieties[0].pokemon.info.types.map((type) => Text(type.slot.toString() + " - " + type.type.info.names["es"])).toList()
            );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 220, 220, 220),
      appBar: new AppBar(
          backgroundColor: Colors.red, title: new Text(species.names["es"])),
      body: Container(
        child: FutureBuilder(
          future: Future.wait<dynamic>([
            getAllVarieties(),
            getAllAbilities(),
            getAllTypes(),
            //getEvolutionChain(species),
            //...species.evolutionChain.info.chain.getAllInfo()
          ]),
          builder: (builder, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) 
                return Icon(Icons.close);
              return _data;
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
