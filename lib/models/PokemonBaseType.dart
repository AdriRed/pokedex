import 'package:flutter/material.dart';
import 'package:pokedex/models/Model.dart';

class PokemonBaseType implements Model {
  int id;
  Map<String, String> names;
  
  PokemonBaseType.fromJSON(Map<String, dynamic> json) {
    id = json["id"];
    names = new Map<String, String>();
    for (var item in json["names"])
      names.putIfAbsent(item["language"]["name"], () => item["name"]);
  }

  static final List<Color> colors = <Color>[
    new Color(0xFFa8a878), // Normal,
    new Color(0xFFc03028), // Fighting,
    new Color(0xFFa890f0), // Flying,
    new Color(0xFFa040a0), // Poison,
    new Color(0xFFe0c068), // Ground,
    new Color(0xFFb8a038), // Rock,
    new Color(0xFFa8b820), // Bug,
    new Color(0xFF705898), // Ghost,
    new Color(0xFFb8b8d0), // Steel,
    new Color(0xFFf08030), // Fire,
    new Color(0xFF6890f0), // Water,
    new Color(0xFF78c850), // Grass,
    new Color(0xFFf8d030), // Electric,
    new Color(0xFFf85888), // Psychic,
    new Color(0xFF98d8d8), // Ice,
    new Color(0xFF7038f8), // Dragon,
    new Color(0xFF705848), // Dark,
    new Color(0xFFf0b6bc), // Fairy,
    new Color(0xFF6aa596), // Unknown,
    new Color(0xFF705898) // Shadow
  ];
}
