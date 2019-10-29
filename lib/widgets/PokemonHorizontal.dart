import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokedex/models/PokemonSpecies.dart';
import 'package:pokedex/pages/PokemonSpeciesDetails.dart';

class PokemonHorizontal extends StatelessWidget {
  final List<PokemonSpecies> species;
  final Function next;

  PokemonHorizontal({@required this.species, @required this.next});

  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3);

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

class PokemonSpeciesHorizontalCard
    extends StatelessWidget {
  PokemonSpecies species;

  PokemonSpeciesHorizontalCard(this.species);

  Future getVarieties() async {
    for (var variety in species.varieties) {
      await variety.pokemon.getInfo();
    }
  }

  void getDetails(PokemonSpecies species) {
    log("DETAILS OF " + species.names["es"]);
  }

  Widget _tarjeta(BuildContext context) {
    final tarjeta = Card(
      margin: EdgeInsets.all(5),
      color: Colors.grey,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              getDetails(species);
              Navigator.pushNamed(context, PokemonSpeciesDetail.route, arguments: species);
            } ,
            child:Hero(
              tag: "${species.id} - card",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: new FutureBuilder<void>(
                  future: getVarieties(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return FadeInImage(
                        image: NetworkImage(
                            species.varieties[0].pokemon.info.sprites["front_default"]),
                        placeholder: AssetImage('assets/poke-ball.png'),
                        fit: BoxFit.fitHeight,
                        height: 100.0,
                      );
                    } else {
                      return Image(
                        image: AssetImage('assets/poke-ball.png'),
                        fit: BoxFit.fitHeight,
                        height: 100.0,
                      );
                    }
                    
                  }
                ),
              ),
            ),
          ),
          
          SizedBox(height: 5.0),
          Text(
            species.names["es"],
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );
    return tarjeta;
  }

  @override
  Widget build(BuildContext context) {
    return _tarjeta(context);
  }

  // @override
  // State<StatefulWidget> createState() {
  //   // TODO: implement createState
  //   return null;
  // }
}
