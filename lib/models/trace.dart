
class Trace {
  int id;
  String userid;
  var contactTime;

  Trace({
    this.id,
    this.userid,
    this.contactTime,
  });

  //Add to db
  Map<String, dynamic> toMap() {
    return {
      "contact": userid,
      "time": contactTime,
    };
  }
  //Retrieve from db
  factory Trace.fromMap(Map<String, dynamic> json) => new Trace(
    userid: json["contact"],
    contactTime: json["time"],
  );

}