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
  // https://stackoverflow.com/questions/23969680/waiting-for-futures-raised-by-other-futures?rq=1
  Future<void> getAllVarieties() async {
    List<Future<dynamic>> varietiesFutures = [];
    //log("Varieties from: " + species.names["es"]);
    species.varieties.forEach((variety) {
      varietiesFutures.add(variety.pokemon.getInfo().then((pokemon) {
        List<Future<dynamic>> futures = [];
        futures.add(futureAllTypes(pokemon));
        futures.add(futureAllAbilities(pokemon));
        futures.add(futureStats(pokemon));
        return Future.wait(futures);
      }));
    });
    varietiesFutures.add(futureEvolution(species));
    return Future.wait<dynamic>(varietiesFutures);
  }

  Future<void> futureAllTypes(Pokemon variety) async {
    // for (var variety in species.varieties) {
    List<Future<dynamic>> futures = [];
    for (var type in variety.types) {
      futures.add(type.type.getInfo());
    }
    // }
    variety.types.sort((x, y) => x.slot - y.slot);
    return Future.wait(futures);
  }

  Future<void> futureAllAbilities(Pokemon variety) async {
    List<Future<dynamic>> futures = [];
    for (var abilitiyProv in variety.abilities) {
      futures.add(abilitiyProv.ability.getInfo());
    }
    return Future.wait(futures);
  }

  Future<void> futureEvolution(PokemonSpecies species) async {
    //log("Evolutions from species: " + species.names["es"]);
    return species.evolutionChain
        .getInfo()
        .then((x) => Future.wait(x.chain.getAllInfo()));
  }

  Future<void> futureStats(Pokemon variety) async {
    List<Future<dynamic>> futures = [];
    for (var statProv in variety.stats) {
      futures.add(statProv.stat.getInfo());
    }
    return Future.wait(futures);
  }

  // List<Future<void>> getAllEvolutions(PokemonEvolutionChain evochain) async{
  //   log("chain from " + evochain.id.toString());
  //   await evochain.chain.getAllInfo();
  // }

  Widget _data(PokemonSpecies species) {
    return Column(
      children: [
        _types,
        _stats
      ],
    );
  }

  Widget get _stats {
    return Column(
      children: species.varieties[0].pokemon.info.stats.map((stat) => 
        Text(stat.stat.info.names["es"] + " -> " + stat.value.toString()))
        .toList()
      );
  }

  Widget get _types {
    return Row(
        children: species.varieties[0].pokemon.info.types
            .map((type) =>
                Text(type.slot.toString() + " - " + type.type.info.names["es"] + " "))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 220, 220, 220),
      appBar: new AppBar(
          backgroundColor: Colors.red, title: new Text(species.names["es"])),
      body: Container(
        child: FutureBuilder(
          future: getAllVarieties(),
          builder: (builder, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) return Icon(Icons.close);
              return _data(species);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
