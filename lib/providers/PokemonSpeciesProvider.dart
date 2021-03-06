import 'dart:async';
import 'dart:core';
import 'dart:developer';
import 'dart:io';
import 'dart:convert';

import 'package:pokedex/models/PokemonSpecies.dart';
import 'package:pokedex/models/PokemonSpeciesList.dart';
import 'package:pokedex/providers/Provider.dart';
import 'package:pokedex/search/PokeSearch.dart';

import 'PokeIndex.dart';

class PokemonSpeciesProvider {
  String next;
  int _page = 0;
  int _total = 0;
  int _count;
  final int _limit = 16;
  bool loading = false;
  PokeIndex index;
  final List<Provider<PokemonSpecies>> species = new List();
  
  final _streamController =
      StreamController<List<Provider<PokemonSpecies>>>.broadcast();

  Function(List<Provider<PokemonSpecies>>) get speciesSink {
    log("Sinking things");
    return _streamController.sink.add;
  }
  Stream<List<Provider<PokemonSpecies>>> get speciesStream {
    log("Streaming things");
    return _streamController.stream;
  }

  void disposeStream() {
    _streamController?.close();
  }

  Future<List<Provider<PokemonSpecies>>> getMore() async {
    if (loading) return await getMore();
    if (index == null) await initIndex();
    loading = true;
    // int offset = this._page * this._limit;
    // final url = Uri.https("pokeapi.co", "api/v2/pokemon-species",
    //     {"limit": this._limit.toString(), "offset": offset.toString()});
    
    // _page++;
    // var json = await _procesarRespuesta(url);

    // if (_count == null) _count = json["count"];

    // PokemonSpeciesList list = new PokemonSpeciesList.fromJSON(json);

    // _total += list.species.length;

    // final resp = list.species;
    // _species.addAll(resp);
    var list = index.fetch(_limit);
    species.addAll(list);
    speciesSink(species);
    loading = false;
    return list;
    // return resp;
  }

  Uri getUrl(String strurl) {
    String route = strurl.split("pokeapi.co/")[1];

    return new Uri.https("pokeapi.co", route);
  }

  Future<Map<String, dynamic>> _procesarRespuesta(Uri url) async {
    HttpClient http = new HttpClient();
    final resp = await http.getUrl(url);
    final respbody = await resp.close();
    log(respbody.statusCode.toString() + " -- " + url.toString());
    final converted = await respbody.transform(utf8.decoder).join();
    //log(converted);
    final decodedData = json.decode(converted);
    return decodedData;
  }

  List<PokeEntry> _findByName(String name) {
    return index.entries.where((entry) => entry.name.contains(name)).toList();
  }

  Future<dynamic> find(String query) async {
    if (index == null) initIndex().then((x) => find(query));
    log("QUERY: " + query);
    query = query.trim().toLowerCase();
    int n = int.tryParse(query);
    return n == null ? _findByName(query) : _findById(n);
  }

  PokeEntry _findById(int id) {
    return index.entries.singleWhere((x) => x.id == id, orElse: () => null);
  }

  Future<PokeIndex> initIndex() async {
    var json = await _procesarRespuesta(Uri.tryParse("https://pokeapi.co/api/v2/pokemon-species?limit=-1"));
    index = PokeIndex.fromJSON(json);
    return index;
  }
}
