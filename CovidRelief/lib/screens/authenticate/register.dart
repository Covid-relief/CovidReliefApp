import 'package:flutter/material.dart';
import 'package:CovidRelief/services/auth.dart';


class Register extends StatefulWidget {

  final Function toggleView;

  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {


  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password= '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[200],
      appBar: AppBar(backgroundColor: Colors.red,
      elevation: 0.0,
      title: Text("Register "),
      actions: <Widget>[
        FlatButton.icon(
          icon: Icon(Icons.person),
          label: Text("Sign in"),
          onPressed: (){
            widget.toggleView();
            
          }
        )
      ],
      ),
      body:Container(
        padding: EdgeInsets.symmetric(vertical:20.0,horizontal: 50.0),
      child: Form(
        key: _formKey,


        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            TextFormField(
              validator: (val) => val.isEmpty ? 'Ingrese un correo valido' : null,
              onChanged: (val){
                setState(() => email=val);

              }
            ), 
            SizedBox(height: 20.0),
            TextFormField(
              validator: (val) => val.length < 6 ? 'Ingrese una contrasena de mas de 6 caracteres' : null,
              obscureText: true,
              onChanged: (val){
              setState(() => password=val);


              }
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              color: Colors.blue[300],
              child: Text(
                'Register',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async{
                if(_formKey.currentState.validate()){
                  dynamic result = await _auth.registerEmailandPassword(email, password);

                  if(result == null){
                    setState(() => error ='Ingrese un correo valido');
                  }
                }


              }
            ),
            SizedBox(height: 12.0),
            Text(
              error,
              style: TextStyle(color:Colors.red[900], fontSize: 14.0),
            )


            
            
          ],
        )
      ),
    ),

    );
  }
}