import 'package:texasgym_1/Model/exercicios_Model.dart';

class Treino {
  int? id; // Permitir null
  int? fichaId; // Permitir null
  String nome;
  int? repeticoes; // Permitir null
  String? diasTreino; // Permitir null
  double? pesoUsado; // Permitir null
  int? tempoDescanso; // Permitir null
  String? observacao; // Permitir null
  List<Exercicio>? exercicios; // Lista de exercícios associados

  Treino({
    this.id,
    this.fichaId,
    required this.nome,
    this.repeticoes,
    this.diasTreino,
    this.pesoUsado,
    this.tempoDescanso,
    this.observacao,
    this.exercicios,
  });

  factory Treino.fromJson(Map<String, dynamic> json) {
    return Treino(
      id: json['id'] as int?, // Permitir null
      fichaId: json['fichaId'] as int?, // Permitir null
      nome: json['nome'],
      repeticoes: json['repeticoes'] as int?, // Permitir null
      diasTreino: json['diasTreino'], // Permitir null
      pesoUsado: (json['pesoUsado'] as num?)?.toDouble(), // Permitir null
      tempoDescanso: json['tempoDescanso'] as int?, // Permitir null
      observacao: json['observacao'], // Permitir null
      exercicios: json['exercicios'] != null
          ? (json['exercicios'] as List)
              .map((e) => Exercicio.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'fichaid': fichaId,
      'nome': nome,
      'repeticoes': repeticoes,
      'diasTreino': diasTreino,
      'pesoUsado': pesoUsado,
      'tempoDescanso': tempoDescanso,
      'observacao': observacao,
    };

    if (id != null) {
      json['id'] = id;
    }

    if (exercicios != null && exercicios!.isNotEmpty) {
      json['exercicios'] = exercicios!.map((e) => e.toJson()).toList();
    }

    return json;
  }
}
