import 'package:flutter/material.dart';
import 'package:pokedex/models/PokemonSpecies.dart';
import 'package:pokedex/providers/PokemonSpeciesListProvider.dart';

class PokedexHomePage extends StatelessWidget {
  
  PokemonSpeciesListProvider _provider = new PokemonSpeciesListProvider();
  List<PokemonSpecies> species = new List();
  Widget get _button {
    return new Container(
      child: new FloatingActionButton(
        onPressed: addPokemonSpecies,
        child: Icon(Icons.add)
      )
    );
  }

  Future addPokemonSpecies() async {
    species.addAll(await _provider.getMore());
  }
  
  @override
  Widget build(BuildContext context) {
    
    return _button;
  }

}