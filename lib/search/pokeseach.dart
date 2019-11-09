import 'package:flutter/material.dart';
import 'package:pokedex/models/Model.dart';
import 'package:pokedex/models/PokemonSpecies.dart';
import 'package:pokedex/providers/Provider.dart';

class PokeSearch extends SearchDelegate {
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
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return null;
  }
}

class PokeEntry {
  Provider<PokemonSpecies> species;
  String name;

  PokeEntry.fromJSON(Map<String, dynamic> json) {
    name = json["name"];
    species = new Provider(json["url"]);
  }
}

class PokeIndex implements Model {
  List<PokeEntry> entries = new List();

  PokeIndex.fromJSON(Map<String, dynamic> json) {
    for (var result in json["results"]) {
      entries.add(new PokeEntry.fromJSON(result));
    }
  }
}
