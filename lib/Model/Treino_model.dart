class Treino {
  int? id;
  int fichaId;
  int exerciciosId;
  String nome;
  int? repeticoes;
  String? diasTreino;
  double? pesoUsado;
  int? tempoDescanso;
  String? observacao;

  Treino({
    this.id,
    required this.fichaId,
    required this.exerciciosId,
    required this.nome,
    this.repeticoes,
    this.diasTreino,
    this.pesoUsado,
    this.tempoDescanso,
    this.observacao,
  });

  factory Treino.fromJson(Map<String, dynamic> json) {
    return Treino(
      id: json['id'],
      fichaId: json['ficha_id'],
      exerciciosId: json['exercicios_id'],
      nome: json['nome'],
      repeticoes: json['repeticoes'],
      diasTreino: json['dias_treino'],
      pesoUsado: (json['peso_usado'] as num?)?.toDouble(),
      tempoDescanso: json['tempo_descanso'],
      observacao: json['observacao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ficha_id': fichaId,
      'exercicios_id': exerciciosId,
      'nome': nome,
      'repeticoes': repeticoes,
      'dias_treino': diasTreino,
      'peso_usado': pesoUsado,
      'tempo_descanso': tempoDescanso,
      'observacao': observacao,
    };
  }
}
