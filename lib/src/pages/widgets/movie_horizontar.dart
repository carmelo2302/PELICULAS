import 'package:flutter/material.dart';
import 'package:peliculas/src/models/peliculas_model.dart';

class MovieHorizontar extends StatelessWidget {

  final List<Pelicula> peliculas ;
  final Function siguientePagina;

  MovieHorizontar({@required this.peliculas, @required this.siguientePagina });

  final _pageController= new PageController(
    initialPage: 1,
    viewportFraction: 0.333
  );
  @override
  Widget build(BuildContext context) {

    final _screenSize= MediaQuery.of(context).size;
    _pageController.addListener((){
      if( _pageController.position.pixels >= _pageController.position.maxScrollExtent - 200 ){
        siguientePagina();
        
      }
    });

    return Container(
      height: _screenSize.height * 0.35,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        //children: _targetas(context),
        itemCount: peliculas.length,
        itemBuilder: (context , i){
          return _targeta(context, peliculas[i]);

        },

      )
    );
  }

  Widget _targeta(BuildContext context , Pelicula pelicula){

    pelicula.unipueId= '${pelicula.id}-poster';
    final targeta= Container(
        margin: EdgeInsets.only(right: 5.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: pelicula.unipueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                  height: 190.0,
                  width: 190.0,
                ),
              ),
            ),
            SizedBox(),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );

      return GestureDetector(
        child: targeta,
        onTap: (){
          Navigator.pushNamed(context, 'detalle',arguments: pelicula);
        },
      );

  }
}