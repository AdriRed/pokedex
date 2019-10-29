import 'package:flutter/material.dart';
import 'package:pokedex/providers/PokemonSpeciesListProvider.dart';
import 'package:pokedex/widgets/PokemonHorizontal.dart';

class PokedexHomePage extends StatelessWidget {
  
  static const String route = "home";
  final PokemonSpeciesListProvider _provider = new PokemonSpeciesListProvider();

  // Widget get _button {
  //   return new Container(
  //     child: new FloatingActionButton(
  //       child: Icon(Icons.add)
  //     )
  //   );
  // }

  Widget _footer(BuildContext context){

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Populares', style: Theme.of(context).textTheme.subhead  )
          ),
          SizedBox(height: 5.0),
  
          StreamBuilder(
            stream: _provider.speciesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              
              if ( snapshot.hasData ) {
                return PokemonHorizontal( 
                  species: snapshot.data,
                  next: _provider.getMore,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),

        ],
      ),
    );


  }
  
  
  @override
  Widget build(BuildContext context) {
    _provider.getMore();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Pokédex"),
        backgroundColor: Colors.teal
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _footer(context)
          ],
        )
      )
    );
  }

}
