class User {
  int? id;
  late String name;
  late String email;
  late String password;

  User(this.name, this.email,this.password);

  User.fromMap(Map map) {
    this.id = map["id"];
    this.email = map["email"];
    this.password = map["password"];
    this.name = map["name"];
    
   }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name": this.name,
      "password": this.password,
      "email": this.email
    };

    if (this.id != null) {
      map["id"] = this.id;
    }

    return map;
  }
}