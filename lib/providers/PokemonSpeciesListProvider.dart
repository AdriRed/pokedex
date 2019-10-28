import 'dart:async';
import 'dart:core';
import 'dart:developer';
import 'dart:io';
import 'dart:convert';

import 'package:pokedex/models/PokemonSpecies.dart';
import 'package:pokedex/models/PokemonSpeciesList.dart';

class PokemonSpeciesListProvider {
  String next;
  int _page = 0;
  int _total = 0;
  final int _limit = 15;
  bool loading = false;

  final _streamController = StreamController<List<PokemonSpecies>>.broadcast();

  Function(List<PokemonSpecies>) get speciesSink => _streamController.sink.add;
  Stream<List<PokemonSpecies>> get speciesStream => _streamController.stream;

  List<PokemonSpecies> _species = new List();

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
    
    final resp = await list.getPokemonSpecies();
    _species.addAll(resp);
    speciesSink(_species);

    loading = false;

    return resp;
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
    //log(converted);
    final decodedData = json.decode(converted);
    return decodedData;
  }

}