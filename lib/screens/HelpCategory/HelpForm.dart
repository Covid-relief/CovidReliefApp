
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpForm extends StatefulWidget {
  @override
  HelpFormState createState() {
    return HelpFormState();
  }
}

class HelpFormState extends State<HelpForm>{
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitud de apoyo personalizado'),
      ),
      body: _buildForm(),
    );
  }

  // APP LAYER?
  Widget _buildForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildDisclaimer(),
        _buildNameField(),
        _buildEmailField(),
        _buildPhoneField(),
        _buildProblemField(),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildDisclaimer() {
    return Text('Te recordamos que esta es una plataforma facilitada por la Universidad '
        'Francisco Marroquín pero de ninguna manera es responsable de los consejos e ideas aquí presentadas '
        'y el éxito o fracaso de los mismos.',
      textAlign: TextAlign.center,
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Nombre completo'),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Correo electrónico',

      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Número de teléfono'),
    );
  }

  Widget _buildProblemField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Describe brevemente tu problema'),
    );
  }


  Widget _buildSubmitButton() {
    return RaisedButton(
      onPressed: () {},
      child: Text('Enviar Solicitud'),
    );
  }
}