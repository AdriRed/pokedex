import 'dart:async';
import 'dart:core';
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
  final int _limit = 16;
  bool loading = false;

  final _streamController = StreamController<List<Provider<PokemonSpecies>>>.broadcast();

  Function(List<Provider<PokemonSpecies>>) get speciesSink => _streamController.sink.add;
  Stream<List<Provider<PokemonSpecies>>> get speciesStream => _streamController.stream;

  List<Provider<PokemonSpecies>> _species = new List();

  void disposeStream() {
    _streamController?.close();
  }

  Future<List<Provider<PokemonSpecies>>> getMore() async {
    if (loading) return null;

    loading = true;
    _page++;

    final url = Uri.https("pokeapi.co", "api/v2/pokemon-species", 
      {
        "limit": _limit.toString(), 
        "offset" : _total.toString()
      });
      
    var json = await _procesarRespuesta(url);


    PokemonSpeciesList list = new PokemonSpeciesList.fromJSON(json, "results");
    
    _total += list.species.length;
    
    final resp = list.species;
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