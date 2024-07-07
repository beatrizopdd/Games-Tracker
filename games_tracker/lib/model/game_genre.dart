class Game_Genre {
  int? genre_id;
  int? game_id;
  //genre_id referencia game(id)
  //game_id referencia genre(id)


  
  Game_Genre(this.genre_id,this.game_id);

  Game_Genre.fromMap(Map map) {
    this.genre_id = map["genre_id"];
    this.game_id = map["game_id"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "game_id": this.game_id,
      "genre_id": this.genre_id,
    };


    if (this.genre_id != null) {
      map["genre_id"] = this.genre_id;
    }
    if (this.game_id != null) {
      map["game_id"] = this.game_id;
    }

    return map;
  }
}