
import 'package:CovidRelief/models/trace.dart';

class Contact {
  String user;
  String key;
  var day;
  List <Trace> traces;

  Contact({
    this.user,
    this.key,
    this.day,
    this.traces
  });


  Map<String, dynamic> toJson() =>
      {
        'user': user,
        'key':key,
        'day':day,
        'contacts':traces
      };
}