class UserPermissions {
  bool geolocation;

  UserPermissions({this.geolocation});

  Map get toMap => {'geolocation': geolocation};

  static UserPermissions fromMap(Map map) =>
      UserPermissions(geolocation: map['geolocation'] ?? false);
}
