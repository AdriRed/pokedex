import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/HelperMethods.dart';
import 'package:pokedex/User.dart';
import 'package:pokedex/models/Pokemon.dart';
import 'package:pokedex/models/PokemonBaseType.dart';
import 'package:pokedex/models/PokemonChainLink.dart';
import 'package:pokedex/models/PokemonEvolutionChain.dart';
import 'package:pokedex/models/PokemonSpecies.dart';
import 'package:pokedex/pages/PokedexHomePage.dart';
import 'package:pokedex/providers/PokemonLoader.dart';
import 'dart:async';

import 'package:pokedex/providers/Provider.dart';
import 'package:pokedex/widgets/PokemonSpeciesCard.dart';

class PokemonSpeciesDetail extends StatefulWidget {
  static const String route = "/detail";
  final PokemonSpecies species;

  PokemonSpeciesDetail(this.species);

  @override
  State<StatefulWidget> createState() {
    return new _PokemonSpeciesDetailState(species);
  }
}

class _PokemonSpeciesDetailState extends State<PokemonSpeciesDetail> {
  final PokemonSpecies species;

  var _size;
  int varietyIndex = 0;

  _PokemonSpeciesDetailState(this.species);

  // https://stackoverflow.com/questions/23969680/waiting-for-futures-raised-by-other-futures?rq=1
  static Future<void> getAllVarieties(PokemonSpecies species) async {
    List<Future<dynamic>> varietiesFutures = [];
    species.varieties.forEach((variety) {
      varietiesFutures.add(variety.pokemon.getInfo().then((pokemon) {
        List<Future<dynamic>> futures = [];
        futures.add(PokemonLoader.futureAllTypes(pokemon));
        futures.add(PokemonLoader.futureAllAbilities(pokemon));
        futures.add(PokemonLoader.futureStats(pokemon));
        return Future.wait(futures);
      }));
    });
    //species.varieties.sort((a, b) => a.isDefault ? 1 : -1);
    varietiesFutures.add(PokemonLoader.futureEvolution(species));
    // species.varieties.forEach((v) =>
    //     v.pokemon.info.stats.sort((x, y) => x.stat.info.id - y.stat.info.id));
    return Future.wait<dynamic>(varietiesFutures);
  }

  Widget _evolutions(PokemonChainLink evolution) {
    List<Provider<PokemonSpecies>> allevos = evolution.orderedEvos();

    return Card(
        child: ListView(
      shrinkWrap: true,
      controller: ScrollController(),
      padding: EdgeInsets.all(5),
      children: [
        // Container(
        //     margin: EdgeInsets.fromLTRB(10, 5, 0, 3),
        //     child: Text(
        //       "Evolution chain",
        //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        //     )),
        //Divider(color: Colors.black),
        ...List.generate(allevos.length,
            (index) => Container(padding: EdgeInsets.all(8),child:PokemonSpeciesCard(allevos[index]), height: 150,))
      ],

    ));
  }

  Widget get _details {
    return Container(
        child: Card(
            child: Padding(
                padding: EdgeInsets.all(7),
                child: Column(children: [
                  _name,
                  Divider(color: Colors.black),
                  _generaTypes,
                  Divider(color: Colors.black),
                  _description,
                ]))));
  }

  Widget get _description {
    return _text(
        species.descriptionEntries[User.language] ??
            species.descriptionEntries[User.extraLang],
        Colors.black,
        false,
        15);
  }

  Widget _text(String text, Color color, bool bold, double size) {
    TextStyle style = TextStyle(
        color: color,
        fontSize: size,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal);

    return Text(text, style: style);
  }

  Widget get _name {
    return _text(
        "Nº" + species.id.toString() + " - " + species.names[User.language] ??
            species.names[User.extraLang],
        Colors.black,
        true,
        20);
  }

  Widget get _genera {
    return _text(
        species.genera[User.language] ?? species.genera[User.extraLang],
        Colors.black,
        false,
        16);
  }

  Widget _data(PokemonSpecies species) {
    return ListView(
      shrinkWrap: true,
      children: [
        _imageBox,
        _details,
        _stats,
        _evolutions(species.evolutionChain.info.chain)
      ],
    );
  }

  Widget get _imageBox {
    List<Widget> children = new List();

    children.add(Align(
      alignment: Alignment.center,
      child: _image(varietyIndex),
    ));
    if (species.varieties.length > 1) {
      children.add(Align(alignment: Alignment.topCenter, child: _forms));
    }

    return Container(
        width: _size.width * 0.775,
        height: _size.height * 0.469,
        child: Center(child: Card(child: Stack(children: children))));
  }

  Widget get _forms {
    return PopupMenuButton<int>(
      itemBuilder: (context) {
        List<PopupMenuItem<int>> list = List();
        for (int i = 0; i < species.varieties.length; i++) {
          list.add(PopupMenuItem(
            value: i,
            child: Center(
                child: _image(i,
                    fit:
                        true)), //Padding( child:, padding: EdgeInsets.only(top: 30),),
            height: _size.height * 0.15625,
          ));
        }
        return list;
      },
      onSelected: (val) => setState(() => varietyIndex = val),
      initialValue: varietyIndex,
      icon: Icon(Icons.list),
    );
  }

  Widget _image(int varIndex, {bool fit = true}) {
    var provider = species
                .varieties[varIndex].pokemon.info.sprites["front_default"] !=
            null
        ? NetworkImage(
            species.varieties[varIndex].pokemon.info.sprites["front_default"])
        : AssetImage("assets/poke-ball.png");

    return fit
        ? Image(
            image: provider,
            filterQuality: FilterQuality.none,
            width: _size.width * 0.652,
            height: _size.width * 0.652,
            fit: BoxFit.fitHeight)
        : Image(
            image: provider,
            filterQuality: FilterQuality.none,
            width: _size.width * 0.652,
            height: _size.width * 0.652,
          );
  }

  Widget get _stats {
    return Card(
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Column(
                children: HelperMethods.splitIn(
                        species.varieties[varietyIndex].pokemon.info.stats, 2)
                    .map((pairstat) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _stat(pairstat.first),
                              Divider(),
                              _stat(pairstat.last)
                            ]))
                    .toList())));
  }

  Widget _stat(PokemonStat stat) {
    return Card(
      color: Colors.black,
      child: Row(children: [
        Card(
          color: Colors.white,
          child: Padding(
              padding: EdgeInsets.all(2),
              child: _text(
                  stat.stat.info.names[User.language] ??
                      stat.stat.info.names[User.extraLang],
                  Colors.black,
                  true,
                  15)),
        ),
        Card(
          color: Colors.white,
          child: Padding(
              padding: EdgeInsets.all(2),
              child: _text(stat.value.toString(), Colors.black, true, 15)),
        ),
      ]),
    );
  }

  Widget get _types {
    return Row(
        children: species.varieties[varietyIndex].pokemon.info.types
            .map((type) => Card(
                color: PokemonBaseType.colors[type.type.info.id - 1],
                child: new Padding(
                    padding: EdgeInsets.all(8),
                    child: new Text(
                      (type.type.info.names[User.language] ??
                              type.type.info.names[User.extraLang])
                          .toUpperCase(),
                      style: new TextStyle(color: Colors.white, fontSize: 15),
                    ))))
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
    _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 250, 250),
      appBar: new AppBar(
          backgroundColor: Colors.red,
          title: new Text(
              species.names[User.language] ?? species.names[User.extraLang]),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.home),
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, PokedexHomePage.route, (_) => false)),
          ]),
      body: Container(
        child: FutureBuilder(
          future: getAllVarieties(species),
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
