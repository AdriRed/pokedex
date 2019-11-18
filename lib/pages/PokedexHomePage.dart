import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pokedex/models/PokemonSpecies.dart';
import 'package:pokedex/providers/PokemonSpeciesProvider.dart';
import 'package:pokedex/providers/Provider.dart';
import 'package:pokedex/search/PokeSearch.dart';
import 'package:pokedex/widgets/PokemonListWidget.dart';

class PokedexHomePage extends StatelessWidget {
  static const String route = "/home";
  final PokemonSpeciesProvider _provider = new PokemonSpeciesProvider();
  bool first = true;

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StreamBuilder(
            stream: _provider.speciesStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<Provider<PokemonSpecies>>> snapshot) {
              if (snapshot.hasData) {
                return PokemonListWidget(
                  snapshot.data,
                  _provider.getMore,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (first) {
      // Provider<PokeIndex> provider =
      //     new Provider("https://pokeapi.co/api/v2/pokemon-species/?limit=807");
      // provider.getInfo();
      _provider.getMore();
      first = false;
    }
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Pokédex"),
          backgroundColor: Colors.red,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: PokeSearch(_provider, MediaQuery.of(context).size),
                  // query: 'Hola'
                );
              },
            )
          ],
        ),
        body: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[_footer(context)],
        )),
        drawer: new Drawer(
          child: Padding(
            padding: MediaQuery.of(context).viewPadding,
            child:Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _generations,
                _buttonOf(context, "Settings", Icons.settings, () => log("SETTINGS!")) // Align bot
              ],
        ))));
  }

  Widget _buttonOf(
      BuildContext ctx, String label, IconData img, Function() onPressed) {
    return Container(
      height: MediaQuery.of(ctx).size.width * 0.1,
      padding: EdgeInsets.fromLTRB(10,10, 0, 0),
      child: GestureDetector(
        onTap: onPressed,
        child: Stack(
          children: <Widget>[
            Align(
              child: Icon(img),
              alignment: Alignment.centerLeft,
            ),
            //SizedBox(width: 20,),
            Align(
              child: Text(label),
              alignment: Alignment.center,
            )
          ],
        ),
      ),
    );
  }

  Widget get _generations {
    return Container();
  }
}
