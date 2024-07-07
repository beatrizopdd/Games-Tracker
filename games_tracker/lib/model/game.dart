class Game {
  int? id;//primary key
  int? user_id;
  late String name;
  late String release_date;
  late String description;
  //user_id referencia user(id)

  Game(this.name,this.user_id,this.release_date,this.description);

  Game.fromMap(Map map) {
    this.id = map["id"];
    this.user_id = map["user_id"];
    this.name = map["name"];
    this.release_date = map["release_date"];
    this.description = map["description"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name": this.name,
      "release_date": this.release_date,
      "description" : this.description
    };

    if (this.id != null) {
      map["id"] = this.id;
    }
    if (this.user_id != null) {
      map["user_id"] = this.user_id;
    }

    return map;
  }
}