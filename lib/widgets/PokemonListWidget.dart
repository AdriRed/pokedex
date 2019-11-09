import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokedex/models/PokemonSpecies.dart';
import 'package:pokedex/providers/Provider.dart';

import 'PokemonSpeciesCard.dart';

class PokemonListWidget extends StatelessWidget {
  final double cardWidth = 40, cardHeight = 66;

  final List<Provider<PokemonSpecies>> species;
  final Function next;

  PokemonListWidget(this.species,this.next);

  final _pageController =
      new PageController(viewportFraction: 0.4, keepPage: true);

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
      height: _screenSize.height * 0.875,
      color: Colors.blueGrey,
      child: GridView.count(

        controller: _pageController,
        crossAxisCount: 4,
        childAspectRatio: (cardWidth / cardHeight),
        //shrinkWrap: true,
        // children: _tarjetas(context),
        children: List.generate(species.length, (index) => new PokemonSpeciesCard(species[index], cardWidth, cardHeight))
      ),
    );
  }
}


