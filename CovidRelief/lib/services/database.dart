import 'package:CovidRelief/models/profile.dart';
import 'package:CovidRelief/models/user.dart';
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

  //lista del perfil del snapshot

  List<Perfiles> _profileListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Perfiles(
        name: doc.data['name'] ?? '',
        birthday: doc.data['birthday'] ?? '',
        country: doc.data['country'] ?? '',
        gender: doc.data['gender'] ?? '',
        phone: doc.data['phone'] ?? '',
        state: doc.data['state'] ?? '',
        type: doc.data['type'] ?? '',
        // creation: doc.data[' creation'] ?? '',

      );
    }).toList();
  }

  // Para hacer update de la info del perfil en la BD
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      birthday: snapshot.data['birthday'] ?? '',
      country: snapshot.data['country'] ?? '',
      gender: snapshot.data['gender'] ?? '',
      phone: snapshot.data['phone'] ?? '',
      state: snapshot.data['state'] ?? '',
      type: snapshot.data['type'] ?? '',
    );
  }

  //stream

  Stream<List<Perfiles>> get perfiles {
    return  userscollection.snapshots()
    .map(_profileListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return userscollection.document(uid).snapshots()
      .map(_userDataFromSnapshot);
  }

}