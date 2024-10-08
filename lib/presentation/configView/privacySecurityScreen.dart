import 'package:flutter/material.dart';

class PrivacySecurityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacidade e Segurança'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Gerenciar Senhas'),
              onTap: () {
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('Definições de Privacidade'),
              onTap: () {
              },
            ),
            ListTile(
              leading: Icon(Icons.security),
              title: Text('Autenticação de Dois Fatores'),
              onTap: () {
              },
            ),
          ],
        ),
      ),
    );
  }
}
