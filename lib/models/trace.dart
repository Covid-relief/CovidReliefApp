import 'dart:convert';

class Trace {
  int id;
  String userid;
  var contactTime;

  Trace({
    this.id,
    this.userid,
    this.contactTime,
  });

  Map<String, dynamic> toMap() {
    return {
      "contact": userid,
      "time": contactTime,
    };
  }

  Trace.fromMap(Map<String, dynamic> map){
        userid = map['contact'];
        contactTime =map['time'];
        id=map['id'];
  }

  Map<String, dynamic> toJson() =>
      {
        'contact': userid,
        'time': contactTime,
      };

}