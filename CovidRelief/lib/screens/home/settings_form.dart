import 'package:CovidRelief/screens/home/user_profile.dart';
import 'package:CovidRelief/services/database.dart';
import 'package:flutter/material.dart';
import 'package:CovidRelief/shared/constants.dart';
import 'package:CovidRelief/models/user.dart';
import 'package:provider/provider.dart';
import 'package:CovidRelief/models/routes.dart';

class SettingsForm extends StatefulWidget {

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  

  final _formKey = GlobalKey<FormState>();
  final List<String> type = [ 'Busca ayuda' , 'Desea ayudar' ,'Ambos'];// esta es la lista de que va a poder elegir el usuario en forma de dropdown
  final List<String> gender = [ 'Masculino' , 'Femenino'];

  // valores
  String _currentName; // text done
  DateTime _currentBirthday; // calendar done
  String _currentCountry; // dropbox
  String _currentCreation; // not displaying in the app
  String _currentgender; // dropbox ya
  String _currentPhone; // text
  String _currentState; // not displaying in the app
  String _currenType; // dropbox ya
  
  @override
  Widget build(BuildContext context) {

    // this variable allows us to get the uid that contains the info of the user
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        UserData userData = snapshot.data;
        // if we want to load existing data we need an 'if sentence' in here        
        return Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              /*
              Text(
                'Ingresa tus datos',
                style : TextStyle(fontSize: 18.0),
              ),
              */

              // this sizebox helps us to keep distance between elements
              SizedBox(height: 20.0),

              // input text for name
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Nombres y apellidos'),
                validator: (valname) => valname.isEmpty ? 'Por favor ingrese su nombre' : null,
                onChanged: (valname) => setState(() => _currentName = valname),
              ),

              SizedBox(height: 20.0),
              // Date picker for birthday
              // Lacks validation when it's null and the display of the date in the button
              FlatButton(
                color: Colors.white,
                // padding is the spacing inside the element
                padding: EdgeInsets.fromLTRB(15, 15, 145, 15),
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
                    });
                  });
                },
              ),

              SizedBox(height: 20.0),

              // dropdown for country
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'País'),
                validator: (valcountry) => valcountry.isEmpty ? 'Por favor ingresa tu país' : null,
                onChanged: (valcountry) => setState(() => _currentCountry = valcountry),
              ),

              SizedBox(height: 20.0),

              // text for phone number
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'numero de teléfono'),
                validator: (valphone) => valphone.isEmpty ? 'Por favor ingresa tu número de teléfono' : null,
                onChanged: (valphone) => setState(() => _currentPhone = valphone),
              ),

              SizedBox(height: 20.0),

              // dropdown for gender
              // Lacks validation and display title
              DropdownButtonFormField(
                decoration: textInputDecoration,
                // value: _currenType ??  '0',
                items: gender.map((genders){
                  return DropdownMenuItem(
                    value: genders,
                    child: Text('$genders '),
                  );
                }).toList(),
                onChanged: (valgenders) => setState(() => _currentgender = valgenders),
              ),

              SizedBox(height: 20.0),

              // dropdown for type of profile
              // Lacks validation and display title
              DropdownButtonFormField(
                decoration: textInputDecoration,
                // value: _currenType ??  '0',
                items: type.map((types){
                  return DropdownMenuItem(
                    value: types,
                    child: Text('$types '),
                  );
                }).toList(),
                onChanged: (valtypes) => setState(() => _currenType = valtypes),
              ),

              SizedBox(height: 20.0),

              // Move this button to other file
              
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
                  print(_currenType);

                  // update the data in the DB
                  if(_formKey.currentState.validate()){
                    await DatabaseService(uid: user.uid).updateUserData(
                      // if there's no new data, remain with the same as before
                      _currentBirthday.toString() ?? userData.birthday, 
                      _currentName ?? userData.name, 
                      _currentCountry ?? userData.country,
                      _currenType ?? userData.type,
                      _currentPhone ?? userData.phone,
                      _currentState ?? 'activo',
                      _currentgender ?? userData.gender,
                      _currentCreation ?? 'hoy'
                    );
                    // redirect to profile page
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile()),);
                    // Navigator.pushNamed(context, '/userProfile');
                  }
                } // onPressed
              )
            ],
          )
        );
      }
    );
  }
}