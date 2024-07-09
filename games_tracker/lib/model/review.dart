class Review {
  int id;
  int user_id;
  int game_id;
  double score;
  String description;
  String date;


  // FOREIGN KEY(user_id) REFERENCES user(id),
  // FOREIGN KEY(game_id) REFERENCES game(id)


  Review(this.id,this.game_id,this.user_id, this.score, this.description,this.date);

    factory Review.fromMap(Map<String, dynamic> map) {    
      return Review(
      map["id"],
      map["game_id"],
      map["user_id"],
      map["score"],
      map["date"],
      map["description"],
      );
  }
}





