import 'package:flutter/material.dart';
import 'package:pokedex/models/Model.dart';
import 'package:pokedex/models/PokemonSpecies.dart';
import 'package:pokedex/pages/PokemonSpeciesDetails.dart';
import 'package:pokedex/providers/PokeIndex.dart';
import 'package:pokedex/providers/PokemonSpeciesProvider.dart';
import 'package:pokedex/providers/Provider.dart';
import 'package:pokedex/widgets/PokemonSpeciesCard.dart';

class PokeSearch extends SearchDelegate {
  PokemonSpeciesProvider provider;
  Size _size;
  PokeSearch(PokemonSpeciesProvider provider, Size size) {
    this.provider = provider;
    provider.initIndex();
    _size = size;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }
  
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return Container(width: 40, height: 40);

    return FutureBuilder(
      future: provider.find(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return Center(child:CircularProgressIndicator());
        if (snapshot.hasData) {
          if (snapshot.data is List<PokeEntry>) {
            return ListView(
              children: <Widget>[...snapshot.data.map((item) => Container(padding: EdgeInsets.all(8),child:PokemonSpeciesCard(item.species), height: 150,))],
            );
          } else {
            return Center(child: Container(padding: EdgeInsets.all(8),child:PokemonSpeciesCard(snapshot.data.species), height: 150,));
          }
        }
        return Container();
      },
    );
  }
}
