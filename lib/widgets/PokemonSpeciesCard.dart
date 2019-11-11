import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/User.dart';
import 'package:pokedex/models/PokemonBaseType.dart';
import 'package:pokedex/models/PokemonSpecies.dart';
import 'package:pokedex/pages/PokemonSpeciesDetails.dart';
import 'package:pokedex/providers/PokemonLoader.dart';
import 'package:pokedex/providers/Provider.dart';

class PokemonSpeciesCard extends StatefulWidget {
  final Provider<PokemonSpecies> speciesProv;

  final double width, height;
  final bool appearLoading;

  PokemonSpeciesCard(this.speciesProv,
      [this.width = 40, this.height = 40, this.appearLoading = false]);

  @override
  State<StatefulWidget> createState() {
    return _PokemonSpeciesCardState(speciesProv, width, height, appearLoading);
  }
}

class _PokemonSpeciesCardState extends State<PokemonSpeciesCard>
    with SingleTickerProviderStateMixin {
  final Provider<PokemonSpecies> species;
  final double width, height;
  final bool appearLoading;
  var _size;

  _PokemonSpeciesCardState(
      this.species, this.width, this.height, this.appearLoading);

  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    // )..addListener(() => setState(() {}));
    // _animation = CurvedAnimation(
    //   parent: _controller,
    //   curve: Curves.easeInExpo,
    // );
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> getVarieties(PokemonSpecies species) async {
    return species.defaultVariety.pokemon
        .getInfo()
        .then((variety) => PokemonLoader.futureAllTypes(variety));
  }

  Widget get _data {
    return Card(
        margin: EdgeInsets.all(5),
        color: Colors.white,
        child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, PokemonSpeciesDetail.route,
                  arguments: species.info);
            },
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(children: <Widget>[
                        _image,
                        Divider(
                          color: Colors.black,
                          indent: 3,
                          endIndent: 3,
                        ),
                        _name
                      ]),
                      _types
                    ]))));
  }

  Widget get _types {
    return FutureBuilder(
        future: PokemonLoader.futureAllTypes(
            species.info.defaultVariety.pokemon.info),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError) {
            log(species.info.defaultVariety.pokemon.info.types[0].type.info
                .names["es"]);
            return Row(
              children: species.info.defaultVariety.pokemon.info.types
                  .map((x) => Expanded(
                        child: Container(
                          color: PokemonBaseType.colors[x.type.info.id],
                        ),
                      ))
                  .toList(),
            );
            return Expanded(
              child: Container(
                color: Colors.black,
              ),
            );
          }
          return Container();
        });
  }

  Widget get _image {
    return Card(
        color: Colors.white70,
        child: Hero(
          tag: "${species.info.id} - card",
          child: new FutureBuilder<void>(
              future: getVarieties(species.info),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Center(
                      child: FadeInImage(
                    image: NetworkImage(species.info.defaultVariety.pokemon.info
                            .sprites["front_default"] ??
                        ""),
                    placeholder: AssetImage('assets/poke-ball.png'),
                    height: _size.height * 0.15625,
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
                    height: _size.height * 0.15625,
                    filterQuality: FilterQuality.none,
                  ));
                }
              }),
        ));
  }

  Widget get _name {
    return Text(
      species.info.names[User.language] ?? species.info.names[User.extraLang],
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.subtitle,
    );
  }

  Widget get _loadingPokeball {
    return Center(
        child: RotationTransition(
            turns: _animation,
            child: Container(
              height: _size.height * 0.125,
              width: _size.width * 0.125,
              child: Image(
                image: AssetImage("assets/pokeball-hd.png"),
                fit: BoxFit.scaleDown,
              ),
            )));
  }

  Widget get _loading {
    return Center(child: CircularProgressIndicator());
  }

  Widget get _futureBuilder {
    return FutureBuilder(
        future: species.getInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Icon(Icons.close));
          if (snapshot.connectionState == ConnectionState.waiting &&
              appearLoading) return _loading;
          if (snapshot.connectionState == ConnectionState.done)
            return FadeTransition(
                // If the widget is visible, animate to 0.0 (invisible).
                // If the widget is hidden, animate to 1.0 (fully visible).
                opacity: _controller.drive(CurveTween(curve: Curves.linear)),
                child: _data);
          return SizedBox.expand();
        });
  }

  Widget _card(BuildContext context) {
    final tarjeta = Container(
        height: height,
        width: width,
        child: species.hasInfo ? _data : _futureBuilder);
    return tarjeta;
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return _card(context);
  }

  // @override
  // State<StatefulWidget> createState() {
  //   // TODO: implement createState
  //   return null;
  // }
}
