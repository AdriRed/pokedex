import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/models/PokemonBaseType.dart';
import 'package:pokedex/models/PokemonSpecies.dart';

import '../models/pokemon.dart';

String _formattedPokeIndex(int index) {
  return "#${((index) / 100).toStringAsFixed(2).replaceAll(".", "")}";
}

String capitalizeFirstChar(String text) {
  if (text == null || text.length <= 1) {
    return text.toUpperCase();
  }

  return text[0].toUpperCase() + text.substring(1);
}

class PokemonCard extends StatelessWidget {
  const PokemonCard(
    this.pokemon, {
    @required this.index,
    Key key,
    this.onPress,
  }) : super(key: key);

  final PokemonSpecies pokemon;
  final int index;
  final Function onPress;

  // List<Widget> _buildTypes() {
  //   final widgetTypes = pokemon.defaultVariety.pokemon.info.types
  //       .map(
  //         (type) => Hero(
  //           tag: pokemon.name + type,
  //           child: PokemonType(capitalizeFirstChar(type)),
  //         ),
  //       )
  //       .expand((item) => [item, SizedBox(height: 6)]);

  //   return widgetTypes.take(widgetTypes.length - 1).toList();
  // }

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
            filterQuality: FilterQuality.none,
            imageBuilder: (context, imageProvider) => Image(
              image: imageProvider,
              fit: BoxFit.contain,
              width: itemHeight * 0.6,
              height: itemHeight * 0.6,
              alignment: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      Positioned(
        top: 10,
        right: 14,
        child: Text(
          _formattedPokeIndex(this.index),
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
    return LayoutBuilder(
      builder: (context, constrains) {
        final itemHeight = constrains.maxHeight;

        return Container(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: PokemonBaseType.colors[pokemon.defaultVariety.pokemon.info.types.first.type.info.id-1].withOpacity(0.12),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Material(
              color: PokemonBaseType.colors[pokemon.defaultVariety.pokemon.info.types.first.type.info.id-1],
              child: InkWell(
                onTap: onPress,
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
  }
}