import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/models/Pokemon.dart';
import 'package:pokedex/models/PokemonChainLink.dart';
import 'package:pokedex/models/PokemonEvolutionChain.dart';
import 'package:pokedex/models/PokemonSpecies.dart';
import 'dart:async';

import 'package:pokedex/providers/Provider.dart';
import 'package:pokedex/widgets/PokemonSpeciesCard.dart';

class PokemonSpeciesDetail extends StatelessWidget {
  int varietyIndex = 0;
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
    //species.varieties.sort((a, b) => a.isDefault ? 1 : -1);
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

  Widget _evolutions(PokemonChainLink evolution) {
    List<Provider<PokemonSpecies>> allevos = evolution.orderedEvos();


    return Card(
      child: ListView(  
        shrinkWrap: true,
        controller: ScrollController(),
        padding: EdgeInsets.all(5),
        children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 5, 0, 3),
              child:  Text("Evolution chain",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
            ), 
            //Divider(color: Colors.black),
            ...List.generate(allevos.length, (index) => PokemonSpeciesCard(allevos[index], 1, 140))
            ],
      )
    );
  }

  Widget get _details {
    return Container(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              _name,
              Divider(color: Colors.black),
              _generaTypes,
              Divider(color: Colors.black),
              _description,
            ]
          )
        )
      )
    );
  }
  Widget get _description {
    return _text(species.descriptionEntries["es"], Colors.black, false, 15);
  }
  Widget _text(String text, Color color, bool bold, double size) {

    TextStyle style = TextStyle(color: color, fontSize: size, fontWeight: bold ? FontWeight.bold : FontWeight.normal);

    return Text(text, style: style);
  }

  Widget get _name {
    return _text("Nº" + species.id.toString() + " - " + species.names["es"], Colors.black, true, 20);
  }

  Widget get _genera {
    return _text(species.genera["es"], Colors.black, false, 16);
  }

  Widget _data(PokemonSpecies species) {
    return ListView(
      shrinkWrap: true,
      children: [
        _image,
        _details,
        _stats,
        _evolutions(species.evolutionChain.info.chain)
      ],
    );
  }
  Widget get _image {
    return Container(
      width: 300,
      height: 300,
      child: Center(
        child: Card(
          child: Image(
            image: species.varieties[varietyIndex].pokemon.info.sprites["front_default"] != null ? 
              NetworkImage(species.varieties[varietyIndex].pokemon.info.sprites["front_default"])
              : AssetImage("assets/poke-ball.png"),
            filterQuality: FilterQuality.none,
            width: 250,
            height: 250,
            fit: BoxFit.fill
          )
        )
      )
    );
  }
  
  Widget get _stats {
    return Column(
      children: species.varieties[varietyIndex].pokemon.info.stats.map((stat) => 
        Text(stat.stat.info.names["es"] + " -> " + stat.value.toString()))
        .toList()
      );
  }

  static var typeColors = <Color>[
      new Color(0xFFa8a878),// Normal,
      new Color(0xFFc03028),// Fighting,
      new Color(0xFFa890f0),// Flying,
      new Color(0xFFa040a0),// Poison,
      new Color(0xFFe0c068),// Ground,
      new Color(0xFFb8a038),// Rock,
      new Color(0xFFa8b820),// Bug,
      new Color(0xFF705898),// Ghost,
      new Color(0xFFb8b8d0),// Steel,
      new Color(0xFFf08030),// Fire,
      new Color(0xFF6890f0),// Water,
      new Color(0xFF78c850),// Grass,
      new Color(0xFFf8d030),// Electric,
      new Color(0xFFf85888),// Psychic,
      new Color(0xFF98d8d8),// Ice,
      new Color(0xFF7038f8),// Dragon,
      new Color(0xFF705848),// Dark,
      new Color(0xFFf0b6bc),// Fairy,
      new Color(0xFF6aa596),// Unknown,
      new Color(0xFF705898)// Shadow
    ];

  Widget get _types {

    return Row(
        children: species.varieties[varietyIndex].pokemon.info.types
            .map((type) =>
                Card(
                  color: typeColors[type.type.info.id-1],
                  child: new Padding(
                    padding: EdgeInsets.all(8),
                    child: new Text(
                      type.type.info.names["es"].toUpperCase(), 
                      style: new TextStyle(color: Colors.white, fontSize: 15),
                    )
                    )
                )
            )
            .toList());
  }

  Widget get _generaTypes {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[_genera, _types],
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
