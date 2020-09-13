import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'Posts.dart';
import 'package:CovidRelief/screens/HelpCategory/PersonalizedHelp.dart';
import 'package:CovidRelief/screens/authenticate/authenticate.dart';
import 'package:CovidRelief/screens/home/home.dart';
import 'package:CovidRelief/screens/home/user_profile.dart';
import 'package:CovidRelief/services/auth.dart';

//import 'package:video_player/video_player.dart';

class ViewPosts extends StatefulWidget {
  String categoryOfHelp;
  ViewPosts({this.categoryOfHelp});

  @override
  _ViewPostsState createState() => _ViewPostsState(categoryOfHelp:categoryOfHelp);
}

class _ViewPostsState extends State<ViewPosts> {
  String categoryOfHelp;
  _ViewPostsState({this.categoryOfHelp});


  List<Posts> postsList = [];

  @override
  void initState()
  {
    super.initState();

    DatabaseReference postsRef = FirebaseDatabase.instance.reference().child(categoryOfHelp);

    postsRef.once().then((DataSnapshot snap)
    {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      postsList.clear();

      for(var individualKey in KEYS)
      {
        Posts posts = new Posts
          (
          DATA[individualKey]['Descripcion'],
          DATA[individualKey]['Fecha'],
          DATA[individualKey]['Hora'],
          DATA[individualKey]['Imagen'],
          DATA[individualKey]['Titulo'],
          DATA[individualKey]['Video'],
        );

        postsList.add(posts);
      }
      setState(()
      {
        print('Length : $postsList.length');
      });
    }
    );
  }

  showImage(img){
    if(img!=null){
      return new Image.network(img, fit: BoxFit.cover);
    }else{
      return SizedBox();
    }
  }

  showDescript(descript){
    if(descript!=null){
      return new Text(descript, style: TextStyle(fontStyle: FontStyle.normal), textAlign: TextAlign.left);
    }else{
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
      appBar: AppBar(
        title: Text('Ayuda General de ' + categoryOfHelp),
      ),
      body: new Container
        (
        child: postsList.length == 0 ? new Text("No hay ningún consejo general disponible por el momento"): new ListView.builder
          (
            itemCount: postsList.length,
            itemBuilder: (_, index)
            {
              return PostsUI
                (
                  postsList[index].Descripcion,
                  postsList[index].Fecha,
                  postsList[index].Hora,
                  postsList[index].Imagen,
                  postsList[index].Titulo,
                  postsList[index].Video
              );//PostsUi
            }
        ),
      ),
    );
  }

  Widget PostsUI(String Descripcion, String Fecha, String Hora, String Imagen, String Titulo, String Video)
  {
    return new Card
      (
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),

      child: new Container
        (
        padding: new EdgeInsets.all(14.0),

        child: new Column
          (
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>
          [
            new Row
              (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: <Widget>
              [
                new Text(
                  Fecha,
                  style: TextStyle(fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),


                new Text(
                  Hora,
                  style: TextStyle(fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                )
              ],
            ),

            SizedBox(height: 10.0,),

            new Text(
              Titulo,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10.0,),

            showImage(Imagen),

            SizedBox(height: 10.0,),

            showDescript(Descripcion),

          ],

        ),

      ),

    ); // Card

  } // Widget PostsUI

}
