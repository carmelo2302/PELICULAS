import 'package:flutter/material.dart';
import 'package:peliculas/src/pages/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/pages/widgets/movie_horizontar.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';


class HomePage extends StatelessWidget {

  final peliculasprovider =new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    peliculasprovider.getPopulares();
    return Scaffold(
      appBar: AppBar(
        title: Text("Peliculas De Cine "),
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search), 
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(),
              );
            })
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _swiperTargetas(),
                _footer(context),
              ], 
            )
          ],
        ),
      ),
    );
  }

  Widget _swiperTargetas() {


    return FutureBuilder(
      future: peliculasprovider.getEnCine(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(peliculas: snapshot.data);
          
        } else {
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator(),
            )
           );
        }
      },
    );
    
 }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 2.0),
            child: Text("Populares",style: Theme.of(context).textTheme.subhead,)),
          SizedBox(height: 10.0,),
          StreamBuilder(
            stream: peliculasprovider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if(snapshot.hasData){
                return MovieHorizontar(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasprovider.getPopulares,);

              }else{
                return Center(
                  child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}