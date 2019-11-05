import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex/models/PokemonSpecies.dart';
import 'package:pokedex/pages/PokedexHomePage.dart';
import 'package:pokedex/pages/PokemonSpeciesDetails.dart';

import 'src/pages/home_page.dart';
import 'src/pages/pelicula_detalle.dart';

void main() => runApp(Pokedex());

class Pokedex extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokédex',
      // initialRoute: '/',
      // routes: {
      //   '/'       : ( BuildContext context ) => PokedexHomePage(),
      //   'detalle' : ( BuildContext context ) => PeliculaDetalle(),
      // },
      home: PokedexHomePage(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case PokedexHomePage.route:
            return MaterialPageRoute(
              builder: (context) {
                return PokedexHomePage();
              },
            );
          case PokemonSpeciesDetail.route:
            return MaterialPageRoute(
              builder: (context) {
                return PokemonSpeciesDetail(
                    settings.arguments as PokemonSpecies);
              },
            );
            break;
        }
        throw Exception("ERROR NAVIGATOR");
      },
    );
  }
}
