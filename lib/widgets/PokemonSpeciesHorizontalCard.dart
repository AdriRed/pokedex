
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/models/PokemonSpecies.dart';
import 'package:pokedex/pages/PokemonSpeciesDetails.dart';
import 'package:pokedex/providers/Provider.dart';

class PokemonSpeciesHorizontalCard extends StatefulWidget {
  
  final Provider<PokemonSpecies> speciesProv;

  PokemonSpeciesHorizontalCard(this.speciesProv);
  
  @override
  State<StatefulWidget> createState() {
    
    return _PokemonSpeciesHorizontalCardState(speciesProv);
  }

}

class _PokemonSpeciesHorizontalCardState extends State<PokemonSpeciesHorizontalCard> with TickerProviderStateMixin  {
  final Provider<PokemonSpecies> species;

  _PokemonSpeciesHorizontalCardState(this.species);
  AnimationController _controller;
  Animation<double> _animation;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..addListener(() => setState(() {}));
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInExpo,
    );
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  Future<void> getVarieties(PokemonSpecies species) async {
    List<Future<void>> futures = [];
    for (var variety in species.varieties) {
      futures.add(variety.pokemon.getInfo());
    }
    return Future.wait(futures);
  }

  Widget get _data {
    return Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    log("DETAILS OF " + species.info.names["es"]);
                    Navigator.pushNamed(context, PokemonSpeciesDetail.route, arguments: species.info);
                  } ,
                  child:Hero(
                    tag: "${species.info.id} - card",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: new FutureBuilder<void>(
                        future: getVarieties(species.info),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return Center(
                              child: FadeInImage(
                                image: NetworkImage(
                                    species.info.varieties[0].pokemon.info.sprites["front_default"]),
                              placeholder: AssetImage('assets/poke-ball.png'),
                              fit: BoxFit.scaleDown,
                              height: 100.0,
                            ));
                          } else {
                            return Center(
                              child: Image(
                              image: AssetImage("assets/poke-ball.png"),
                              fit: BoxFit.scaleDown,
                              height: 100.0,
                              filterQuality: FilterQuality.none,
                            ));
                          }
                          
                        }
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 5.0),
                Text(
                  species.info.names["es"],
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                )
              ]);
  }

  Widget get _loadingPokeball {
    return Center(
    child: RotationTransition(
      turns: _animation,
      child: Container(
          height: 80,
          width: 80,
          child: Image(
            image: AssetImage("assets/pokeball-hd.png"),
            fit: BoxFit.scaleDown,
          ),
        )
      )
    );
  }

  Widget get _loading {
    return Center(child: CircularProgressIndicator());
  }

  Widget _tarjeta(BuildContext context) {
    final tarjeta = Card(
      margin: EdgeInsets.all(5),
      color: Colors.grey,
      child: FutureBuilder (
        future: species.getInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _data;
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return _loading;
          } else {
            return Center(child: Icon(Icons.close));
          }
        }
        
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