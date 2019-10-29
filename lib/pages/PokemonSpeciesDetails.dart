import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/models/Pokemon.dart';
import 'package:pokedex/models/PokemonSpecies.dart';
import 'dart:async';

class PokemonSpeciesDetail extends StatelessWidget {
  static const String route = "detail";

  final PokemonSpecies species;

  PokemonSpeciesDetail(this.species);

  Future<void> getAllVarieties() async {
    for (var variety in species.varieties) {
      await variety.pokemon.getInfo()
      // .then((x) {
      //   for (var abilityprovider in variety.pokemon.info.abilities) {
      //     abilityprovider.ability.getInfo();
      //   }
      // })
      ;
    }
  }

  Future<void> getAllTypes(List<PokemonVariety> varieties) async {
    for (var variety in varieties) {
      for (var type in variety.pokemon.info.types) {
        await type.type.getInfo();
      }
    }
  }

  Future<void> getAllAbilities(List<PokemonVariety> varieties) async {
    for (var variety in varieties) {
      for (var ability in variety.pokemon.info.abilities) {
        await ability.ability.getInfo();
      }
    }
  }

  Future<void> getEvolutions() async {
    species.evolutionChain.getInfo().then((x) => x.chain.getAllInfo());
  }

  Widget get _data {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 220, 220, 220),
      appBar: new AppBar(
          backgroundColor: Colors.red, title: new Text(species.names["es"])),
      body: Container(
        child: FutureBuilder(
          future: Future.wait<dynamic>([
            getAllAbilities(species.varieties),
            getAllVarieties(),
            getAllTypes(species.varieties)
          ]),
          builder: (builder, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) return Icon(Icons.close);
              return Text(species
                  .varieties[0].pokemon.info.types[0].type.info.names["es"]);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
