import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'Posts.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:isolate';
import 'dart:ui';
import 'package:linkable/linkable.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:simple_url_preview/simple_url_preview.dart';

//import 'package:video_player/video_player.dart';

class ViewPosts extends StatefulWidget {
  String categoryOfHelp;
  ViewPosts({this.categoryOfHelp});

  @override
  _ViewPostsState createState() =>
      _ViewPostsState(categoryOfHelp: categoryOfHelp);
}

class _ViewPostsState extends State<ViewPosts> {
  String categoryOfHelp;
  _ViewPostsState({this.categoryOfHelp});

  List<Posts> postsList = [];

  @override
  void initState() {
    super.initState();

    DatabaseReference postsRef =  FirebaseDatabase.instance.reference().child(categoryOfHelp);

    postsRef
        .orderByChild('Estado')
        .equalTo("approved")
        .once()
        .then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      postsList.clear();

      for (var individualKey in KEYS) {
        Posts posts = new Posts(
          DATA[individualKey]['Descripcion'],
          DATA[individualKey]['Fecha'],
          DATA[individualKey]['Hora'],
          DATA[individualKey]['Imagen'],
          DATA[individualKey]['Titulo'],
          DATA[individualKey]['Video'],
          DATA[individualKey]['Archivo'],
          DATA[individualKey]['Dia'],
          DATA[individualKey]['Link'],
        );

        postsList.add(posts);
      }
      setState(() {
        print('Length : $postsList.length');
      });
    });
  }

  showImage(img) {
    if (img != null) {
      return new Image.network(img, fit: BoxFit.cover);
    } else {
      return SizedBox();
    }
  }

  showDescript(descript) {
    if (descript != null) {
      return new Text(descript,
          style: TextStyle(fontStyle: FontStyle.normal),
          textAlign: TextAlign.left);
    } else {
      return SizedBox();
    }
  }

  showLink(link) {
    if (link != null) {
      return new SimpleUrlPreview(
        url: link,
        textColor: Colors.white,
        bgColor: Colors.red,
        isClosable: false,
        previewHeight: 150,
      );
    } else {
      return SizedBox();
    }
  }

  showFile(archive) {
    if (archive != null) {
      return new OutlineButton(
        child: new Text(
          "Descargar archivo",
          style: TextStyle(color: Colors.blue),
        ),
        onPressed: () async {
          final status = await Permission.storage.request();
          if (status.isGranted) {
            final externalDir = await getExternalStorageDirectory();
            FlutterDownloader.enqueue(
                url: archive,
                savedDir: externalDir.path,
                fileName: "Archivo de " + categoryOfHelp,
                showNotification: true,
                openFileFromNotification: true);
          } else {
            print('Permission denied');
          }
        },
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        borderSide: BorderSide(color: Colors.blue),
      );
    } else {
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [
                const Color(0xFFFF5252),
                const Color(0xFFFF1744)
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.5, 0.0),
              stops: [0.0, 0.5],
              tileMode: TileMode.clamp
            ),
          ),
        ),
        title: Text('Ayuda general de ' + categoryOfHelp),
      ),
      body: new Container(
        child: postsList.length == 0
            ? Padding(padding: EdgeInsets.symmetric(vertical: 100.0, horizontal:100), child: Text("No hay publicaciones", style: TextStyle(fontSize: 20.0, color: Colors.grey)),)
            : new ListView.builder(
                itemCount: postsList.length,
                itemBuilder: (_, index) {
                  return PostsUI(
                      postsList[index].Descripcion,
                      postsList[index].Fecha,
                      postsList[index].Hora,
                      postsList[index].Imagen,
                      postsList[index].Titulo,
                      postsList[index].Video,
                      postsList[index].Archivo,
                      postsList[index].Dia,
                      postsList[index].Link);//PostsUi
                }),
      ),
    );
  }

  Widget PostsUI(String Descripcion, String Fecha, String Hora, String Imagen,
      String Titulo, String Video, String Archivo, String Dia, String Link) {
    return new Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //elevation: 10.0,
      margin: EdgeInsets.all(15.0),
      child: new Container(
        padding: new EdgeInsets.all(14.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  Fecha,
                  style: TextStyle(fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                new Text(
                  Dia + ", " + Hora,
                  style: TextStyle(fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                )
              ],
            ),
            SizedBox(
              height: 14.0,
            ),
            new Text(
              Titulo,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17.0,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            showDescript(Descripcion),
            SizedBox(
              height: 15.0,
            ),
            showImage(Imagen),
            SizedBox(
              height: 15.0,
            ),
            showLink(Link),
            SizedBox(
              height: 10.0,
            ),
            showFile(Archivo),
          ],
        ),
      ),
    );
  } // Widget PostsUI
}
