import 'package:pokedex/models/Model.dart';

class PokemonAbility extends Model {
  int id;
  Map<String, String> names;

  PokemonAbility.fromJSON(Map<String, dynamic> json) : super.fromJSON(json) {

  }
}
