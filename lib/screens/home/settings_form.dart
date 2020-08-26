import 'package:CovidRelief/screens/home/user_profile.dart';
import 'package:CovidRelief/services/database.dart';
import 'package:flutter/material.dart';
import 'package:CovidRelief/shared/constants.dart';
import 'package:CovidRelief/models/user.dart';
import 'package:provider/provider.dart';
import 'package:CovidRelief/screens/authenticate/authenticate.dart';
import 'package:CovidRelief/screens/home/home.dart';

import 'package:google_sign_in/google_sign_in.dart';


class UserDataForm extends StatefulWidget {

  @override
  _UserDataFormState createState() => _UserDataFormState();
}

class _UserDataFormState extends State<UserDataForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> type = [ 'Busca ayuda' , 'Desea ayudar' ,'Busca y desea ayuda'];// esta es la lista de que va a poder elegir el usuario en forma de dropdown
  final List<String> gender = [ 'Masculino' , 'Femenino'];
  final List<String> country = ['Afganistán','Albania','Alemania','Andorra','Angola','Antigua y Barbuda','Arabia Saudita','Argelia','Argentina','Armenia','Australia','Austria','Azerbaiyán','Bahamas','Bangladés','Barbados','Baréin','Bélgica','Belice','Benín','Bielorrusia','Birmania','Bolivia','Bosnia y Herzegovina','Botsuana','Brasil','Brunéi','Bulgaria','Burkina Faso','Burundi','Bután','Cabo Verde','Camboya','Camerún','Canadá','Catar','Chad','Chile','China','Chipre','Ciudad del Vaticano','Colombia','Comoras','Corea del Norte','Corea del Sur','Costa de Marfil','Costa Rica','Croacia','Cuba','Dinamarca','Dominica','Ecuador','Egipto','El Salvador','Emiratos Árabes Unidos','Eritrea','Eslovaquia','Eslovenia','España','Estados Unidos','Estonia','Etiopía','Filipinas','Finlandia','Fiyi','Francia','Gabón','Gambia','Georgia','Ghana','Granada','Grecia','Guatemala','Guyana','Guinea','Guinea ecuatorial','Guinea-Bisáu','Haití','Honduras','Hungría','India','Indonesia','Irak','Irán','Irlanda','Islandia','Islas Marshall','Islas Salomón','Israel','Italia','Jamaica','Japón','Jordania','Kazajistán','Kenia','Kirguistán','Kiribati','Kuwait','Laos','Lesoto','Letonia','Líbano','Liberia','Libia','Liechtenstein','Lituania','Luxemburgo','Macedonia del Norte','Madagascar','Malasia','Malaui','Maldivas','Malí','Malta','Marruecos','Mauricio','Mauritania','México','Micronesia','Moldavia','Mónaco','Mongolia','Montenegro','Mozambique','Namibia','Nauru','Nepal','Nicaragua','Níger','Nigeria','Noruega','Nueva Zelanda','Omán','Países Bajos','Pakistán','Palaos','Panamá','Papúa Nueva Guinea','Paraguay','Perú','Polonia','Portugal','Reino Unido','República Centroafricana','República Checa','República del Congo','República Democrática del Congo','República Dominicana','Ruanda','Rumanía','Rusia','Samoa','San Cristóbal y Nieves','San Marino','San Vicente y las Granadinas','Santa Lucía','Santo Tomé y Príncipe','Senegal','Serbia','Seychelles','Sierra Leona','Singapur','Siria','Somalia','Sri Lanka','Suazilandia','Sudáfrica','Sudán','Sudán del Sur','Suecia','Suiza','Surinam','Tailandia','Tanzania','Tayikistán','Timor Oriental','Togo','Tonga','Trinidad y Tobago','Túnez','Turkmenistán','Turquía','Tuvalu','Ucrania','Uganda','Uruguay','Uzbekistán','Vanuatu','Venezuela','Vietnam','Yemen','Yibuti','Zambia','Zimbabu'];

  // valores
  String _currentName; // text done
  DateTime _currentBirthday; // calendar done
  String _currentCountry; // dropbox
  String _currentCreation; // not displaying in the app
  String _currentgender; // dropbox ya
  String _currentPhone; // text
  String _currentState; // not displaying in the app
  String _currenType; // dropbox ya
  
  // display birthday date when selected (if not, display 'Fecha de nacimiento' text)
  String selectedDate () {
    String message;
    if (_currentBirthday == null){
      message = 'Fecha de nacimiento';
    }else{
      String bday = _currentBirthday.toString();
      message = bday.substring(8, 10)+'-'+bday.substring(5, 7)+'-'+bday.substring(0, 4);
    }
      return message;
  }
  // display different colors of selection in birthday picker
  Color styleDate () {
    Color color;
    if (selectedDate() == 'Fecha de nacimiento') {
      color=Colors.black45.withOpacity(0.6);
    }else{
      color=Colors.black.withOpacity(1.0);
    }
    return color;
  }
  // padding changes when date selected
  EdgeInsets paddingdate(){
    EdgeInsets pad;
    if (selectedDate() == 'Fecha de nacimiento') {
      pad=EdgeInsets.fromLTRB(13, 15, 155, 15);
    }else{
      pad=EdgeInsets.fromLTRB(15, 15, 215, 15);
    }
    return pad;
  }

  @override
  Widget build(BuildContext context) {

    // this variable allows us to get the uid that contains the info of the user
    final user = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        title: Text('Registrarse',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              fontFamily: 'Open Sans',
              fontSize: 25),),
        backgroundColor: Colors.cyan[700],
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Inicio',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: 'Open Sans',
              ),
            ),
            onPressed: ()  {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()),);
            },
          ),
        ],
      ),
      body: StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;
          // if we want to load existing data we need an 'if sentence' in here        
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // this sizebox helps us to keep distance between elements
                  SizedBox(height: 30.0),
                  // input text for name
                  Container(
                    width: 350.0,
                    padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                    child: TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Nombres y apellidos'),
                      validator: (valname) => valname.isEmpty ? 'Por favor ingrese su nombre' : null,
                      onChanged: (valname) => setState(() => _currentName = valname),
                    ),
                  ),

                  SizedBox(height: 20.0),

                  // Date picker for birthday
                  Container(
                  margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                  child: FlatButton(
                    color: Colors.white,
                    // padding is the spacing inside the element
                    padding: paddingdate(),
                    child: Text(
                    '${selectedDate()}',
                      style: TextStyle(
                        color: styleDate(),
                        fontWeight: FontWeight.w400,
                        fontSize: 15
                      ),
                    ),
                    onPressed: () {
                      // shows calendar to pick a date
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now().subtract(Duration(days: 6570)),
                        firstDate: DateTime(1920, 1, 1),
                        lastDate: DateTime.now().subtract(Duration(days: 6570)),
                      ).then((date){
                        // change variable value (current date in DB) to selected
                        setState((){
                          _currentBirthday = date;
                        });
                      });
                    },
                  ),),

                  SizedBox(height: 20.0),

                  // dropdown for country
                  Container(
                    padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                    width: 350.0,
                    child: DropdownButtonFormField(
                      hint: Text('País'),
                      decoration: textInputDecoration,
                      validator: (valcountry) => valcountry.isEmpty ? 'Por favor ingresa tu país' : null,
                      items: country.map((countries){
                        return DropdownMenuItem(
                          value: countries,
                          child: Text('$countries '),
                        );
                      }).toList(),
                      onChanged: (valcountry) => setState(() => _currentCountry = valcountry),
                    ),
                  ),

                  SizedBox(height: 20.0),

                  // text for phone number
                  Container(
                    padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                    width: 350.0,
                    child: TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Numero de teléfono'),
                      validator: (valphone) => valphone.isEmpty ? 'Por favor ingresa tu número de teléfono' : null,
                      onChanged: (valphone) => setState(() => _currentPhone = valphone),
                    ),
                  ),
                  
                  SizedBox(height: 20.0),

                  // dropdown for gender
                  Container(
                    padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                    width: 350.0,
                    child: DropdownButtonFormField(
                      hint: Text('Género'),
                      decoration: textInputDecoration,
                      validator: (valgenders) => valgenders.isEmpty ? 'Por favor ingresa tu género' : null,
                      items: gender.map((genders){
                        return DropdownMenuItem(
                          value: genders,
                          child: Text('$genders '),
                        );
                      }).toList(),
                      onChanged: (valgenders) => setState(() => _currentgender = valgenders),
                    ),
                  ),
                  
                  SizedBox(height: 20.0),

                  // dropdown for type of profile
                  Container(
                    padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                    width: 350.0,
                    child: DropdownButtonFormField(
                      hint: Text('Tipo de perfil'),
                      decoration: textInputDecoration,
                      validator: (valtypes) => valtypes.isEmpty ? 'Por favor ingresa el tipo de perfil' : null,
                      items: type.map((types){
                        return DropdownMenuItem(
                          value: types,
                          child: Text('$types '),
                        );
                      }).toList(),
                      onChanged: (valtypes) => setState(() => _currenType = valtypes),
                    ),
                  ),
                  
                  SizedBox(height: 20.0),
                  
                  // Update the DB
                  RaisedButton(
                    color: Colors.blue[200],
                    child: Text( 
                      'Enviar',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async{
                      // update the data in the DB
                      if(_formKey.currentState.validate()){
                        await DatabaseService(uid: user.uid).updateUserData(
                          // if there's no new data, remain with the same as before
                          _currentBirthday.toString() ?? userData.birthday, 
                          _currentCountry ?? userData.country,
                          _currentCreation ?? 'hoy',
                          _currentgender ?? userData.gender,
                          _currentName ?? userData.name, 
                          _currentPhone ?? userData.phone,
                          _currentState ?? 'activo',
                          _currenType ?? userData.type,
                        );
                        // redirect to profile page
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()),);
                      }
                    } // onPressed
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}