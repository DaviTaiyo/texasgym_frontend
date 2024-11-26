class Exercicio {
  int? id;
  String nome;
  String? descricao;
  String? linkYoutube;

  Exercicio({
    this.id,
    required this.nome,
    this.descricao,
    this.linkYoutube,
  });

  factory Exercicio.fromJson(Map<String, dynamic> json) {
    return Exercicio(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      linkYoutube: json['linkYoutube'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'linkYoutube': linkYoutube,
    };
  }
}
