import 'package:equatable/equatable.dart';

class Participant extends Equatable {
  final String idName;
  final int score;

  const Participant({required this.idName, required this.score});

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(idName: json['username'], score: json['pontos'] ?? 0);
  }

  Participant copyWith({String? idName, int? score}) {
    return Participant(
      idName: idName ?? this.idName,
      score: score ?? this.score,
    );
  }

  @override
  List<Object?> get props => [idName, score];
}
