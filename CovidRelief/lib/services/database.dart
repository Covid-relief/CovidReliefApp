import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  //coleccion de referencias 

  final CollectionReference userscollection = Firestore.instance.collection('perfiles');

  Future updateUserData(String birthday,String country, String creation, String gender, String name, String phone, String state, String type) async {

    return await userscollection.document(uid).setData({
      'birthday' : birthday,
      'country' : country,
      'creation' : creation,
      'gender' : gender,
      'name' : name,
      'phone' : phone,
      'state' : state,
      'type' : type,
    


    });

  }
}