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
  int _count = 0;

  List<Provider<PokemonSpecies>> fetch(int many) {
    var list = entries.sublist(_count, many).map((item) {return item.species;}).toList();
    _count += many;
    return list;
  }

  PokeIndex.fromJSON(Map<String, dynamic> json) {
    for (var i = 0; i < json["results"].length; i++) {
      entries.add(new PokeEntry.fromJSON(json["results"][i], i + 1));
    }
  }
}