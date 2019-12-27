import 'dart:collection';
import 'dart:developer';

import 'package:pokedex/models/Model.dart';
import 'package:pokedex/models/PokemonSpecies.dart';
import 'package:pokedex/providers/Provider.dart';

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
  Queue<PokeEntry> order;
  int _count = 0;

  List<Provider<PokemonSpecies>> fetch(int many) {
    // log("Fetching " + many.toString());
    // var list = entries.sublist(_count, many+1).map((item) {return item.species;}).toList();
    // _count += many;
    // log("Total " + _count.toString());
    var list = new List<Provider<PokemonSpecies>>();
    for (var i = 0; i < many; i++) {
      list.add(order.removeFirst().species);
    }
    
    return list;
  }

  PokeIndex.fromJSON(Map<String, dynamic> json) {
    for (var i = 0; i < json["results"].length; i++) {
      entries.add(new PokeEntry.fromJSON(json["results"][i], i + 1));
    }
    order = new Queue.from(entries);
  }
}