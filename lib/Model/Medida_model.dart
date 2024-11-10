class Medida {
  int? id;
  int usuarioId;
  double altura;
  double peso;
  double gorduraCorporal;
  DateTime? dataMedida;

  Medida({
    this.id,
    required this.usuarioId,
    required this.altura,
    required this.peso,
    required this.gorduraCorporal,
    this.dataMedida,
  });

  factory Medida.fromJson(Map<String, dynamic> json) {
    return Medida(
      id: json['id'],
      usuarioId: json['usuario_id'],
      altura: (json['altura'] as num).toDouble(),
      peso: (json['peso'] as num).toDouble(),
      gorduraCorporal: (json['gordura_corporal'] as num).toDouble(),
      dataMedida: json['data_medida'] != null
          ? DateTime.parse(json['data_medida'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'altura': altura,
      'peso': peso,
      'gordura_corporal': gorduraCorporal,
      'data_medida': dataMedida?.toIso8601String(),
    };
  }
}
