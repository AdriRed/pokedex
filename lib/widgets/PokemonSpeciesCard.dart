import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/models/PokemonBaseType.dart';
import 'package:pokedex/models/PokemonSpecies.dart';
import 'package:pokedex/pages/PokemonSpeciesDetails.dart';
import 'package:pokedex/providers/PokemonLoader.dart';
import 'package:pokedex/providers/Provider.dart';

import '../models/pokemon.dart';

String _formattedPokeIndex(int index) {
  return "#${(index / 100).toStringAsFixed(2).replaceAll(".", "")}";
}

String capitalizeFirstChar(String text) {
  if (text == null || text.length <= 1) {
    return text.toUpperCase();
  }

  return text[0].toUpperCase() + text.substring(1);
}

// class PokemonSpeciesCard extends StatefulWidget {

//   PokemonSpeciesCard(Provider<PokemonSpecies> species) : super(key: new Key(species.url.toString()))
//   {
//     this.species = species;
//   }

//   Provider<PokemonSpecies> species;

//   @override
//   State<StatefulWidget> createState() {
//     return new _PokemonSpeciesCard(species);
//   }

// }

class PokemonSpeciesCard extends StatelessWidget  {

  PokemonSpeciesCard(Provider<PokemonSpecies> species)
  {
    this.species = species;
  }

  // AnimationController _controller;

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = AnimationController(
  //     duration: const Duration(seconds: 1),
  //     vsync: this,
  //   );
  // }

  Provider<PokemonSpecies> species;

  int get index {
    return pokemon.id;
  }

  PokemonSpecies get pokemon {
    return species.info;
  }

  Widget _buildCardContent() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: "pk" + pokemon.id.toString(),
              child: Material(
                color: Colors.transparent,
                child: Text(
                  pokemon.names["es"],
                  style: TextStyle(
                    fontSize: 14,
                    height: 0.7,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            // ..._buildTypes(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDecorations(double itemHeight) {
    return [
      Positioned(
        bottom: itemHeight * 0.136,
        right: itemHeight * 0.034,
        child: Image.asset(
          "assets/black_pokeball.png",
          width: itemHeight * 0.754,
          height: itemHeight * 0.754,
          color: Colors.white.withOpacity(0.14),
        ),
      ),
      Positioned(
        bottom: itemHeight * 0.136,
        right: itemHeight * 0.034,
        child: Hero(
          tag: pokemon.defaultVariety.pokemon.info.sprites["front_default"],
          child: CachedNetworkImage(
            imageUrl: pokemon.defaultVariety.pokemon.info.sprites["front_default"],
            // placeholder: (context, str) => Image.asset("assets/poke-ball.png", filterQuality: FilterQuality.none,),
            filterQuality: FilterQuality.none,
            imageBuilder: (context, imageProvider) => Image(
              image: imageProvider,
              fit: BoxFit.contain,
              // width: itemHeight * 0.6,
              // height: itemHeight * 0.6,
              // alignment: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      Positioned(
        top: 10,
        right: 14,
        child: Text(
          _formattedPokeIndex(index),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.12),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final tarjeta = Container(
        child: species.hasInfo ? _data(context) : _futureBuilder);
    return tarjeta;
  }

  Widget get _futureBuilder {
    return FutureBuilder(
        future: species.getInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Icon(Icons.close, color: Colors.white,));
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if (snapshot.connectionState == ConnectionState.done)
            return _data(context);
            // return FadeTransition(
            //     // If the widget is visible, animate to 0.0 (invisible).
            //     // If the widget is hidden, animate to 1.0 (fully visible).
            //     opacity: _controller.drive(CurveTween(curve: Curves.linear)),
            //     child: _data(context));
          return SizedBox.expand();
        });
  }


  Widget _loadedData(BuildContext context, Color c) {
    var data = LayoutBuilder(
      builder: (ctx, constrains) {
        final itemHeight = constrains.maxHeight;

        return Container(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                // color: PokemonBaseType.colors[pokemon.defaultVariety.pokemon.info.types.first.type.info.id-1].withOpacity(0.12),
                color: c.withOpacity(0.12),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Material(
              color: c,
              child: InkWell(
                // onTap: onPress,
                splashColor: Colors.white10,
                highlightColor: Colors.white10,
                child: Stack(
                  children: [
                    _buildCardContent(),
                    ..._buildDecorations(itemHeight),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return GestureDetector(
      onTap: () {
              Navigator.pushNamed(context, PokemonSpeciesDetail.route,
                  arguments: species.info);
            },
      child: data,
    );
  }

  Widget _data(BuildContext context) {
    return FutureBuilder(
      future: pokemon.defaultVariety.pokemon.getInfo(),
      builder: (ctx1, snapshot) {
        if (!snapshot.hasData && snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator(),);
        }
        return FutureBuilder(
          future: pokemon.defaultVariety.pokemon.info.types[0].type.getInfo(),
          builder: (ctx2, snapshot) {
            Color c = new Color(0x989898);
            // List<TweenSequenceItem<Color>> color = new List() ..add(new TweenSequenceItem());
            if (snapshot.connectionState == ConnectionState.done) {
              c = PokemonBaseType.colors[pokemon.defaultVariety.pokemon.info.types.first.type.info.id-1];
            }
            return _loadedData(ctx2, c);
          }
        );
      },
    );
  }
}