import 'package:texasgym_1/Model/Treino_model.dart';

class Ficha {
  int? id;
  int usuarioId;
  DateTime dataCriacao;
  String observacao;
  List<Treino>? treinos;

  Ficha({
    this.id,
    required this.usuarioId,
    required this.dataCriacao,
    required this.observacao,
    this.treinos,
  });

  factory Ficha.fromJson(Map<String, dynamic> json) {
    return Ficha(
      id: json['id'],
      usuarioId: json['usuario_id'],
      dataCriacao: DateTime.parse(json['data_criacao']),
      observacao: json['observacao'],
      treinos: json['treinos'] != null
          ? List<Treino>.from(json['treinos'].map((item) => Treino.fromJson(item)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'data_criacao': dataCriacao.toIso8601String(),
      'observacao': observacao,
      'treinos': treinos?.map((item) => item.toJson()).toList(),
    };
  }
}
