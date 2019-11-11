import 'package:pokedex/models/Pokemon.dart';
import 'package:pokedex/models/PokemonSpecies.dart';

class PokemonLoader {
  static Future<void> futureAllTypes(Pokemon variety) async {
    // for (var variety in species.varieties) {
    List<Future<dynamic>> futures = [];
    for (var type in variety.types) {
      futures.add(type.type.getInfo());
    }
    // }
    return Future.wait(futures);
  }

  static Future<void> futureAllAbilities(Pokemon variety) async {
    List<Future<dynamic>> futures = [];
    for (var abilitiyProv in variety.abilities) {
      futures.add(abilitiyProv.ability.getInfo());
    }
    return Future.wait(futures);
  }

  static Future<void> futureEvolution(PokemonSpecies species) async {
    return species.evolutionChain
        .getInfo()
        .then((x) => Future.wait(x.chain.getAllInfo()));
  }

  static Future<void> futureStats(Pokemon variety) async {
    List<Future<dynamic>> futures = [];
    for (var statProv in variety.stats) {
      futures.add(statProv.stat.getInfo());
    }
    return Future.wait(futures);
  }
}