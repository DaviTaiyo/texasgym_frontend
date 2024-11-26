class Usuario {
  int? id;
  String? nome;
  DateTime? dataNascimento;
  String email;
  String? cpf;
  String? telefone;
  String? senha;
  bool professor;

  Usuario({
    this.id,
    this.nome,
    this.dataNascimento,
    required this.email,
    this.cpf,
    this.telefone,
    this.senha,
    this.professor = false
  });

  // Método para criar um objeto Usuario a partir de um JSON
  factory Usuario.fromJson(Map<String, dynamic> json) {
  return Usuario(
    id: json['id'],
    nome: json['nome'],
    dataNascimento: json['dataNascimento'] != null
        ? DateTime.parse(json['dataNascimento'])
        : null,
    email: json['email'],
    cpf: json['cpf'],
    telefone: json['telefone'],
    professor: json['professor'] ?? false, // Certifique-se do nome correto
    senha: json['senha'], // Opcional
  );
}


  // Método para enviar apenas os dados necessários para registro
  Map<String, dynamic> toJsonRegistro() {
    return {
      'nome': nome,
      'dataNascimento': dataNascimento?.toIso8601String().split('T').first,
      'email': email,
      'cpf': cpf,
      'telefone': telefone,
      'senha': senha,
    };
  }
}
