import 'package:flutter/material.dart';
import 'package:pokedex/models/PokemonSpecies.dart';
import 'package:pokedex/providers/PokemonSpeciesListProvider.dart';
import 'package:pokedex/providers/Provider.dart';
import 'package:pokedex/search/pokeseach.dart';
import 'package:pokedex/widgets/PokemonListWidget.dart';

class PokedexHomePage extends StatelessWidget {
  static const String route = "/home";
  final PokemonSpeciesListProvider _provider = new PokemonSpeciesListProvider();
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
            backgroundColor: Colors.red),
        body: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[_footer(context)],
        )));
  }
}
