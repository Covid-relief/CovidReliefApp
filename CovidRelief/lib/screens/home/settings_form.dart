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

  String _currentBirthday;//ya
  String _currentCountry;//ya
  String _currentCreation;
  String _currentgender; //dropbox
  String _currentName; //ya
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
            'Update your info',
            style : TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 20.0),
          TextFormField(

            decoration: textInputDecoration.copyWith(hintText: 'birthday'),
            validator: (valbirth) => valbirth.isEmpty ? 'Please enter your birthday' : null,
            onChanged: (valbirth) => setState(() => _currentBirthday = valbirth),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            decoration: textInputDecoration.copyWith(hintText: 'Name'),
            validator: (valname) => valname.isEmpty ? 'Please enter a name' : null,
            onChanged: (valname) => setState(() => _currentName = valname),
          ),

          SizedBox(height: 20.0),
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

          //info personal
          RaisedButton(
            color: Colors.blue[200],
            child: Text( 
              'Update',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async{
              print(_currentName);
              print(_currenType);
            }
          )

        ],

      )
      
    );
  }
}