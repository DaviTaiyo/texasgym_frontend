import 'package:flutter/material.dart';
import 'package:texasgym_1/presentation/views/termsServiceScreen.dart';

class AboutAppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre o Aplicativo'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text('Versão do Aplicativo'),
              subtitle: Text('Versão 1.0.0'),
            ),
            ListTile(
              title: Text('Desenvolvedores'),
              subtitle: Text('Equipe de Desenvolvimento XYZ'),
            ),
            ListTile(
              title: Text('Feedback'),
              subtitle: Text('Envie seu feedback para feedback@exemplo.com'),
              onTap: () {
              },
            ),
            ListTile(
              title: Text('Política de Privacidade'),
              onTap: () {
              },
            ),
            ListTile(
              title: Text('Termos de Serviço'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TermsOfServiceScreen())
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
