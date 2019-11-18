import 'package:flutter/material.dart';
import 'package:pokedex/models/Model.dart';
import 'package:pokedex/models/PokemonSpecies.dart';
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
              children: <Widget>[...snapshot.data.map((item) => PokemonSpeciesCard(item.species, 1, _size.width*0.8*0.59, true))],
            );
          } else {
            return Center(child:PokemonSpeciesCard(snapshot.data.species, _size.width*0.8, _size.width*0.8*0.3, true));
          }
        }
        return Container();
      },
    );
  }
}

class PokeEntry {
  Provider<PokemonSpecies> species;
  String name;
  int id;

  PokeEntry.fromJSON(Map<String, dynamic> json, int id) {
    name = json["name"];
    species = new Provider(json["url"]);
    this.id = id;
  }
}

class PokeIndex implements Model {
  List<PokeEntry> entries = new List();

  PokeIndex.fromJSON(Map<String, dynamic> json) {
    for (var i = 0; i < json["results"].length; i++) {
      entries.add(new PokeEntry.fromJSON(json["results"][i], i + 1));
    }
  }
}
