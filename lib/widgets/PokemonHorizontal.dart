import 'package:flutter/material.dart';
import 'package:pokedex/models/PokemonSpecies.dart';

class PokemonHorizontal extends StatelessWidget {

  final List<PokemonSpecies> species;
  final Function next;

  PokemonHorizontal({@required this.species, @required this.next});
  
  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3
  );

  

  @override
  Widget build(BuildContext context) {
    
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener( () {

      if ( _pageController.position.pixels >= _pageController.position.maxScrollExtent - 200 ){
        next();
      }

    });



    return Container(
      height: _screenSize.height * 0.3,
      color: Colors.blueGrey,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        // children: _tarjetas(context),
        itemCount: species.length,
        itemBuilder: ( context, i ) => _tarjeta(context, species[i] ),
      ),
    );


  }

  Widget _tarjeta(BuildContext context, PokemonSpecies species) {
    
    final tarjeta = Container(
      margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: "${ species.id } - card",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  image: NetworkImage(species.varieties[0].pokemon.info.sprites["front_default"]),
                  placeholder: AssetImage('assets/poke-ball.png'),
                  fit: BoxFit.fitHeight,
                  height: 100.0,
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
}