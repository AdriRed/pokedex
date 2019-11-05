
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/models/PokemonSpecies.dart';
import 'package:pokedex/pages/PokemonSpeciesDetails.dart';
import 'package:pokedex/providers/Provider.dart';

class PokemonSpeciesCard extends StatefulWidget {
  
  final Provider<PokemonSpecies> speciesProv;

  final double width, height;

  PokemonSpeciesCard(this.speciesProv, [this.width = 40, this.height = 40]);
  
  @override
  State<StatefulWidget> createState() {
    return _PokemonSpeciesCardState(speciesProv, width, height);
  }

}

class _PokemonSpeciesCardState extends State<PokemonSpeciesCard> with TickerProviderStateMixin  {
  final Provider<PokemonSpecies> species;
  final double width, height;

  _PokemonSpeciesCardState(this.species, this.width, this.height);

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
                Card(
                  color: Colors.white70,
                  child: GestureDetector(
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
                                  image: NetworkImage(species.info.varieties[0].pokemon.info.sprites["front_default"]),
                                  placeholder: AssetImage('assets/poke-ball.png'),
                                  height: 100.0,
                                  fadeOutDuration: Duration(milliseconds: 300),
                                )
                                // child: CachedNetworkImage(
                                //   imageUrl: species.info.varieties[0].pokemon.info.sprites["front_default"],
                                //   placeholder: (context, url) => Image.asset('assets/poke-ball.png'),
                                //   fit: BoxFit.scaleDown,
                                //   height: 100.0,
                                //   fadeOutDuration: Duration(milliseconds: 300),
                                //   filterQuality: FilterQuality.none,
                                // )
                              );
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
                ),
                SizedBox(height: 5.0),
                Text(
                  species.info.names["es"],
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle,
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

  Widget get _futureBuilder {
    return FutureBuilder (
        future: species.getInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError)
              return Center(child: Icon(Icons.close));
            else
              return _data;
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return _loading;
          } else {
            ;
          }
        }
    );
  }

  Widget _tarjeta(BuildContext context) {
    final tarjeta = Container(
      height: height,
      width: width,
      child: Card(
        margin: EdgeInsets.all(5),
        color: Colors.white,
        child: species.hasInfo ? _data : _futureBuilder
        )
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