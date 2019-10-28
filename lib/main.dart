import 'package:flutter/material.dart';
import 'package:pokedex/pages/PokedexHomePage.dart';

import 'src/pages/home_page.dart';
import 'src/pages/pelicula_detalle.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Películas',
      initialRoute: '/',
      routes: {
        '/'       : ( BuildContext context ) => PokedexHomePage(),
        'detalle' : ( BuildContext context ) => PeliculaDetalle(),
      },
    );
  }
}