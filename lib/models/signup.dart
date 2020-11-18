class Signup{
  String userUid;
  String userEmail;

  Signup({
    this.userUid,
    this.userEmail,
  });

  Map<String, dynamic> toJson() =>
      {
        'hashed_email': userUid,
        'email':userEmail,
      };
}