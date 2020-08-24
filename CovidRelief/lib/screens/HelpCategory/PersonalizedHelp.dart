import 'package:flutter/material.dart';

class Help extends StatelessWidget{

    @override
    // State<StatefulWidget> createState() {
    Widget build(BuildContext context) {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('CovidRelief'),
            backgroundColor: Colors.red[400],
            elevation: 0.0,),
          body:
          ListView(
            padding: const EdgeInsets.all(15),
            children: <Widget>[
              Container(
                height: 90,
                child: const Center(child: Text('¿Cómo deseas ayudar?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              ),
              Container(
                height: 50,
              ),
              Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(50,0,50,0),
                child:
                RaisedButton(
                  padding: const EdgeInsets.all(2.0),
                  textColor: Colors.white,
                  color: Colors.orangeAccent[700],
                  onPressed:() async {
                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ),);
                  },
                  child: new Text("Puedo dar tips y consejos generales"),
                ),
              ),
              Container(
                height: 20,
              ),
              Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(50,0,50,0),
                child:
                RaisedButton(
                  padding: const EdgeInsets.all(2.0),
                  textColor: Colors.white,
                  color: Colors.orangeAccent[700],
                  onPressed:() {
                  },
                  child: new Text("Quiero dar apoyo personalizado y que me contacten"),
                ),
              ),
              Container(
                height: 90,
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(50,0,50,0),
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Para comunicarte con la facultad de medicina UFM, '
                          'llama al siguiente número', textAlign: TextAlign.center,),
                      RichText(text: TextSpan(
                          children: [
                            WidgetSpan(child: Icon(Icons.phone)),
                            TextSpan(
                              text: '  2413 3235',
                              style: TextStyle(color: Colors.black),
                            )
                          ]
                      ))
                    ],
                  ),
              ),
            ],
          )
      );
  }
}