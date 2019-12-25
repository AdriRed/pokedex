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

  @override
  Widget build(BuildContext context) {
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
                );
              },
            )
          ],
        ),
        body: Container(
          child: _footer(context),
        ),
        drawer: new Drawer(
            child: Padding(
                padding: MediaQuery.of(context).viewPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    _generations,
                    _buttonOf(context, "Settings", Icons.settings,
                        () => log("SETTINGS!")) // Align bot
                  ],
                ))));
  }

  Widget _footer(BuildContext context) {
    return Container(
        child: FutureBuilder(
            future: _provider.initIndex().then((_){_provider.getMore();}),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return StreamBuilder(
                    stream: _provider.speciesStream,
                    builder: (BuildContext ctx,
                        AsyncSnapshot<List<Provider<PokemonSpecies>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return PokemonListWidget(
                          snapshot.data,
                          _provider.getMore,
                        );
                      }
                      return Center(child: CircularProgressIndicator());

                    });
              }
              return Center(child: CircularProgressIndicator());
            }));
  }

  Widget _buttonOf(
      BuildContext ctx, String label, IconData img, Function() onPressed) {
    return Container(
      height: MediaQuery.of(ctx).size.width * 0.1,
      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
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
