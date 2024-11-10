import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Termos de Serviço'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Termos de Serviço do TexasGym',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                '1. Aceitação dos Termos\n'
                'Ao usar o aplicativo TexasGym, você concorda com os seguintes termos e condições...\n',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 10),
              Text(
                '2. Uso do Serviço\n'
                'O usuário concorda em usar o aplicativo de maneira responsável e respeitar todas as regras e diretrizes estabelecidas pela TexasGym...\n',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 10),
              Text(
                '3. Modificações nos Termos\n'
                'A TexasGym se reserva o direito de modificar estes termos a qualquer momento. As mudanças serão comunicadas aos usuários através do aplicativo...\n',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
