class User {
  final String displayName;
  final String photoUrl;
  final String email;
  final String id;

  User({this.displayName, this.photoUrl, this.email, this.id});

  static User fromMap(Map map) {
    return User(
      displayName: map['displayName'],
      email: map['email'],
      id: map['id'],
      photoUrl: map['photoUrl'],
    );
  }

  Map<String, String> get toMap => {
        'displayName': displayName,
        'email': email,
        'photoUrl': photoUrl,
        'id': id,
      };
}
