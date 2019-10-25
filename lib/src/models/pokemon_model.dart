import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

class PokemonSpecie {

  final String _findLang = "en";
  String name;
  String description;
  List<dynamic> evolutionChain;
  List<Pokemon> pokemon;
  
  Uri _evolutionChainUri;

  PokemonSpecie.fromJSON(Map<String, dynamic> json) {
    description = _findFlavorText(json["flavor_text_entries"]);
    String evoChain = json["evolution_chain"]["url"].split("https://pokeapi.co/api/v2/evolution-chain/")[1].split('/')[0];
    _evolutionChainUri = new Uri.https("pokeapi.co", "api/v2/evolution-chain/" + evoChain);
  }

  Future<List<dynamic>> setEvolutionChain(Map<String, dynamic> json) async {
    
  }

  String _findFlavorText(var flavortexts) {

    String find = "Not found";

    for (var flavor_text in flavortexts) {
      if (flavor_text["language"]["name"] == _findLang) {
        find = flavor_text["flavor_text"];
        break;
      }
    }

    return find;
  }
}

class Pokemon {
  String name;
}