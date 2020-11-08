import 'package:cloud_firestore/cloud_firestore.dart';

class Request
{
  String state, category, name, description, email, contactMail, phone, contactMessage, code;
  Timestamp lastInteraction;

  Request(this.state, this.category, this.name, this.description, this.email, this.contactMail, this.phone, this.contactMessage, this.code, this.lastInteraction);

}