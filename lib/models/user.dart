class User {

  final String uid;
  
  User({ this.uid });

}

class UserData {
  final String uid;
  final String name;
  final DateTime birthday;
  final String country;
  final String gender;
  final String phone;
  final String type;
  final String state;
  final String creation;

  UserData({ this.uid, this.name, this.birthday, this.country, this.gender, this.phone, this.type, this.state, this.creation});
}