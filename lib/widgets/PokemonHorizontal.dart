import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokedex/models/PokemonSpecies.dart';
import 'package:pokedex/pages/PokemonSpeciesDetails.dart';
import 'package:pokedex/providers/Provider.dart';

import 'PokemonSpeciesHorizontalCard.dart';

class PokemonHorizontal extends StatelessWidget {
  final List<Provider<PokemonSpecies>> species;
  final Function next;

  PokemonHorizontal(this.species,this.next);

  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3, keepPage: true);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        next();
      }
    });

    return Container(
      height: _screenSize.height * 0.21,
      color: Colors.blueGrey,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        
        // children: _tarjetas(context),
        itemCount: species.length,
        itemBuilder: (context, i) => new PokemonSpeciesHorizontalCard(species[i]),
      ),
    );
  }
}


