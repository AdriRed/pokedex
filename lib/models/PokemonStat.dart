import 'package:pokedex/models/Model.dart';

class PokemonStat extends Model {
  int id;
  int value;
  Map<String, String> names;

  PokemonStat.fromJSON(Map<String, dynamic> json) : super.fromJSON(json) {

  }
}
