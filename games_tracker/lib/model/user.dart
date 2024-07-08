class User {
  int id;
  String name;
  String email;
  String password;

  User(this.id, this.name, this.email, this.password);

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      map['id'],
      map['name'],
      map['email'],
      map['password'],
    );
  }
}