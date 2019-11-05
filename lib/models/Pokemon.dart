import 'package:pokedex/models/Model.dart';
import 'package:pokedex/providers/Provider.dart';
import 'package:pokedex/models/PokemonBaseStat.dart';

import 'PokemonBaseAbility.dart';
import 'PokemonSpecies.dart';
import 'PokemonBaseType.dart';

class Pokemon implements Model {
  int id;
  //Provider<PokemonSpecies> specie;
  List<PokemonStat> stats;
  Map<String, String> sprites;
  List<PokemonType> types;
  List<PokemonAbility> abilities;

  Pokemon.fromJSON(Map<String, dynamic> json) {
    id = json["id"];

    stats = new List();
    sprites = new Map();
    types = new List();
    abilities = new List();

  
    for (var stat in json["stats"]) {
      stats.add(new PokemonStat.fromJSON(stat));
    }    
    for (var type in json["types"]) {
      types.add(new PokemonType.fromJSON(type));
    }      
    for (var ability in json["abilities"]) {
      abilities.add(new PokemonAbility.fromJSON(ability));
    }
    
    json["sprites"].forEach((k, v) {
      if (v != null) sprites.putIfAbsent(k, () => v);
    });
  
  }
}

class PokemonAbility {
  Provider<PokemonBaseAbility> ability;
  bool isHidden;
  int slot;

  PokemonAbility.fromJSON(Map<String, dynamic> json) {
    ability = new Provider(json["ability"]["url"]);
    isHidden = json["is_hidden"];
    slot = json["slot"];
  }
}

class PokemonType {
  int slot;
  Provider<PokemonBaseType> type;

  PokemonType.fromJSON(Map<String, dynamic> json) {
    slot = json["slot"];
    type = new Provider(json["type"]["url"]);
  }
}

class PokemonStat {
  Provider<PokemonBaseStat> stat;
  int value;

  PokemonStat.fromJSON(Map<String, dynamic> json) {
    this.value = json["base_stat"];
    stat = new Provider(json["stat"]["url"]);
  }
}
