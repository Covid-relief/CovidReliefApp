import 'dart:convert';

class Trace {
  var userid;
  var contactTime;

  Trace({
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
  }

}