import 'package:flutter/material.dart';
import 'package:CovidRelief/shared/constants.dart';

class SettingsForm extends StatefulWidget {


  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  

  final _formKey = GlobalKey<FormState>();
  final List<String> type = [ 'Busca ayuda' , 'Desea ayudar' ,'Ambos'];//esta es la lista de que va a poder elegir el usuario en forma de dropdown
  final List<String> genero = [ 'Masculino' , 'Femenino'];

  //valores
  String _currentName; //ya
  DateTime _currentBirthday;//ya
  String _currentCountry;//dropbox
  String _currentCreation;
  String _currentgender; //dropbox
  String _currentPhone;
  String _currentState;
  String _currenType; ///ya
  

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text(
            'Ingresa tus datos',
            style : TextStyle(fontSize: 18.0),
          ),

          // this sizebox helps us to keep distance between elements
          SizedBox(height: 20.0),

          // input text for name
          TextFormField(
            decoration: textInputDecoration.copyWith(hintText: 'Name'),
            validator: (valname) => valname.isEmpty ? 'Please enter a name' : null,
            onChanged: (valname) => setState(() => _currentName = valname),
          ),

          SizedBox(height: 20.0),
          // Date picker for birthday
          FlatButton(
            color: Colors.white,
            // padding is the spacing inside the element
            padding: EdgeInsets.fromLTRB(15, 15, 125, 15),
            child: Text(
              'Fecha de nacimiento',
              style: TextStyle(color: Colors.black45),
            ),
            onPressed: () {
              // shows calendar to pick a date
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1920, 1, 1),
                lastDate: DateTime.now()
              ).then((date){
                // change variable value (current date in DB) to selected
                setState((){
                  _currentBirthday = date;
                  print(_currentBirthday);
                });
              });
            },
          ),

          SizedBox(height: 20.0),

          // dropdown for country
          TextFormField(
            decoration: textInputDecoration.copyWith(hintText: 'country'),
            validator: (valcountry) => valcountry.isEmpty ? 'Please enter your country' : null,
            onChanged: (valcountry) => setState(() => _currentCountry = valcountry),
          ),

          SizedBox(height: 20.0),
          
          //dropdown
         /* DropdownButtonFormField(
            decoration: textInputDecoration,
            value: _currenType ??  '0',
            items: type.map((types){
              return DropdownMenuItem(
                value: types,
                child: Text('$types '),
              );
            }).toList(),
            onChanged: (valtypes) => setState(() => _currenType = valtypes),

          ),*/

          // Update the DB
          RaisedButton(
            color: Colors.blue[200],
            child: Text( 
              'Update',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async{
              print(_currentName);
              print(_currentBirthday);
              print(_currentCountry);
              //print(_currenType);
            }
          )

        ],
      )
    );
  }
}