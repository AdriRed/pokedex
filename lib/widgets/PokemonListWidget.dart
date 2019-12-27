import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokedex/models/PokemonSpecies.dart';
import 'package:pokedex/providers/PokeIndex.dart';
import 'package:pokedex/providers/Provider.dart';

import 'PokemonSpeciesCard.dart';

class PokemonListWidget extends StatelessWidget {
  final double cardWidth = 40, cardHeight = 66;
  
  List<Provider<PokemonSpecies>> species;
  Function next;

  PokemonListWidget(this.species,this.next);
  PokemonListWidget.all(PokeIndex index) {
    species = index.entries.map((x) {return x.species;}).toList();
  }

  final _pageController =
      new PageController(viewportFraction: 0.4, keepPage: true);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    if (next != null)
      _pageController.addListener(() {
        if (_pageController.position.pixels >=
            _pageController.position.maxScrollExtent - 200) {
          next();
        }
      });

    log(_screenSize.width.toString() + " " + _screenSize.height.toString());
    return Column(children: [Expanded(child: GridView.count(
      controller: _pageController,
      crossAxisCount: 2,
      childAspectRatio: (_screenSize.width/ (_screenSize.width*0.75)),
      padding: EdgeInsets.all(10),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      // shrinkWrap: true,
      children: List.generate(species.length, (index) => new PokemonSpeciesCard(species[index]))))]
    );;
  }
}


