class Usuario {
  int? id;
  String? nome;
  DateTime? dataNascimento;
  String email;
  String? cpf;
  String? telefone;
  String? senha; // Torna 'senha' opcional
  bool administrador;

  Usuario({
    this.id,
    this.nome,
    this.dataNascimento,
    required this.email,
    this.cpf,
    this.telefone,
    this.senha, // Remove 'required' para tornar opcional
    this.administrador = false,
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
      administrador: json['administrador'] ?? false,
      senha: json['senha'], // Opcional: será `null` se não estiver no JSON
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
