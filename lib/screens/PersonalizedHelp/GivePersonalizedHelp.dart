import 'package:CovidRelief/screens/home/home.dart';
import 'package:CovidRelief/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:CovidRelief/screens/PersonalizedHelp/HelpRequests.dart';
import 'package:CovidRelief/services/auth.dart';
import 'package:CovidRelief/models/user.dart';

class GivePersonalizedHelp extends StatefulWidget {
  String categoryOfHelp;
  GivePersonalizedHelp({this.categoryOfHelp});
  
  @override
  _GivePersonalizedHelpState createState() {
    return _GivePersonalizedHelpState(categoryOfHelp:categoryOfHelp);
  }
}

class _GivePersonalizedHelpState extends State<GivePersonalizedHelp>{
  String categoryOfHelp;
  _GivePersonalizedHelpState({this.categoryOfHelp});

  String _formName;
  String _formEmail;
  String _formPhone;
  bool _contactMail=false;
  bool _contactMessage=false;
  String codeHelper;

  final databaseReference = Firestore.instance;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // this variable allows us to get the uid that contains the info of the user
    final user = Provider.of<User>(context);
    String uid = user.uid;

    //var myref = databaseReference.collection("darayuda").where("category", isEqualTo: categoryOfHelp).getDocuments();
    var myref = databaseReference.collection("darayuda").where("category", isEqualTo: categoryOfHelp).snapshots();
    
    Future hasApplied() async {
      var val = await myref.elementAt(0).then((QuerySnapshot querySnapshot) => {querySnapshot.documents.length});
      if(val.toString()!='{0}'){
        Navigator.push(context, MaterialPageRoute(builder: (context) => HelpRequests(categoryOfHelp:categoryOfHelp)),);
      }
    }
    hasApplied();

    return Scaffold(
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
        title: Text('Apoyar en ' + categoryOfHelp),
        //backgroundColor: Colors.lightBlue[900],
      ),
      body: SingleChildScrollView(
        child: _buildForm(uid),
      )
    );
  }

  // APP LAYER?
  Widget _buildForm(String uid) {
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
        _buildContactMail(),
        _buildContactMessage(),
        SizedBox(height: 15.0,),
        _buildSubmitButton(uid),
      ],
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Text('Te recordamos que esta es una plataforma facilitada por la Universidad '
        'Francisco Marroquín pero de ninguna manera es responsable de las solicitudes e ideas aquí presentadas '
        'y el éxito o fracaso de las mismas.',
        textAlign: TextAlign.center
      )
    );
  }

  Widget _buildNameField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,0,20,0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Nombre completo',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0x1F000000), width: 0.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFEBEE), width: 1.5),
            borderRadius: BorderRadius.circular(5.0),
          ),
          fillColor: Color(0xFFF5F5F5),
          filled: true
        ),
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
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0x1F000000), width: 0.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFEBEE), width: 1.5),
            borderRadius: BorderRadius.circular(5.0),
          ),
          fillColor: Color(0xFFF5F5F5),
          filled: true
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
        decoration: InputDecoration(
          labelText: 'Número de teléfono',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0x1F000000), width: 0.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFEBEE), width: 1.5),
            borderRadius: BorderRadius.circular(5.0),
          ),
          fillColor: Color(0xFFF5F5F5),
          filled: true
        ),
        validator: (valphone) => valphone.isEmpty ? 'Por favor ingrese su número de teléfono' : null,
        onChanged: (valphone) => setState(() => _formPhone = valphone),
      ),
    );
  }

// Alguno de estos debe ser true para continuar!
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

  Widget _buildSubmitButton(String uid) {

    return Container(
      height: 70,
      padding: EdgeInsets.fromLTRB(70,0,70,0),
      child:
        RaisedButton(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          color: Colors.blueAccent,
          shape: StadiumBorder(),
          onPressed: () {
            _submitForm(uid);
          Navigator.push(context, MaterialPageRoute(builder: (context) => HelpRequests(categoryOfHelp: categoryOfHelp)),);},
          child: Text('Empezar a apoyar', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20),),
        ),
    );

  }

  void _submitForm(String uid) async {
    DocumentReference ref = await databaseReference.collection("darayuda")
      .add({
        'category': categoryOfHelp,
        'name': _formName,
        'email': _formEmail,
        'contactMail':_contactMail,
        'phone': _formPhone,
        'contactMessage':_contactMessage,
        'uid': uid
      });
      // quitar codeHelper?
      setState(() {
        codeHelper=ref.documentID;
      });
    print(ref.documentID);
  }
}