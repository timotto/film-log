import 'package:film_log/model/equals.dart';

class Thumbnail implements Equals<Thumbnail> {
  Thumbnail({required this.id});

  final String id;

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
      };

  @override
  bool equals(Thumbnail other) => id == other.id;
}
