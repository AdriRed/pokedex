import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:convert';

import 'package:pokedex/models/PokemonSpecies.dart';
import 'package:pokedex/models/PokemonSpeciesList.dart';
import 'package:pokedex/providers/Provider.dart';

class PokemonSpeciesListProvider {
  String next;
  int _page = 0;
  int _total = 0;
  final int _limit = 20;
  bool loading = false;

  final _streamController = StreamController<PokemonSpeciesList>.broadcast();

  Function(PokemonSpeciesList) get popularesSink => _streamController.sink.add;
  Stream<PokemonSpeciesList> get popularesStream => _streamController.stream;

  void disposeStream() {
    _streamController?.close();
  }

  Future<List<PokemonSpecies>> getMore() async {
    if (loading) return null;

    loading = true;
    _page++;

    final url = Uri.https("pokeapi.co", "api/v2/pokemon-species", 
      {
        "limit": _limit.toString(), 
        "offset" : _total.toString()
      });
      
    var json = await _procesarRespuesta(url);


    PokemonSpeciesList list = new PokemonSpeciesList.fromJSON(json);
    
    _total += list.species.length;

    List<PokemonSpecies> species = new List();

    //return await list.getPokemonSpecies();
    for (var item in list.species) {
      species.add(new PokemonSpecies.fromJSON(await _procesarRespuesta(getUrl(item.url))));
    }
    
    return species;
  }

  Uri getUrl(String strurl) {
    String route = strurl.split("pokeapi.co/")[1];

    return new Uri.https("pokeapi.co", route);
  }

  Future<Map<String, dynamic>> _procesarRespuesta(Uri url) async {
    
    HttpClient http = new HttpClient();
    final resp = await http.getUrl(url);
    final respbody = await resp.close();
    final converted = await respbody.transform(utf8.decoder).join();
    log(converted);
    final decodedData = json.decode(converted);
    return decodedData;
  }

}