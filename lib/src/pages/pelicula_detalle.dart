import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/peliculas_model.dart';

import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula= ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppBar(pelicula),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10.0,),
                _posterTitulo(context ,pelicula ),
                _descriccionPelicula(pelicula),
                _descriccionPelicula(pelicula),
                _descriccionPelicula(pelicula),
                _descriccionPelicula(pelicula),
                _crearCasting(pelicula),
              ]
            ),
          ),
        ],
      )
      
    );
  }
  Widget _posterTitulo(BuildContext context ,Pelicula pelicula ){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 15.0),
      child: Row(
        children: <Widget>[

          Hero(
            tag: pelicula.unipueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(pelicula.getPosterImg()),
                height: 200.0,
              ),
            ),
          ),
          SizedBox(width: 15.0,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(pelicula.title,style: Theme.of(context).textTheme.title, overflow: TextOverflow.ellipsis,),
                Text(pelicula.title,style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.ellipsis,),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(pelicula.voteAverage.toString(),style: Theme.of(context).textTheme.subhead)
                  ],
                )
              ],
            ),
          ),
        ],),
    );
  }

  Widget _crearAppBar(Pelicula pelicula){

    return SliverAppBar(
      elevation: 20.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: true,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(color:Colors.white , fontSize: 16.0),
        ),background: FadeInImage(
          image: NetworkImage(pelicula.getBackgroumImg()),
          placeholder: AssetImage('assets/img/no-image.jpg'),
          fadeOutDuration: Duration(seconds: 1),
          fit: BoxFit.cover, 
          ),
      ),

    );

  }

  Widget _descriccionPelicula(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify
      ),
    );
  }
  Widget _crearCasting(Pelicula pelicula){
    final peliProvider=new PeliculasProvider();

    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if(snapshot.hasData){
          return _crearActoresPageView(snapshot.data);
        }else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.33,
          initialPage: 1
        ),
        itemCount: actores.length,
        itemBuilder: (context ,i){
          return _actorTargeta(actores[i]);
        }),
    );

  }
  Widget _actorTargeta(Actor actor){
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/img/no-image.jpg'), 
              image: NetworkImage(actor.getFoto()),
              height: 150.0,
              fit: BoxFit.cover,
            ),
              
          ),
          Text(actor.name)
        ],
      ),
    );
  }
}