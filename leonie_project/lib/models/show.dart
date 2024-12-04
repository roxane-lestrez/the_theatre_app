class Show {
  final String id;
  final String title;
  final String synopsis;
  final List<String> productions;

  Show({
    required this.id,
    required this.title,
    required this.synopsis,
    required this.productions,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'synopsis': synopsis,
      'productions': productions,
    };
  }

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      id: json['id'],
      title: json['title'],
      synopsis: json['synopsis'],
      productions: List<String>.from(json['productions']),
    );
  }
}
