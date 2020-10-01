import 'package:CovidRelief/screens/home/home.dart';
import 'package:CovidRelief/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HelpForm extends StatefulWidget {
  String categoryOfHelp;
  HelpForm({this.categoryOfHelp});
  
  @override
  HelpFormState createState() {
    return HelpFormState(categoryOfHelp:categoryOfHelp);
  }
}

class HelpFormState extends State<HelpForm>{
  String categoryOfHelp;
  HelpFormState({this.categoryOfHelp});

  String _formName;
  String _formEmail;
  String _formPhone;
  String _formDescription;
  bool _contactMail=false;
  bool _contactMessage=false;

  final databaseReference = Firestore.instance;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitud de apoyo personalizado'),
        backgroundColor: Colors.lightBlue[900],
      ),
      body: SingleChildScrollView(
        child: _buildForm()
      )
    );
  }

// _buildForm()
  // APP LAYER?
  Widget _buildForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(height: 30.0,),
        _buildDisclaimer(),
        SizedBox(height: 30.0,),
        _buildNameField(),
        SizedBox(height: 25.0,),
        _buildEmailField(),
        SizedBox(height: 25.0,),
        _buildPhoneField(),
        SizedBox(height: 25.0,),
        _buildProblemField(),
        SizedBox(height: 25.0,),
        _buildContactMail(),
        _buildContactMessage(),
        SizedBox(height: 15.0,),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Text('Te recordamos que esta es una plataforma facilitada por la Universidad '
        'Francisco Marroquín pero de ninguna manera es responsable de los consejos e ideas aquí presentadas '
        'y el éxito o fracaso de los mismos.',
        textAlign: TextAlign.center
        ),
    );
  }

  Widget _buildNameField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,0,20,0),
      child: TextFormField(
        decoration: InputDecoration(labelText: 'Nombre completo'),
        validator: (valname) => valname.isEmpty ? 'Por favor ingrese su nombre' : null,
        onChanged: (valname) => setState(() => _formName = valname),
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,0,20,0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Correo electrónico',
        ),
        validator: (val) => val.isEmpty ? 'Ingrese un correo electrónico válido' : null,
        onChanged: (valemail) => setState(() => _formEmail = valemail),
      ),
    );
  }


  Widget _buildPhoneField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,0,20,0),
      child: TextFormField(
        decoration: InputDecoration(labelText: 'Número de teléfono'),
        validator: (valphone) => valphone.isEmpty ? 'Por favor ingrese su número de teléfono' : null,
        onChanged: (valphone) => setState(() => _formPhone = valphone),
      ),
    );
  }

  Widget _buildProblemField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,0,20,0),
      child: TextFormField(
        decoration: InputDecoration(labelText: 'Describe brevemente tu problema'),
        validator: (valdescription) => valdescription.isEmpty ? 'Por favor ingrese su número de teléfono' : null,
        onChanged: (valdescription) => setState(() => _formDescription = valdescription),
      ),
    );
  }

  Widget _buildContactMail() {
      return CheckboxListTile(
        title: Text("Contactarme por correo"),
        value: _contactMail,
        onChanged: (mailCont) => setState(() => _contactMail = mailCont),
        controlAffinity: ListTileControlAffinity.leading,
      );
  }
  Widget _buildContactMessage() {
      return CheckboxListTile(
        title: Text("Contactarme por mensaje"),
        value: _contactMessage,
        onChanged: (messageCont) => setState(() => _contactMessage = messageCont),
        controlAffinity: ListTileControlAffinity.leading,
      );
  }

  Widget _buildSubmitButton() {
    return Container(
      height: 70,
      padding: EdgeInsets.fromLTRB(70,0,70,0),
      child:
        RaisedButton(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          color: Colors.teal,
          shape: StadiumBorder(),
          onPressed: () {
            print(_formName);
            print(_formKey);
            print(_formDescription);
            print(_formEmail);
            print(_formPhone);
            _submitForm();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()),);},
          child: Text('Enviar Solicitud',style: TextStyle(color: Colors.white, fontSize: 20),),
        ),
    );
  }

  void _submitForm() async {
    DocumentReference ref = await databaseReference.collection("solicitarayuda_" + categoryOfHelp)
        .add({
          'email': _formEmail,
          'description': _formDescription,
          'name': _formName,
          'phone': _formPhone
        });
    print(ref.documentID);
  }
}