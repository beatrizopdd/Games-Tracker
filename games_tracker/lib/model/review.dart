class Review {
  int? id;
  int? user_id;
  int? game_id;
  double? score;
  late String description;
  late String date;


  // FOREIGN KEY(user_id) REFERENCES user(id),
  // FOREIGN KEY(game_id) REFERENCES game(id)


  Review(this.game_id,this.user_id, this.score, this.description,this.date);

  Review.fromMap(Map map) {
    this.id = map["id"];
    this.game_id = map["game_id"];
    this.user_id = map["user_id"];
    this.score = map["score"];
    this.date = map["date"];
    this.description = map["description"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "description": this.description,
      "date": this.date,
      "score": this.score,
    };

    if (this.id != null) {
      map["id"] = this.id;
    }
    if (this.game_id != null) {
      map["game_id"] = this.game_id;
    }
    if (this.user_id != null) {
      map["user_id"] = this.user_id;
    }

    return map;
  }
}