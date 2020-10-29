import 'dart:async';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/actores_model.dart';

import 'package:peliculas/src/models/peliculas_model.dart';

class PeliculasProvider{

  String _apikey   ='7bcb04591d67fca19c92d1a299609acc';
  String _url      ='api.themoviedb.org';
  String _language ='es-ES';

  int _popularesPage=0;
  List<Pelicula> _populares = new List();

  bool _cargendo=false;

  final _popularesSteamController= StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>_popularesSteamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesSteamController.stream;

  void disposeStream(){
    _popularesSteamController?.close();
  }


  Future<List<Pelicula>> _prosesarPeliculas(Uri url) async{

    final resp = await http.get( url );
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);


    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCine() async{
    final url =Uri.https(_url, '3/movie/now_playing',{
      'api_key': _apikey,
      'language' :_language
    });

   return await _prosesarPeliculas(url);
  }

  Future<List<Pelicula>> getPopulares() async{

    if (_cargendo) return [];
    

    _cargendo=true;

    _popularesPage++;
    final url =Uri.https(_url, '3/movie/popular',{
      'api_key'    : _apikey,
      'language'   :_language,
      'page'       :_popularesPage.toString()
    });

    final resp= await _prosesarPeliculas(url);
    _populares.addAll(resp);
    popularesSink( _populares );
    _cargendo=false;
    return resp;
  }

  Future<List<Actor>> getCast(String peliId) async{
    final url=Uri.https(_url, '3/movie/$peliId/credits',{
      'api_key'    : _apikey,
      'language'   :_language,
    });
    final resp=await http.get(url);
    final decodedData=json.decode(resp.body);
    final cast=new Cast.fromJsonList(decodedData['cast']);
    return cast.actores;
  }
   Future<List<Pelicula>> buscarPelicula(String query) async{
    final url =Uri.https(_url, '3/search/movie',{
      'api_key': _apikey,
      'language' :_language,
      'query': query
    });

   return await _prosesarPeliculas(url);
  }

}
