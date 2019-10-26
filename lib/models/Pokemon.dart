import 'package:pokedex/providers/Provider.dart';

import 'PokemonAbility.dart';
import 'PokemonSpecies.dart';
import 'PokemonStat.dart';
import 'PokemonType.dart';

class Pokemon {
  int id;
  Provider<PokemonSpecies> specie;
  Map<String, Provider<PokemonStat>> stats;
  Map<String, String> sprites;
  Map<int, Provider<PokemonType>> types;
  List<Provider<PokemonAbility>> abilities;
}