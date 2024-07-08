  class Genre {
  int game_id ;
  String genre_id;

  Genre(this.game_id, this.genre_id);

  factory Genre.fromMap(Map<String, dynamic> map) {
    return Genre(
      map['game_id'],
      map['genre_id'],
    );
  }
}