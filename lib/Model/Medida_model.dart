class Medida {
  final int? id;
  final double? altura;
  final double? peso;
  final double? gorduraCorporal;
  final DateTime? dataMedida;

  Medida({this.id, this.altura, this.peso, this.gorduraCorporal, this.dataMedida});

  factory Medida.fromJson(Map<String, dynamic> json) {
    return Medida(
      id: json['id'],
      altura: json['altura']?.toDouble(),
      peso: json['peso']?.toDouble(),
      gorduraCorporal: json['gorduraCorporal']?.toDouble(),
      dataMedida: json['dataMedida'] != null
          ? DateTime.parse(json['dataMedida'])
          : null,
    );
  }
}

