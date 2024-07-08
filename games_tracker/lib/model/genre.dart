  class Genre {
  int id;
  String name;

  Genre(this.id, this.name);

  factory Genre.fromMap(Map<String, dynamic> map) {
    return Genre(
      map['id'],
      map['name'],
    );
  }
}