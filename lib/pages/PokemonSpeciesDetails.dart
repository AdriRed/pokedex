import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/models/PokemonSpecies.dart';
import 'dart:async';

class PokemonSpeciesDetail extends StatelessWidget {
  static const String route ="detail";

  final PokemonSpecies species;

  PokemonSpeciesDetail(this.species);

  Future<void> getAllSpeciesInfo() async {
    for (var variety in species.varieties) {
      await variety.pokemon.getInfo();
      for (var type in variety.pokemon.info.types) {
        await type.type.getInfo();
      }
      for (var ability in variety.pokemon.info.abilities) {
        await ability.ability.getInfo();
      }
      
    }
    
    await species.evolutionChain.getInfo();
    await species.evolutionChain.info.chain.getAllInfo();
  }

  Widget get _data {

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 220, 220, 220),
      appBar: new AppBar(
            backgroundColor: Colors.red, 
            title: new Text(species.names["es"])),
      body: Container(
        child: FutureBuilder(
          future: getAllSpeciesInfo(),
          builder: (builder, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Text(species.varieties[0].pokemon.info.types[0].type.info.names["es"]);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

}