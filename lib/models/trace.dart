import 'dart:convert';

class Trace {
  var id;
  var userid;
  var contactTime;

  Trace({
    this.id,
    this.userid,
    this.contactTime,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "contact": userid,
      "time": contactTime,
    };
  }

  Trace.fromMap(Map<String, dynamic> map){
        userid = map['contact'];
        contactTime =map['time'];
  }

}