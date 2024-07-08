  class Game {
  int id;
  int user_id;
  String name;
  String description;
  String release_date;

  Game(this.id,this.user_id, this.name, this.description, this.release_date);

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      map['id'],
      map['user_id'],
      map['name'],
      map['description'],
      map['release_date']
    );
  }
}